Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab3GWGqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 02:46:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46952 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab3GWGqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 02:46:42 -0400
Message-ID: <51EE26C4.30508@ti.com>
Date: Tue, 23 Jul 2013 12:16:28 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>
Subject: Re: [PATCH 05/16] usb: musb: dsps: use proper child nodes
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de> <1374516607-2705-6-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1374516607-2705-6-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/22/2013 11:39 PM, Sebastian Andrzej Siewior wrote:
> This moves the two instances from the big node into two child nodes. The
> glue layer ontop does almost nothing.
> There is one devices containing the (2) phy, (2) usb and later the dma
> engine. The usb device is the "glue device" which contains the musb
> device as a child. This is what we do ever since.
> The new file musb_am335x is just here to prob the new bus and populate
> child devices.
> There are a lot of changes to the dsps file as a result of the changes:
> - musb_core_offset
>    This is gone. The device tree provides memory ressources information
>    for the device there is no need to "fix" things
> - instances
>    This is gone as well. If we have two instances then we have have two
>    child enabled nodes in the device tree. For instance the SoC in beagle
>    bone has two USB instances but only one has been wired up so there is
>    no need to load and init the second instance since it won't be used.
> - dsps_glue is now per glue device
>    In the past there was one of this structs but with an array of two and
>    each instance accessed its variable depending on the platform device
>    id.
> - no unneeded copy of structs
>    I do not know why struct dsps_musb_wrapper is copied but it is not
>    necessary. The same goes for musb_hdrc_platform_data which allocated
>    on demand and then again by platform_device_add_data(). One copy is
>    enough.
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>   arch/arm/boot/dts/am335x-bone.dts  |  12 ++
>   arch/arm/boot/dts/am335x-evm.dts   |  20 +++
>   arch/arm/boot/dts/am335x-evmsk.dts |  12 ++
>   arch/arm/boot/dts/am33xx.dtsi      |  89 +++++++++++--
>   drivers/usb/musb/Kconfig           |   4 +
>   drivers/usb/musb/Makefile          |   3 +
>   drivers/usb/musb/musb_am335x.c     |  55 ++++++++
>   drivers/usb/musb/musb_dsps.c       | 255 ++++++++++++++-----------------------
>   8 files changed, 279 insertions(+), 171 deletions(-)
>   create mode 100644 drivers/usb/musb/musb_am335x.c
>
> diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
> index 444b4ed..2c2ac84 100644
> --- a/arch/arm/boot/dts/am335x-bone.dts
> +++ b/arch/arm/boot/dts/am335x-bone.dts
> @@ -120,6 +120,18 @@
>   			status = "okay";
>   		};
>   
> +		musb: usb@47400000 {
> +			status = "okay";
> +
> +			phy@47401300 {
> +				status = "okay";
> +			};
> +
> +			usb@47401000 {
> +				status = "okay";
> +			};
> +		};
> +
>   		i2c0: i2c@44e0b000 {
>   			pinctrl-names = "default";
>   			pinctrl-0 = <&i2c0_pins>;
> diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
> index 3aee1a4..a3a642a 100644
> --- a/arch/arm/boot/dts/am335x-evm.dts
> +++ b/arch/arm/boot/dts/am335x-evm.dts
> @@ -171,6 +171,26 @@
>   			};
>   		};
>   
> +		musb: usb@47400000 {
> +			status = "okay";
> +
> +			phy@47401300 {
> +				status = "okay";
> +			};
> +
> +			phy@47401b00 {
> +				status = "okay";
> +			};
> +
> +			usb@47401000 {
> +				status = "no";
> +			};
Any reason usb0 is disabled for am33xx evm? Just for testing?

> +
> +			usb@47401800 {
> +				status = "okay";
> +			};
> +		};
> +
>   		i2c1: i2c@4802a000 {
>   			pinctrl-names = "default";
>   			pinctrl-0 = <&i2c1_pins>;
> diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
> index 0c8ad17..766c23a 100644
> --- a/arch/arm/boot/dts/am335x-evmsk.dts
> +++ b/arch/arm/boot/dts/am335x-evmsk.dts
> @@ -207,6 +207,18 @@
>   			};
>   		};
>   
> +		musb: usb@47400000 {
> +			status = "okay";
> +
> +			phy@47401300 {
> +				status = "okay";
> +			};
> +
> +			usb@47401000 {
> +				status = "okay";
> +			};
> +		};
> +
>   		epwmss2: epwmss@48304000 {
>   			status = "okay";
>   
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 38b446b..81afb27 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -26,6 +26,10 @@
>   		serial5 = &uart5;
>   		d_can0 = &dcan0;
>   		d_can1 = &dcan1;
> +		usb0 = &usb0;
> +		usb1 = &usb1;
> +		phy0 = &usb0_phy;
> +		phy1 = &usb1_phy;
>   	};
>   
>   	cpus {
> @@ -333,21 +337,78 @@
>   			status = "disabled";
>   		};
>   
> -		usb@47400000 {
> -			compatible = "ti,musb-am33xx";
> -			reg = <0x47400000 0x1000	/* usbss */
> -			       0x47401000 0x800		/* musb instance 0 */
> -			       0x47401800 0x800>;	/* musb instance 1 */
> -			interrupts = <17		/* usbss */
> -				      18		/* musb instance 0 */
> -				      19>;		/* musb instance 1 */
> -			multipoint = <1>;
> -			num-eps = <16>;
> -			ram-bits = <12>;
> -			port0-mode = <3>;
> -			port1-mode = <3>;
> -			power = <250>;
> +		usb: usb@47400000 {
> +			compatible = "ti,am33xx-usb";
> +			reg = <0x47400000 0x1000>;
> +			ranges;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
>   			ti,hwmods = "usb_otg_hs";
> +			status = "disabled";
> +
> +			usb0_phy: phy@47401300 {
> +				compatible = "ti,am335x-usb-phy";
> +				reg = <0x44e10620 0x8
> +					0x47401300 0x100>;
> +				reg-names = "reset_mod", "phy";
> +				status = "disabled";
> +			};
> +
> +			usb0: usb@47401000 {
> +				compatible = "ti,musb-am33xx";
> +				ranges;
> +				#address-cells = <1>;
> +				#size-cells = <1>;
> +				reg = <0x47401000 0x200>;
> +				reg-names = "control";
> +				status = "disabled";
> +
> +				musb0: usb@47401400 {
> +					compatible = "mg,musbmhdrc";
> +					reg = <0x47401400 0x400>;
> +					reg-names = "mc";
> +					interrupts = <18>;
> +					interrupt-names = "mc";
> +					multipoint = <1>;
> +					num-eps = <16>;
> +					ram-bits = <12>;
> +					port-mode = <3>;
> +					power = <250>;
> +					phys = <&usb0_phy>;
> +				};
> +			};
> +
> +			usb1_phy: phy@47401b00 {
> +				compatible = "ti,am335x-usb-phy";
> +				reg = <0x44e10628 0x8
> +					0x47401b00 0x100>;
> +				reg-names = "reset_mod", "phy";
> +				status = "disabled";
> +			};
> +
> +			usb1: usb@47401800 {
> +				compatible = "ti,musb-am33xx";
> +				ranges;
> +				#address-cells = <1>;
> +				#size-cells = <1>;
> +				reg = <0x47401800 0x200>;
> +				reg-names = "control";
> +				status = "disabled";
> +
> +				musb1: usb@47401c00 {
> +					compatible = "mg,musbmhdrc";
> +					reg = <0x47401c00 0x400>;
> +					reg-names = "mc";
> +					interrupts = <19>;
> +					interrupt-names = "mc";
> +					multipoint = <1>;
> +					num-eps = <16>;
> +					ram-bits = <12>;
> +					port-mode = <3>;
> +					power = <250>;
> +					phys = <&usb1_phy>;
> +				};
> +			};
>   		};
>   
>   		epwmss0: epwmss@48300000 {
> diff --git a/drivers/usb/musb/Kconfig b/drivers/usb/musb/Kconfig
> index 797e3fd..b7257ae 100644
> --- a/drivers/usb/musb/Kconfig
> +++ b/drivers/usb/musb/Kconfig
> @@ -83,6 +83,7 @@ config USB_MUSB_AM35X
>   
>   config USB_MUSB_DSPS
>   	tristate "TI DSPS platforms"
> +	select USB_MUSB_AM335X_CHILD
>   
>   config USB_MUSB_BLACKFIN
>   	tristate "Blackfin"
> @@ -93,6 +94,9 @@ config USB_MUSB_UX500
>   
>   endchoice
>   
> +config USB_MUSB_AM335X_CHILD
> +	tristate
> +
>   choice
>   	prompt 'MUSB DMA mode'
>   	default MUSB_PIO_ONLY if ARCH_MULTIPLATFORM
> diff --git a/drivers/usb/musb/Makefile b/drivers/usb/musb/Makefile
> index 2b82ed7..52f552c 100644
> --- a/drivers/usb/musb/Makefile
> +++ b/drivers/usb/musb/Makefile
> @@ -20,6 +20,9 @@ obj-$(CONFIG_USB_MUSB_DA8XX)			+= da8xx.o
>   obj-$(CONFIG_USB_MUSB_BLACKFIN)			+= blackfin.o
>   obj-$(CONFIG_USB_MUSB_UX500)			+= ux500.o
>   
> +
> +obj-$(CONFIG_USB_MUSB_AM335X_CHILD)		+= musb_am335x.o
> +
>   # the kconfig must guarantee that only one of the
>   # possible I/O schemes will be enabled at a time ...
>   # PIO only, or DMA (several potential schemes).
> diff --git a/drivers/usb/musb/musb_am335x.c b/drivers/usb/musb/musb_am335x.c
> new file mode 100644
> index 0000000..41ac5b5
> --- /dev/null
> +++ b/drivers/usb/musb/musb_am335x.c
> @@ -0,0 +1,55 @@
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/module.h>
> +#include <linux/of_platform.h>
> +
> +static int am335x_child_probe(struct platform_device *pdev)
> +{
> +	int ret;
> +
> +	pm_runtime_enable(&pdev->dev);
> +
> +	ret = of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
> +	if (ret)
> +		goto err;
> +
> +	return 0;
> +err:
> +	pm_runtime_disable(&pdev->dev);
> +	return ret;
> +}
> +
> +static int of_remove_populated_child(struct device *dev, void *d)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +
> +	of_device_unregister(pdev);
> +	return 0;
> +}
> +
> +static int am335x_child_remove(struct platform_device *pdev)
> +{
> +	device_for_each_child(&pdev->dev, NULL, of_remove_populated_child);
> +	pm_runtime_disable(&pdev->dev);
> +	return 0;
> +}
> +
> +static const struct of_device_id am335x_child_of_match[] = {
> +	{ .compatible = "ti,am33xx-usb" },
> +	{  },
> +};
> +MODULE_DEVICE_TABLE(of, am335x_child_of_match);
> +
> +static struct platform_driver am335x_child_driver = {
> +	.probe		= am335x_child_probe,
> +	.remove         = am335x_child_remove,
> +	.driver         = {
> +		.name   = "am335x-usb-childs",
> +		.of_match_table	= of_match_ptr(am335x_child_of_match),
> +	},
> +};
> +
> +module_platform_driver(am335x_child_driver);
> +MODULE_DESCRIPTION("AM33xx child devices");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
> index 1440fac..37ebcbc 100644
> --- a/drivers/usb/musb/musb_dsps.c
> +++ b/drivers/usb/musb/musb_dsps.c
> @@ -43,6 +43,7 @@
>   #include <linux/of.h>
>   #include <linux/of_device.h>
>   #include <linux/of_address.h>
> +#include <linux/of_irq.h>
>   
>   #include "musb_core.h"
>   
> @@ -106,10 +107,7 @@ struct dsps_musb_wrapper {
>   	/* bit positions for mode */
>   	unsigned	iddig:5;
>   	/* miscellaneous stuff */
> -	u32		musb_core_offset;
>   	u8		poll_seconds;
> -	/* number of musb instances */
> -	u8		instances;
>   };
>   
>   /**
> @@ -117,10 +115,10 @@ struct dsps_musb_wrapper {
>    */
>   struct dsps_glue {
>   	struct device *dev;
> -	struct platform_device *musb[2];	/* child musb pdev */
> +	struct platform_device *musb;	/* child musb pdev */
>   	const struct dsps_musb_wrapper *wrp; /* wrapper register offsets */
> -	struct timer_list timer[2];	/* otg_workaround timer */
> -	unsigned long last_timer[2];    /* last timer data for each instance */
> +	struct timer_list timer;	/* otg_workaround timer */
> +	unsigned long last_timer;    /* last timer data for each instance */
>   };
>   
>   /**
> @@ -170,7 +168,6 @@ static void otg_timer(unsigned long _musb)
>   	struct musb *musb = (void *)_musb;
>   	void __iomem *mregs = musb->mregs;
>   	struct device *dev = musb->controller;
> -	struct platform_device *pdev = to_platform_device(dev);
>   	struct dsps_glue *glue = dev_get_drvdata(dev->parent);
>   	const struct dsps_musb_wrapper *wrp = glue->wrp;
>   	u8 devctl;
> @@ -207,7 +204,7 @@ static void otg_timer(unsigned long _musb)
>   	case OTG_STATE_B_IDLE:
>   		devctl = dsps_readb(mregs, MUSB_DEVCTL);
>   		if (devctl & MUSB_DEVCTL_BDEVICE)
> -			mod_timer(&glue->timer[pdev->id],
> +			mod_timer(&glue->timer,
>   					jiffies + wrp->poll_seconds * HZ);
>   		else
>   			musb->xceiv->state = OTG_STATE_A_IDLE;
> @@ -221,7 +218,6 @@ static void otg_timer(unsigned long _musb)
>   static void dsps_musb_try_idle(struct musb *musb, unsigned long timeout)
>   {
>   	struct device *dev = musb->controller;
> -	struct platform_device *pdev = to_platform_device(dev);
>   	struct dsps_glue *glue = dev_get_drvdata(dev->parent);
>   
>   	if (timeout == 0)
> @@ -232,23 +228,23 @@ static void dsps_musb_try_idle(struct musb *musb, unsigned long timeout)
>   				musb->xceiv->state == OTG_STATE_A_WAIT_BCON)) {
>   		dev_dbg(musb->controller, "%s active, deleting timer\n",
>   				usb_otg_state_string(musb->xceiv->state));
> -		del_timer(&glue->timer[pdev->id]);
> -		glue->last_timer[pdev->id] = jiffies;
> +		del_timer(&glue->timer);
> +		glue->last_timer = jiffies;
>   		return;
>   	}
>   
> -	if (time_after(glue->last_timer[pdev->id], timeout) &&
> -				timer_pending(&glue->timer[pdev->id])) {
> +	if (time_after(glue->last_timer, timeout) &&
> +				timer_pending(&glue->timer)) {
>   		dev_dbg(musb->controller,
>   			"Longer idle timer already pending, ignoring...\n");
>   		return;
>   	}
> -	glue->last_timer[pdev->id] = timeout;
> +	glue->last_timer = timeout;
>   
>   	dev_dbg(musb->controller, "%s inactive, starting idle timer for %u ms\n",
>   		usb_otg_state_string(musb->xceiv->state),
>   			jiffies_to_msecs(timeout - jiffies));
> -	mod_timer(&glue->timer[pdev->id], timeout);
> +	mod_timer(&glue->timer, timeout);
>   }
>   
>   static irqreturn_t dsps_interrupt(int irq, void *hci)
> @@ -256,7 +252,6 @@ static irqreturn_t dsps_interrupt(int irq, void *hci)
>   	struct musb  *musb = hci;
>   	void __iomem *reg_base = musb->ctrl_base;
>   	struct device *dev = musb->controller;
> -	struct platform_device *pdev = to_platform_device(dev);
>   	struct dsps_glue *glue = dev_get_drvdata(dev->parent);
>   	const struct dsps_musb_wrapper *wrp = glue->wrp;
>   	unsigned long flags;
> @@ -316,7 +311,7 @@ static irqreturn_t dsps_interrupt(int irq, void *hci)
>   			 */
>   			musb->int_usb &= ~MUSB_INTR_VBUSERROR;
>   			musb->xceiv->state = OTG_STATE_A_WAIT_VFALL;
> -			mod_timer(&glue->timer[pdev->id],
> +			mod_timer(&glue->timer,
>   					jiffies + wrp->poll_seconds * HZ);
>   			WARNING("VBUS error workaround (delay coming)\n");
>   		} else if (drvvbus) {
> @@ -324,7 +319,7 @@ static irqreturn_t dsps_interrupt(int irq, void *hci)
>   			MUSB_HST_MODE(musb);
>   			musb->xceiv->otg->default_a = 1;
>   			musb->xceiv->state = OTG_STATE_A_WAIT_VRISE;
> -			del_timer(&glue->timer[pdev->id]);
> +			del_timer(&glue->timer);
>   		} else {
>   			musb->is_active = 0;
>   			MUSB_DEV_MODE(musb);
> @@ -351,8 +346,7 @@ static irqreturn_t dsps_interrupt(int irq, void *hci)
>   
>   	/* Poll for ID change */
>   	if (musb->xceiv->state == OTG_STATE_B_IDLE)
> -		mod_timer(&glue->timer[pdev->id],
> -			 jiffies + wrp->poll_seconds * HZ);
> +		mod_timer(&glue->timer, jiffies + wrp->poll_seconds * HZ);
>   
>   	spin_unlock_irqrestore(&musb->lock, flags);
>   
> @@ -362,31 +356,34 @@ static irqreturn_t dsps_interrupt(int irq, void *hci)
>   static int dsps_musb_init(struct musb *musb)
>   {
>   	struct device *dev = musb->controller;
> -	struct platform_device *pdev = to_platform_device(dev);
>   	struct dsps_glue *glue = dev_get_drvdata(dev->parent);
> +	struct platform_device *parent = to_platform_device(dev->parent);
>   	const struct dsps_musb_wrapper *wrp = glue->wrp;
> -	void __iomem *reg_base = musb->ctrl_base;
> +	void __iomem *reg_base;
> +	struct resource *r;
>   	u32 rev, val;
> -	int status;
>   
> -	/* mentor core register starts at offset of 0x400 from musb base */
> -	musb->mregs += wrp->musb_core_offset;
> +	r = platform_get_resource_byname(parent, IORESOURCE_MEM, "control");
> +	if (!r)
> +		return -EINVAL;
> +
> +	reg_base = devm_ioremap_resource(dev, r);
> +	if (!musb->ctrl_base)
> +		return -EINVAL;
> +	musb->ctrl_base = reg_base;
>   
>   	/* NOP driver needs change if supporting dual instance */
> -	musb->xceiv = devm_usb_get_phy_by_phandle(glue->dev, "phys", 0);
> -	if (IS_ERR_OR_NULL(musb->xceiv))
> -		return -EPROBE_DEFER;
> +	musb->xceiv = devm_usb_get_phy_by_phandle(dev, "phys", 0);
> +	if (IS_ERR(musb->xceiv))
> +		return PTR_ERR(musb->xceiv);
>   
>   	/* Returns zero if e.g. not clocked */
>   	rev = dsps_readl(reg_base, wrp->revision);
> -	if (!rev) {
> -		status = -ENODEV;
> -		goto err0;
> -	}
> +	if (!rev)
> +		return -ENODEV;
>   
>   	usb_phy_init(musb->xceiv);
> -
> -	setup_timer(&glue->timer[pdev->id], otg_timer, (unsigned long) musb);
> +	setup_timer(&glue->timer, otg_timer, (unsigned long) musb);
>   
>   	/* Reset the musb */
>   	dsps_writel(reg_base, wrp->control, (1 << wrp->reset));
> @@ -402,17 +399,14 @@ static int dsps_musb_init(struct musb *musb)
>   	dsps_writel(reg_base, wrp->eoi, 0);
>   
>   	return 0;
> -err0:
> -	return status;
>   }
>   
>   static int dsps_musb_exit(struct musb *musb)
>   {
>   	struct device *dev = musb->controller;
> -	struct platform_device *pdev = to_platform_device(dev);
>   	struct dsps_glue *glue = dev_get_drvdata(dev->parent);
>   
> -	del_timer_sync(&glue->timer[pdev->id]);
> +	del_timer_sync(&glue->timer);
>   
>   	usb_phy_shutdown(musb->xceiv);
>   	return 0;
> @@ -430,106 +424,98 @@ static struct musb_platform_ops dsps_ops = {
>   
>   static u64 musb_dmamask = DMA_BIT_MASK(32);
>   
> -static int dsps_create_musb_pdev(struct dsps_glue *glue, u8 id)
> +static int get_int_prop(struct device_node *dn, const char *s)
>   {
> -	struct device *dev = glue->dev;
> -	struct platform_device *pdev = to_platform_device(dev);
> -	struct musb_hdrc_platform_data  *pdata = dev->platform_data;
> -	struct device_node *np = pdev->dev.of_node;
> -	struct musb_hdrc_config	*config;
> -	struct platform_device	*musb;
> -	struct resource *res;
> +	int ret;
> +	u32 val;
> +
> +	ret = of_property_read_u32(dn, s, &val);
> +	if (ret)
> +		return 0;
> +	return val;
> +}
> +
> +static int dsps_create_musb_pdev(struct dsps_glue *glue,
> +		struct platform_device *parent)
> +{
> +	struct musb_hdrc_platform_data pdata;
>   	struct resource	resources[2];
> -	char res_name[11];
> +	struct device *dev = &parent->dev;
> +	struct musb_hdrc_config	*config;
> +	struct platform_device *musb;
> +	struct device_node *dn = parent->dev.of_node;
> +	struct device_node *child_node;
>   	int ret;
>   
> -	/* first resource is for usbss, so start index from 1 */
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, id + 1);
> -	if (!res) {
> -		dev_err(dev, "failed to get memory for instance %d\n", id);
> -		ret = -ENODEV;
> -		goto err0;
> +	child_node = of_get_child_by_name(dn, "usb");
> +	if (!child_node)
> +		return -EINVAL;
> +
> +	memset(resources, 0, sizeof(resources));
> +	ret = of_address_to_resource(child_node, 0, &resources[0]);
> +	if (ret) {
> +		dev_err(dev, "failed to get memory.\n");
> +		return ret;
>   	}
> -	res->parent = NULL;
> -	resources[0] = *res;
> -
> -	/* first resource is for usbss, so start index from 1 */
> -	res = platform_get_resource(pdev, IORESOURCE_IRQ, id + 1);
> -	if (!res) {
> -		dev_err(dev, "failed to get irq for instance %d\n", id);
> -		ret = -ENODEV;
> -		goto err0;
> +
> +	ret = of_irq_to_resource(child_node, 0, &resources[1]);
> +	if (ret == 0) {
> +		dev_err(dev, "failed to get irq.\n");
> +		ret = -EINVAL;
> +		return ret;
>   	}
> -	res->parent = NULL;
> -	resources[1] = *res;
> -	resources[1].name = "mc";
>   
>   	/* allocate the child platform device */
>   	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
>   	if (!musb) {
>   		dev_err(dev, "failed to allocate musb device\n");
> -		ret = -ENOMEM;
> -		goto err0;
> +		return -ENOMEM;
>   	}
>   
>   	musb->dev.parent		= dev;
>   	musb->dev.dma_mask		= &musb_dmamask;
>   	musb->dev.coherent_dma_mask	= musb_dmamask;
> +	musb->dev.of_node		= of_node_get(child_node);
>   
> -	glue->musb[id]			= musb;
> +	glue->musb = musb;
>   
> -	ret = platform_device_add_resources(musb, resources, 2);
> +	ret = platform_device_add_resources(musb, resources,
> +			ARRAY_SIZE(resources));
>   	if (ret) {
>   		dev_err(dev, "failed to add resources\n");
> -		goto err2;
> +		goto err;
>   	}
>   
> -	if (np) {
> -		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> -		if (!pdata) {
> -			dev_err(&pdev->dev,
> -				"failed to allocate musb platform data\n");
> -			ret = -ENOMEM;
> -			goto err2;
> -		}
> -
> -		config = devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
> -		if (!config) {
> -			dev_err(&pdev->dev,
> -				"failed to allocate musb hdrc config\n");
> -			ret = -ENOMEM;
> -			goto err2;
> -		}
> -
> -		of_property_read_u32(np, "num-eps", (u32 *)&config->num_eps);
> -		of_property_read_u32(np, "ram-bits", (u32 *)&config->ram_bits);
> -		snprintf(res_name, sizeof(res_name), "port%d-mode", id);
> -		of_property_read_u32(np, res_name, (u32 *)&pdata->mode);
> -		of_property_read_u32(np, "power", (u32 *)&pdata->power);
> -		config->multipoint = of_property_read_bool(np, "multipoint");
> -
> -		pdata->config		= config;
> +	config = devm_kzalloc(&parent->dev, sizeof(*config), GFP_KERNEL);
> +	if (!config) {
> +		dev_err(dev, "failed to allocate musb hdrc config\n");
> +		ret = -ENOMEM;
> +		goto err;
>   	}
> +	pdata.config = config;
> +	pdata.platform_ops = &dsps_ops;
>   
> -	pdata->platform_ops		= &dsps_ops;
> +	config->num_eps = get_int_prop(child_node, "num-eps");
> +	config->ram_bits = get_int_prop(child_node, "ram-bits");
> +	pdata.mode = get_int_prop(child_node, "port-mode");
> +	pdata.power = get_int_prop(child_node, "power");
> +	config->multipoint = of_property_read_bool(child_node, "multipoint");
>   
> -	ret = platform_device_add_data(musb, pdata, sizeof(*pdata));
> +	ret = platform_device_add_data(musb, &pdata, sizeof(pdata));
>   	if (ret) {
>   		dev_err(dev, "failed to add platform_data\n");
> -		goto err2;
> +		goto err;
>   	}
>   
>   	ret = platform_device_add(musb);
>   	if (ret) {
>   		dev_err(dev, "failed to register musb device\n");
> -		goto err2;
> +		goto err;
>   	}
> -
>   	return 0;
>   
> -err2:
> +err:
>   	platform_device_put(musb);
> -err0:
>   	return ret;
>   }
>   
> @@ -538,14 +524,12 @@ static int dsps_probe(struct platform_device *pdev)
>   	const struct of_device_id *match;
>   	const struct dsps_musb_wrapper *wrp;
>   	struct dsps_glue *glue;
> -	struct resource *iomem;
> -	int ret, i;
> +	int ret;
>   
>   	match = of_match_node(musb_dsps_of_match, pdev->dev.of_node);
>   	if (!match) {
>   		dev_err(&pdev->dev, "fail to get matching of_match struct\n");
> -		ret = -EINVAL;
> -		goto err0;
> +		return -EINVAL;
>   	}
>   	wrp = match->data;
>   
> @@ -553,29 +537,13 @@ static int dsps_probe(struct platform_device *pdev)
>   	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
>   	if (!glue) {
>   		dev_err(&pdev->dev, "unable to allocate glue memory\n");
> -		ret = -ENOMEM;
> -		goto err0;
> -	}
> -
> -	/* get memory resource */
> -	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!iomem) {
> -		dev_err(&pdev->dev, "failed to get usbss mem resourse\n");
> -		ret = -ENODEV;
> -		goto err1;
> +		return -ENOMEM;
>   	}
>   
>   	glue->dev = &pdev->dev;
> +	glue->wrp = wrp;
>   
> -	glue->wrp = kmemdup(wrp, sizeof(*wrp), GFP_KERNEL);
> -	if (!glue->wrp) {
> -		dev_err(&pdev->dev, "failed to duplicate wrapper struct memory\n");
> -		ret = -ENOMEM;
> -		goto err1;
> -	}
>   	platform_set_drvdata(pdev, glue);
> -
> -	/* enable the usbss clocks */
>   	pm_runtime_enable(&pdev->dev);
>   
>   	ret = pm_runtime_get_sync(&pdev->dev);
> @@ -584,17 +552,9 @@ static int dsps_probe(struct platform_device *pdev)
>   		goto err2;
>   	}
>   
> -	/* create the child platform device for all instances of musb */
> -	for (i = 0; i < wrp->instances ; i++) {
> -		ret = dsps_create_musb_pdev(glue, i);
> -		if (ret != 0) {
> -			dev_err(&pdev->dev, "failed to create child pdev\n");
> -			/* release resources of previously created instances */
> -			for (i--; i >= 0 ; i--)
> -				platform_device_unregister(glue->musb[i]);
> -			goto err3;
> -		}
> -	}
> +	ret = dsps_create_musb_pdev(glue, pdev);
> +	if (ret)
> +		goto err3;
>   
>   	return 0;
>   
> @@ -602,26 +562,19 @@ static int dsps_probe(struct platform_device *pdev)
>   	pm_runtime_put(&pdev->dev);
>   err2:
>   	pm_runtime_disable(&pdev->dev);
> -	kfree(glue->wrp);
> -err1:
>   	kfree(glue);
> -err0:
>   	return ret;
>   }
> +
>   static int dsps_remove(struct platform_device *pdev)
>   {
>   	struct dsps_glue *glue = platform_get_drvdata(pdev);
> -	const struct dsps_musb_wrapper *wrp = glue->wrp;
> -	int i;
>   
> -	/* delete the child platform device */
> -	for (i = 0; i < wrp->instances ; i++)
> -		platform_device_unregister(glue->musb[i]);
> +	platform_device_unregister(glue->musb);
>   
>   	/* disable usbss clocks */
>   	pm_runtime_put(&pdev->dev);
>   	pm_runtime_disable(&pdev->dev);
> -	kfree(glue->wrp);
>   	kfree(glue);
>   	return 0;
>   }
> @@ -652,9 +605,7 @@ static const struct dsps_musb_wrapper ti81xx_driver_data = {
>   	.rxep_shift		= 16,
>   	.rxep_mask		= 0xfffe,
>   	.rxep_bitmap		= (0xfffe << 16),
> -	.musb_core_offset	= 0x400,
>   	.poll_seconds		= 2,
> -	.instances		= 1,
>   };
>   
>   static const struct of_device_id musb_dsps_of_match[] = {
> @@ -678,14 +629,4 @@ MODULE_AUTHOR("Ravi B <ravibabu@ti.com>");
>   MODULE_AUTHOR("Ajay Kumar Gupta <ajay.gupta@ti.com>");
>   MODULE_LICENSE("GPL v2");
>   
> -static int __init dsps_init(void)
> -{
> -	return platform_driver_register(&dsps_usbss_driver);
> -}
> -subsys_initcall(dsps_init);
> -
> -static void __exit dsps_exit(void)
> -{
> -	platform_driver_unregister(&dsps_usbss_driver);
> -}
> -module_exit(dsps_exit);
> +module_platform_driver(dsps_usbss_driver);


-- 
-George

