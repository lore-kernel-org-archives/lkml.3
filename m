Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab3IQD3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 23:29:15 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:48815 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab3IQD3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 23:29:13 -0400
MIME-Version: 1.0
In-Reply-To: <523736DE.1050201@wwwdotorg.org>
References: <1379238028-7960-1-git-send-email-acourbot@nvidia.com>
 <1379238028-7960-2-git-send-email-acourbot@nvidia.com> <523736DE.1050201@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 17 Sep 2013 12:28:53 +0900
Message-ID: <CAAVeFuJgtF1xWHfF4gN+WbOBpL93pFdX7AR1ccu1imvoi9XZXg@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] ARM: add basic support for Trusted Foundations
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>, Dave Martin <Dave.Martin@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 1:50 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 09/15/2013 03:40 AM, Alexandre Courbot wrote:
>> Trusted Foundations is a TrustZone-based secure monitor for ARM that
>> can be invoked using the same SMC-based API on all supported
>> platforms. This patch adds initial basic support for Trusted
>> Foundations using the ARM firmware API. Current features are limited
>> to the ability to boot secondary processors.
>>
>> Note: The API followed by Trusted Foundations does *not* follow the SMC
>> calling conventions. It has nothing to do with PSCI neither and is only
>> relevant to devices that use Trusted Foundations (like most Tegra-based
>> retail devices).
>
>> diff --git a/arch/arm/firmware/trusted_foundations.c b/arch/arm/firmware/trusted_foundations.c
>
>> +#if IS_ENABLED(CONFIG_OF)
>> +void of_register_trusted_foundations(void)
>> +{
>> +     struct device_node *node;
>> +     struct trusted_foundations_platform_data pdata;
>> +     int err;
>> +
>> +     node = of_find_compatible_node(NULL, NULL, "tl,trusted-foundations");
>> +     if (!node)
>> +             return;
> ...
>
>> diff --git a/arch/arm/include/asm/trusted_foundations.h b/arch/arm/include/asm/trusted_foundations.h
>
>> +#if IS_ENABLED(CONFIG_TRUSTED_FOUNDATIONS)
>> +void register_trusted_foundations(struct trusted_foundations_platform_data *pd);
>> +#if IS_ENABLED(CONFIG_OF)
>> +void of_register_trusted_foundations(void);
>> +#endif
>
> I still don't think that's correct.
>
> If TF support is enabled, yet DT support is not enabled, then there is
> no prototype, implementation, or dummy implementation for
> of_register_trusted_foundations(). I think there should be a dummy
> implementation in this case, shouldn't there?
>
>> +
>> +#else /* CONFIG_TRUSTED_FOUNDATIONS */
>> +
>> +#include <linux/printk.h>
>> +#include <linux/of.h>
>> +#include <asm/bug.h>
>> +
>> +static inline void register_trusted_foundations(
>> +                                struct trusted_foundations_platform_data *pd)
>> +{
>> +     panic("No support for Trusted Foundations, stopping...\n");
>> +}
>> +
>> +#if IS_ENABLED(CONFIG_OF)
>> +static inline void of_register_trusted_foundations(void)
>> +{
>> +     /* If we find the target should enable TF but does not support it,
>> +      * fail as the system won't be able to do much anyway */
>> +     if (of_find_compatible_node(NULL, NULL, "tl,trusted-foundations"))
>> +             register_trusted_foundations(NULL);
>> +}
>> +#else
>> +static inline void of_register_trusted_foundations(void)
>> +{
>> +}
>> +#endif /* CONFIG_OF */
>
> That's more complex than it needs to be; there is a dummy
> of_find_compatible_node() in the !OF case, so you don't need to ifdef
> the implementation of of_register_trusted_foundations(); you just need
> the first implementation here.
>
>> +#endif /* CONFIG_TRUSTED_FOUNDATIONS */
>
> In summary, I think you need:
>
> If TF is enabled, always implement of_register_trusted_foundations() in
> the C file, and rely on of_find_compatible_node() to return NULL if
> !CONFIG_OF.
>
> If TF is not enabled, implement the inline version in the header file,
> and again rely on of_find_compatible_node() to return NULL if !CONFIG_OF.

Indeed, all your points are correct, and I've clearly been negligent
here. Sorry about that.

Will have to submit a v7, but hopefully we can get the acks that we
need (Russel?) on this version.

Alex.
