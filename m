Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbbATK5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:57:12 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38882 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbbATK5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:57:07 -0500
Date: Tue, 20 Jan 2015 10:56:55 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Mark Rutland <Mark.Rutland@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Al Stone <al.stone@linaro.org>, Timur Tabi <timur@codeaurora.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v7 04/17] ARM64 / ACPI: Introduce early_param for "acpi"
 and pass acpi=force to enable ACPI
Message-ID: <20150120105655.GC25575@e104818-lin.cambridge.arm.com>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <1421247905-3749-5-git-send-email-hanjun.guo@linaro.org>
 <20150119114255.GF11835@e104818-lin.cambridge.arm.com>
 <CAKv+Gu8vPKAdsNg7QC7xW+i8_BemWEx4mvBx6NrnAHi8Y+bNtw@mail.gmail.com>
 <20150119135144.GI11835@e104818-lin.cambridge.arm.com>
 <20150119151350.21B65C40948@trevor.secretlab.ca>
 <54BD3803.6020307@redhat.com>
 <20150119175233.GK11835@e104818-lin.cambridge.arm.com>
 <20150119180122.GJ21553@leverpostej>
 <54BE1FEA.5040109@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54BE1FEA.5040109@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 09:29:14AM +0000, Hanjun Guo wrote:
> On 2015年01月20日 02:01, Mark Rutland wrote:
> > On Mon, Jan 19, 2015 at 05:52:33PM +0000, Catalin Marinas wrote:
> >> On Mon, Jan 19, 2015 at 04:59:47PM +0000, Jon Masters wrote:
> >>> On 01/19/2015 10:13 AM, Grant Likely wrote:
> >>>> On Mon, 19 Jan 2015 13:51:45 +0000
> >>>> , Catalin Marinas <catalin.marinas@arm.com>
> >>>>   wrote:
> >>>>> On Mon, Jan 19, 2015 at 11:55:32AM +0000, Ard Biesheuvel wrote:
> >>>>>> On 19 January 2015 at 11:42, Catalin Marinas <catalin.marinas@arm.com> wrote:
> >>>>>>> On Wed, Jan 14, 2015 at 03:04:52PM +0000, Hanjun Guo wrote:
> >>>>>>>> From: Al Stone <al.stone@linaro.org>
> >>>>>>>>
> >>>>>>>> Introduce one early parameters "off" and "force" for "acpi", acpi=off
> >>>>>>>> will be the default behavior for ARM64, so introduce acpi=force to
> >>>>>>>> enable ACPI on ARM64.
> >>>>>>>>
> >>>>>>>> Disable ACPI before early parameters parsed, and enable it to pass
> >>>>>>>> "acpi=force" if people want use ACPI on ARM64. This ensures DT be
> >>>>>>>> the prefer one if ACPI table and DT both are provided at this moment.
> >>>>>>> [...]
> >>>>>>>> --- a/arch/arm64/kernel/setup.c
> >>>>>>>> +++ b/arch/arm64/kernel/setup.c
> >>>>>>>> @@ -62,6 +62,7 @@
> >>>>>>>>   #include <asm/memblock.h>
> >>>>>>>>   #include <asm/psci.h>
> >>>>>>>>   #include <asm/efi.h>
> >>>>>>>> +#include <asm/acpi.h>
> >>>>>>>>
> >>>>>>>>   unsigned int processor_id;
> >>>>>>>>   EXPORT_SYMBOL(processor_id);
> >>>>>>>> @@ -388,6 +389,8 @@ void __init setup_arch(char **cmdline_p)
> >>>>>>>>        early_fixmap_init();
> >>>>>>>>        early_ioremap_init();
> >>>>>>>>
> >>>>>>>> +     disable_acpi();
> >>>>>>>> +
> >>>>>>>>        parse_early_param();
> >>>>>>>>
> >>>>>>>>        /*
> >>>>>>>
> >>>>>>> Did we get to any conclusion here? DT being the preferred one is fine
> >>>>>>> when both DT and ACPI are present but do we still want the kernel to
> >>>>>>> ignore ACPI altogether if DT is not present? It's a bit harder to detect
> >>>>>>> the presence of DT at this point since the EFI_STUB added one already. I
> >>>>>>> guess we could move the "acpi=force" argument passing to EFI_STUB if no
> >>>>>>> DT is present at boot.
> >>>>>>
> >>>>>> Since the EFI stub populates the /chosen node in DT, I would prefer
> >>>>>> for it to add a property there to indicate whether it created the DT
> >>>>>> from scratch rather than adding ACPI specific stuff in there (even if
> >>>>>> it is just a string to concatenate)
> >>>>>
> >>>>> This works for me. So we could pass "acpi=force" in EFI stub if it
> >>>>> created the DT from scratch *and* ACPI tables are present (can it detect
> >>>>> the latter? And maybe it could print something if none are available).
> >>>>> If that works, the actual kernel can assume that ACPI needs to be
> >>>>> explicitly enabled via acpi=force, irrespective of how much information
> >>>>> it has in DT.
> >>>>
> >>>> Ditto for me. I think this is a fine solution. And, yes, the stub can
> >>>> easily detect the presence of ACPI by looking in the UEFI config table.
> >>>
> >>> I get the point behind doing this, but could we not have it pass in a
> >>> different parameter than =force? Perhaps something new? I'd like to
> >>> separate out the case that it was enabled automatically vs explicitly
> >>> forced on by a user wanting to use ACPI on a system with both tables.
> >>
> >> Ard had a point, so we should probably not pass acpi=force from EFI stub
> >> (especially since a user may explicitly pass acpi=off irrespective of DT
> >> presence). Some other property in the chosen node? It's not even an ABI
> >> since that's a contract between EFI stub and the rest of the kernel, so
> >> an in-kernel only interface.
> >
> > Not strictly true once kexec is in place. Then it becomes a stub ->
> > kernel -> kernel -> kernel -> ... interface, alnog with the rest of the
> > properties the stub puts in the DTB.
> >
> > Having something like /chosen/linux,uefi-stub-generated-dtb sounds sane
> > regardless.
> 
> How about the patch (just RFC, maybe it is horrible :) ) below:
> 
> When system supporting both DT and ACPI but firmware providing
> no dtb, we can use this linux,uefi-stub-generated-dtb property
> to let kernel know that we can try ACPI configuration data.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>

I'm ok with the idea but I'll let Mark comment on the DT aspects.

-- 
Catalin
