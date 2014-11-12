Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaKLOj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:39:56 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:55361 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaKLOjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:39:54 -0500
MIME-Version: 1.0
In-Reply-To: <1415771461.5124.33.camel@kernel.crashing.org>
References: <1415771461.5124.33.camel@kernel.crashing.org>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 12 Nov 2014 08:39:32 -0600
Message-ID: <CAL_JsqKfBGdpFV_XuE4DEhFrkhN33kOMkiZE_TOnAZDm2qjwMw@mail.gmail.com>
Subject: Re: [PATCH] of/base: Fix PowerPC address parsing hack
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 11:51 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> We have a historical hack that treats missing ranges properties as the
> equivalent of an empty one. This is needed for ancient PowerMac "bad"
> device-trees, and shouldn't be enabled for any other PowerPC platform,
> otherwise we get some nasty layout of devices in sysfs or even
> duplication when a set of otherwise identically named devices is
> created multiple times under a different parent node with no ranges
> property.
>
> This fix is needed for the PowerNV i2c busses to be exposed properly
> and will fix a number of other embedded cases.
>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> CC: <stable@vger.kernel.org>
> ---
>
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index e371825..e37f017 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -7,6 +7,10 @@
>  #include <linux/pci_regs.h>
>  #include <linux/string.h>
>
> +#ifdef CONFIG_PPC
> +#include <asm/machdep.h>
> +#endif
> +
>  /* Max address size we deal with */
>  #define OF_MAX_ADDR_CELLS      4
>  #define OF_CHECK_ADDR_COUNT(na)        ((na) > 0 && (na) <= OF_MAX_ADDR_CELLS)
> @@ -428,12 +432,13 @@ static int of_translate_one(struct device_node *parent, struct of_bus *bus,
>          * This code is only enabled on powerpc. --gcl
>          */
>         ranges = of_get_property(parent, rprop, &rlen);
> -#if !defined(CONFIG_PPC)
> +#if defined(CONFIG_PPC)
> +       if (!machine_is(powermac))

Can we use a machine compatible here or something not PPC specific?
Then we can use IS_ENABLED(CONFIG_PPC) instead of ifdefs.

Rob

> +#endif /* defined(CONFIG_PPC) */
>         if (ranges == NULL) {
> -               pr_err("OF: no ranges; cannot translate\n");
> +               pr_debug("OF: no ranges; cannot translate\n");
>                 return 1;
>         }
> -#endif /* !defined(CONFIG_PPC) */
>         if (ranges == NULL || rlen == 0) {
>                 offset = of_read_number(addr, na);
>                 memset(addr, 0, pna * 4);
>
