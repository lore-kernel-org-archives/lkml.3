Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab3FGIMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:12:14 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:51524 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab3FGIMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:12:01 -0400
MIME-Version: 1.0
In-Reply-To: <51B0BC80.9040007@wwwdotorg.org>
References: <1370503687-17767-1-git-send-email-acourbot@nvidia.com> <51B0BC80.9040007@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 7 Jun 2013 17:11:40 +0900
Message-ID: <CAAVeFu+by44HnOzv_85kwgeCx5b9TxiMhr27x69QcUj9GRbk8A@mail.gmail.com>
Subject: Re: [PATCH] ARM: tegra: add basic SecureOS support
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Joseph Lo <josephl@nvidia.com>,
        Karan Jhavar <kjhavar@nvidia.com>, Varun Wadekar <vwadekar@nvidia.com>,
        Chris Johnson <CJohnson@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
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

On Fri, Jun 7, 2013 at 1:44 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/06/2013 01:28 AM, Alexandre Courbot wrote:
>> Boot loaders on some Tegra devices can be unlocked but do not let the
>> system operate without SecureOS. SecureOS prevents access to some
>> registers and requires the operating system to perform certain
>> operations through Secure Monitor Calls instead of directly accessing
>> the hardware.
>>
>> This patch introduces basic SecureOS support for Tegra. SecureOS support
>> can be enabled by adding a "nvidia,secure-os" property to the "chosen"
>> node of the device tree.
>
> I suspect "SecureOS" here is the name of a specific implementation of a
> secure monitor, right? It's certainly a very unfortunate name, since it
> sounds like a generic concept rather than a specific implementation:-(

Right. Using the actual name (Trusted Foundations) is probably better.
I don't think the SecureOS denomination is used by anyone else but
NVIDIA.

> There certainly could be (and I believe are in practice?) multiple
> implementation of a secure monitor for Tegra. Presumably, each of those
> implementations has (or could have) a different definition for what SVC
> calls it supports, their parameters, etc.
>
> I think we need to separate the concept of support for *a* secure
> monitor, from support for a *particular* secure monitor.

Agreed. In this case, can we assume that support for a specific secure
monitor is not arch-specific, and that this patch should be moved
outside of arch-tegra and down to arch/arm? In other words, the ABI of
a particular secure monitor should be the same no matter the chip,
shouldn't it?

>> +node:
>> +
>> +  nvidia,secure-os: enable SecureOS.
>
> ... as such, I think some work is needed here to allow specification of
> which secure monitor is present and/or which secure monitor ABI it
> implements. The suggestion to use a specific DT node, and hence use
> compatible values for this, seems reasonable. Alternatively, perhaps:
>
> nvidia,secure-monitor = "name_of_vendor_or_SMC_ABI";
>
> might be reasonable, although using a node would allow ABI-specific
> additional properties to be defined should they be needed, so I guess I
> would lean towards that.

Considering your previous comment, I agree this seems to make the most sense.

> Similar comments may apply to the CONFIG_ option and description,
> filenames, etc.
>
>> diff --git a/arch/arm/mach-tegra/secureos.c b/arch/arm/mach-tegra/secureos.c
>
>> +void __init tegra_init_secureos(void)
>> +{
>> +     struct device_node *node = of_find_node_by_path("/chosen");
>> +
>> +     if (node && of_property_read_bool(node, "nvidia,secure-os"))
>> +             register_firmware_ops(&tegra_firmware_ops);
>> +}
>
> I'm tempted to think that function should /always/ exist an be called
> (so no dummy inline in secureos.h).
>
> In particular, what happens when a kernel without CONFIG_SECUREOS
> enabled is booted under a secure monitor. Presumably we want the init
> code to explicitly check for this condition, and either BUG(), or do
> something to disable any features (like SMP) that require SVCs?
>
> So, the algorithm here might be more like:
>
> find node
> if node exists
>     if (!IS_ENABLED(SECURE_OS))
>         BUG/WARN/...
>     else
>         register_firmware_ops()
>
> ?

Yep, let's do it this way.

Alex.
