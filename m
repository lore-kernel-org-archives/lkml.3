Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbaDHGRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 02:17:22 -0400
Received: from relay.parallels.com ([195.214.232.42]:35406 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaDHGRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 02:17:20 -0400
Message-ID: <5343946A.6000601@parallels.com>
Date: Tue, 8 Apr 2014 10:17:14 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>, <linux-kernel@vger.kernel.org>
CC: <shawn@churchofgit.com>, <tglx@linutronix.de>, <akpm@linux-foundation.org>,
        <avagin@openvz.org>, <xemul@parallels.com>
Subject: Re: [patch 1/3] timerfd: Implement show_fdinfo method
References: <20140407174701.734703531@openvz.org> <20140407174933.641611536@openvz.org>
In-Reply-To: <20140407174933.641611536@openvz.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cyrill,

On 04/07/2014 09:47 PM, Cyrill Gorcunov wrote:
> For checkpoint/restore of timerfd files we need to know how exactly
> the timer were armed to be able to handle it. Thus implement show_fdinfo
> method which provides enough information for timer re-creation.
>
> One of significant changes I think is addition of
> timerfd_ctx::settime_flags member. Currently there are
> two flags TFD_TIMER_ABSTIME and TFD_TIMER_CANCEL_ON_SET,
> and the second can be found from @might_cancel variable
> but in case if the flags will be extended in future we
> most probably will have to somehow remember them explicitly
> anyway so I guss doing that right now won't hurt.
>
> To not bloat the timerfd_ctx structure I've converted
> @expired to short integer and defined @settime_flags
> as short as well.
>
> v2 (by avagin@, vdavydov@ and tglx@):
>
>  - Add it_value/it_interval fields
>  - Save flags being used in timerfd_setup in context
>
> CC: Shawn Landden <shawn@churchofgit.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Andrey Vagin <avagin@openvz.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Vladimir Davydov <vdavydov@parallels.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  fs/timerfd.c |   30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
>
> Index: linux-2.6.git/fs/timerfd.c
> ===================================================================
> --- linux-2.6.git.orig/fs/timerfd.c
> +++ linux-2.6.git/fs/timerfd.c
> @@ -35,8 +35,9 @@ struct timerfd_ctx {
>  	ktime_t moffs;
>  	wait_queue_head_t wqh;
>  	u64 ticks;
> -	int expired;
>  	int clockid;
> +	short unsigned expired;
> +	short unsigned settime_flags;	/* to show in fdinfo */
>  	struct rcu_head rcu;
>  	struct list_head clist;
>  	bool might_cancel;
> @@ -196,6 +197,8 @@ static int timerfd_setup(struct timerfd_
>  		if (timerfd_canceled(ctx))
>  			return -ECANCELED;
>  	}
> +
> +	ctx->settime_flags = flags & TFD_SETTIME_FLAGS;
>  	return 0;
>  }
>  
> @@ -284,11 +287,36 @@ static ssize_t timerfd_read(struct file
>  	return res;
>  }
>  
> +static int timerfd_show(struct seq_file *m, struct file *file)
> +{
> +	struct timerfd_ctx *ctx = file->private_data;
> +	struct itimerspec t;
> +
> +	spin_lock_irq(&ctx->wqh.lock);
> +	t.it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
> +	t.it_interval = ktime_to_timespec(ctx->tintv);
> +	spin_unlock_irq(&ctx->wqh.lock);
> +
> +	return seq_printf(m,
> +			  "clockid: %d\n"
> +			  "ticks: %llu\n"
> +			  "settime flags: 0%o\n"
> +			  "it_value: (%llu, %llu)\n"
> +			  "it_interval: (%llu, %llu)\n",

IMO, one would expect to setup the timer on restore by passing the
values of settime_flags, it_value, and it_interval obtained from the
fdinfo to sys_timerfd_settime, but this will be incorrect, because AFAIU
the it_value you report here is always relative to the current time, no
matter whether TFD_TIMER_ABSTIME was set in settime_flags or not. Is it OK?

Thanks.

> +			  ctx->clockid, (unsigned long long)ctx->ticks,
> +			  ctx->settime_flags,
> +			  (unsigned long long)t.it_value.tv_sec,
> +			  (unsigned long long)t.it_value.tv_nsec,
> +			  (unsigned long long)t.it_interval.tv_sec,
> +			  (unsigned long long)t.it_interval.tv_nsec);
> +}
> +
>  static const struct file_operations timerfd_fops = {
>  	.release	= timerfd_release,
>  	.poll		= timerfd_poll,
>  	.read		= timerfd_read,
>  	.llseek		= noop_llseek,
> +	.show_fdinfo	= timerfd_show,
>  };
>  
>  static int timerfd_fget(int fd, struct fd *p)
