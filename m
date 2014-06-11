Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbaFKH1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 03:27:53 -0400
Received: from relay.parallels.com ([195.214.232.42]:39413 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaFKH1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 03:27:52 -0400
Date: Wed, 11 Jun 2014 11:27:43 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <avagin@openvz.org>,
        <xemul@parallels.com>, <vdavydov@parallels.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [patch 3/3] timerfd: Implement write method
Message-ID: <20140611072743.GA10612@paralelels.com>
References: <20140428212517.200264067@openvz.org>
 <20140428213301.507657833@openvz.org>
 <alpine.DEB.2.02.1405220643170.9695@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1405220656130.9695@ionos.tec.linutronix.de>
 <20140610163530.GF2243@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <20140610163530.GF2243@moon>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.24.36.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 08:35:30PM +0400, Cyrill Gorcunov wrote:
> On Thu, May 22, 2014 at 06:58:19AM +0900, Thomas Gleixner wrote:
> > > 
> > > So what wakes a potential waiter in read/poll?
> > 
> > And who is updating timerfd_create(2) ?
> 
> Thomas, could you please take a look if the approach below is acceptable?
> If it will be fine I update manpage then.
> ---
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: timerfd: Implement timerfd_ioctl method to restore timerfd_ctx::ticks
> 
> The read() of timerfd files allows to fetch the number of timer ticks
> while there is no way to set it back from userspace.
> 
> To restore the timer's state as it was at checkpoint moment we need
> a path to bring @ticks back. Initially I thought about writing ticks
> back via write() interface but it seems such API is somehow obscure.
> 
> Instead implement timerfd_ioctl() method with TFD_IOC_SET_TICKS
> command which requires CAP_SYS_RESOURCE capability to be able to
> set @ticks into arbitrary value. Note this command doesn't wake
> up readers/waiters and its purpose only to serve C/R needs
> (for same sake I wrapped code with CONFIG_CHECKPOINT_RESTORE).
> Still if needed the ioctl may be extended for new commands
> and CONFIG_CHECKPOINT_RESTORE dropped off.
> 
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Andrey Vagin <avagin@openvz.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Vladimir Davydov <vdavydov@parallels.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  fs/timerfd.c            |   31 +++++++++++++++++++++++++++++++
>  include/linux/timerfd.h |    5 +++++
>  2 files changed, 36 insertions(+)
> 
> Index: linux-2.6.git/fs/timerfd.c
> ===================================================================
> --- linux-2.6.git.orig/fs/timerfd.c
> +++ linux-2.6.git/fs/timerfd.c
> @@ -313,11 +313,42 @@ static int timerfd_show(struct seq_file
>  }
>  #endif
>  
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +static long timerfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	struct timerfd_ctx *ctx = file->private_data;
> +	int ret = 0;
> +
> +	switch (cmd) {
> +	case TFD_IOC_SET_TICKS: {
> +		u64 ticks;
> +
> +		if (!capable(CAP_SYS_RESOURCE))
> +			return -EPERM;

I think it is too strong. It will not work in userns.

Why do we need to check CAP_SYS_RESOURCE here?
Can we replace capable on ns_capable?

> +		if (get_user(ticks, (u64 __user *)arg))
> +			return -EFAULT;
> +		spin_lock_irq(&ctx->wqh.lock);
> +		ctx->ticks = ticks;

I think we need to wakt up readers here if ctx->ticks isn't zero.

> +		spin_unlock_irq(&ctx->wqh.lock);
> +		break;
> +	}
> +	default:
> +		ret = -ENOTTY;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +#endif
> +
>  static const struct file_operations timerfd_fops = {
>  	.release	= timerfd_release,
>  	.poll		= timerfd_poll,
>  	.read		= timerfd_read,
>  	.llseek		= noop_llseek,
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +	.unlocked_ioctl	= timerfd_ioctl,
> +#endif
>  #ifdef CONFIG_PROC_FS
>  	.show_fdinfo	= timerfd_show,
>  #endif
> Index: linux-2.6.git/include/linux/timerfd.h
> ===================================================================
> --- linux-2.6.git.orig/include/linux/timerfd.h
> +++ linux-2.6.git/include/linux/timerfd.h
> @@ -11,6 +11,9 @@
>  /* For O_CLOEXEC and O_NONBLOCK */
>  #include <linux/fcntl.h>
>  
> +/* For _IO helpers */
> +#include <linux/ioctl.h>
> +
>  /*
>   * CAREFUL: Check include/asm-generic/fcntl.h when defining
>   * new flags, since they might collide with O_* ones. We want
> @@ -29,4 +32,6 @@
>  /* Flags for timerfd_settime.  */
>  #define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_TIMER_CANCEL_ON_SET)
>  
> +#define TFD_IOC_SET_TICKS	_IOW('T', 0, u64)
> +
>  #endif /* _LINUX_TIMERFD_H */
