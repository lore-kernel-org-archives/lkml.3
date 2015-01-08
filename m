Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbbAHKh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 05:37:26 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:34437 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbbAHKhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 05:37:24 -0500
Date: Thu, 8 Jan 2015 11:37:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Huang Ying <ying.huang@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [mm] c8c06efa8b5: -7.6% unixbench.score
Message-ID: <20150108103708.GE29390@twins.programming.kicks-ass.net>
References: <1420684064.6201.86.camel@linux.intel.com>
 <1420703154.12346.10.camel@stgolabs.net>
 <1420703414.12346.12.camel@stgolabs.net>
 <1420707599.12346.14.camel@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420707599.12346.14.camel@stgolabs.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 12:59:59AM -0800, Davidlohr Bueso wrote:
> > > >     721721 ±  1%    +303.6%    2913110 ±  3%  unixbench.time.voluntary_context_switches
> > > >      11767 ±  0%      -7.6%      10867 ±  1%  unixbench.score

> heh I was actually looking at the reader code. We really do:
> 
> 	/* wait until we successfully acquire the lock */
> 	set_current_state(TASK_UNINTERRUPTIBLE);
> 	while (true) {
> 		if (rwsem_try_write_lock(count, sem))
> 			break;
> 		raw_spin_unlock_irq(&sem->wait_lock);
> 
> 		/* Block until there are no active lockers. */
> 		do {
> 			schedule();
> 			set_current_state(TASK_UNINTERRUPTIBLE);
> 		} while ((count = sem->count) & RWSEM_ACTIVE_MASK);
> 
> 		raw_spin_lock_irq(&sem->wait_lock);
> 	}
> 
> 
> Which still has similar issues with even two barriers, I guess for both
> the rwsem_try_write_lock call (less severe) and count checks. Anyway...

So its actually scheduling a lot more, this could also mean the opt
spinning thing isn't working as well (I've no real idea what the
workload is).

One thing I noticed is that we set sem->owner very late in comparison
with the mutex code, this could cause us to break out of the spin loop
prematurely.
