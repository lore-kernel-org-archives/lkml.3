Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab3ISIbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 04:31:11 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:39808 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3ISIbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 04:31:03 -0400
Date: Thu, 19 Sep 2013 09:30:50 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, broonie@kernel.org
Subject: Re: [PATCH] mfd: core: introduce of_node_name for mfd sub devices
Message-ID: <20130919083050.GH16984@lee--X1>
References: <1379579392-1794-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1379579392-1794-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Sep 2013, Laxman Dewangan wrote:

> Multi Function Devices (MFDs) have multiple sub module whose driver is
> developed in different sub-system like GPIO, regulators, RTC, clock etc.
> The device tree of such device contains multiple sub-node which contains
> the properties of these sub-modules.
> 
> The sub module gets of_node handle either by the dev->of_node or by getting
> the child node handle from parent DT handle by finding child name on parent's
> of_node.
> 
> To provide the of_node of sub-module directly, currently there is only one
> approach:
> - Add compatible value when defining the sub-module in mfd core and
>   add this properties when adding DT.
> 
> Introduce the of_node_name of each sub devices which is set when defining
> the mfd_cells of the sub devices and get the handle of these child node
> when adding the mfd_devices by getting the sub-node handle with matching
> the node name getting the sub-node handle with matching the node name.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Creating this patch based on the discussion on patch
> [PATCH 1/4] mfd: add support for AMS AS3722 PMIC
> The discussion on above patch is not concluded and want to have
> further discussion on this patch.

I'm not entirely sure this is what Mark was saying. I think he was
complaining about the existence of the sub-nodes rather than how the
MFD Core assigns their of_node. My take is that the chip is really a
single device which provides different bits of functionality. To break
that functionality up and disperse the drivers into various subsystems
is a Linuxisum. By providing each functional block with its own node
you're describing how we do things in Linux, rather than specifying a
single node for the AS3722 which would probably be the norm.

Do the sub-nodes have their own properties? If so, it would be worth
breaking them up as other OSes could reuse the specifics. If they do,
then you need so put them in the binding. If they don't, then you do
not require sub-nodes. The MFD core will ensure the sub-devices are
probed and there is no requirement for the of_node to be assigned.

>  Documentation/devicetree/bindings/mfd/mfd-core.txt |   57 ++++++++++++++++++++
>  drivers/mfd/mfd-core.c                             |   10 +++-
>  include/linux/mfd/core.h                           |    6 ++
>  3 files changed, 71 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/mfd-core.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/mfd-core.txt b/Documentation/devicetree/bindings/mfd/mfd-core.txt
> new file mode 100644
> index 0000000..d68c893
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/mfd-core.txt
> @@ -0,0 +1,57 @@
> +MFD DT binding document
> +-----------------------
> +
> +Multi Function Devices (MFDs) have multiple sub module whose driver is developed
> +in different sub-system like GPIO, regulators, RTC, clock etc. The device
> +tree of such device contains multiple sub-node which contains the properties
> +of these sub-modules.
> +The sub modules get of_node handle either by the dev->of_node or by getting
> +the child node handle from parent DT handle by finding child name on parent's
> +of_node.
> +To provide the of_node of sub-module directly, there is two approach:
> +- Add compatible value when defining the sub-module in mfd core and
> +  add this properties when adding DT.
> +- Add the of_node_name when defining the sub-module in mfd core and
> +  add keep same name of child node when adding DT.
> +
> +If none of above matches then sub-module driver will not get their of_node
> +and they need to derive the method to get their node from parent node.
> +
> +Examples:
> +DT file:
> +--------
> +	mfd_device_dt {
> +		....
> +		gpio_child {
> +			/* Properties which need by gpio sub module */
> +		};
> +
> +		rtc_child {
> +			/* Properties which need by rtc sub module */
> +		};
> +
> +		regulator_child {
> +			/* Properties which need by regulator sub module */
> +		};
> +	};
> +
> +
> +Driver code:
> +-----------
> +static struct mfd_cell mfd_abc_devs[] = {
> +	{
> +		.name = "mfd-abc-gpio",
> +		.of_node_name = "gpio_child";
> +	},
> +	{
> +		.name = "mfd-abc-regulator",
> +		.of_node_name = "regulator_child";
> +	},
> +	{
> +		.name = "mfd-abc-rtc",
> +		.of_node_name = "rtc_child";
> +	},
> +};
> +
> +Here sub-node names are gpio_child, rtc_child, regulator_child and it is same
> +as of_node_name defined in the driver.
> diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
> index f421586..88836c2 100644
> --- a/drivers/mfd/mfd-core.c
> +++ b/drivers/mfd/mfd-core.c
> @@ -99,9 +99,15 @@ static int mfd_add_device(struct device *parent, int id,
>  	pdev->dev.dma_mask = parent->dma_mask;
>  	pdev->dev.dma_parms = parent->dma_parms;
>  
> -	if (parent->of_node && cell->of_compatible) {
> +	if (parent->of_node && (cell->of_compatible || cell->of_node_name)) {
>  		for_each_child_of_node(parent->of_node, np) {
> -			if (of_device_is_compatible(np, cell->of_compatible)) {
> +			if (cell->of_compatible &&
> +			    of_device_is_compatible(np, cell->of_compatible)) {
> +				pdev->dev.of_node = np;
> +				break;
> +			}
> +			if (cell->of_node_name && np->name &&
> +			    !strcmp(cell->of_node_name, np->name)) {
>  				pdev->dev.of_node = np;
>  				break;
>  			}
> diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
> index cebe97e..4cf891f 100644
> --- a/include/linux/mfd/core.h
> +++ b/include/linux/mfd/core.h
> @@ -45,6 +45,12 @@ struct mfd_cell {
>  	const char		*of_compatible;
>  
>  	/*
> +	 * Device tree sub-node name.
> +	 * See: Documentation/devicetree/bindings/mfd/mfd-core.txt
> +	 */
> +	const char		*of_node_name;
> +
> +	/*
>  	 * These resources can be specified relative to the parent device.
>  	 * For accessing hardware you should use resources from the platform dev
>  	 */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
