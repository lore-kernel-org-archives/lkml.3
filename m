Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758AbbAPQt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 11:49:26 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36361 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbbAPQtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 11:49:21 -0500
Date: Fri, 16 Jan 2015 16:48:59 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Will Deacon <Will.Deacon@arm.com>
Cc: Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "leo.yan@linaro.org" <leo.yan@linaro.org>,
        "yexl@marvell.com" <yexl@marvell.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] arm64: Consolidate hotplug notifier for instruction
 emulation
Message-ID: <20150116164859.GE32155@leverpostej>
References: <1421325366-13263-1-git-send-email-suzuki.poulose@arm.com>
 <1421325366-13263-3-git-send-email-suzuki.poulose@arm.com>
 <20150116160730.GY7091@arm.com>
 <20150116163254.GC32155@leverpostej>
 <20150116164433.GB7091@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116164433.GB7091@arm.com>
Thread-Topic: [PATCH 2/3] arm64: Consolidate hotplug notifier for instruction
 emulation
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 04:44:34PM +0000, Will Deacon wrote:
> On Fri, Jan 16, 2015 at 04:32:54PM +0000, Mark Rutland wrote:
> > On Fri, Jan 16, 2015 at 04:07:30PM +0000, Will Deacon wrote:
> > > On Thu, Jan 15, 2015 at 12:36:05PM +0000, Suzuki K. Poulose wrote:
> > > > From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
> > > > 
> > > > As of now each insn_emulation has a cpu hotplug notifier that
> > > > enables/disables the CPU feature bit for the functionality. This
> > > > patch re-arranges the code, such that there is only one notifier
> > > > that runs through the list of registered emulation hooks and runs
> > > > their corresponding set_hw_mode.
> > > > 
> > > > We do nothing when a CPU is dying as we will set the appropriate bits
> > > > as it comes back online based on the state of the hooks.
> > > > 
> > > > Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
> > > > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > > > ---
> > > >  Documentation/arm64/legacy_instructions.txt |    4 +
> > > >  arch/arm64/include/asm/cpufeature.h         |    2 +
> > > >  arch/arm64/kernel/armv8_deprecated.c        |  113 +++++++++++++++------------
> > > >  3 files changed, 69 insertions(+), 50 deletions(-)
> > > > 
> > > > diff --git a/Documentation/arm64/legacy_instructions.txt b/Documentation/arm64/legacy_instructions.txt
> > > > index a3b3da2..0a4dc26 100644
> > > > --- a/Documentation/arm64/legacy_instructions.txt
> > > > +++ b/Documentation/arm64/legacy_instructions.txt
> > > > @@ -27,6 +27,10 @@ behaviours and the corresponding values of the sysctl nodes -
> > > >    instructions. Using hardware execution generally provides better
> > > >    performance, but at the loss of ability to gather runtime statistics
> > > >    about the use of the deprecated instructions.
> > > > +  Note: Emulation of a deprecated instruction depends on the availability
> > > > +  of the feature on all the active CPUs. In case of CPU hotplug, if a new
> > > > +  CPU doesn't support a feature, it could result in the abortion of the
> > > > +  hotplug operation.
> > > 
> > > Is this true? We should be able to *emulate* the instruction anywhere,
> > > it's the "hardware execution" setting that needs CPU support.
> > 
> > Not quite. In ARMv8 there are three possible cases for endianness
> > support:
> > 
> > (a) Mixed endian support at all levels
> >     ID_AA64MMFR0_EL1.BigEnd == 0b0001
> >     ID_AA64MMFR0_EL1.BigEnd0 == 0b0000 (RES0, invalid)
> > 
> > (b) Mixed endian support at EL0 only
> >     ID_AA64MMFR0_EL1.BigEnd == 0b0000
> >     ID_AA64MMFR0_EL1.BigEnd0 == 0b0001
> >     SCTLR_EL1.EE has a fixed value
> > 
> > (c) No mixed endian support at all
> >     ID_AA64MMFR0_EL1.BigEnd == 0b0000
> >     ID_AA64MMFR0_EL1.BigEnd0 == 0b0000
> >     SCTLR_EL1.{EE,E0E} have fixed values
> > 
> > We can emulate setend in cases (a) and (b), but not (c) unless we
> > trapped every single instruction that could access memory. I don't think
> > that's feasible.
> > 
> > Also fun in case (c) is that the kernel may not be able to run on all
> > CPUs (consider a BE kernel where some CPUs are fixed to LE at EL1).
> > 
> > I hope no-one builds a system where CPUs are mismatched w.r.t.
> > endianness support.
> 
> Agreed, the problem here is all down to the wording.
> Documentation/arm64/legacy_instructions.txt isn't specific to SETEND
> emulation and saying "Emulation of a deprecated instruction depends on the
> availability of the feature on all the active CPUs." as a blanket statement
> doesn't make a lot of sense in isolation. It's certainly not the case for
> SWP and CP15 barriers, for example.
> 
> With SETEND, we have requirements on mixed-endian support for the emulation.
> Fine, but let's not muddy the waters around the general CPU requirements
> for deprecated instruction emulation.

Sure. I was only contending the "We should be able to *emulate* the
instruction anywhere" part of your statement.

We should probably add _a_ note as part of the patch introducing SETEND
emulation, but not the one above, and we can drop it from this patch.

Mark.
