Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbaAOHEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 02:04:13 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:38826 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaAOHEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 02:04:10 -0500
Message-ID: <1389769445.2944.33.camel@j-VirtualBox>
Subject: Re: [RFC 3/3] mutex: When there is no owner, stop spinning after
 too many tries
From: Jason Low <jason.low2@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        Waiman.Long@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com, davidlohr@hp.com,
        hpa@zytor.com, aswin@hp.com, scott.norton@hp.com
Date: Tue, 14 Jan 2014 23:04:05 -0800
In-Reply-To: <20140114170056.7e93f279e11c751acb15ae67@linux-foundation.org>
References: <1389745990-7069-1-git-send-email-jason.low2@hp.com>
	 <1389745990-7069-4-git-send-email-jason.low2@hp.com>
	 <20140114170056.7e93f279e11c751acb15ae67@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-14 at 17:00 -0800, Andrew Morton wrote:
> On Tue, 14 Jan 2014 16:33:10 -0800 Jason Low <jason.low2@hp.com> wrote:
> 
> > When running workloads that have high contention in mutexes on an 8 socket
> > machine, spinners would often spin for a long time with no lock owner.
> > 
> > One of the potential reasons for this is because a thread can be preempted
> > after clearing lock->owner but before releasing the lock, or preempted after
> > acquiring the mutex but before setting lock->owner. In those cases, the
> > spinner cannot check if owner is not on_cpu because lock->owner is NULL.
> 
> That sounds like a very small window.  And your theory is that this
> window is being hit sufficiently often to impact aggregate runtime
> measurements, which sounds improbable to me?
> 
> > A solution that would address the preemption part of this problem would
> > be to disable preemption between acquiring/releasing the mutex and
> > setting/clearing the lock->owner. However, that will require adding overhead
> > to the mutex fastpath.
> 
> preempt_disable() is cheap, and sometimes free.
> 
> Have you confirmed that the preempt_disable() approach actually fixes
> the performance issues?  If it does then this would confirm your
> "potential reason" hypothesis.  If it doesn't then we should be hunting
> further for the explanation.

Using Ingo's test-mutex application (http://lkml.org/lkml/2006/1/8/50)
which can also generate high mutex contention, the preempt_disable()
approach did provide approximately a 4% improvement at 160 threads, but
not nearly the 25+% I was seeing with this patchset. So, it looks like
preemption is not the main cause of the problem then.

Thanks,
Jason

