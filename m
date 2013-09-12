Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab3ILJ4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 05:56:40 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:48701 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3ILJ4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 05:56:38 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYLbG3uMfces=jv=G+ysqejW5kdLjKwLvNvghPns5RmWA@mail.gmail.com>
References: <1378351680-14696-1-git-send-email-acourbot@nvidia.com>
 <1378351680-14696-2-git-send-email-acourbot@nvidia.com> <5228CEDB.1090306@gmail.com>
 <CAAVeFu+MGGBfmm1jwtKGP_d3EjkLdf5B_E_5RT___PVh1e=8jw@mail.gmail.com>
 <20130910130431.GE27966@mudshark.cambridge.arm.com> <CACRpkdYLbG3uMfces=jv=G+ysqejW5kdLjKwLvNvghPns5RmWA@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 12 Sep 2013 18:56:16 +0900
Message-ID: <CAAVeFuKsVtfxp0VbXuCTP89+56HeDi-XFOrRaZ13Vh0eFkAo7A@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] ARM: add basic Trusted Foundations support
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, Rob Herring <robherring2@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Olof Johansson <olof@lixom.net>, Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 6:18 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Sep 10, 2013 at 3:04 PM, Will Deacon <will.deacon@arm.com> wrote:
>> On Mon, Sep 09, 2013 at 07:15:31AM +0100, Alexandre Courbot wrote:
>
>>> I don't have any information about the future of TF unfortunately,
>>> excepted that it should remain backward-compatible. What is this SMC
>>> calling convention doc your are talking about btw? Is there a standard
>>> calling convention defined by ARM?
>>
>> SMC calling convention:
>> https://silver.arm.com/download/download.tm?pv=1435186
>
> According to the SMC calling convention r0 should be
> the SMC function identifier.
>
> +static void __naked tf_generic_smc(u32 type, u32 subtype, u32 arg)
> +{
> +       asm volatile(
> +               ".arch_extension        sec\n\t"
> +               "stmfd  sp!, {r4 - r11, lr}\n\t"
> +               __asmeq("%0", "r0")
> +               __asmeq("%1", "r1")
> +               __asmeq("%2", "r2")
> +               "mov    r3, #0\n\t"
> +               "mov    r4, #0\n\t"
> +               "smc    #0\n\t"
> +               "ldmfd  sp!, {r4 - r11, pc}"
> +               :
> +               : "r" (type), "r" (subtype), "r" (arg)
> +               : "memory");
> +}
>
> So type == function identifier? Or are these two totally
> different things, such that trusted foundations are already
> a different beast that what the SMC calling convention
> specifies?

After looking at the documents linked by Will and Catalin (thanks!), I
can state with confidence that TF does not follow the SMC calling
convention and has nothing to do with PSCI neither. The value passed
in r0 does not match the function identifier definition at all: with
its two MSBs set to 1, it would be interpreted as a SMC64 Fast Call,
which it clearly is not.

There is also no correspondance with any of the functions ids defined
in the PSCI specification.

> Anyway:
> r0,r1,r2 = type/subtype/arg.
>
> +#define TF_SET_CPU_BOOT_ADDR_SMC 0xfffff200
> (...)
> +static int tf_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
> +{
> +       tf_generic_smc(TF_SET_CPU_BOOT_ADDR_SMC, boot_addr, 0);
> +
> +       return 0;
> +}
>
> What kind of a "subtype" is the boot address? I could have
> accepted it if the *last* thing, the argument contained the boot
> address. With the type/subtype/arg convention it would be
> more natural if the "subtype" was something like 0.
>
> Should the SMC function rather have this signature:
>
> tf_generic_smc(u32 type, u32 arg1, u32 arg2)
>
> ?
>
> Then *sometimes* arg1 is a subtype, if the "type" is
> such that it takes a subtype?
>
> (That's a rough guess.)
>
> So to begin with the arguments to tf_generic_smc() are either
> confusingly named or tf_set_cpu_boot_addr() begins the
> journey with violating the function signature.

Indeed the subtype parameter is poorly named. That will teach me
reproducing the behavior of our downstream kernel without thinking. :/

> I also wonder what kind if "type" starts its enumerator on
> 0xfffff200? Wouldn't it be more natural if it was e.g. 1?
> It looks like the TF_SET_CPU_BOOT_ADDR_SMC
> reflects some bit-wise encoding scheme, so some details
> here wouldn't hurt?

I agree, unfortunately this raw value is all the details I myself have
access to. /o\

> The main thing is that the patch has to say that this
> is an API toward trusted foundations, that it has nothing
> to do with the SMC calling conventions, and only pertain
> to devices that use trusted foundations, so as to avoid
> any confusion.

Note that the patch never claimed to follow the SMC calling
conventions. You guys assumed it should for some reason. ;)

But clearly, it cannot hurt to state this unambiguously, so I will
make sure to do that. Then I hope the lack of detail about the
non-standard calling convention will not be an obstacle to its
merging, as this enables a bunch of retail Tegra devices (e.g. SHIELD)
to boot.

Thanks,
Alex.
