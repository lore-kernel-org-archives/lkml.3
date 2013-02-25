Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366Ab3BYLSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 06:18:53 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39206 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030Ab3BYLSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 06:18:52 -0500
Date: Mon, 25 Feb 2013 11:18:35 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Steve Muckle <smuckle@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: vfp: fix fpsid register subarchitecture field mask
 width
Message-ID: <20130225111835.GA24254@mudshark.cambridge.arm.com>
References: <1361520485-30269-1-git-send-email-sboyd@codeaurora.org>
 <20130222182705.GC19527@mudshark.cambridge.arm.com>
 <5128034A.4000008@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5128034A.4000008@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 11:46:18PM +0000, Stephen Boyd wrote:
> On 2/22/2013 10:27 AM, Will Deacon wrote:
> > Hi guys,
> >
> > On Fri, Feb 22, 2013 at 08:08:05AM +0000, Stephen Boyd wrote:
> >> From: Steve Muckle <smuckle@codeaurora.org>
> >>
> >> The subarchitecture field in the fpsid register is 7 bits wide.
> >> The topmost bit is used to designate that the subarchitecture
> >> designer is not ARM. We use this field to determine which VFP
> >> version is supported by the CPU. Since the topmost bit is masked
> >> off we detect non-ARM subarchitectures as supporting only
> >> HWCAP_VFP and not HWCAP_VFPv3 as it should be for Qualcomm's
> >> processors.
> > I'm struggling to see why this has anything to do with the hwcaps being set
> > incorrectly. What value do you have in fpsid? As far as I can tell, the
> > subarchitecture bits 6:0 should start at 0x40 for you, right?
> 
> Yes it does.

Ok, good. Could you share the different subarchitecture encodings that you
have please? (assumedly some/all of these are compatible with a variant of
VFP).

> >
> > I can see cases for changing this code, I just don't see why it would go
> > wrong in the case you're describing.
> 
> VFP_arch = (vfpsid & FPSID_ARCH_MASK) >> FPSID_ARCH_BIT;
> 
> causes VFP_arch to be equal to 0 because 0x40 & 0xf == 0.
> 
> and then a little bit later we have
> 
>                if (VFP_arch >= 2) {
>                         elf_hwcap |= HWCAP_VFPv3;
> 
> 
> The branch is not taken so we never set VFPv3.

Ah, that's what I feared: the low bits are zero yet you are compatible with
VFPv3. That's fine, but the proposed fix feels like a kludge; the only reason
we'd choose on VFPv3 is because the implementor is not ARM, which may not hold
true for other vendors. I think it would be better if we translated
vendor-specific subarchitectures that are compatible with VFPvN into the
corresponding architecture number instead. This would also allow us to add
extra hwcaps for extensions other than VFP.

Cheers,

Will
