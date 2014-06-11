Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbaFKHvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 03:51:33 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:40343 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaFKHvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 03:51:31 -0400
Date: Wed, 11 Jun 2014 11:51:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Vagin <avagin@parallels.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, avagin@openvz.org,
        xemul@parallels.com, vdavydov@parallels.com,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [patch 3/3] timerfd: Implement write method
Message-ID: <20140611075125.GI2243@moon>
References: <20140428212517.200264067@openvz.org>
 <20140428213301.507657833@openvz.org>
 <alpine.DEB.2.02.1405220643170.9695@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1405220656130.9695@ionos.tec.linutronix.de>
 <20140610163530.GF2243@moon>
 <20140611072743.GA10612@paralelels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611072743.GA10612@paralelels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 11:27:43AM +0400, Andrew Vagin wrote:
> > +	case TFD_IOC_SET_TICKS: {
> > +		u64 ticks;
> > +
> > +		if (!capable(CAP_SYS_RESOURCE))
> > +			return -EPERM;
> 
> I think it is too strong. It will not work in userns.
> 
> Why do we need to check CAP_SYS_RESOURCE here?
> Can we replace capable on ns_capable?
> 
> > +		if (get_user(ticks, (u64 __user *)arg))
> > +			return -EFAULT;
> > +		spin_lock_irq(&ctx->wqh.lock);
> > +		ctx->ticks = ticks;
> 
> I think we need to wakt up readers here if ctx->ticks isn't zero.

  I used this caps to prevent arbitrary changing the ticks from a
regular programs because i didn't wake up readers. But after thinking
more i think indeed this case (write ticks but not wake up anyone)
leads to strange situation -- currently (without the patch) there can't
be scenario when we have a waiter not woken up with nonzero @ticks,
but with this patch applied the timerfd logic become vague. One can
set up @ticks to nonzero value and still have waiter looping around.

  Thanks Andrew! How about the patch below? We allow to modify @ticks
and wake up waiter on non-zero @ticks assignment. I think this should
fit current timerfd logic.

(once such or anything else approach get approved -- I'll resend new
 series with man updated).
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: timerfd: Implement timerfd_ioctl method to restore timerfd_ctx::ticks

The read() of timerfd files allows to fetch the number of timer ticks
while there is no way to set it back from userspace.

To restore the timer's state as it was at checkpoint moment we need
a path to bring @ticks back. Initially I thought about writing ticks
back via write() interface but it seems such API is somehow obscure.

Instead implement timerfd_ioctl() method with TFD_IOC_SET_TICKS
command which allows to adjust @ticks into arbitrary value. In
case if new value is non-zero we are waking up the waiters.
I wrapped code with CONFIG_CHECKPOINT_RESTORE which can be
dropped off if there users except c/r camp appear.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Andrey Vagin <avagin@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/timerfd.c            |   31 +++++++++++++++++++++++++++++++
 include/linux/timerfd.h |    5 +++++
 2 files changed, 36 insertions(+)

Index: linux-2.6.git/fs/timerfd.c
===================================================================
--- linux-2.6.git.orig/fs/timerfd.c
+++ linux-2.6.git/fs/timerfd.c
@@ -313,11 +313,42 @@ static int timerfd_show(struct seq_file
 }
 #endif
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static long timerfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct timerfd_ctx *ctx = file->private_data;
+	int ret = 0;
+
+	switch (cmd) {
+	case TFD_IOC_SET_TICKS: {
+		u64 ticks;
+
+		if (get_user(ticks, (u64 __user *)arg))
+			return -EFAULT;
+		spin_lock_irq(&ctx->wqh.lock);
+		ctx->ticks = ticks;
+		if (ticks)
+			wake_up_locked(&ctx->wqh);
+		spin_unlock_irq(&ctx->wqh.lock);
+		break;
+	}
+	default:
+		ret = -ENOTTY;
+		break;
+	}
+
+	return ret;
+}
+#endif
+
 static const struct file_operations timerfd_fops = {
 	.release	= timerfd_release,
 	.poll		= timerfd_poll,
 	.read		= timerfd_read,
 	.llseek		= noop_llseek,
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	.unlocked_ioctl	= timerfd_ioctl,
+#endif
 #ifdef CONFIG_PROC_FS
 	.show_fdinfo	= timerfd_show,
 #endif
Index: linux-2.6.git/include/linux/timerfd.h
===================================================================
--- linux-2.6.git.orig/include/linux/timerfd.h
+++ linux-2.6.git/include/linux/timerfd.h
@@ -11,6 +11,9 @@
 /* For O_CLOEXEC and O_NONBLOCK */
 #include <linux/fcntl.h>
 
+/* For _IO helpers */
+#include <linux/ioctl.h>
+
 /*
  * CAREFUL: Check include/asm-generic/fcntl.h when defining
  * new flags, since they might collide with O_* ones. We want
@@ -29,4 +32,6 @@
 /* Flags for timerfd_settime.  */
 #define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_TIMER_CANCEL_ON_SET)
 
+#define TFD_IOC_SET_TICKS	_IOW('T', 0, u64)
+
 #endif /* _LINUX_TIMERFD_H */
