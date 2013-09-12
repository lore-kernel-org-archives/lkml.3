Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab3ILJSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 05:18:13 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:61006 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab3ILJSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 05:18:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130910130431.GE27966@mudshark.cambridge.arm.com>
References: <1378351680-14696-1-git-send-email-acourbot@nvidia.com>
	<1378351680-14696-2-git-send-email-acourbot@nvidia.com>
	<5228CEDB.1090306@gmail.com>
	<CAAVeFu+MGGBfmm1jwtKGP_d3EjkLdf5B_E_5RT___PVh1e=8jw@mail.gmail.com>
	<20130910130431.GE27966@mudshark.cambridge.arm.com>
Date: Thu, 12 Sep 2013 11:18:09 +0200
Message-ID: <CACRpkdYLbG3uMfces=jv=G+ysqejW5kdLjKwLvNvghPns5RmWA@mail.gmail.com>
Subject: Re: [PATCH v5 1/5] ARM: add basic Trusted Foundations support
From: Linus Walleij <linus.walleij@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Alexandre Courbot <gnurou@gmail.com>, Rob Herring <robherring2@gmail.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 3:04 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Mon, Sep 09, 2013 at 07:15:31AM +0100, Alexandre Courbot wrote:

>> I don't have any information about the future of TF unfortunately,
>> excepted that it should remain backward-compatible. What is this SMC
>> calling convention doc your are talking about btw? Is there a standard
>> calling convention defined by ARM?
>
> SMC calling convention:
> https://silver.arm.com/download/download.tm?pv=1435186

According to the SMC calling convention r0 should be
the SMC function identifier.

+static void __naked tf_generic_smc(u32 type, u32 subtype, u32 arg)
+{
+       asm volatile(
+               ".arch_extension        sec\n\t"
+               "stmfd  sp!, {r4 - r11, lr}\n\t"
+               __asmeq("%0", "r0")
+               __asmeq("%1", "r1")
+               __asmeq("%2", "r2")
+               "mov    r3, #0\n\t"
+               "mov    r4, #0\n\t"
+               "smc    #0\n\t"
+               "ldmfd  sp!, {r4 - r11, pc}"
+               :
+               : "r" (type), "r" (subtype), "r" (arg)
+               : "memory");
+}

So type == function identifier? Or are these two totally
different things, such that trusted foundations are already
a different beast that what the SMC calling convention
specifies?

Anyway:
r0,r1,r2 = type/subtype/arg.

+#define TF_SET_CPU_BOOT_ADDR_SMC 0xfffff200
(...)
+static int tf_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
+{
+       tf_generic_smc(TF_SET_CPU_BOOT_ADDR_SMC, boot_addr, 0);
+
+       return 0;
+}

What kind of a "subtype" is the boot address? I could have
accepted it if the *last* thing, the argument contained the boot
address. With the type/subtype/arg convention it would be
more natural if the "subtype" was something like 0.

Should the SMC function rather have this signature:

tf_generic_smc(u32 type, u32 arg1, u32 arg2)

?

Then *sometimes* arg1 is a subtype, if the "type" is
such that it takes a subtype?

(That's a rough guess.)

So to begin with the arguments to tf_generic_smc() are either
confusingly named or tf_set_cpu_boot_addr() begins the
journey with violating the function signature.

I also wonder what kind if "type" starts its enumerator on
0xfffff200? Wouldn't it be more natural if it was e.g. 1?
It looks like the TF_SET_CPU_BOOT_ADDR_SMC
reflects some bit-wise encoding scheme, so some details
here wouldn't hurt?

The main thing is that the patch has to say that this
is an API toward trusted foundations, that it has nothing
to do with the SMC calling conventions, and only pertain
to devices that use trusted foundations, so as to avoid
any confusion.

Then I'm game :-)

Yours,
Linus Walleij
