Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaBTKv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:51:58 -0500
Received: from www.linutronix.de ([62.245.132.108]:58218 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaBTKv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:51:57 -0500
Date: Thu, 20 Feb 2014 11:52:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Perevalov <a.perevalov@samsung.com>
cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        Anton Vorontsov <anton@enomsg.org>, anton@nomsg.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH v3 4/6] timerfd: Factor out timer-type unspecific
 timerfd_expire()
In-Reply-To: <1392885633-7787-5-git-send-email-a.perevalov@samsung.com>
Message-ID: <alpine.DEB.2.02.1402201136500.4468@ionos.tec.linutronix.de>
References: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com> <1392885633-7787-5-git-send-email-a.perevalov@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Feb 2014, Alexey Perevalov wrote:

> From: Anton Vorontsov <anton@enomsg.org>
> 
> There is nothing hrtimer-specific inside the timerfd_tmrproc(), except
> the function prototype. We're about to add other timer types, so factor
> out generic timerfd_expire() helper from timerfd_tmrproc().

This changelog is completely useless. How is timerfd_tmrproc, which is
not a function but a function pointer, related to the patch?

Moving duplicated code to a common function is nice, but ....
 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
> ---
>  fs/timerfd.c |   40 +++++++++++++++++++---------------------
>  1 file changed, 19 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/timerfd.c b/fs/timerfd.c
> index 9293121..3561ce7 100644
> --- a/fs/timerfd.c
> +++ b/fs/timerfd.c
> @@ -229,6 +229,23 @@ static unsigned int timerfd_poll(struct file *file, poll_table *wait)
>  	return events;
>  }
>  
> +static u64 timerfd_rearm(struct timerfd_ctx *ctx)
> +{
> +	u64 orun;
> +
> +	if (isalarm(ctx)) {
> +		orun += alarm_forward_now(
> +			&ctx->t.alarm, ctx->tintv) - 1;
> +		alarm_restart(&ctx->t.alarm);
> +	} else {
> +		orun += hrtimer_forward_now(&ctx->t.tmr,
> +		     ctx->tintv) - 1;
> +		hrtimer_restart(&ctx->t.tmr);

Warnings are there to be ignored and testing of user space
interfaces after a change is overrated, right?

Aside of that you just blindly copied the original code w/o fixing up
the now unnecessary line breaks.

The summary of this patch is:

    1) Breaks existing functionality including user space ABI
    2) Compiler warnings ignored
    3) Untested
    4) Utter lack of programming style
    5) Useless changelog

Impressive for a trivial thing like this.

Thanks,

	tglx
