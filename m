Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab3G2VVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:21:43 -0400
Received: from mx1.corp.phx1.mozilla.com ([63.245.216.69]:61322 "EHLO
	smtp.mozilla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab3G2VVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:21:42 -0400
Date: Mon, 29 Jul 2013 14:21:40 -0700
From: Jed Davis <jld@mozilla.com>
To: Dave Martin <Dave.Martin@arm.com>, Will Deacon <will.deacon@arm.com>
Cc: Robert Richter <rric@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: Fix r7/r11 confusion when CONFIG_THUMB2_KERNEL=y
Message-ID: <20130729212140.GB12681@mozilla.com>
References: <1373685501-1620-1-git-send-email-jld@mozilla.com>
 <20130715135420.GG10000@mudshark.cambridge.arm.com>
 <20130720044655.GC9433@mozilla.com>
 <20130721213753.GA29879@mudshark.cambridge.arm.com>
 <20130722185234.GA14519@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130722185234.GA14519@localhost.localdomain>
X-User-Agent-Host: Linux nimbostratus 3.2.0-4-amd64 x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 07:52:39PM +0100, Dave Martin wrote:
> On Sun, Jul 21, 2013 at 10:37:53PM +0100, Will Deacon wrote:
> > Ok, I think I'm with you now. I also think that a better solution would be
> > to try and limit the r7/fp confusion to one place, perhaps behind something
> > like:
> > 
> > void arm_get_current_stackframe(struct pt_regs *regs, struct stackframe *frame);
> > 
> > then that function can act as the bridge between pt_regs (where we leave
> > everything as it is) and stackframe (where we assign either r7 or fp into
> > the fp member). Then we just fix up the call sites to pass the regs they're
> > interested in to our new function.
> > 
> > What do you think?

I can see that being useful if we wanted to opacify struct stackframe,
but... all uses of stackframe that I see involve passing it to
unwind_frame, which expands it back out into an array of registers.
(Except with CONFIG_FRAME_POINTER, but "APCS variants that require a
frame pointer register are obsolete.")

So... why not make pt_regs and stackframe the same, and avoid the
translations entirely?

> Do the ARM unwind tables guarantee not to need knowledge of any
> virtual registers for the purpose of processing the opcodes of a single
> function's unwind table entry, except those virtual regs that we happen
> to initialise?  Or do we just rely on luck?

Yes, for some value of "luck".  The spec documents 0x90|N, for N a core
register number other than 13 or 15, as setting the vSP to the value of
virtual register N.  We can get away with some omissions for kernel code
(e.g., unwind.c doesn't handle saved floating point registers, nor adding
constants larger than 1024 to vSP), but is this one of them?

[...]
> The purist answer seems to be: we might need all the regs in struct
> stackframe.
> 
> The pragmatic answer might be that we definitely need r7 for Thumb code,
> but given the nimbleness of GCC to evolve we might get away with not
> including extra registers for a long time yet.

The other question to ask here might be: what does the "pragmatic
answer" gain us over the "purist answer"?

> A review of existing custom unwind annotations might be a good idea
> anyway, to check whether any of them requires another register right now.

`egrep -r '\.(setf|movs)p' arch/arm` finds nothing, for what it's worth.

--Jed

