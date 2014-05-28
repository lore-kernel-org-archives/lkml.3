Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaE1Kgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:36:35 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50980 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaE1Kgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:36:33 -0400
Date: Wed, 28 May 2014 11:36:25 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Alex Elder <elder@linaro.org>
Cc: "mporter@linaro.org" <mporter@linaro.org>,
        "bcm@fixthebug.org" <bcm@fixthebug.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Pawel Moll <Pawel.Moll@arm.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "rjui@broadcom.com" <rjui@broadcom.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "rvaswani@codeaurora.org" <rvaswani@codeaurora.org>
Subject: Re: [PATCH v4 1/5] devicetree: bindings: document Broadcom CPU
 enable method
Message-ID: <20140528103625.GA29219@e102568-lin.cambridge.arm.com>
References: <1400607830-10989-1-git-send-email-elder@linaro.org>
 <1400607830-10989-2-git-send-email-elder@linaro.org>
 <20140527114958.GC18476@e102568-lin.cambridge.arm.com>
 <53855867.7050800@linaro.org>
MIME-Version: 1.0
In-Reply-To: <53855867.7050800@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 28 May 2014 10:36:28.0753 (UTC) FILETIME=[AEF14410:01CF7A60]
X-MC-Unique: 114052811363008601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 04:30:47AM +0100, Alex Elder wrote:
> On 05/27/2014 06:49 AM, Lorenzo Pieralisi wrote:
> > On Tue, May 20, 2014 at 06:43:46PM +0100, Alex Elder wrote:
> >> Broadcom mobile SoCs use a ROM-implemented holding pen for
> >> controlled boot of secondary cores.  A special register is
> >> used to communicate to the ROM that a secondary core should
> >> start executing kernel code.  This enable method is currently
> >> used for members of the bcm281xx and bcm21664 SoC families.
> >>
> >> The use of an enable method also allows the SMP operation vector to
> >> be assigned as a result of device tree content for these SoCs.
> >>
> >> Signed-off-by: Alex Elder <elder@linaro.org>
> > 
> > This is getting out of control, it is absolutely ghastly. I wonder how
> > I can manage to keep cpus.txt updated if anyone with a boot method
> > du jour adds into cpus.txt, and honestly in this specific case it is even
> > hard to understand why.
> 
> OK, in this message I'll focus on the particulars of this
> proposed binding.
> 
> > Can't it be done with bindings for the relative register address space
> > (regmap ?) and platform code just calls the registers driver to set-up the
> > jump address ? It is platform specific code anyway there is no way you
> > can make this generic.
> 
> I want to clarify what you're after here.
> 
> My aim is to add SMP support for a class of Broadcom SMP
> machines.  To do so, I'm told I need to use the technique
> of assigning the SMP operations vector as a result of
> identifying an enable method in the DT.
> 
> For 32-bit ARM, there are no generic "enable-method" values.
> (I did attempt to create one for "spin-table" but that was
> rejected by Russell King.)  For the machines I'm trying to
> enable, secondary CPUS start out spinning in a ROM-based
> holding pen, and there is no need for a kernel-based one.
> 
> However, like a spin-table/holding pen enable method, a
> memory location is required for coordination between the
> boot CPU running kernel code and secondary CPUs running ROM
> code.  My proposal specifies it using a special numeric
> property value named "secondary-boot-reg" in the "cpus"
> node in the DT.
> 
> And as I understand it, the issue you have relates to how
> this memory location is specified.

The issue I have relates to cluttering cpus.txt with all
sorts of platform specific SMP boot hacks.

> You suggest regmap.  I'm using a single 32-bit register,
> only at very early boot time, and thereafter access to
> it is meaningless.  It seems like overkill if it's only
> used for this purpose.  I could hide the register values
> in the code, but with the exception of that, the code I'm
> using is generic (in the context of this class of Broadcom
> machine).  I could specify the register differently somehow,
> in a different node, or with a different property.

Is that register part of a larger registers block ? What I wanted
to say is that you can use a driver "API" (we wish) to write that
register, something like eg vexpress does with sysflags:

drivers/mfd/vexpress-sysreg.c

vexpress_flags_set()

instead of grabbing the reg address from a platform specific boot
method DT entry.

I doubt that register exists on its own, even though I have to say this
would force you to write yet another platform specific driver to control
a bunch of registers, I do not see any other solution.

One thing is for certain: I really do not see the point in adding a boot
method per-SoC, and I do not want to end up having a cpus.txt file with a
gazillion entries just because every given platform reinvents the wheel when
it comes to booting an SMP system, cpus.txt would become a document that
describes platform quirks, not a proper binding anymore.

At least all platform specific quirks must be moved out of cpus.txt and
in platform documentation, I understand it is just a cosmetic change but
I want to prevent cpus.txt to become an abomination.

> The bottom line here is I'm not sure whether I understand
> what you're suggesting, or perhaps why what you suggest is
> preferable.  I'm very open to suggestions, I just need it
> laid out a bit more detail in order to respond directly.

See above.

Thanks !
Lorenzo

> 
> Thanks.
> 
> 					-Alex
> 
> > I really do not see the point in cluttering cpus.txt with this stuff, it
> > is a platform specific hack, and do not belong in generic bindings in my
> > opinion.
> > 
> > Thanks,
> > Lorenzo
> > 
> >> ---
> >>  Documentation/devicetree/bindings/arm/cpus.txt | 12 ++++++++++++
> >>  1 file changed, 12 insertions(+)
> >>
> >> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
> >> index 333f4ae..c6a2411 100644
> >> --- a/Documentation/devicetree/bindings/arm/cpus.txt
> >> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> >> @@ -185,6 +185,7 @@ nodes to be present and contain the properties described below.
> >>  			    "qcom,gcc-msm8660"
> >>  			    "qcom,kpss-acc-v1"
> >>  			    "qcom,kpss-acc-v2"
> >> +			    "brcm,bcm11351-cpu-method"
> >>  
> >>  	- cpu-release-addr
> >>  		Usage: required for systems that have an "enable-method"
> >> @@ -209,6 +210,17 @@ nodes to be present and contain the properties described below.
> >>  		Value type: <phandle>
> >>  		Definition: Specifies the ACC[2] node associated with this CPU.
> >>  
> >> +	- secondary-boot-reg
> >> +		Usage:
> >> +			Required for systems that have an "enable-method"
> >> +			property value of "brcm,bcm11351-cpu-method".
> >> +		Value type: <u32>
> >> +		Definition:
> >> +			Specifies the physical address of the register used to
> >> +			request the ROM holding pen code release a secondary
> >> +			CPU.  The value written to the register is formed by
> >> +			encoding the target CPU id into the low bits of the
> >> +			physical start address it should jump to.
> >>  
> >>  Example 1 (dual-cluster big.LITTLE system 32-bit):
> >>  
> >> -- 
> >> 1.9.1
> >>
> >>
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

