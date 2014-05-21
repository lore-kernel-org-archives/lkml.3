Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaEUVyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:54:14 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:39617 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbaEUVyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:54:13 -0400
Date: Thu, 22 May 2014 01:54:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, shawn@churchofgit.com,
        akpm@linux-foundation.org, avagin@openvz.org, xemul@parallels.com,
        vdavydov@parallels.com
Subject: Re: [patch 1/3] timerfd: Implement show_fdinfo method
Message-ID: <20140521215409.GG12819@moon>
References: <20140428212517.200264067@openvz.org>
 <20140428213301.304637183@openvz.org>
 <alpine.DEB.2.02.1405220641240.9695@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1405220641240.9695@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 22, 2014 at 06:41:57AM +0900, Thomas Gleixner wrote:
> 
> Shouldn't this depend on CONFIG_PROCFS?
> 
> >  static const struct file_operations timerfd_fops = {
> >  	.release	= timerfd_release,
> >  	.poll		= timerfd_poll,
> >  	.read		= timerfd_read,
> >  	.llseek		= noop_llseek,
> > +	.show_fdinfo	= timerfd_show,
> >  };
> >  
> >  static int timerfd_fget(int fd, struct fd *p)

yeah, good point, thanks! Updated.

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=timerfd-show-fdinfo-4

From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: timerfd: Implement show_fdinfo method

For checkpoint/restore of timerfd files we need to know how exactly
the timer were armed to be able to handle it. Thus implement show_fdinfo
method which provides enough information for timer re-creation.

One of significant changes I think is addition of
timerfd_ctx::settime_flags member. Currently there are
two flags TFD_TIMER_ABSTIME and TFD_TIMER_CANCEL_ON_SET,
and the second can be found from @might_cancel variable
but in case if the flags will be extended in future we
most probably will have to somehow remember them explicitly
anyway so I guss doing that right now won't hurt.

To not bloat the timerfd_ctx structure I've converted
@expired to short integer and defined @settime_flags
as short as well.

v2 (by avagin@, vdavydov@ and tglx@):

 - Add it_value/it_interval fields
 - Save flags being used in timerfd_setup in context

v3 (by tglx@):
 - don't forget to use CONFIG_PROC_FS

CC: Shawn Landden <shawn@churchofgit.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Andrey Vagin <avagin@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/timerfd.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

Index: linux-2.6.git/fs/timerfd.c
===================================================================
--- linux-2.6.git.orig/fs/timerfd.c
+++ linux-2.6.git/fs/timerfd.c
@@ -35,8 +35,9 @@ struct timerfd_ctx {
 	ktime_t moffs;
 	wait_queue_head_t wqh;
 	u64 ticks;
-	int expired;
 	int clockid;
+	short unsigned expired;
+	short unsigned settime_flags;	/* to show in fdinfo */
 	struct rcu_head rcu;
 	struct list_head clist;
 	bool might_cancel;
@@ -196,6 +197,8 @@ static int timerfd_setup(struct timerfd_
 		if (timerfd_canceled(ctx))
 			return -ECANCELED;
 	}
+
+	ctx->settime_flags = flags & TFD_SETTIME_FLAGS;
 	return 0;
 }
 
@@ -284,11 +287,40 @@ static ssize_t timerfd_read(struct file
 	return res;
 }
 
+#ifdef CONFIG_PROC_FS
+static int timerfd_show(struct seq_file *m, struct file *file)
+{
+	struct timerfd_ctx *ctx = file->private_data;
+	struct itimerspec t;
+
+	spin_lock_irq(&ctx->wqh.lock);
+	t.it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
+	t.it_interval = ktime_to_timespec(ctx->tintv);
+	spin_unlock_irq(&ctx->wqh.lock);
+
+	return seq_printf(m,
+			  "clockid: %d\n"
+			  "ticks: %llu\n"
+			  "settime flags: 0%o\n"
+			  "it_value: (%llu, %llu)\n"
+			  "it_interval: (%llu, %llu)\n",
+			  ctx->clockid, (unsigned long long)ctx->ticks,
+			  ctx->settime_flags,
+			  (unsigned long long)t.it_value.tv_sec,
+			  (unsigned long long)t.it_value.tv_nsec,
+			  (unsigned long long)t.it_interval.tv_sec,
+			  (unsigned long long)t.it_interval.tv_nsec);
+}
+#endif
+
 static const struct file_operations timerfd_fops = {
 	.release	= timerfd_release,
 	.poll		= timerfd_poll,
 	.read		= timerfd_read,
 	.llseek		= noop_llseek,
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	= timerfd_show,
+#endif
 };
 
 static int timerfd_fget(int fd, struct fd *p)

--azLHFNyN32YCQGCU--
