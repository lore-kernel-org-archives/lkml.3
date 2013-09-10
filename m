Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab3IJIny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:43:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40989 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab3IJInw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:43:52 -0400
Date: Tue, 10 Sep 2013 10:43:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [RFC] seqcount: Add lockdep functionality to
 seqcount/seqlock structures
Message-ID: <20130910084340.GL26785@twins.programming.kicks-ass.net>
References: <1378788166-18474-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378788166-18474-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 09:42:46PM -0700, John Stultz wrote:
> Currently seqlocks and seqcounts don't support lockdep.
> 
> After running across a seqcount related deadlock in the timekeeping
> code, I used a less-refined and more focused varient of this patch
> to narrow down the cause of the issue.
> 
> This is a first-pass attempt to properly enable lockdep functionality
> on seqlocks and seqcounts.
> 
> Due to seqlocks/seqcounts having slightly different possible semantics
> then standard locks (ie: reader->reader and reader->writer recursion is
> fine, but writer->reader is not), this implementation is probably not
> as exact as I'd like (currently using a hack by only spot checking
> readers), and may be overly strict in some cases.
> 
> I've handled one cases where there were nested seqlock writers, and
> there may be more edge cases, as while I've gotten it to run cleanly,
> depending on config its reporting issues that I'm not sure if they are
> flaws in the implementation or actual bugs. But I wanted to send this
> out for some initial thoughts as until today I hadn't looked at much
> of the lockdep infrastructure. So I'm sure there are improvements
> that could be made.
> 
> Comments and feedback would be appreciated!

> --- a/arch/x86/vdso/vclock_gettime.c
> +++ b/arch/x86/vdso/vclock_gettime.c
> @@ -178,13 +178,15 @@ notrace static int __always_inline do_realtime(struct timespec *ts)
>  
>  	ts->tv_nsec = 0;
>  	do {
> -		seq = read_seqcount_begin(&gtod->seq);
> +		seq = __read_seqcount_begin(&gtod->seq);
> +		smp_rmb();
>  		mode = gtod->clock.vclock_mode;
>  		ts->tv_sec = gtod->wall_time_sec;
>  		ns = gtod->wall_time_snsec;
>  		ns += vgetsns(&mode);
>  		ns >>= gtod->clock.shift;
> -	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
> +		smp_rmb();
> +	} while (unlikely(__read_seqcount_retry(&gtod->seq, seq)));
>  
>  	timespec_add_ns(ts, ns);
>  	return mode;


You didn't mention the VDSO 'fun' in you Changelog!
