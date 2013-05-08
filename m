Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab3EHWjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 18:39:18 -0400
Received: from ozlabs.org ([203.10.76.45]:36299 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274Ab3EHWjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 18:39:16 -0400
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: eranian@google.com, Linux PPC dev <linuxppc-dev@ozlabs.org>,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au,
        Anshuman Khandual <anshuman.khandual@in.ibm.com>
Subject: Re: Invalid perf_branch_entry.to entries question
In-reply-to: <20130508155929.GA8459@dyad.programming.kicks-ass.net>
References: <25394.1367890528@ale.ozlabs.ibm.com> <20130508155929.GA8459@dyad.programming.kicks-ass.net>
Comments: In-reply-to Peter Zijlstra <peterz@infradead.org>
   message dated "Wed, 08 May 2013 17:59:29 +0200."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Thu, 09 May 2013 08:39:15 +1000
Message-ID: <14691.1368052755@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, May 07, 2013 at 11:35:28AM +1000, Michael Neuling wrote:
> > Peter & Stephane,
> > 
> > We are plumbing the POWER8 Branch History Rolling Buffer (BHRB) into
> > struct perf_branch_entry.
> > 
> > Sometimes on POWER8 we may not be able to fill out the "to" address.  
> 
> Just because I'm curious.. however does that happen? Surely the CPU
> knows where next to fetch instructions?

For computed gotos (ie. branch to a register value), the hardware gives
you the from and to address in the branch history buffer.

For branches where the branch target address is an immediate encoded in
the instruction, the hardware only logs the from address.  It assumes
that software (perf irq handler in this case) can read this branch
instruction, calculate the corresponding offset and hence the
to/target address.

It's entirely possible that when the perf IRQ handler happens, the
instruction in question is not readable or is no longer a branch (self
modifying code).  Hence we aren't able to calculate a valid to address.

Mikey

> 
> > We
> > initially thought of just making this 0, but it's feasible that this
> > could be a valid address to branch to. 
> 
> Right, while highly unlikely, x86 actually has some cases where 0 address is
> valid *shudder*..
> 
> > The other logical value to indicate an invalid entry would be all 1s
> > which is not possible (on POWER at least).
> > 
> > Do you guys have a preference as to what we should use as an invalid
> > entry?  This would have some consequences for the userspace tool also.
> > 
> > The alternative would be to add a flag alongside mispred/predicted to
> > indicate the validity of the "to" address.
> 
> Either would work with me I suppose.. Stephane do you have any preference?
> 
