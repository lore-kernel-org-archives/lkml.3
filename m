Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab3GVSyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:54:20 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:44187 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932957Ab3GVSyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:54:19 -0400
Date: Mon, 22 Jul 2013 19:52:39 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Jed Davis <jld@mozilla.com>, Robert Richter <rric@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: Fix r7/r11 confusion when CONFIG_THUMB2_KERNEL=y
Message-ID: <20130722185234.GA14519@localhost.localdomain>
References: <1373685501-1620-1-git-send-email-jld@mozilla.com>
 <20130715135420.GG10000@mudshark.cambridge.arm.com>
 <20130720044655.GC9433@mozilla.com>
 <20130721213753.GA29879@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130721213753.GA29879@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 21, 2013 at 10:37:53PM +0100, Will Deacon wrote:
> Hello Jed,
> 
> Thanks for the reply.
> 
> On Sat, Jul 20, 2013 at 05:46:55AM +0100, Jed Davis wrote:
> > On Mon, Jul 15, 2013 at 02:54:20PM +0100, Will Deacon wrote:
> > > On Sat, Jul 13, 2013 at 04:18:20AM +0100, Jed Davis wrote:
> > [...]
> > > > Effects of this are probably limited to failure of EHABI unwinding when
> > > > starting from a function that uses r7 to restore its stack pointer, but
> > > > the possibility for further breakage (which would be invisible on
> > > > non-Thumb kernels) is worrying.
> > [...]
> > > I'm struggling to understand exactly the problem that this patch is trying
> > > to address. If it's just a code consistency issue, I don't think it's worth
> > > it (I actually find it less confusing the way we currently have things) but
> > > if there is a real bug, perhaps you could provide a testcase?
> > 
> > There is a real bug here, but my commit message wasn't very clear.  This
> > was breaking PERF_COUNT_SW_CONTEXT_SWITCHES with CONFIG_THUMB2_KERNEL=y
> > (with my other recently posted patch applied), because kernel/sched.c is
> > built with -fno-omit-frame-pointer (which is wrong, but that's a problem
> > for another patch) and so __schedule's EHABI entry uses 0x97 (mov sp, r7),
> > and somewhere along the line the unwinder gets the r11 value instead.
> > This would also apply to any function with a variable-length array, but
> > __schedule happens to have the perf hook I was trying to use.
> 
> Ok, I think I'm with you now. I also think that a better solution would be
> to try and limit the r7/fp confusion to one place, perhaps behind something
> like:
> 
> void arm_get_current_stackframe(struct pt_regs *regs, struct stackframe *frame);
> 
> then that function can act as the bridge between pt_regs (where we leave
> everything as it is) and stackframe (where we assign either r7 or fp into
> the fp member). Then we just fix up the call sites to pass the regs they're
> interested in to our new function.
> 
> What do you think?

Do the ARM unwind tables guarantee not to need knowledge of any
virtual registers for the purpose of processing the opcodes of a single
function's unwind table entry, except those virtual regs that we happen
to initialise?  Or do we just rely on luck?

For compiler-generated unwind entries, sp is likely to be enough in most
cases... but I think that may be more a gcc implementation detail than
an ABI guarantee.  For custom unwind entries (we do have a few of those)
I think all bets might be off... but again, there's a limit to how
insane those are likely to be in practice, and there aren't many of
them.

If the unwind tables might need the value of r7 (or other random
registers), then we need r7 (or all possible regs) in struct stackframe.


Compiling a function with a simple runtime-sized array causes GCC
to generate:

        .setfp r7, sp, #0

among the unwind annotations, so the unwind opcodes will definitely
refer to r7 in that case.  But r7 is not a magic register in the ABI, so
I think the compiler would be allowed to use any other register for the
same purpose...

Frames of this sort will be relatively unusual, which might be why this
wasn't identified as a problem earlier.


GCC's commitment to r7 if a frame pointer is needed in Thumb appears
quite strong, even with -fomit-frame-pointer... but this is still
an implementation detail of GCC and a legacy of Thumb-1, rather than
ABI.

A variable-sized frame seems to cause GCC to force r7 as a framepointer
anyway.  Trying to clobber r7 from an asm within such a frame results
in a compile error, even with -fomit-frame-pointer.


The purist answer seems to be: we might need all the regs in struct
stackframe.

The pragmatic answer might be that we definitely need r7 for Thumb code,
but given the nimbleness of GCC to evolve we might get away with not
including extra registers for a long time yet.  Thumb code probably
doesn't use r11 ("fp") in the same way, though that will be needed for
ARM (with or without ARM_UNWIND).

A review of existing custom unwind annotations might be a good idea
anyway, to check whether any of them requires another register right now.


Cheers
---Dave

