Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab3AYLBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:01:51 -0500
Received: from service87.mimecast.com ([91.220.42.44]:47469 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab3AYLBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:01:49 -0500
Date: Fri, 25 Jan 2013 11:01:41 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "tony@atomide.com" <tony@atomide.com>, "balbi@ti.com" <balbi@ti.com>,
        "b-cousson@ti.com" <b-cousson@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 1/4] drivers: usb: phy: add a new driver for usb
 part of control module
Message-ID: <20130125110141.GK3075@e106331-lin.cambridge.arm.com>
References: <1359109440-2195-1-git-send-email-kishon@ti.com>
 <1359109440-2195-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
In-Reply-To: <1359109440-2195-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 25 Jan 2013 11:01:42.0528 (UTC) FILETIME=[5BA30000:01CDFAEB]
X-MC-Unique: 113012511014501601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 10:23:57AM +0000, Kishon Vijay Abraham I wrote:
> Added a new driver for the usb part of control module. This has an API
> to power on the USB2 phy and an API to write to the mailbox depending on
> whether MUSB has to act in host mode or in device mode.
> 
> Writing to control module registers for doing the above task which was
> previously done in omap glue and in omap-usb2 phy will be removed.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  Documentation/devicetree/bindings/usb/omap-usb.txt |   30 +-
>  Documentation/devicetree/bindings/usb/usb-phy.txt  |    5 +
>  drivers/usb/phy/Kconfig                            |   10 +
>  drivers/usb/phy/Makefile                           |    1 +
>  drivers/usb/phy/omap-control-usb.c                 |  295 ++++++++++++++++++++
>  include/linux/usb/omap_control_usb.h               |   92 ++++++
>  6 files changed, 432 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/usb/phy/omap-control-usb.c
>  create mode 100644 include/linux/usb/omap_control_usb.h
> 
> diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
> index 29a043e..2d8c6c4 100644
> --- a/Documentation/devicetree/bindings/usb/omap-usb.txt
> +++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
> @@ -1,4 +1,4 @@
> -OMAP GLUE
> +OMAP GLUE AND OTHER OMAP SPECIFIC COMPONENTS
> 
>  OMAP MUSB GLUE
>   - compatible : Should be "ti,omap4-musb" or "ti,omap3-musb"
> @@ -16,6 +16,10 @@ OMAP MUSB GLUE
>   - power : Should be "50". This signifies the controller can supply upto
>     100mA when operating in host mode.
> 
> +Optional properties:
> + - ctrl-module : phandle of the control module this glue uses to write to
> +   mailbox
> +
>  SOC specific device node entry
>  usb_otg_hs: usb_otg_hs@4a0ab000 {
>         compatible = "ti,omap4-musb";
> @@ -23,6 +27,7 @@ usb_otg_hs: usb_otg_hs@4a0ab000 {
>         multipoint = <1>;
>         num_eps = <16>;
>         ram_bits = <12>;
> +       ctrl-module = <&omap_control_usb>;
>  };
> 
>  Board specific device node entry
> @@ -31,3 +36,26 @@ Board specific device node entry
>         mode = <3>;
>         power = <50>;
>  };
> +
> +OMAP CONTROL USB
> +
> +Required properties:
> + - compatible: Should be "ti,omap-control-usb"
> + - reg : Address and length of the register set for the device. It contains
> +   the address of "control_dev_conf" and "otghs_control" or "phy_power_usb"

Could you not use '-' over '_' here?

> +   depending upon omap4 or omap5.
> + - reg-names: The names of the register addresses corresponding to the registers
> +   filled in "reg".
> + - ti,type: This is used to differentiate whether the control module has
> +   usb mailbox or usb3 phy power. omap4 has usb mailbox in control module to
> +   notify events to the musb core and omap5 has usb3 phy power register to
> +   power on usb3 phy. Should be "1" if it has mailbox and "2" if it has usb3
> +   phy power.

Why not make this a string property, perhaps values "mailbox" or "register"?

That way it's easy for humans and code to verify the dts, and easy to expand
arbitrarily in future if necessary. It also means you're not leaking
kernel-side constants as an ABI.

> +
> +omap_control_usb: omap-control-usb@4a002300 {
> +       compatible = "ti,omap-control-usb";
> +       reg = <0x4a002300 0x4>,
> +             <0x4a00233c 0x4>;
> +       reg-names = "control_dev_conf", "otghs_control";
> +       ti,type = <1>;
> +};

[...]

> +static int omap_control_usb_probe(struct platform_device *pdev)
> +{
> +       struct resource *res;
> +       struct device_node *np = pdev->dev.of_node;
> +       struct omap_control_usb_platform_data *pdata = pdev->dev.platform_data;
> +
> +       control_usb = devm_kzalloc(&pdev->dev, sizeof(*control_usb),
> +               GFP_KERNEL);
> +       if (!control_usb) {
> +               dev_err(&pdev->dev, "unable to alloc memory for control usb\n");
> +               return -ENOMEM;
> +       }
> +
> +       if (np) {
> +               of_property_read_u32(np, "ti,type", &control_usb->type);
> +       } else if (pdata) {
> +               control_usb->type = pdata->type;
> +       } else {
> +               dev_err(&pdev->dev, "no pdata present\n");
> +               return -EINVAL;
> +       }

Please do some sanity checking here on type. What if it's not
OMAP_CTRL_DEV_TYPE1 or OMAP_CTRL_DEV_TYPE2?

What if the values for OMAP_CTRL_DEV_TYPE{1,2} change? The binding will be
broken.

If you change ti,type to a string, the parsing also becomes sanity checking:

if (np) {
	char *type;
	if (of_property_read_string(np, "ti,type", &type) != 0)
		return -EINVAL;

	if (strcmp(type, "mailbox") == 0)
		control_usb->type = OMAP_CTRL_DEV_TYPE1;
	else if (strcmp(type, "register") == 0)
		control_usb->type = OMAP_CTRL_DEV_TYPE2;
	else
		return -EINVAL;
} else {
	... pdata case ...
}

Also, TYPE1 and TYPE2 aren't very descriptive. These could probably be better
named.

> +
> +       control_usb->dev        = &pdev->dev;
> +
> +       res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +               "control_dev_conf");
> +       control_usb->dev_conf = devm_request_and_ioremap(&pdev->dev, res);
> +       if (!control_usb->dev_conf) {
> +               dev_err(&pdev->dev, "Failed to obtain io memory\n");
> +               return -EADDRNOTAVAIL;
> +       }
> +
> +       if (control_usb->type == OMAP_CTRL_DEV_TYPE1) {
> +               res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +                       "otghs_control");
> +               control_usb->otghs_control = devm_request_and_ioremap(
> +                       &pdev->dev, res);
> +               if (!control_usb->otghs_control) {
> +                       dev_err(&pdev->dev, "Failed to obtain io memory\n");
> +                       return -EADDRNOTAVAIL;
> +               }
> +       }
> +
> +       if (control_usb->type == OMAP_CTRL_DEV_TYPE2) {
> +               res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +                       "phy_power_usb");
> +               control_usb->phy_power = devm_request_and_ioremap(
> +                       &pdev->dev, res);
> +               if (!control_usb->phy_power) {
> +                       dev_dbg(&pdev->dev, "Failed to obtain io memory\n");
> +                       return -EADDRNOTAVAIL;
> +               }
> +
> +               control_usb->sys_clk = devm_clk_get(control_usb->dev,
> +                       "sys_clkin");
> +               if (IS_ERR(control_usb->sys_clk)) {
> +                       pr_err("%s: unable to get sys_clkin\n", __func__);
> +                       return -EINVAL;
> +               }
> +       }
> +
> +
> +       dev_set_drvdata(control_usb->dev, control_usb);
> +
> +       return 0;
> +}

[...]

Thanks,
Mark.

