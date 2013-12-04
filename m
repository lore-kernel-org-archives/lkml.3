Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab3LDNGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:06:48 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:40397 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab3LDNGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:06:45 -0500
Message-ID: <529F28E3.90905@linaro.org>
Date: Wed, 04 Dec 2013 07:06:43 -0600
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Christian Daudt <bcm@fixthebug.org>,
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
References: <529EA78E.7060904@linaro.org> <529EA80F.3050009@linaro.org> <20131204111457.GF16025@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131204111457.GF16025@e106331-lin.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 05:14 AM, Mark Rutland wrote:
> On Wed, Dec 04, 2013 at 03:57:03AM +0000, Alex Elder wrote:
>> Add code for device tree support of clocks in the BCM281xx family of
>> SoCs.  Machines in this family use peripheral clocks implemented by
>> "Kona" clock control units (CCUs).  (Other Broadcom SoC families use
>> Kona style CCUs as well, but support for them is not yet upstream.)
> 
> How applicable are the clocks defined in this driver to those other
> SoCs? How big will the changes need to be to add support for them?
> 
> [...]
> 
>> +/* A bit position must be less than the number of bits in a 32-bit
>> register. */
> 
> Comment codestyle issue.

If you mean the wrapped words, I think my mailer did that.  Otherwise
I don't konw what the problem is.

> [...]
> 
>> +       /* Now fill in the parent names and selector arrays */
>> +       j = 0;
>> +       for (i = 0; i < orig_count; i++) {
> 
> This would look nicer with j initialised in the loop initialisation:
> 
> for (i = 0, j = 0; i < orig_count; i++)

If you prefer it that way it's fine with me, I'll do that.

> 
> [...]
> 
>> +static void __init kona_ccu_teardown(struct ccu_data *ccu)
>> +{
>> +       u32 i;
>> +
>> +       if (!ccu || !ccu->base)
>> +               goto done;
>> +
>> +       of_clk_del_provider(ccu->node); /* safe if never added */
>> +       of_node_put(ccu->node);
>> +
>> +       for (i = 0; i < ccu->data.clk_num; i++)
>> +               kona_clk_teardown(ccu->data.clks[i]);
>> +       kfree(ccu->data.clks);
>> +
>> +       list_del(&ccu->links);
>> +
>> +       iounmap(ccu->base);
>> +done:
>> +       kfree(ccu);
> 
> What about ccu->name ?

When the ccu structure is allocated, space beyond it is
allocated for ccu->name and the pointer is assigned to
that spot and filled.  Therefore we don't explicitly
free ccu->name.  I will add a brief comment to that
effect.

> 
>> +}
>> +
>> +/*
>> + * Set up a CCU.  Call the provided ccu_clks_setup callback to
>> + * initialize the array of clocks provided by the CCU.
>> + */
>> +void __init kona_dt_ccu_setup(struct device_node *node,
>> +                       int (*ccu_clks_setup)(struct ccu_data *))
>> +{
>> +       struct ccu_data *ccu;
>> +       struct resource res = { 0 };
>> +       resource_size_t range;
>> +       size_t name_size;
>> +       int ret;
>> +
>> +       name_size = strlen(node->name) + 1;
>> +       ccu = kzalloc(sizeof(*ccu) + name_size, GFP_KERNEL);
>> +       if (!ccu) {
>> +               pr_err("%s: unable to map allocate CCU struct for %s\n",
>> +                       __func__, node->name);
>> +               return;
>> +       }
>> +       memcpy((char *)ccu->name, node->name, name_size);
> 
> You could simplify this with kstrdup.

You are correct, and I will make that change.  I think at
one point I needed the length but that doesn't appear to
be the case here.

>> +       INIT_LIST_HEAD(&ccu->links);
>> +
>> +       ret = of_address_to_resource(node, 0, &res);
>> +       if (ret) {
>> +               pr_err("%s: no valid CCU registers found for %s\n", __func__,
>> +                       node->name);
>> +               goto out_err;
>> +       }
>> +       ret = -EINVAL;
>> +       if (res.start > (resource_size_t)U32_MAX) {
>> +               pr_err("%s: address start too large for %s\n", __func__,
>> +                       node->name);
>> +               goto out_err;
>> +       }
> 
> Why do we care? On an LPAE system, you could place devices above 4GB and
> map them in. Why impose an arbitrary limitation here?

I'm doing the tests here simply to validate that the values
being used do not exceed the representable range of the
types of objects that hold them.

That being said, I think the 32-bit limit I'm imposing on
these may also be due to an assumption about what's in the
device tree, i.e. that #address-cells = #size-cells = 1.
But there's no reason to assume that.  I will look at this
again, and rework it if possible so it is agnostic about
that--and will increase the size of the fields that hold
the related value accordingly.

>> +       if (res.start % sizeof(u32)) {
>> +               pr_err("%s: unaligned address range start %u for %s\n",
>> +                       __func__, res.start, node->name);
>> +               goto out_err;
>> +       }
> 
> Is there not a more restrictive alignment constraint on the clocks?

I don't think so.  But in any case my purpose here is doing
very basic sanity testing.  (To be honest I think most people
just assume all is well and don't do these sorts of tests.)

>> +
>> +       range = resource_size(&res);
>> +       if (range > (resource_size_t)U32_MAX) {
>> +               pr_err("%s: address range too large for %s\n", __func__,
>> +                       node->name);
>> +               goto out_err;
>> +       }
> 
> Surely there's a much smaller max size you can check for given the
> offsets you know? A size of U32_MAX seems absurd but will pass this
> test.

Same answer as the last one.  I guess as long as I'm testing
I could restrict it further (unnecessarily?), but I'm just
making sure I don't overrun the type of ccu->range.

> [...]
> 
>> +/*
>> + * Build a scaled divider value as close as possible to the
>> + * given whole part (div_value) and fractional part (expressed
>> + * in billionths).
>> + */
>> +u64 scaled_div_build(struct bcm_clk_div *div, u32 div_value, u32
>> billionths)
>> +{
>> +       u64 combined;
>> +
>> +       BUG_ON(!div_value);
>> +       BUG_ON(billionths > BILLION);
> 
> Can billionths == BILLION ?

Oooh!  A bug!  It should not be.  I will fix that.

>> +
>> +       combined = (u64)div_value * BILLION + billionths;
>> +       combined <<= div->frac_width;
>> +
>> +       return do_div_round_closest(combined, BILLION);
>> +}
> 
> [...]
> 
>> diff --git a/drivers/clk/bcm/clk-kona.h b/drivers/clk/bcm/clk-kona.h
>> new file mode 100644
>> index 0000000..850a70a
>> --- /dev/null
>> +++ b/drivers/clk/bcm/clk-kona.h
>> @@ -0,0 +1,416 @@
>> +/*
>> + * Copyright (C) 2013 Broadcom Corporation
>> + * Copyright 2013 Linaro Limited
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#ifndef _CLK_KONA_H
>> +#define _CLK_KONA_H
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/list.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/slab.h>
>> +#include <linux/device.h>
>> +#include <linux/of.h>
>> +#include <linux/clk-provider.h>
>> +
>> +#define        BILLION         1000000000
>> +
>> +#ifndef U32_MAX
> 
> Why the ifndef? Either this is defined elsewhere, or it's not. If it's
> available sometimes but not others, that seems like a bug in itself.

This is in anticipation of submitting a patch that I've had sitting
around for like a year to get these symbols in <linux/kernel.h>.
I'll get rid of the #ifndef.

> I see a few other places define U32_MAX. Might it be worth unifying the
> definitions in a common header?

Yes.  And most of those are mine... :)

>> +#define U8_MAX ((u8)~0U)
>> +#define U32_MAX        ((u32)~0U)
>> +#define U64_MAX        ((u64)~0U)
>> +#endif /* U32_MAX */
> 
> Likewise for the rest.

Yup, that's my plan.  You've prodded me now to get this done.

					-Alex
> Thanks,
> Mark.
> 

