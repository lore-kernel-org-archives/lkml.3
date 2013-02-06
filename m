Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626Ab3BFQLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:11:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757502Ab3BFQLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:11:20 -0500
Date: Wed, 6 Feb 2013 17:10:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Tommi Rantala <tt.rantala@gmail.com>
Subject: Re: [PATCH] posix-cpu-timers: fix nanosleep task_struct leak
Message-ID: <20130206161011.GA11161@redhat.com>
References: <CA+ydwtqUUAR9zf3dp+N1JRW+if88EZ73i+5BQtuggVPDFVdCBg@mail.gmail.com> <alpine.LFD.2.02.1302011450160.11905@ionos> <20130204193223.GA11910@redhat.com> <20130205103455.GB18313@redhat.com> <alpine.LFD.2.02.1302051155000.11905@ionos> <20130206112327.GA1824@redhat.com> <CA+ydwtrdNL_7AvZpmJ__06YUCVhSr7YPO8D=wzXhZiWp1-DVqg@mail.gmail.com> <20130206151550.GA1758@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130206151550.GA1758@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislaw,

First of all, thank you so much. I knew it was a good idea to cc you ;)

And let me repeat that I forgot everything about this code.

On 02/06, Stanislaw Gruszka wrote:
>
> In do_cpu_nanosleep() we do posix_cpu_timer_create(), but forgot
> corresponding posix_cpu_timer_del(), what lead to task_struct leak.

Plus, it seems we can leave the timer on ->cpu_timers list...

> @@ -1403,6 +1403,7 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
>  				/*
>  				 * Our timer fired and was reset.
>  				 */
> +				posix_cpu_timer_del(&timer);
>  				spin_unlock_irq(&timer.it_lock);
>  				return 0;
>  			}
> @@ -1420,9 +1421,17 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
>  		 * We were interrupted by a signal.
>  		 */
>  		sample_to_timespec(which_clock, timer.it.cpu.expires, rqtp);
> -		posix_cpu_timer_set(&timer, 0, &zero_it, it);
> +		error = posix_cpu_timer_set(&timer, 0, &zero_it, it);
> +		if (!error)
> +			posix_cpu_timer_del(&timer);
>  		spin_unlock_irq(&timer.it_lock);
>
> +		while (error == TIMER_RETRY) {
> +			spin_lock_irq(&timer.it_lock);
> +			error = posix_cpu_timer_del(&timer);

It is not clear to me why other posix_cpu_timer_del's above can't fail..
May be you can add a comment.

And I am not sure that TIMER_RETRY is the only error we should worry.
And perhaps we need even more posix_cpu_timer_del's?

For example. Suppose that posix_cpu_timer_create() succeeds and does
get_task_struct(p). But than p dies, and the first posix_cpu_timer_set()
fails with -ESRCH. No?

Oleg.

