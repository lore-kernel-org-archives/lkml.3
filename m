Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab3HLR6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:58:38 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:48547 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab3HLR6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:58:34 -0400
Date: Mon, 12 Aug 2013 19:58:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] per-cpu preempt_count
Message-ID: <20130812175830.GB18691@gmail.com>
References: <20130812115113.GE27162@twins.programming.kicks-ass.net>
 <CA+55aFznj9WqGa_Qa0B4=5iTio2br54uJG7xkm6otN2sG2P=8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFznj9WqGa_Qa0B4=5iTio2br54uJG7xkm6otN2sG2P=8w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Aug 12, 2013 at 4:51 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > The below boots to wanting to mount a root filesystem with
> > CONFIG_PREEMPT=y using kvm -smp 4.
> 
> But doesn't work in general? Or you just never tested?

(I think Peter never tested it on real hw - this is an RFC patch to show 
the concept .)

> > Adding TIF_NEED_RESCHED into the preempt count would allow a single 
> > test in preempt_check_resched() instead of still needing the TI. 
> > Removing PREEMPT_ACTIVE from preempt count should allow us to get rid 
> > of ti::preempt_count altogether.
> >
> > The only problem with TIF_NEED_RESCHED is that its cross-cpu which 
> > would make the entire thing atomic which would suck donkey balls so 
> > maybe we need two separate per-cpu variables?
> 
> Agreed. Making it atomic would suck, and cancel all advantages of the 
> better code generation to access it. Good point.

We could still have the advantages of NEED_RESCHED in preempt_count() by 
realizing that we only rarely actually set/clear need_resched and mostly 
read it from the highest freq user, the preempt_enable() check.

So we could have it atomic, but do atomic_read() in the preempt_enable() 
hotpath which wouldn't suck donkey balls, right?

That would allow a really sweet preempt_enable() fastpath, on x86 at 
least.

Thanks,

	Ingo
