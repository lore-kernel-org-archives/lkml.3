Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263Ab3B0Qmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:42:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab3B0Qml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:42:41 -0500
Message-ID: <512E376D.70105@redhat.com>
Date: Wed, 27 Feb 2013 11:42:21 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, aquini@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        linux-tip-commits@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket
 lock out of line
References: <20130206150403.006e5294@cuia.bos.redhat.com> <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org> <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com> <511BE4A3.8050607@redhat.com> <CA+55aFycMB7OZGQ54ueQ74C42beDBSdQE_fKJDV=TbjTjr_emg@mail.gmail.com> <511C1204.9040608@redhat.com> <CA+55aFwxYK-BLH0crhySHaQvAYHOH-VGUi7WTd1aq-24+WTDYw@mail.gmail.com> <511C24A6.8020409@redhat.com> <CA+55aFws80EEJQskqiP+a5J-HOGu=M1Fe=uCs50ifedVxPxT1Q@mail.gmail.com>
In-Reply-To: <CA+55aFws80EEJQskqiP+a5J-HOGu=M1Fe=uCs50ifedVxPxT1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 08:21 PM, Linus Torvalds wrote:
> On Wed, Feb 13, 2013 at 3:41 PM, Rik van Riel <riel@redhat.com> wrote:
>>
>> I have an example of the second case. It is a test case
>> from a customer issue, where an application is contending on
>> semaphores, doing semaphore lock and unlock operations. The
>> test case simply has N threads, trying to lock and unlock the
>> same semaphore.
>>
>> The attached graph (which I sent out with the intro email to
>> my patches) shows how reducing the memory accesses from the
>> spinlock wait path prevents the large performance degradation
>> seen with the vanilla kernel. This is on a 24 CPU system with
>> 4 6-core AMD CPUs.
>>
>> The "prop-N" series are with a fixed delay proportional back-off.
>> You can see that a small value of N does not help much for large
>> numbers of cpus, and a large value hurts with a small number of
>> CPUs. The automatic tuning appears to be quite robust.
>
> Ok, good, so there are some numbers. I didn't see any in the commit
> messages anywhere, and since the threads I've looked at are from
> tip-bot, I never saw the intro email.

Some people at HP have collected an extensive list of AIM 7 results,
all the different AIM 7 workloads, on an 80-core DL-980, with HT
disabled.

The AIM7 workloads all work by slowly increasing the number of
worker processes, all of which have some duty cycle (busy & sleep).
Adding more processes tends to increase the number of jobs/minute
completed, up to a certain point. For some workloads, the system
has a performance peak and performance levels up at or near that
peak, for other workloads performance drops when more processes
are added beyond the peak, and performance drops to a lower plateau.

To keep the results readable and relevant, I am reporting the
plateau performance numbers. Comments are given where required.

		3.7.6 vanilla	3.7.6 w/ backoff

all_utime		333000		333000
alltests	300000-470000	180000-440000	large variability
compute			528000		528000
custom		290000-320000	250000-330000	4 fast runs, 1 slow
dbase			920000		925000
disk			100000	 90000-120000	similar plateau, wild
						swings with patches
five_sec		140000		140000
fserver		160000-300000	250000-430000	w/ patch drops off at
						higher number of users
high_systime	 80000-110000	 30000-125000	w/ patch mostly 40k-70k,
						wild wings
long		no performance platform, equal performance for both
new_dbase		960000		96000
new_fserver	150000-300000	210000-420000	vanilla drops off,
						w/ patches wild swings
shared		270000-440000	120000-440000	all runs ~equal to
						vanilla up to 1000
						users, one out of 5
						runs slows down past
						1100 users
short			120000		190000

In conclusion, the spinlock backoff patches seem to significantly
improve performance in workloads where there is simple contention
on just one or two spinlocks. However, in more complex workloads,
high variability is seen, including performance regression in some
test runs.

One hypothesis is that before the spinlock backoff patches, the
workloads get contention (and bottleneck) on multiple locks. With
the patches, the contention on some of the locks is relieved, and
more tasks bunch up on the remaining bottlenecks, leading to worse
performance.

> That said, it's interesting that this happens with the semaphore path.
> We've had other cases where the spinlock in the *sleeping* locks have
> caused problems, and I wonder if we should look at that path in
> particular.

If we want to get reliable improved performance without unpredictable
performance swings, we should probably change some of the kernel's
spinlocks, especially the ones embedded in sleeping locks, into
scalable locks like Michel's implementation of MCS locks.

We may be hitting the limit of what can be done with the current
ticket lock data structure. It simply may not scale as far as the
hardware on which Linux is being run.

-- 
All rights reversed
