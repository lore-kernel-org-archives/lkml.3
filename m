Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab3BYR0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 12:26:10 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49826 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3BYR0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 12:26:06 -0500
Date: Mon, 25 Feb 2013 17:25:45 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Steve Muckle <smuckle@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: vfp: fix fpsid register subarchitecture field
	mask width
Message-ID: <20130225172545.GO17833@n2100.arm.linux.org.uk>
References: <1361520485-30269-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361520485-30269-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 12:08:05AM -0800, Stephen Boyd wrote:
> From: Steve Muckle <smuckle@codeaurora.org>
> 
> The subarchitecture field in the fpsid register is 7 bits wide.
> The topmost bit is used to designate that the subarchitecture
> designer is not ARM. We use this field to determine which VFP
> version is supported by the CPU. Since the topmost bit is masked
> off we detect non-ARM subarchitectures as supporting only
> HWCAP_VFP and not HWCAP_VFPv3 as it should be for Qualcomm's
> processors.
> 
> Use the proper width for the mask so that we report the correct
> elf_hwcap of non-ARM designed processors.

This is a *big* can of worms.  How this register is defined depends on
what document you look at:

DDI0238A/B/C: 0x41011090: (VFP9) 
 23:	0 = hw,
 22:21:	00 = FSTMX/FLDMX format is standard format 1,
 20: 	0 = Single-precision and double-precision data supported
 19:16: 0001 = architecture version
DDI0133A: 0x410000A0: (VFP10) 
 23:16: 0 = architecture version
DDI0274F: 0x410120B3: (VFP11) 
 23:	0 = hw,
 22:21: 00 = FSTMX/FLDMX format is standard format 1,
 20:	0 = Single-precision and double-precision data supported
 19:16:	0001 = architecture version
DDI0406A/B/C:
 23: hw, 22:16: architecture version

Now, DDI0238C was updated on 4th August 2010.  The ARM ARM revs A and B
were published before this version - only ARM ARM rev C post-dates this.

The ARM ARM defines bit 22 to be zero for any ARM produced VFP hardware,
and must be one for non-ARM designed VFP hardware.

Now, the ARM ARM gives these as possible values for bits 22:16:

 0000000 - VFPv1
 0000001 - VFPv2
 0000010 - VFPv3 with common VFPv2
 0000011 - VFPv3 h/w only
 0000100 - VFPv3 with common VFPv3

We _do_ test bit 20 to determine if there is support for 32 double
precision registers, and if this bit is set, we ignore the VFP.  From
the description in the ARM ARM, this is wrong if the implementer is
not ARM.

If the information above _does_ correspond accurately with all ARM
produced hardware (VFP9S, VFP10, VFP11, plus any other variants in
ARMs CPUs) then they will always have bits 22:20 as zero.  This means
we can extend the architecture field to include those bits.  We should
also arrange for VFP support to fail if any of these bits are set.

How do we handle non-ARM produced VFP hardware?  I've no idea - the
stinking pile of dogs poo that ARM Ltd have created here means that
we're going to have to decode this register in a per-designer way -
and if we don't have support for your designer, then the support code
_must_ fail to initialize and report _any_ VFP support.

This is going to be horrendously disruptive, because _I_ don't know
what values of FPSID register can be found out in the wild.  I know
that the Dove chips have a Marvell implementer value (0x56), but
these report a subarch value of 2 (which seems to correspond with
ARM Ltd's implementation of architecture coding.)  Is it fully
compatible?  Don't know.

I think the only way we're going to find out is to end up with VFP
disabled on most CPUs and wait for people to stream reports in of
their hardware breaking.  Again, way to go ARM Ltd!  What a truely
excellent situation this is!
