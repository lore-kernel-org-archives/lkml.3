Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaAOHe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 02:34:58 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:3145 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaAOHe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 02:34:56 -0500
Message-ID: <1389771288.2944.58.camel@j-VirtualBox>
Subject: Re: [RFC 3/3] mutex: When there is no owner, stop spinning after
 too many tries
From: Jason Low <jason.low2@hp.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: mingo@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        Waiman.Long@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, hpa@zytor.com, aswin@hp.com,
        scott.norton@hp.com
Date: Tue, 14 Jan 2014 23:34:48 -0800
In-Reply-To: <1389747999.4971.27.camel@buesod1.americas.hpqcorp.net>
References: <1389745990-7069-1-git-send-email-jason.low2@hp.com>
	 <1389745990-7069-4-git-send-email-jason.low2@hp.com>
	 <1389747999.4971.27.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-14 at 17:06 -0800, Davidlohr Bueso wrote:
> On Tue, 2014-01-14 at 16:33 -0800, Jason Low wrote:
> > When running workloads that have high contention in mutexes on an 8 socket
> > machine, spinners would often spin for a long time with no lock owner.
> > 
> > One of the potential reasons for this is because a thread can be preempted
> > after clearing lock->owner but before releasing the lock
> 
> What happens if you invert the order here? So mutex_clear_owner() is
> called after the actual unlocking (__mutex_fastpath_unlock).

Reversing the mutex_fastpath_unlock and mutex_clear_owner resulted in a
20+% performance improvement to Ingo's test-mutex application at 160
threads on an 8 socket box.

I have tried this method before, but what I was initially concerned
about with clearing the owner after unlocking was that the following
scenario may occur.

thread 1 releases the lock
thread 2 acquires the lock (in the fastpath)
thread 2 sets the owner
thread 1 clears owner

In this situation, lock owner is NULL but thread 2 has the lock.

> >  or preempted after
> > acquiring the mutex but before setting lock->owner. 
> 
> That would be the case _only_ for the fastpath. For the slowpath
> (including optimistic spinning) preemption is already disabled at that
> point.

Right, for just the fastpath_lock.

> > In those cases, the
> > spinner cannot check if owner is not on_cpu because lock->owner is NULL.
> > 
> > A solution that would address the preemption part of this problem would
> > be to disable preemption between acquiring/releasing the mutex and
> > setting/clearing the lock->owner. However, that will require adding overhead
> > to the mutex fastpath.
> 
> It's not uncommon to disable preemption in hotpaths, the overhead should
> be quite smaller, actually.
> 
> > 
> > The solution used in this patch is to limit the # of times thread can spin on
> > lock->count when !owner.
> > 
> > The threshold used in this patch for each spinner was 128, which appeared to
> > be a generous value, but any suggestions on another method to determine
> > the threshold are welcomed.
> 
> Hmm generous compared to what? Could you elaborate further on how you
> reached this value? These kind of magic numbers have produced
> significant debate in the past.

I've observed that when running workloads which don't exhibit this
behavior (long spins with no owner), threads rarely take more than 100
extra spins. So I went with 128 based on those number.

