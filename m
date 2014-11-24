Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaKXLLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 06:11:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54860 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaKXLLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:11:20 -0500
Message-ID: <1416827470.32191.1.camel@pengutronix.de>
Subject: Re: [PATCH v2] mfd: syscon: add child device support
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Rob Herring <robh+dt@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Flora Fu <flora.fu@mediatek.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Date: Mon, 24 Nov 2014 12:11:10 +0100
In-Reply-To: <1415006209-1312-1-git-send-email-p.zabel@pengutronix.de>
References: <1415006209-1312-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2014-11-03 at 10:16 +0100, Philipp Zabel wrote:
> For devices which have a complete register for themselves, it is possible to
> place them next to the syscon device with overlapping reg ranges. The same is
> not possible for devices which only occupy bitfields in registers shared with
> other users.
> For devices that are completely controlled by bitfields in the syscon address
> range, such as multiplexers or voltage regulators, allow to put child devices
> into the syscon device node.

Could I please get an ack for the device tree binding change so the MFD
maintainers can take this patch? I'd like to queue the Mediatek reset
driver, which depends on this.

regards
Philipp

> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v1:
>  - Reworded binding documentation to allow #size-cells = <1>, which is useful
>    for syscon children that are controlled through a (possibly shared) register
>    range.
> ---
>  Documentation/devicetree/bindings/mfd/syscon.txt | 13 +++++++++++++
>  drivers/mfd/syscon.c                             |  3 +++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/syscon.txt b/Documentation/devicetree/bindings/mfd/syscon.txt
> index fe8150b..0c6b497 100644
> --- a/Documentation/devicetree/bindings/mfd/syscon.txt
> +++ b/Documentation/devicetree/bindings/mfd/syscon.txt
> @@ -9,12 +9,25 @@ using a specific compatible value), interrogate the node (or associated
>  OS driver) to determine the location of the registers, and access the
>  registers directly.
>  
> +Optionally, devices that are controlled exclusively through syscon registers,
> +or even bitfields in shared syscon registers, can also be added as child nodes
> +to the syscon device node. These devices can implicitly assume their parent
> +node is a syscon provider without referencing it explicitly via phandle.
> +In this case, the syscon node should have #address-cells = <1> and
> +#size-cells = <0> or <1> and no ranges property.
> +
>  Required properties:
>  - compatible: Should contain "syscon".
>  - reg: the register region can be accessed from syscon
>  
> +Optional properties:
> +- #address-cells: Should be 1.
> +- #size-cells: Should be 0 or 1.
> +
>  Examples:
>  gpr: iomuxc-gpr@020e0000 {
> +	#address-cells = <1>;
> +	#size-cells = <0>;
>  	compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
>  	reg = <0x020e0000 0x38>;
>  };
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index ca15878..38da178 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -155,6 +155,9 @@ static int syscon_probe(struct platform_device *pdev)
>  
>  	dev_dbg(dev, "regmap %pR registered\n", res);
>  
> +	if (!of_device_is_compatible(pdev->dev.of_node, "simple-bus"))
> +		of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
> +
>  	return 0;
>  }
>  


