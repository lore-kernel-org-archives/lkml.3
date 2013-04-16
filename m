Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935869Ab3DPKjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 06:39:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756428Ab3DPKjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 06:39:19 -0400
Date: Tue, 16 Apr 2013 12:40:07 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Lower chances of cputime scaling overflow
Message-ID: <20130416104007.GA620@redhat.com>
References: <tip-d9a3c9823a2e6a543eb7807fb3d15d8233817ec5@git.kernel.org>
 <20130326140147.GB2029@redhat.com>
 <1365687946.8824.3.camel@laptop>
 <CA+55aFway4C89fTewKvED4RvFLaNdM-BVtkJ2YChsvracLKiyA@mail.gmail.com>
 <1365753356.17140.18.camel@laptop>
 <20130413144934.GA11556@redhat.com>
 <CA+55aFwMeAe6Mb9EPeT4Ke0W36z-XUK3BZvbOt+dMzdbJ3F1Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwMeAe6Mb9EPeT4Ke0W36z-XUK3BZvbOt+dMzdbJ3F1Ew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 11:44:54AM -0700, Linus Torvalds wrote:
> PS. This is the "Make sure 'total' fits in 32 bits first" version. Not
> really tested, but it's just changing the order of operations a bit.
> 
>     /* We know one of the values has a bit set in the high 32 bits */
>     for (;;) {
>         /* Make sure "rtime" is the bigger of stime/rtime */
>         if (stime > rtime) {
>             u64 tmp = rtime; rtime = stime; stime = tmp;
>         }
> 
>         /* Make sure 'total' fits in 32 bits */
>         if (total >> 32)
>                 goto drop_precision;
> 
>         /* Does rtime (and thus stime) fit in 32 bits? */
>         if (!(rtime >> 32))
>                 break;
> 
>         /* Can we just balance rtime/stime rather than dropping bits? */
>         if (stime >> 31)
>             goto drop_precision;
> 
>         /* We can grow stime and shrink rtime and try to make them both fit */
>         stime <<= 1;
>         rtime >>= 1;
>         continue;
> 
> drop_precision:
>         /* We drop from rtime, it has more bits than stime */
>         rtime >>= 1;
>         total >>= 1;
>     }

It also also pass 0.1% relative error on my tests. Decreasing error
threshold to 0.02% failed. I didn't check other values or measure how
frequent 0.02% fail on each version, I assume this one is better :-)

So regarding relative error this algorithm is fine, there is no
multiplication overflow error which make scaled numbers bogus. Then
I looked on this algorithm regarding context how it is used ...

Raw stime/rtime/total values will increase in jiffies resolution,
so do scaled_stime if we do not drop precision. For bigger numbers,
since we drop precision, scaled_stime will grow in chunks. How big
the chunk depend on how overall big numbers are and stime/total ratio.
For example: stime = 0.5*total, 128 threads, after 1 year of CPU
execution chunk will be 1024 jiffies.

We use scaled stime value this way:

	if (total)
		stime = scale_stime(stime, rtime, total);
	else
		stime = rtime;

	/*
	 * If the tick based count grows faster than the scheduler one,
	 * the result of the scaling may go backward.
	 * Let's enforce monotonicity.
	 */
	prev->stime = max(prev->stime, stime);
	prev->utime = max(prev->utime, rtime - prev->stime);

	*ut = prev->utime;
	*st = prev->stime;

Since rtime increase, but scaled stime not, stime will be accounted
as prev->utime. Then after chunk jiffies, stime will grow and we will
get it accounted in prev->stime. As result we will account more cpu
time than actually process do. This error will accumulate depending
how frequently cputime_adjust(process) will be called.
 
As solution for this we could just stop accounting if prev->stime +
prev->utime are already bigger than rtime. For example:

 	rtime = nsecs_to_cputime(curr->sum_exec_runtime);
 
+	/*
+	 * Update userspace visible utime/stime values only if actual execution
+	 * time is bigger than already exported. Note that can happen, that we 
+	 * provided bigger values due to scaling inaccuracy on big numbers.
+	 */
+	if (prev->stime + prev->utime >= rtime)
+		goto out;
+
 	if (total)
 		stime = scale_stime(stime, rtime, total);
 	else
@@ -573,6 +581,7 @@ static void cputime_adjust(struct task_cputime *curr,
 	prev->stime = max(prev->stime, stime);
 	prev->utime = max(prev->utime, rtime - prev->stime);
 
+out:
 	*ut = prev->utime;
 	*st = prev->stime;
 }
 
This should help with erroneously accounting more CPU time than process
actually use. As disadvantage userspace will see CPU time increase in
chunks, but I think this is better than see values much bigger than
correct ones (and for 99.9% user cases it does not matter).

Stanislaw
 
