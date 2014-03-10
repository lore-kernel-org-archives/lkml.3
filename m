Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaCJMLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:11:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbaCJMLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:11:45 -0400
Date: Mon, 10 Mar 2014 13:11:30 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        alex.williamson@redhat.com, mtosatti@redhat.com, gleb@kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH 3/7] KVM: x86: Allow the guest to run with dirty debug
 registers
Message-ID: <20140310121129.GA16023@potion.brq.redhat.com>
References: <1394192571-11056-1-git-send-email-pbonzini@redhat.com>
 <1394192571-11056-4-git-send-email-pbonzini@redhat.com>
 <20140309182825.GA11078@potion.redhat.com>
 <531CC9EC.1000804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <531CC9EC.1000804@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-09 21:07+0100, Paolo Bonzini:
> Il 09/03/2014 19:28, Radim Krčmář ha scritto:
> >>>  	/*
> >>> +	 * Do this here before restoring debug registers on the host.  And
> >>> +	 * since we do this before handling the vmexit, a DR access vmexit
> >>> +	 * can (a) read the correct value of the debug registers, (b) set
> >>> +	 * KVM_DEBUGREG_WONT_EXIT again.
> >We re-enable intercepts on the next exit for the sake of simplicity?
> >(Batched accesses make perfect sense, but it seems we don't have to care
> > about DRs at all, without guest-debug.)
> 
> It's not just for the sake of simplicity.  Synchronizing debug
> registers on entry does have some cost, and it's required for
> running without debug register intercepts.  You would incur this
> cost always, since no-guest-debug is actually the common case.

Good point, it's just this case that accesses them often, most guest
won't use them at all ...

> We're well into diminishing returns; Alex timed this patch vs. one
> that completely ignores MOV DR exits and (to the surprise of both of
> us) this patch completely restored performance despite still having
> a few tens of thousands MOV DR exits/second.
> 
> In the problematic case, each context switch will do a save and
> restore of debug registers; that's in total 13 debug register
> accesses (read 6 registers, write DR7 to disable all registers,
> write 6 registers including DR7 which enables breakpoints), all very
> close in time.  It's quite likely that the final DR7 write is very
> expensive (e.g. it might have to flush the pipeline).  Also, this
> test case must be very heavy on context switches, and each context
> switch already incurs a few exits (for example to inject the
> interrupt that causes it, to read the current time).

We would save just one exit and there are probably enough non-DR exits
even in this case to balance it out.
I've been carried too far away for design.
(Thanks for the details.)

> A different optimization could be to skip the LOAD_DEBUG_CONTROLS
> vm-entry control if DR7 == host DR7 == 0x400 && MOV DR exits are
> enabled.  Not sure it's worthwhile though, and there's also the
> DEBUGCTL MSR to take into account.  Better do these kinds of tweaks
> if they actually show up in the profile: Alex's testcase shows that
> when they do, the impact is massive.

Yeah, we'd have to implement TRUE-VMX-MSR handling just for two
load/stores ...

> >>+		kvm_x86_ops->sync_dirty_debug_regs(vcpu);
> >
> >Sneaky functionality ... it would be nicer to split 'enable DR
> >intercepts' into a new kvm op.
> 
> Why?  "Disable DR intercepts" is already folded into the handler for
> MOV DR exits.

It's not obvious from the name that we also enable intercepts again,
which is more important part, imho.
(I don't like the folded code much, but considering the alternatives,
 it's a good solution.)

> >And we don't have to modify DR intercepts then, which is probably the
> >main reason why sync_dirty_debug_regs() does two things.
> 
> Another is that indirect calls are relatively expensive and add
> complexity; in this case they would always be used back-to-back.

True.
(I could not come up with a good name to this function,
 intercept_debug_registers() does not reveal that we also save them, and
 a longer name would be hard to read without 'and', which looks weird.)
