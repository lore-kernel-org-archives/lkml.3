Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622Ab3BZRzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 12:55:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50460 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab3BZRzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 12:55:02 -0500
Date: Tue, 26 Feb 2013 17:54:39 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Steve Muckle <smuckle@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: vfp: fix fpsid register subarchitecture field
	mask width
Message-ID: <20130226175439.GT17833@n2100.arm.linux.org.uk>
References: <1361520485-30269-1-git-send-email-sboyd@codeaurora.org> <20130222182705.GC19527@mudshark.cambridge.arm.com> <5128034A.4000008@codeaurora.org> <20130225111835.GA24254@mudshark.cambridge.arm.com> <512C2577.3030202@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512C2577.3030202@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 07:01:11PM -0800, Stephen Boyd wrote:
> On 02/25/13 03:18, Will Deacon wrote:
> > On Fri, Feb 22, 2013 at 11:46:18PM +0000, Stephen Boyd wrote:
> >> On 2/22/2013 10:27 AM, Will Deacon wrote:
> >>> What value do you have in fpsid? As far as I can tell, the
> >>> subarchitecture bits 6:0 should start at 0x40 for you, right?
> >> Yes it does.
> > Ok, good. Could you share the different subarchitecture encodings that you
> > have please? (assumedly some/all of these are compatible with a variant of
> > VFP).
> 
> Definitely all Krait processors have 0x40 for the subarchitecture
> encoding. I need to check our Scorpions but I'm fairly certain they also
> have 0x40.
> 
> >
> >>> I can see cases for changing this code, I just don't see why it would go
> >>> wrong in the case you're describing.
> >> VFP_arch = (vfpsid & FPSID_ARCH_MASK) >> FPSID_ARCH_BIT;
> >>
> >> causes VFP_arch to be equal to 0 because 0x40 & 0xf == 0.
> >>
> >> and then a little bit later we have
> >>
> >>                if (VFP_arch >= 2) {
> >>                         elf_hwcap |= HWCAP_VFPv3;
> >>
> >>
> >> The branch is not taken so we never set VFPv3.
> > Ah, that's what I feared: the low bits are zero yet you are compatible with
> > VFPv3. That's fine, but the proposed fix feels like a kludge; the only reason
> > we'd choose on VFPv3 is because the implementor is not ARM, which may not hold
> > true for other vendors. I think it would be better if we translated
> > vendor-specific subarchitectures that are compatible with VFPvN into the
> > corresponding architecture number instead. This would also allow us to add
> > extra hwcaps for extensions other than VFP.
> 
> Ok. We should be able to make VFP_arch into 0x4 if the implementer is
> 0x51 and the subarch bits are 0x40.

What I actually need from you is: for the Qualcomm implementation, what
are the subarch bits defined as, and what do they correspond with - both
the VFP version, and whether they correspond with any ARM common VFP
subarchitecture version.

The VFP version defines what the user-visible architecture of the VFP
looks like.

The common VFP subarchitecture version partly defines the behaviour of
the interface between the VFP hardware and the support code.

In ARM land, these are the possiblities - I've also listed those
platforms which I definitely know of at the moment which use the
particular version combination:

VFP version	VFP subarch
V1		-
V2		V1		Raspberry Pi
V3		V2		Marvell Dove (Cubox) (though, not ARM)
V3		NULL		OMAP3430 / OMAP4430
V3		V3

There is also mooted to be a VFPv4...

Now, we detect VFPv4 via testing for the "fused multiply accumulate"
instructions, and flag that to userspace.  These are the VFMA, VFMS,
VFNMA, and VFNMS instructions.  HOWEVER: we do not implement these in
the support code, so should these ever get bounced, we will fail to
deal with them correctly.  So VFPv4 should not be flagged as being
implemented yet.

Not only that, but VFPv4 introduces the half-precision extension as
mandatory - which the support code doesn't support.

Also... there seems to be a variant of VFPv3 with half-precision
support... which the support code doesn't support either.

And finally we get into the issues surrounding trapping/nontrapping
implementations - nontrapping implementations are ones where (for
example) a floating point divide by zero can't raise a SIGFPE...

Last comment to make: this evening I'm beginning to wonder whether I've
made a messup with the VFP support code: if we get a bounce due to an
unmasked trap, we perform the operation in software and store the result.
I don't think this is what's intended from the support code.  Problem -
the OMAP platforms are nontrapping VFPv3 implementations which can't
have their trap enable bits set, so I can't check this there.

Dove does, but I don't use that as too much of a devel platform at the
moment... and I don't have a RPi that I can build and boot kernels for
(the one I've been experimenting with is someone elses, the other end
of the country, who is not a software guy...)
