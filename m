Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaBTVNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:13:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:34598 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbaBTVNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:13:05 -0500
Date: Thu, 20 Feb 2014 22:13:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Perevalov <a.perevalov@samsung.com>
cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        Anton Vorontsov <anton@enomsg.org>, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, akpm@linux-foundation.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH v4 4/6] timerfd: Move repeated logic into
 timerfd_rearm()
In-Reply-To: <1392913425-29369-5-git-send-email-a.perevalov@samsung.com>
Message-ID: <alpine.DEB.2.02.1402202141220.4468@ionos.tec.linutronix.de>
References: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com> <1392913425-29369-5-git-send-email-a.perevalov@samsung.com>
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
> This patch introduces timerfd_rearm(), this small helper is used to
> forward and restart the hrtimer.

And for what is this helper used for?
 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
> ---
>  fs/timerfd.c |   40 +++++++++++++++++++---------------------
>  1 file changed, 19 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/timerfd.c b/fs/timerfd.c
> index 9293121..4a349cb 100644
> --- a/fs/timerfd.c
> +++ b/fs/timerfd.c
> @@ -229,6 +229,23 @@ static unsigned int timerfd_poll(struct file *file, poll_table *wait)
>  	return events;
>  }
>  
> +static u64 timerfd_rearm(struct timerfd_ctx *ctx)
> +{
> +	u64 orun = 0;
> +
> +	if (isalarm(ctx)) {
> +		orun += alarm_forward_now(
> +			&ctx->t.alarm, ctx->tintv) - 1;
> +		alarm_restart(&ctx->t.alarm);
> +	} else {
> +		orun += hrtimer_forward_now(&ctx->t.tmr,
> +		     ctx->tintv) - 1;
> +		hrtimer_restart(&ctx->t.tmr);
> +	}
> +
> +	return orun;

I really give up. You did not even try to read and understand my
review points.

No, you went and mechanicallly fixed the compiler warning in the most
idiotic way one can come up with.

What's wrong with writing it:

{
	u64 orun;

	if (isalarm(ctx)) {
		orun = alarm_forward_now(ctx->t.alarm, ctx->tintv) - 1;
		alarm_restart(&ctx->t.alarm);
	} else {
		orun = hrtimer_forward_now(&ctx->t.tmr, ctx->tintv) - 1;
		hrtimer_restart(&ctx->t.tmr);
	}
	return orun;
}

Can you spot the difference? Just for the record:

1) It fixes the issue with proper assignments instead of pointlessly
   initializing the variable to 0 and then add the return value.

2) It removes the useless line break which makes the code simpler to
   read.

I told you to do #2 explicitely, but you decided to ignore it.

I did not tell you how to do #1, but I did not expect at all that
anyone might come up with that horrible solution.

This is not some random homework assignment in high school where you
might get away with the "It compiles so what" mentality.

Seriously, if you come back with another set of half baken patches,
you're going to end up in the utter-waste-of-time section of my
.procmailrc.

I have quite some patience with people, but I really have better
things to do than wasting my scarce time with advisory resistant
wannabe kernel developers.

Thanks,

	tglx

Hint: Take your time. Read carefully what I asked for and let your
      coworkers look over the patches including the subject lines and
      the changelogs before you send another half baken crap out in a
      haste.

