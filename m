Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaDYVdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 17:33:22 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:42354 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaDYVdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 17:33:20 -0400
Message-ID: <535AD49C.6040600@gmail.com>
Date: Fri, 25 Apr 2014 23:33:16 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu
CC: pankaj.dubey@samsung.com, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        devicetree <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3] mfd: syscon: Support early initialization
References: <3eb785d83c406f4a57508dc03610b05492e12bfd.1396969250.git.michal.simek@xilinx.com>
In-Reply-To: <3eb785d83c406f4a57508dc03610b05492e12bfd.1396969250.git.michal.simek@xilinx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

First of all, even though not touching DT bindings, this change is DT 
related and so devicetree mailing list should be on Cc, as well as some 
DT people, especially Grant. Adding them.

Otherwise, please see my comments inline.

On 08.04.2014 17:00, Michal Simek wrote:
> Some platforms need to get system controller
> ready as soon as possible.
> The patch provides early_syscon_initialization
> which create early mapping for all syscon compatible
> devices in early_syscon_probe.
> Regmap is get via syscon_early_regmap_lookup_by_phandle()
>
> Regular device probes attach device to regmap
> via regmap_attach_dev().
>
> For early syscon initialization is necessary to extend
> struct syscon and provide remove function
> which unmap all early init structures.
>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>
> Changes in v3:
> - Keep backward compatibility for platform drivers and test it
> - Use only one probe method which is early_syscon_probe
>    suggested by Lee Jones. Do not force anybody to call early_syscon_init
> - Add kernel-doc description
>
> Changes in v2:
> - Fix bad logic in early_syscon_probe
> - Fix compilation failure for x86_64 reported by zero day testing system
> - Regmap change available here
>    git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/nodev
>
>   drivers/mfd/syscon.c       | 159 ++++++++++++++++++++++++++++++++++++++++-----
>   include/linux/mfd/syscon.h |  11 ++++
>   2 files changed, 153 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index 71841f9..8e2ff88 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -20,12 +20,15 @@
>   #include <linux/of_platform.h>
>   #include <linux/platform_device.h>
>   #include <linux/regmap.h>
> +#include <linux/slab.h>
>   #include <linux/mfd/syscon.h>
>
>   static struct platform_driver syscon_driver;
>
>   struct syscon {
> +	void __iomem *base;
>   	struct regmap *regmap;
> +	struct resource res;
>   };
>
>   static int syscon_match_node(struct device *dev, void *data)
> @@ -95,6 +98,30 @@ struct regmap *syscon_regmap_lookup_by_pdevname(const char *s)
>   }
>   EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_pdevname);
>
> +/**
> + * syscon_early_regmap_lookup_by_phandle - Early phandle lookup function
> + * @np:		device_node pointer
> + * @property:	property name which handle system controller phandle
> + * Return:	regmap pointer, an error pointer otherwise
> + */
> +struct regmap *syscon_early_regmap_lookup_by_phandle(struct device_node *np,
> +						     const char *property)
> +{
> +	struct device_node *syscon_np;
> +	struct syscon *syscon;
> +
> +	syscon_np = of_parse_phandle(np, property, 0);
> +	if (!syscon_np)
> +		return ERR_PTR(-ENODEV);
> +
> +	syscon = syscon_np->data;
> +
> +	of_node_put(syscon_np);

As it was mentioned in other review comments, this is rather fishy.

Instead, couldn't you create a local list of system controllers 
available in the system and then use that to perform look-up? This could 
also let you eliminate the need to have separate functions for early and 
normal look-up as the list could be simply used for both cases. Of 
course you would have to add of_node and list_head fields to struct 
syscon, but I don't think that matters.

As a side effect, the look-up would not need to iterate over all devices 
in the system anymore, just over the list of registered system controllers.

Best regards,
Tomasz
