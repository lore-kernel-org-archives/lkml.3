Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaCGQTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:19:42 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:55069 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaCGQTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:19:40 -0500
Message-ID: <5319FFB4.3050102@cogentembedded.com>
Date: Fri, 07 Mar 2014 20:19:48 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ben Dooks <ben.dooks@codethink.co.uk>, linux-media@vger.kernel.org
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-kernel@vger.kernel.org, magnus.damm@opensource.se,
        linux-sh@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Subject: Re: [PATCH 5/5] rcar_vin: add devicetree support
References: <1394197299-17528-1-git-send-email-ben.dooks@codethink.co.uk> <1394197299-17528-6-git-send-email-ben.dooks@codethink.co.uk>
In-Reply-To: <1394197299-17528-6-git-send-email-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03/07/2014 04:01 PM, Ben Dooks wrote:

> Add support for devicetree probe for the rcar-vin
> driver.

> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>   .../devicetree/bindings/media/rcar_vin.txt         | 79 ++++++++++++++++++++++
>   drivers/media/platform/soc_camera/rcar_vin.c       | 67 ++++++++++++++++--
>   2 files changed, 140 insertions(+), 6 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/media/rcar_vin.txt

> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> new file mode 100644
> index 0000000..105b8de
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -0,0 +1,79 @@
> +Renesas RCar Video Input driver (rcar_vin)
> +------------------------------------------
> +
> +The rcar_vin device provides video input capabilities for the Renesas R-Car
> +family of devices. The current blocks are always slaves and suppot one input

    Support.

> +channel which can be either RGB, YUYV or BT656.
> +
> + - compatible: Must be one of the following
> +   - "renesas,vin-r8a7791" for the R8A7791 device
> +   - "renesas,vin-r8a7790" for the R8A7790 device
> +   - "renesas,vin-r8a7779" for the R8A7779 device
> +   - "renesas,vin-r8a7778" for the R8A7778 device
> + - reg: the register base and size for the device registers
> + - interrupts: the interrupt for the device
> + - clocks: Reference to the parent clock
> +
> +The per-board settings:
> + - port sub-node describing a single endpoint connected to the vin

    s/vin/VIN/.

> +   as described in video-interfaces.txt[1]. Only the first one will
> +   be considered as each vin interface has one input port.
[...]
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 47516df..73c56c7 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -1404,15 +1418,50 @@ MODULE_DEVICE_TABLE(platform, rcar_vin_id_table);
>
>   static int rcar_vin_probe(struct platform_device *pdev)
>   {
> +	const struct of_device_id *match = NULL;
>   	struct rcar_vin_priv *priv;
>   	struct resource *mem;
>   	struct rcar_vin_platform_data *pdata;
> +	unsigned int pdata_flags;
>   	int irq, ret;
>
> -	pdata = pdev->dev.platform_data;
> -	if (!pdata || !pdata->flags) {
> -		dev_err(&pdev->dev, "platform data not set\n");
> -		return -EINVAL;
> +	if (pdev->dev.of_node) {
> +		struct v4l2_of_endpoint ep;
> +		struct device_node *np;
> +
> +		match = of_match_device(of_match_ptr(rcar_vin_of_table),
> +					&pdev->dev);
> +
> +		np = v4l2_of_get_next_endpoint(pdev->dev.of_node, NULL);
> +		if (!np) {
> +			dev_err(&pdev->dev, "could not find endpoint\n");
> +			return -EINVAL;
> +		}
> +
> +		ret = v4l2_of_parse_endpoint(np, &ep);
> +		if (ret) {
> +			dev_err(&pdev->dev, "could not parse endpoint\n");
> +			return ret;
> +		}
> +
> +		if (ep.bus_type == V4L2_MBUS_BT656)
> +			pdata_flags = RCAR_VIN_BT656;
> +		else {

    Both arms of *if* should have {} -- see Documentation/CodingStyle.

> +			pdata_flags = 0;
> +			if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
> +				pdata_flags |= RCAR_VIN_HSYNC_ACTIVE_LOW;
> +			if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
> +				pdata_flags |= RCAR_VIN_VSYNC_ACTIVE_LOW;
> +		}
> +
> +		dev_dbg(&pdev->dev, "pdata_flags = %08x\n", pdata_flags);
> +	} else {
> +		pdata = pdev->dev.platform_data;

    Use dev_get_platdata(&pdev->dev), please. Lot of drivers have been 
converted to use it instead of the direct access. Haven't gotten to this one 
it seems.

> @@ -1447,8 +1496,13 @@ static int rcar_vin_probe(struct platform_device *pdev)
>   	priv->ici.drv_name = dev_name(&pdev->dev);
>   	priv->ici.ops = &rcar_vin_host_ops;
>
> -	priv->pdata_flags = pdata->flags;
> -	priv->chip = pdev->id_entry->driver_data;
> +	priv->pdata_flags = pdata_flags;
> +	if (!match)
> +		priv->chip = pdev->id_entry->driver_data;
> +	else
> +		priv->chip = (enum chip_id)match->data;
> +
> +

    Too many empty lines here, I think.

WBR, Sergei

