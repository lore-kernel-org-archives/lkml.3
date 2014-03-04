Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbaCDVM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:12:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44964 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932842AbaCDVMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:12:54 -0500
Message-ID: <531641A8.40306@zytor.com>
Date: Tue, 04 Mar 2014 13:12:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Khalid Aziz <khalid.aziz@oracle.com>, tglx@linutronix.de,
        Ingo Molnar <mingo@kernel.org>, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com, venki@google.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
In-Reply-To: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 10:07 AM, Khalid Aziz wrote:
> 
> I am working on a feature that has been requested by database folks that
> helps with performance. Some of the oft executed database code uses
> mutexes to lock other threads out of a critical section. They often see
> a situation where a thread grabs the mutex, runs out of its timeslice
> and gets switched out which then causes another thread to run which
> tries to grab the same mutex, spins for a while and finally gives up.
> This can happen with multiple threads until original lock owner gets the
> CPU again and can complete executing its critical section. This queueing
> and subsequent CPU cycle wastage can be avoided if the locking thread
> could request to be granted an additional timeslice if its current
> timeslice runs out before it gives up the lock. Other operating systems
> have implemented this functionality and is used by databases as well as
> JVM. This functionality has been shown to improve performance by 3%-5%.
> 
> I have implemented similar functionality for Linux. This patch adds a
> file /proc/<tgid>/task/<tid>/sched_preempt_delay for each thread.
> Writing 1 to this file causes CFS scheduler to grant additional time
> slice if the currently running process comes up for pre-emption. Writing
> to this file needs to be very quick operation, so I have implemented
> code to allow mmap'ing /proc/<tgid>/task/<tid>/sched_preempt_delay. This
> allows a userspace task to write this flag very quickly. Usage model is
> a thread mmaps this file during initialization. It then writes a 1 to
> the mmap'd file after it grabs the lock in its critical section where it
> wants immunity from pre-emption. It then writes 0 again to this file
> after it releases the lock and calls sched_yield() to give up the
> processor. I have also added a new field in scheduler statistics -
> nr_preempt_delayed, that counts the number of times a thread has been
> granted amnesty. Further details on using this functionality are in 
> Documentation/scheduler/sched-preempt-delay.txt in the patch. This
> patch is based upon the work Venkatesh Pallipadi had done couple of
> years ago.
> 

Shades of the Android wakelocks, no?

This seems to effectively give userspace an option to turn preemptive
multitasking into cooperative multitasking, which of course is
unacceptable for a privileged process (the same reason why unprivileged
processes aren't allowed to run at above-normal priority, including RT
priority.)

I have several issues with this interface:

1. First, a process needs to know if it *should* have been preempted
before it calls sched_yield().  So there needs to be a second flag set
by the scheduler when granting amnesty.

2. A process which fails to call sched_yield() after being granted
amnesty must be penalized.

3. I'm not keen on occupying a full page for this.  I'm wondering if
doing a pointer into user space, futex-style, might make more sense.
The downside, of course, is what happens if the page being pointed to is
swapped out.

Keep in mind this HAS to be per thread.

	-hpa


