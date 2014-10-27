Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaJ0VVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 17:21:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:40703 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaJ0VVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 17:21:15 -0400
Date: Mon, 27 Oct 2014 22:21:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Heena Sirwani <heenasirwani@gmail.com>, linux-kernel@vger.kernel.org,
        john.stultz@linaro.org
Subject: Re: [PATCH v5] timekeeping: Added a function to return tv_sec portion
 of ktime_get_ts64()
In-Reply-To: <6577930.2pEqZJjtqW@wuerfel>
Message-ID: <alpine.DEB.2.11.1410272219560.5308@nanos>
References: <20141025123406.GA13128@heena.com> <alpine.DEB.2.11.1410251705550.5308@nanos> <6577930.2pEqZJjtqW@wuerfel>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2014, Arnd Bergmann wrote:
> On Saturday 25 October 2014 17:12:48 Thomas Gleixner wrote:
> > I'd rather have an extra field in the timekeeper
> > 
> >     u64 xtime_sec;
> > +   u64 ktime_sec;
> > 
> > and update this in tk_update_ktime_data() so the readout function
> > boils down to
> > 
> > time64_t ktime_get_seconds(void)
> > {
> > #if BITS_PER_LONG < 64
> >         u64 sec;
> >         int seq;
> > 
> >         do {
> >                 seq = read_seqcount_begin(&tk_core.seq);
> >                 sec = tk->ktime_sec;
> >         } while (read_seqcount_retry(&tk_core.seq, seq));
> > 
> >         return sec;
> > #else
> >         return tk->ktime_sec;
> > #endif
> > }
> > 
> > So 64bit can do w/o the seqcount and 32bit avoids all extra math, right?
> > 
> 
> But where would you set ktime_sec? My first thought was tk_update_ktime_data(),
> but would then either be slightly wrong because it doesn't take the current
> xtime_nsec + tk->wall_to_monotonic.tv_nsec into account, if we do
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index ec1791fae965..d72a456c6bd3 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -426,8 +426,8 @@ static inline void tk_update_ktime_data(struct timekeeper *tk)
>  	 *	nsec = base_mono + now();
>  	 * ==> base_mono = (xtime_sec + wtm_sec) * 1e9 + wtm_nsec
>  	 */
> -	nsec = (s64)(tk->xtime_sec + tk->wall_to_monotonic.tv_sec);
> -	nsec *= NSEC_PER_SEC;
> +	tk->ktime_sec = (s64)(tk->xtime_sec + tk->wall_to_monotonic.tv_sec);
> +	nsec = tk->ktime_sec * NSEC_PER_SEC;
>  	nsec += tk->wall_to_monotonic.tv_nsec;
>  	tk->tkr.base_mono = ns_to_ktime(nsec);
>  
> 
> or we'd have to add an expensive timekeeping_get_ns() call:
> 
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index ec1791fae965..d4c95b815de6 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -426,9 +426,11 @@ static inline void tk_update_ktime_data(struct timekeeper *tk)
>  	 *	nsec = base_mono + now();
>  	 * ==> base_mono = (xtime_sec + wtm_sec) * 1e9 + wtm_nsec
>  	 */
> -	nsec = (s64)(tk->xtime_sec + tk->wall_to_monotonic.tv_sec);
> -	nsec *= NSEC_PER_SEC;
> -	nsec += tk->wall_to_monotonic.tv_nsec;
> +	tk->ktime_sec = (s64)(tk->xtime_sec + tk->wall_to_monotonic.tv_sec);
> +	nsec = tk->wall_to_monotonic.tv_nsec;
> +	if ((nsec + timekeeping_get_ns()) > NSEC_PER_SEC)
> +		tk->ktime_sec += 1;
> +	nsec += tk->ktime_sec * NSEC_PER_SEC;
>  	tk->tkr.base_mono = ns_to_ktime(nsec);

No. Why would you do that? Look at the math you implemented and just
do the same thing in the update function.

Thanks,

	tglx
