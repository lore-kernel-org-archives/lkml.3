Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab3LDLPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 06:15:06 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43189 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755551Ab3LDLPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:15:03 -0500
Date: Wed, 4 Dec 2013 11:14:57 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Alex Elder <alex.elder@linaro.org>
Cc: Christian Daudt <bcm@fixthebug.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mike Turquette <mturquette@linaro.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] clk: bcm281xx: add initial clock framework support
Message-ID: <20131204111457.GF16025@e106331-lin.cambridge.arm.com>
References: <529EA78E.7060904@linaro.org>
 <529EA80F.3050009@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529EA80F.3050009@linaro.org>
Thread-Topic: [PATCH 2/3] clk: bcm281xx: add initial clock framework support
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 03:57:03AM +0000, Alex Elder wrote:
> Add code for device tree support of clocks in the BCM281xx family of
> SoCs.  Machines in this family use peripheral clocks implemented by
> "Kona" clock control units (CCUs).  (Other Broadcom SoC families use
> Kona style CCUs as well, but support for them is not yet upstream.)

How applicable are the clocks defined in this driver to those other
SoCs? How big will the changes need to be to add support for them?

[...]

> +/* A bit position must be less than the number of bits in a 32-bit
> register. */

Comment codestyle issue.

[...]

> +       /* Now fill in the parent names and selector arrays */
> +       j = 0;
> +       for (i = 0; i < orig_count; i++) {

This would look nicer with j initialised in the loop initialisation:

for (i = 0, j = 0; i < orig_count; i++)

[...]

> +static void __init kona_ccu_teardown(struct ccu_data *ccu)
> +{
> +       u32 i;
> +
> +       if (!ccu || !ccu->base)
> +               goto done;
> +
> +       of_clk_del_provider(ccu->node); /* safe if never added */
> +       of_node_put(ccu->node);
> +
> +       for (i = 0; i < ccu->data.clk_num; i++)
> +               kona_clk_teardown(ccu->data.clks[i]);
> +       kfree(ccu->data.clks);
> +
> +       list_del(&ccu->links);
> +
> +       iounmap(ccu->base);
> +done:
> +       kfree(ccu);

What about ccu->name ?

> +}
> +
> +/*
> + * Set up a CCU.  Call the provided ccu_clks_setup callback to
> + * initialize the array of clocks provided by the CCU.
> + */
> +void __init kona_dt_ccu_setup(struct device_node *node,
> +                       int (*ccu_clks_setup)(struct ccu_data *))
> +{
> +       struct ccu_data *ccu;
> +       struct resource res = { 0 };
> +       resource_size_t range;
> +       size_t name_size;
> +       int ret;
> +
> +       name_size = strlen(node->name) + 1;
> +       ccu = kzalloc(sizeof(*ccu) + name_size, GFP_KERNEL);
> +       if (!ccu) {
> +               pr_err("%s: unable to map allocate CCU struct for %s\n",
> +                       __func__, node->name);
> +               return;
> +       }
> +       memcpy((char *)ccu->name, node->name, name_size);

You could simplify this with kstrdup.

> +       INIT_LIST_HEAD(&ccu->links);
> +
> +       ret = of_address_to_resource(node, 0, &res);
> +       if (ret) {
> +               pr_err("%s: no valid CCU registers found for %s\n", __func__,
> +                       node->name);
> +               goto out_err;
> +       }
> +       ret = -EINVAL;
> +       if (res.start > (resource_size_t)U32_MAX) {
> +               pr_err("%s: address start too large for %s\n", __func__,
> +                       node->name);
> +               goto out_err;
> +       }

Why do we care? On an LPAE system, you could place devices above 4GB and
map them in. Why impose an arbitrary limitation here?

> +       if (res.start % sizeof(u32)) {
> +               pr_err("%s: unaligned address range start %u for %s\n",
> +                       __func__, res.start, node->name);
> +               goto out_err;
> +       }

Is there not a more restrictive alignment constraint on the clocks?

> +
> +       range = resource_size(&res);
> +       if (range > (resource_size_t)U32_MAX) {
> +               pr_err("%s: address range too large for %s\n", __func__,
> +                       node->name);
> +               goto out_err;
> +       }

Surely there's a much smaller max size you can check for given the
offsets you know? A size of U32_MAX seems absurd but will pass this
test.

[...]

> +/*
> + * Build a scaled divider value as close as possible to the
> + * given whole part (div_value) and fractional part (expressed
> + * in billionths).
> + */
> +u64 scaled_div_build(struct bcm_clk_div *div, u32 div_value, u32
> billionths)
> +{
> +       u64 combined;
> +
> +       BUG_ON(!div_value);
> +       BUG_ON(billionths > BILLION);

Can billionths == BILLION ?

> +
> +       combined = (u64)div_value * BILLION + billionths;
> +       combined <<= div->frac_width;
> +
> +       return do_div_round_closest(combined, BILLION);
> +}

[...]

> diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
> new file mode 100644
> index 0000000..850a70a
> --- /dev/null
> +++ b/drivers/clk/bcm/clk-kona.h
> @@ -0,0 +1,416 @@
> +/*
> + * Copyright (C) 2013 Broadcom Corporation
> + * Copyright 2013 Linaro Limited
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef _CLK_KONA_H
> +#define _CLK_KONA_H
> +
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/spinlock.h>
> +#include <linux/slab.h>
> +#include <linux/device.h>
> +#include <linux/of.h>
> +#include <linux/clk-provider.h>
> +
> +#define        BILLION         1000000000
> +
> +#ifndef U32_MAX

Why the ifndef? Either this is defined elsewhere, or it's not. If it's
available sometimes but not others, that seems like a bug in itself.

I see a few other places define U32_MAX. Might it be worth unifying the
definitions in a common header?

> +#define U8_MAX ((u8)~0U)
> +#define U32_MAX        ((u32)~0U)
> +#define U64_MAX        ((u64)~0U)
> +#endif /* U32_MAX */

Likewise for the rest.

Thanks,
Mark.
