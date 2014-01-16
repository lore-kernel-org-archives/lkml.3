Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaAPK20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:28:26 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:65098 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbaAPK2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:28:24 -0500
Date: Thu, 16 Jan 2014 10:28:01 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Saurabh Singh <saurabh1.s@samsung.com>
Cc: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "celinux-dev@tree.celinuxforum.org" 
	<celinux-dev@tree.celinuxforum.org>,
        "srevatsa@samsung.com" <srevatsa@samsung.com>,
        "bp.praveen@samsung.com" <bp.praveen@samsung.com>
Subject: Re: [PATCH] Parse missing regulator constraints from device tree
 blob
Message-ID: <20140116102800.GA19578@e106331-lin.cambridge.arm.com>
References: <23745449.572421389854083634.JavaMail.weblogic@epml20>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23745449.572421389854083634.JavaMail.weblogic@epml20>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 16, 2014 at 06:34:46AM +0000, Saurabh Singh wrote:
> This patch adds support for parsing following regulator contraints from device tree blob.
> 1. valid modes mask (valid_modes_mask)
> 2. input microvolt(input_uV)
> 3. initial mode (initial_mode)
> 4. initial state (initial_state)
> 5. state mem (state_mem)
> 6. state disk (state_disk)
> 7. state standby (state_standby)
> 
> This patch is currently against a linux 3.12.6 kernel.
> 
> diffstat for this patch is:
>  of_regulator.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
> 
> To apply the patch, in the root of a kernel tree use:
> patch -p1 < of_regulator.patch
> 
> Please let me know any feedback you have on this patch or the approach used.

There are several issues with this patch:

* None of these properties are documented. Documentation is required so
  that the contract is defined. That allows people to learn how to use
  the properties, and makes clear what we can and cannot change
  kernel-side.

* It leaks Linux internal details (e.g. suspend_state_t values,
  valid_mode_mask) without any attempt at abstraction, in violation of
  dt principles.

* Accessors are used poorly. Endianness conversion is done manually
  rather than being left to accessors, and property lengths aren't
  checked.

> 
> Regards,
> =====================
> Saurabh Singh Sengar
> Lead Engineer
> Samsung R&D Institute
> India
> Samsung
> =====================
> Signed-off-by: Saurabh Singh Sengar <saurabh1.s@samsung.com>
> 
> --------------------------------------------------------------------------------
> --- linux-3.12.6/drivers/regulator/of_regulator.c.orig	2014-01-08 17:19:43.085903573 +0530
> +++ linux-3.12.6/drivers/regulator/of_regulator.c	2014-01-15 20:12:22.146543128 +0530
> @@ -16,11 +16,40 @@
>  #include <linux/regulator/machine.h>
>  #include <linux/regulator/of_regulator.h>
>  
> +/**
> + * set_regulator_state_constraints - set regulator state for low power system states
> + * @np: device node for the low power regulator state
> + * @regulator_state: regulator_state structure need to be filled
> + */
> +static void set_regulator_state_constraints(struct device_node *np,
> +		struct regulator_state *regulator_state)
> +{
> +	const __be32 *uV, *mode;
> +
> +	uV = of_get_property(np, "regulator-state-uV", NULL);

Typically properties are all lower-case.

> +	if (uV)
> +		regulator_state->uV = be32_to_cpu(*uV);

As an example, to use accessors correctly, here you should have:

	u32 uv;
	of_property_read_u32(np, "regulator-state-uv", &uv);

However, as far as I can see this value should come from an input supply
anyway.

Thanks,
Mark.
