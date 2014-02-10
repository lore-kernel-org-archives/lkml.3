Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaBJSQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:16:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56497 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaBJSQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:16:34 -0500
Date: Mon, 10 Feb 2014 19:16:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-rt-users@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>
Subject: Re: allow preemption in check_task_state
Message-ID: <20140210181608.GE27965@twins.programming.kicks-ass.net>
References: <20140210153856.GD20017@opentech.at>
 <20140210111106.67438d1e@gandalf.local.home>
 <20140210171712.GA17517@opentech.at>
 <20140210173833.GQ9987@twins.programming.kicks-ass.net>
 <20140210181203.GA17914@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210181203.GA17914@opentech.at>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 07:12:03PM +0100, Nicholas Mc Guire wrote:
> On Mon, 10 Feb 2014, Peter Zijlstra wrote:
> 
> > On Mon, Feb 10, 2014 at 06:17:12PM +0100, Nicholas Mc Guire wrote:
> > > maybe I'm missing/missunderstanding something here but
> > > pi_unlock -> arch_spin_unlock is a full mb() 
> > 
> > Nope, arch_spin_unlock() on x86 is a single add[wb] without LOCK prefix.
> > 
> > The lock and unlock primitives are in general specified to have ACQUIRE
> > resp. RELEASE semantics.
> > 
> > See Documentation/memory-barriers.txt for far too much head-hurting
> > details.
> 
> I did check that - but from the code check it seems to me to be using a
> lock prefix in the fast __add() path and an explicit smp_add() in the slow
> path (arch/x86/include/asm/spinlock.h:arch_spin_unlock) the __add from 
> arch/x86/include/asm/cmpxchg.h does lock or am I missinterpreting this ?
> the other archs I believe were all doing explicit mb()/smp_mb() in the 
> arch_spin_unlock - will go check this again.

It uses UNLOCK_LOCK_PREFIX, which if you look carefully, is normally
always "". Only some 'broken' i386 chips require a LOCK there.
