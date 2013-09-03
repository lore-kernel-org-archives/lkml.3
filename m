Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab3ICJez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 05:34:55 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:34928 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313Ab3ICJey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 05:34:54 -0400
Date: Tue, 3 Sep 2013 12:33:38 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: [sched next] overflowed cpu time for kernel threads in
 /proc/PID/stat
Message-ID: <20130903093338.GC2464@swordfish>
References: <20130820151509.GA17441@somewhere>
 <20130820153549.GB2315@swordfish.minsk.epam.com>
 <20130820154257.GD17441@somewhere>
 <20130821153957.GA2969@swordfish.minsk.epam.com>
 <20130830230402.GA14760@somewhere>
 <20130902122845.GA2457@swordfish.minsk.epam.com>
 <20130902130744.GB2378@somewhere>
 <20130902135033.GA1686@redhat.com>
 <20130902140015.GB2368@swordfish.minsk.epam.com>
 <20130903084306.GA2694@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903084306.GA2694@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (09/03/13 10:43), Stanislaw Gruszka wrote:
> > 
> > usually stime < rtime.
> > this is what scale_stime() gets as input:
> > 
> > [ 1291.409566] stime:3790580815 rtime:4344293130 total:3790580815
> 
> Ok, I see now, utime is 0 . This seems to be problem with dynamic ticks
> as you told that your application is kernel compilation, so we utilize
> lot of cpu time in user-space.
> 
> Anyway we should handle utime == 0 situation on scaling code. We work
> well when rtime & stime are not big (variables and results fit in
> 32 bit), otherwise we have that stime bigger than rtime problem. Let's
> try to handle the problem by below patch. Sergey, does it work for you ?
> 

Sure, as fas as I understand, this one is against -current, not -next.
I'll test both (though will start with -next).

	-ss

> diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
> index a7959e0..25cc35d 100644
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -557,7 +557,7 @@ static void cputime_adjust(struct task_cputime *curr,
>  			   struct cputime *prev,
>  			   cputime_t *ut, cputime_t *st)
>  {
> -	cputime_t rtime, stime, utime, total;
> +	cputime_t rtime, stime, utime;
>  
>  	if (vtime_accounting_enabled()) {
>  		*ut = curr->utime;
> @@ -565,9 +565,6 @@ static void cputime_adjust(struct task_cputime *curr,
>  		return;
>  	}
>  
> -	stime = curr->stime;
> -	total = stime + curr->utime;
> -
>  	/*
>  	 * Tick based cputime accounting depend on random scheduling
>  	 * timeslices of a task to be interrupted or not by the timer.
> @@ -588,13 +585,19 @@ static void cputime_adjust(struct task_cputime *curr,
>  	if (prev->stime + prev->utime >= rtime)
>  		goto out;
>  
> -	if (total) {
> +	stime = curr->stime;
> +	utime = curr->utime;
> +
> +	if (utime == 0) {
> +		stime = rtime;
> +	} else if (stime == 0) {
> +		utime = rtime;
> +	} else {
> +		cputime_t total = stime + utime;
> +
>  		stime = scale_stime((__force u64)stime,
>  				    (__force u64)rtime, (__force u64)total);
>  		utime = rtime - stime;
> -	} else {
> -		stime = rtime;
> -		utime = 0;
>  	}
>  
>  	/*
> 
