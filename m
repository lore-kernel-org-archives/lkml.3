Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbaCYXBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 19:01:14 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:21793 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaCYXBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 19:01:12 -0400
Message-ID: <1395788467.2480.6.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
From: Davidlohr Bueso <davidlohr@hp.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com, venki@google.com,
        linux-kernel@vger.kernel.org
Date: Tue, 25 Mar 2014 16:01:07 -0700
In-Reply-To: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-03 at 11:07 -0700, Khalid Aziz wrote:
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
> Please provide feedback on this functionality and patch.

Good timing! The topic came up just yesterday in LSF/MM. This
functionality is on the wish list for both facebook and postgres.

