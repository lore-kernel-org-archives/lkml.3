Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3AXK4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:56:54 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:61358 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab3AXKyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:54:39 -0500
Date: Thu, 24 Jan 2013 11:54:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] mutex: use spin_[un]lock instead of
 arch_spin_[un]lock
Message-ID: <20130124105434.GA29956@gmail.com>
References: <1359019365-23646-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1359019365-23646-2-git-send-email-yuanhan.liu@linux.intel.com>
 <20130124095807.GA26351@gmail.com>
 <20130124101305.GE12678@yliu-dev.sh.intel.com>
 <20130124101450.GA27602@gmail.com>
 <20130124102747.GF12678@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124102747.GF12678@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:

> On Thu, Jan 24, 2013 at 11:14:50AM +0100, Ingo Molnar wrote:
> > 
> > * Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> > 
> > > On Thu, Jan 24, 2013 at 10:58:07AM +0100, Ingo Molnar wrote:
> > > > 
> > > > * Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> > > > 
> > > > > Use spin_[un]lock instead of arch_spin_[un]lock in mutex-debug.h so
> > > > > that we can collect the lock statistics of spin_lock_mutex from
> > > > > /proc/lock_stat.
> > > > > 
> > > > > Cc: Ingo Molnar <mingo@kernel.org>
> > > > > Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> > > > > ---
> > > > >  kernel/mutex-debug.h |    4 ++--
> > > > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/kernel/mutex-debug.h b/kernel/mutex-debug.h
> > > > > index 0799fd3..556c0bc 100644
> > > > > --- a/kernel/mutex-debug.h
> > > > > +++ b/kernel/mutex-debug.h
> > > > > @@ -43,13 +43,13 @@ static inline void mutex_clear_owner(struct mutex *lock)
> > > > >  							\
> > > > >  		DEBUG_LOCKS_WARN_ON(in_interrupt());	\
> > > > >  		local_irq_save(flags);			\
> > > > > -		arch_spin_lock(&(lock)->rlock.raw_lock);\
> > > > > +		spin_lock(lock);			\
> > > > 
> > > > But in that case it could probably use the spin_lock_irqsave() 
> > > > primitive, right?
> > > 
> > > Right, in that case I should use spin_lock_irqsave.
> > > 
> > > But one question, why we use spin_lock at kernel/mutex.h, 
> > > while use 'local_irq_save(); arch_spin_lock' at 
> > > kernel/mutex-debug.h?
> > > 
> > > Shouldn't we keep it consistent? Say use spin_lock_irqsave?
> > 
> > I think we did it to increase performance with lockdep enabled - 
> > this particular lockdep annotation, given the short codepaths, 
> > is not that hard to verify - and if it breaks it will break a 
> > thousand mutex locking places in the kernel.
> 
> Thanks for the explanation.
> > 
> > So maybe it's better to leave it alone - maybe add a comment 
> > that explains the reason.
> 
> Sorry, I may not get your point clearly. Should I make another 
> patch to convert 'local_irq_save(..); arch_spin_lock(..);' at 
> kernel/mutex-debug.h to spin_lock_irqsave() then?

No, I'd suggest to add a comment that explains why there's no 
lockdep annotation in that place.

Thanks,

	Ingo
