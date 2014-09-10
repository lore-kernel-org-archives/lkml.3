Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaIKI65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:58:57 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:48147 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaIKI62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:58:28 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 02/17] ARM64 / ACPI: Get RSDP and ACPI boot-time
 tables
To: Hanjun Guo <guohanjun@huawei.com>, Jon Masters <jcm@redhat.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <Will.Deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <5410326F.8080104@huawei.com>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
	<1409583475-6978-3-git-send-email-hanjun.guo@linaro.org>
	<20140909162648.GE2910@arm.com> <540F2DCF.1010104@redhat.com>
	<20140909171541.GD3896@leverpostej>
	<20140909175010.GF4948@e102568-lin.cambridge.arm.com>
	<540F4155.4090200@arm.com> <540F4FCF.1090508@redhat.com>
	<5410326F.8080104@huawei.com>
Date: Wed, 10 Sep 2014 22:41:15 +0100
Message-Id: <20140910214115.BFF3DC40FE6@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014 19:13:51 +0800, Hanjun Guo <guohanjun@huawei.com> wrote:
> On 2014/9/10 3:06, Jon Masters wrote:
> > On 09/09/2014 02:05 PM, Sudeep Holla wrote:
> >>
> >>
> >> On 09/09/14 18:50, Lorenzo Pieralisi wrote:
> >>> On Tue, Sep 09, 2014 at 06:15:41PM +0100, Mark Rutland wrote:
> >>>> On Tue, Sep 09, 2014 at 05:41:51PM +0100, Jon Masters wrote:
> >>>>> On 09/09/2014 12:26 PM, Catalin Marinas wrote:
> >>>>>> On Mon, Sep 01, 2014 at 03:57:40PM +0100, Hanjun Guo wrote:
> >>>>>>> diff --git a/arch/arm64/include/asm/acenv.h b/arch/arm64/include/asm/acenv.h
> >>>>>>> new file mode 100644
> >>>>>>> index 0000000..3899ee6
> >>>>>>> --- /dev/null
> >>>>>>> +++ b/arch/arm64/include/asm/acenv.h
> >>>>>>> @@ -0,0 +1,18 @@
> >>>>>>> +/*
> >>>>>>> + * ARM64 specific ACPICA environments and implementation
> >>>>>>> + *
> >>>>>>> + * Copyright (C) 2014, Linaro Ltd.
> >>>>>>> + *   Author: Hanjun Guo <hanjun.guo@linaro.org>
> >>>>>>> + *   Author: Graeme Gregory <graeme.gregory@linaro.org>
> >>>>>>> + *
> >>>>>>> + * This program is free software; you can redistribute it and/or modify
> >>>>>>> + * it under the terms of the GNU General Public License version 2 as
> >>>>>>> + * published by the Free Software Foundation.
> >>>>>>> + */
> >>>>>>> +
> >>>>>>> +#ifndef _ASM_ACENV_H
> >>>>>>> +#define _ASM_ACENV_H
> >>>>>>> +
> >>>>>>> +#define ACPI_FLUSH_CPU_CACHE() WARN_ONCE(1, "Not currently supported on ARM64")
> >>>>>>
> >>>>>> Does this mean that it will be supported at some point? Looking at the
> >>>>>> places where this function is called, I don't really see how this would
> >>>>>> ever work on ARM. Which means that we add such macro just to be able to
> >>>>>> compile code that would never be used on arm64. I would rather see the
> >>>>>> relevant ACPI files only compiled on x86/IA-64 rather than arm64.
> >>>>>
> >>>>> That specific cache behavior is a part of e.g. ACPI C3 state support
> >>>>> (e.g. ACPI5.1 8.1.4 Processor Power State C3).
> >>>>
> >>>> Per table 5-35, if neither WBINVD or WBINVD_FLUSH are set in the FADT,
> >>>> we don't get S1, S2, or S3 states either.
> >>>>
> >>>>> As you note, it's not going to work on 64-bit ARM as it does on x86,
> >>>>> but it's optional to implement C3 and early 64-bit ARM systems should
> >>>>> not report Wbindv flags in the FADT anyway.
> >>>>
> >>>> Unless the arm cache architecture changes, I wouldn't expect any 64-bit
> >>>> ARM system to set either of the WBINVD flags.
> >>>>
> >>>>> They can also set FADT.P_LVL3_LAT > 1000, which has the effect of
> >>>>> disabling C3 support, while also allowing for use of _CST objects to
> >>>>> define more flexible C-States later on.
> >>>>
> >>>> It sounds like we should be sanity checking these in the arm64 ACPI code
> >>>> for the moment. I don't want us to discover that current platforms
> >>>> report the wrong thing only when new platforms come out that might
> >>>> actually report things correctly.
> >>>
> >>> I think that the kernel must ignore most of the stuff mentioned above
> >>> in HW_REDUCED_ACPI mode. And to be frank I still think that the problem
> >>> is not even there. The problem is trying to compile code that basically
> >>> has no defined behaviour - ie it is unspecified - on ARM64, that's what
> >>> Catalin pointed out.
> >>>
> >>> I understand it is compiled in by default on x86, but that's not a reason
> >>> why we should add empty hooks all over the place to compile code that
> >>> does not stand a chance to be doing anything sensible apart from
> >>> returning an error code, in the best case scenario.
> >>>
> >>
> >> I had pointed out this earlier, even if we make it compile there's
> >> every possibility that it can blow up if some vendor adds S- states
> >> to their ACPI tables. One clear reason why it could blow up is:
> >>
> >> "
> >>       /* This violates the spec but is required for bug compatibility. */
> >>       acpi_write_bit_register(ACPI_BITREG_SCI_ENABLE, 1);
> >> "
> >>
> >> I don't think this can ever work on ARM platforms. So better to fix it
> >> properly.
> > 
> > Hanjun,
> > 
> > How do you want to proceed? I'm not sure it should be !HW_REDUCED_MODE
> > for the cache behavior, because an embedded x86 box would still probably
> > define those, but removing the hooks on ARM may make sense.
> 
> As Graeme said in the reply, for sleep we are doing the same thing as
> ia64 in stubbing out the functions, and before that we are trying to remove
> the hooks on ARM by introducing more stubs and making things more complicated.
> 
> I agree that we should rework the ACPI core to make sleep/cache related
> stuff compatible with ARM, but I think we may not do this in one go, it will
> need incremental changes over the next couple of years as real hardware
> starts to appear and we finalise the standards to support this.

Yes, reworking acpica is out of scope for this patch set. I don't think
it makes sense to try and do that refactoring here.

g.
