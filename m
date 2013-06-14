Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab3FNI1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:27:33 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:52288 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3FNI1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:27:30 -0400
MIME-Version: 1.0
In-Reply-To: <51BA1B41.6030002@wwwdotorg.org>
References: <1371114745-24710-1-git-send-email-acourbot@nvidia.com>
 <1371114745-24710-2-git-send-email-acourbot@nvidia.com> <51BA1B41.6030002@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 14 Jun 2013 17:27:09 +0900
Message-ID: <CAAVeFuLc57pV=To5yaE5x9mrVy1yknH2e90QockCiNbEXRm0WQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] ARM: tegra: basic support for Trusted Foundations
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Joseph Lo <josephl@nvidia.com>,
        Karan Jhavar <kjhavar@nvidia.com>, Varun Wadekar <vwadekar@nvidia.com>,
        Chris Johnson <CJohnson@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 4:19 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/13/2013 03:12 AM, Alexandre Courbot wrote:
>> Add basic support for booting secondary processors on Tegra devices
>> using the Trusted Foundations secure monitor.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>  Documentation/devicetree/bindings/arm/tegra.txt    | 11 +++++
>>  .../devicetree/bindings/vendor-prefixes.txt        |  1 +
>>  arch/arm/configs/tegra_defconfig                   |  1 +
>
> The defconfig change should be a separate patch, so that I can squash it
> into any other defconfig updates separately from all the code changes.

Ok, moved that part into its own patch.

>> diff --git a/arch/arm/mach-tegra/firmware.c b/arch/arm/mach-tegra/firmware.c
>
>> +void __init tegra_init_firmware(void)
>> +{
>> +     struct device_node *node;
>> +
>> +     if (!of_have_populated_dt())
>> +             return;
>> +
>> +     node = of_find_compatible_node(NULL, NULL, "tl,trusted-foundations");
>> +     if (node && !IS_ENABLED(CONFIG_TEGRA_TRUSTED_FOUNDATIONS))
>> +             pr_warn("Trusted Foundations detected but support missing!\n");
>> +#if IS_ENABLED(CONFIG_TEGRA_TRUSTED_FOUNDATIONS)
>> +     else if (node)
>> +             register_firmware_ops(&tegra_trusted_foundations_ops);
>> +#endif
>> +}
>
> Is it worth continuing on in the node && !IS_ENABLED case here? After
> all, we can be pretty certain that the write to the CPU reset vector is
> immediately going to trap...

That's what was happening until 3.9, but from 3.10 on the trap is
apparently handled and the boot completes (although with only one
processor).

> I suppose that perhaps without SMP, cpuidle, suspend, ... we could keep
> running, but that seems a little niche.

If we can keep running, even in degraded mode, I see no reason to
panic. The problem is well reported in the kernel log, and having a
running system might be helpful to analyze the issue.

Thanks,
Alex.
