Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab3FGJES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:04:18 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33921 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3FGJEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:04:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130606180824.GC3320@localhost.localdomain>
References: <1370503687-17767-1-git-send-email-acourbot@nvidia.com>
 <51B0BC80.9040007@wwwdotorg.org> <20130606180824.GC3320@localhost.localdomain>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 7 Jun 2013 18:03:54 +0900
Message-ID: <CAAVeFuJkV3VVfeinLrjCCef9ZqJNvKurQwVWnJsW-bZqniTQ1w@mail.gmail.com>
Subject: Re: [PATCH] ARM: tegra: add basic SecureOS support
To: Dave Martin <Dave.Martin@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Chris Johnson <CJohnson@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Karan Jhavar <kjhavar@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Joseph Lo <josephl@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 7, 2013 at 3:08 AM, Dave Martin <Dave.Martin@arm.com> wrote:
>> I think we need to separate the concept of support for *a* secure
>> monitor, from support for a *particular* secure monitor.
>
> There is no fixed set of functionality implemented by these interfaces,
> so it might be better to think in terms of a generic "firmware" concept.
>
>
> Come to think of it...
>
> One option could be to have some standard baseline firmware calling
> conventions, so that we could have a few specific backends -- perhaps
> this could be built on the "method" notion used by PSCI
>
> (see Documentation/devicetree/bindings/arm/psci.tst; this is probably
> the most developed firmware interface binding we have today)
>
> There, method = "smc" means:
>
>         populate registers in a certain way
>         SMC #0
>         return results from register to caller in a certain way
>
> and method = "hvc" means:
>
>         populate registers in a certain way
>         HVC #0
>         return results from register to caller in a certain way
>
>
> The backend method arch/arm/kernel/psci.c:__invoke_psci_fn_smc()
> is probably close to what's needed for the tegra secureos case,
> so in theory it could be common, along with some of the DT binding
> conventions.
>
> The backends, and the convention for binding a firmware interface
> to the appropriate backend, could then theoretically be handled
> by a common framework.

I'm not sure whether we could use the same backend for many different
firmwares. If I understand you correctly, you propose to have a
backend to the "smc" call that would cover the needs of all firmwares
that rely on the smc instruction to invoke the firmware/secure
monitor.

I can understand the logic, but I'm not sure this is needed or even
possible. For instance, the implementation you have in
__invoke_psci_fn_smc assumes 4 arguments, while Tegra's only needs 3.
Also (and although I have to confess I am not very knowledgeable about
the "SecureOS" covered by this patch and need to double-check what
follows), in Tegra's case registers r3-r11 can be altered by the
secure monitor and need to be preserved - something you don't need to
do with PSCI.

Another example is the function that Tomasz shown
(https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/arch/arm/mach-exynos/exynos-smc.S?id=refs/tags/next-20130606
), which preserves r4-r11 but also assumes r3 is an argument - that's
again another slightly different convention.

All in all the needs of the various firmwares might end up being just
different enough that we need to have a different backend for each of
them. The firmware_ops defined in arch/arm/include/asm/firmware.h
perform the abstraction at a higher level, which seems more fit here
IMHO.

Alex.
