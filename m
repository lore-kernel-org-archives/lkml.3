Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3BCP2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:28:44 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:4152 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab3BCP2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 10:28:42 -0500
Message-ID: <510E8228.6050200@hp.com>
Date: Sun, 03 Feb 2013 07:28:40 -0800
From: Chegu Vinod <chegu_vinod@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        eric.dumazet@gmail.com, lwoodman@redhat.com, knoel@redhat.com,
        raghavendra.kt@linux.vnet.ibm.com, mingo@redhat.com
Subject: Re: [PATCH -v4 0/5] x86,smp: make ticket spinlock proportional backoff
 w/ auto tuning
References: <20130125140553.060b8ced@annuminas.surriel.com>
In-Reply-To: <20130125140553.060b8ced@annuminas.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/2013 11:05 AM, Rik van Riel wrote:
> Many spinlocks are embedded in data structures; having many CPUs
> pounce on the cache line the lock is in will slow down the lock
> holder, and can cause system performance to fall off a cliff.
>
> The paper "Non-scalable locks are dangerous" is a good reference:
>
> 	http://pdos.csail.mit.edu/papers/linux:lock.pdf
>
> In the Linux kernel, spinlocks are optimized for the case of
> there not being contention. After all, if there is contention,
> the data structure can be improved to reduce or eliminate
> lock contention.
>
> Likewise, the spinlock API should remain simple, and the
> common case of the lock not being contended should remain
> as fast as ever.
>
> However, since spinlock contention should be fairly uncommon,
> we can add functionality into the spinlock slow path that keeps
> system performance from falling off a cliff when there is lock
> contention.
>
> Proportional delay in ticket locks is delaying the time between
> checking the ticket based on a delay factor, and the number of
> CPUs ahead of us in the queue for this lock. Checking the lock
> less often allows the lock holder to continue running, resulting
> in better throughput and preventing performance from dropping
> off a cliff.
>
> The test case has a number of threads locking and unlocking a
> semaphore. With just one thread, everything sits in the CPU
> cache and throughput is around 2.6 million operations per
> second, with a 5-10% variation.
>
> Once a second thread gets involved, data structures bounce
> from CPU to CPU, and performance deteriorates to about 1.25
> million operations per second, with a 5-10% variation.
>
> However, as more and more threads get added to the mix,
> performance with the vanilla kernel continues to deteriorate.
> Once I hit 24 threads, on a 24 CPU, 4 node test system,
> performance is down to about 290k operations/second.
>
> With a proportional backoff delay added to the spinlock
> code, performance with 24 threads goes up to about 400k
> operations/second with a 50x delay, and about 900k operations/second
> with a 250x delay. However, with a 250x delay, performance with
> 2-5 threads is worse than with a 50x delay.
>
> Making the code auto-tune the delay factor results in a system
> that performs well with both light and heavy lock contention,
> and should also protect against the (likely) case of the fixed
> delay factor being wrong for other hardware.
>
> The attached graph shows the performance of the multi threaded
> semaphore lock/unlock test case, with 1-24 threads, on the
> vanilla kernel, with 10x, 50x, and 250x proportional delay,
> as well as the v1 patch series with autotuning for 2x and 2.7x
> spinning before the lock is obtained, and with the v2 series.
>
> The v2 series integrates several ideas from Michel Lespinasse
> and Eric Dumazet, which should result in better throughput and
> nicer behaviour in situations with contention on multiple locks.
>
> For the v3 series, I tried out all the ideas suggested by
> Michel. They made perfect sense, but in the end it turned
> out they did not work as well as the simple, aggressive
> "try to make the delay longer" policy I have now. Several
> small bug fixes and cleanups have been integrated.
>
> For the v4 series, I added code to keep the maximum spinlock
> delay to a small value when running in a virtual machine. That
> should solve the performance regression seen in virtual machines.
>
> The performance issue observed with AIM7 is still a mystery.
>
> Performance is within the margin of error of v2, so the graph
> has not been update.
>
> Please let me know if you manage to break this code in any way,
> so I can fix it...
>
I got back on the machine re-ran the AIM7-highsystime microbenchmark 
with a 2000 users and 100 jobs per user
on a 20, 40, 80 vcpu guest using 3.7.5 kernel with and without Rik's 
latest patches.

Host Platform : 8 socket (80 Core) Westmere with 1TB RAM.

Config 1 : 3.7.5 base running on host and in the guest

Config 2 : 3.7.5 + Rik's patches running on host and in the guest

(Note: I didn't change the PLE settings on the host... The severe drop 
from at 40 way and 80 way is due to the un-optimized PLE handler. 
Raghu's PLE's fixes should address those. ).

                           Config 1          Config 2
20vcpu  -              170K               168K
40vcpu  -              37K                   37K
80vcpu  -             10.5K                11.5K


Not much difference between the two configs.. (need to test it along 
with Raghu's fixes).

BTW, I noticed that there were results posted using AIM7-compute 
workload earlier.  The AIM7-highsystime is a lot more kernel intensive.

FYI
Vinod
