Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaKZGWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 01:22:43 -0500
Received: from mail-bl2on0129.outbound.protection.outlook.com ([65.55.169.129]:7616
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752319AbaKZGWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 01:22:31 -0500
Date: Wed, 26 Nov 2014 13:14:57 +0800
From: Peter Chen <peter.chen@freescale.com>
To: George Cherian <george.cherian@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <sojka@merica.cz>,
        <mathias.nyman@intel.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>, <kgene.kim@samsung.com>,
        <ben-linux@fluff.org>, <linux@arm.linux.org.uk>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>
Subject: Re: [PATCH 01/19] usb: common: drd-lib: Add DRD lib for USB.
Message-ID: <20141126051454.GA24203@shlinux2>
References: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
 <1416921115-10467-2-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1416921115-10467-2-git-send-email-george.cherian@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(199003)(51704005)(31966008)(107046002)(15975445006)(110136001)(83506001)(104016003)(46102003)(4396001)(46406003)(33716001)(44976005)(84676001)(50466002)(62966003)(54356999)(19580395003)(50986999)(6806004)(76176999)(77156002)(68736004)(19580405001)(97736003)(87936001)(15202345003)(120916001)(33656002)(106466001)(105606002)(97756001)(95666004)(92726001)(92566001)(64706001)(21056001)(47776003)(20776003)(86362001)(575784001)(102836001)(23726002)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0629;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-Forefront-PRVS: 04073E895A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0728;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 06:41:37PM +0530, George Cherian wrote:
> Add USB DRD library. This Library facilitates to
> switch roles between HOST and Device modes.
> 
> A DRD should be added to the library using usb_drd_add().
> Register the HOST and UDC using usb_drd_register_hcd/udc().
> Un-Register the HOST and UDC using usb_drd_unregister_hcd/udc().
> 
> Depending on the state of IP -
> Call the following to start/stop HOST controller
> usb_drd_start/stop_hcd().
> This internally calls usb_add/remove_hcd() or IP specific low level start/stop
> defined in ll_start/stop
> 
> Call the following to start/stop UDC
> usb_drd_start/stop_udc().
> This internally calls udc_start/udc_stop() or IP specific low level start/stop
> defined in ll_start/stop
> 
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>  drivers/usb/Kconfig          |  15 ++
>  drivers/usb/common/Makefile  |   1 +
>  drivers/usb/common/drd-lib.c | 346 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/usb/drd.h      |  77 ++++++++++
>  4 files changed, 439 insertions(+)
>  create mode 100644 drivers/usb/common/drd-lib.c
>  create mode 100644 include/linux/usb/drd.h
> 
> diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
> index ae481c3..ea0d944 100644
> --- a/drivers/usb/Kconfig
> +++ b/drivers/usb/Kconfig
> @@ -34,6 +34,21 @@ config USB_COMMON
>  	default y
>  	depends on USB || USB_GADGET
>  
> +config DRD_LIB
> +	tristate  "DRD Library support"
> +	default y
> +	depends on USB && USB_GADGET
> +	---help---
> +	  This option adds DRD Library support for Universal Serial Bus (USB).
> +	  DRD Library faciliatets the Role switching by HOST and DEVICE roles,
> +	  If your hardware has a Dual Role Device.
> +
> +	  The DRD Library uses USB core API's to start/stop HOST controllers,
> +	  UDC API's to start/stop DEVICE controllers, ther by enabling to
> +	  switch roles between HOST and Device modes.

%s/ther by/thereby

> +
> +	  Say N if unsure.
> +
>  config USB_ARCH_HAS_HCD
>  	def_bool y
>  
> diff --git a/drivers/usb/common/Makefile b/drivers/usb/common/Makefile
> index ca2f8bd..e2c1593 100644
> --- a/drivers/usb/common/Makefile
> +++ b/drivers/usb/common/Makefile
> @@ -7,3 +7,4 @@ usb-common-y			  += common.o
>  usb-common-$(CONFIG_USB_LED_TRIG) += led.o
>  
>  obj-$(CONFIG_USB_OTG_FSM) += usb-otg-fsm.o
> +obj-$(CONFIG_DRD_LIB)       += drd-lib.o
> diff --git a/drivers/usb/common/drd-lib.c b/drivers/usb/common/drd-lib.c
> new file mode 100644
> index 0000000..6159436
> --- /dev/null
> +++ b/drivers/usb/common/drd-lib.c
> @@ -0,0 +1,346 @@
> +/**
> + * drd-lib.c - USB DRD library functions
> + *
> + * Copyright (C) 2014 Texas Instruments
> + * Author: George Cherian <george.cherian@ti.com>
> + *
> + * This program is free software: you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2  of
> + * the License as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/usb.h>
> +
> +#include <linux/usb/hcd.h>
> +#include <linux/usb/gadget.h>
> +#include <linux/usb/drd.h>
> +
> +/**
> + * struct usb_drd - describes one dual role device
> + * @host - the HOST controller device of this drd
> + * @gadget - the gadget of drd
> + * @parent - the device to the actual controller
> + * @list - for use by the drd lib
> + * @state - specifies the current state
> + *
> + * This represents the internal data structure which is used by the UDC-class
> + * to hold information about udc driver and gadget together.
> + */

It is dual role struct, why you only talk about device?

> +struct usb_drd {
> +	struct usb_drd_host	*host;
> +	struct usb_drd_gadget	*gadget;
> +	struct device		*parent;
> +	struct list_head	list;
> +	unsigned int		state;
> +};
> +
> +static LIST_HEAD(drd_list);
> +static DEFINE_SPINLOCK(drd_lock);
> +
> +static struct usb_drd *usb_drd_get_dev(struct device *parent)
> +{
> +	struct usb_drd *drd;
> +
> +	spin_lock(&drd_lock);
> +	list_for_each_entry(drd, &drd_list, list)
> +		if (drd->parent == parent)
> +			goto out;
> +	drd = NULL;
> +out:
> +	spin_unlock(&drd_lock);
> +
> +	return drd;
> +}
> +
> +int usb_drd_get_state(struct device *parent)
> +{
> +	struct usb_drd	*drd;
> +
> +	drd = usb_drd_get_dev(parent);
> +	if (!drd)
> +		return -ENODEV;
> +
> +	return drd->state;
> +}
> +EXPORT_SYMBOL_GPL(usb_drd_get_state);
> +
> +int usb_drd_release(struct device *parent)
> +{
> +	struct usb_drd	*drd;
> +	int ret;
> +
> +	spin_lock(&drd_lock);
> +	list_for_each_entry(drd, &drd_list, list) {
> +		if (drd->parent == parent) {
> +			kfree(drd);
> +			ret = 0;
> +			goto out;
> +		}
> +	}
> +	ret = -ENODEV;
> +out:
> +	spin_unlock(&drd_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(usb_drd_release);
> +
> +int usb_drd_add(struct device *parent)
> +{
> +	struct usb_drd	*drd;
> +
> +	drd = kzalloc(sizeof(*drd), GFP_KERNEL);
> +	if (!drd)
> +		return -ENOMEM;
> +
> +	spin_lock(&drd_lock);
> +	drd->parent = parent;
> +	list_add_tail(&drd->list, &drd_list);
> +	drd->state = DRD_UNREGISTERED;
> +
> +	spin_unlock(&drd_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(usb_drd_add);
> +
> +int usb_drd_register_hcd(struct device *parent, struct usb_drd_host *host)
> +{
> +	struct usb_drd	*drd;
> +
> +	drd = usb_drd_get_dev(parent);
> +	if (!drd)
> +		return -ENODEV;
> +
> +	spin_lock(&drd_lock);
> +	drd->host = host;
> +	drd->state |= DRD_HOST_REGISTERED | DRD_HOST_ACTIVE;
> +	spin_unlock(&drd_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(usb_drd_register_hcd);
> +
> +int usb_drd_unregister_hcd(struct device *parent)
> +{
> +	struct usb_drd	*drd;
> +
> +	drd = usb_drd_get_dev(parent);
> +	if (!drd)
> +		return -ENODEV;
> +
> +	spin_lock(&drd_lock);
> +	drd->state &= ~(DRD_HOST_REGISTERED | DRD_HOST_ACTIVE);
> +	spin_unlock(&drd_lock);
> +	kfree(drd->host);

It is better to allocate and free memory at the same file, either
both at DRD LIB APIs, or at host controller and udc driver.

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(usb_drd_unregister_hcd);
> +
> +int usb_drd_start_hcd(struct device *parent)
> +{
> +	struct usb_drd	*drd;
> +	struct usb_drd_setup *setup;
> +
> +	drd = usb_drd_get_dev(parent);
> +	if (!drd)
> +		return -ENODEV;
> +
> +	if (WARN_ON(!(drd->state & DRD_HOST_REGISTERED)))
> +		return -EINVAL;
> +
> +	setup = drd->host->host_setup;
> +	if (setup && setup->ll_start)
> +		setup->ll_start(setup->data);
> +
> +	usb_add_hcd(drd->host->main_hcd,
> +		    drd->host->hcd_irq, IRQF_SHARED);
> +	if (drd->host->shared_hcd)
> +		usb_add_hcd(drd->host->shared_hcd,
> +			    drd->host->hcd_irq, IRQF_SHARED);

Check return value please.

Peter
> +
> +	spin_lock(&drd_lock);
> +	drd->state |= DRD_HOST_ACTIVE;
> +	spin_unlock(&drd_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(usb_drd_start_hcd);
> +
> +int usb_drd_stop_hcd(struct device *parent)
> +{
> +	struct usb_drd	*drd;
> +	struct usb_drd_setup *setup;
> +
> +	drd = usb_drd_get_dev(parent);
> +	if (!drd)
> +		return -ENODEV;
> +
> +	if (WARN_ON(!(drd->state & DRD_HOST_ACTIVE)))
> +		return -EINVAL;
> +
> +	setup = drd->host->host_setup;
> +	if (setup && setup->ll_stop)
> +		setup->ll_stop(setup->data);
> +	if (drd->host->shared_hcd)
> +		usb_remove_hcd(drd->host->shared_hcd);
> +
> +	usb_remove_hcd(drd->host->main_hcd);
> +
> +	spin_lock(&drd_lock);
> +	drd->state = drd->state & ~DRD_HOST_ACTIVE;
> +	spin_unlock(&drd_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(usb_drd_stop_hcd);
> +
> +int usb_drd_register_udc(struct device *parent, struct usb_drd_gadget *gadget)
> +{
> +	struct usb_drd	*drd;
> +
> +	drd = usb_drd_get_dev(parent);
> +	if (!drd)
> +		return -ENODEV;
> +
> +	spin_lock(&drd_lock);
> +	drd->gadget = gadget;
> +	drd->state |= DRD_DEVICE_REGISTERED;
> +	if (drd->gadget->g_driver)
> +		drd->state |= DRD_DEVICE_ACTIVE;
> +
> +	spin_unlock(&drd_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(usb_drd_register_udc);
> +
> +int usb_drd_register_udc_driver(struct device *parent,
> +				struct usb_gadget_driver *driver)
> +{
> +	struct usb_drd	*drd;
> +
> +	drd = usb_drd_get_dev(parent);
> +	if (!drd)
> +		return -ENODEV;
> +
> +	spin_lock(&drd_lock);
> +	drd->gadget->g_driver = driver;
> +	drd->state |= DRD_DEVICE_ACTIVE;
> +	spin_unlock(&drd_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(usb_drd_register_udc_driver);
> +
> +int usb_drd_unregister_udc(struct device *parent)
> +{
> +	struct usb_drd	*drd;
> +
> +	drd = usb_drd_get_dev(parent);
> +	if (!drd)
> +		return -ENODEV;
> +
> +	spin_lock(&drd_lock);
> +	drd->state &= ~(DRD_DEVICE_REGISTERED | DRD_DEVICE_ACTIVE);
> +	spin_unlock(&drd_lock);
> +	kfree(drd->gadget->gadget_setup);
> +	kfree(drd->gadget);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(usb_drd_unregister_udc);
> +
> +int usb_drd_unregister_udc_driver(struct device *parent)
> +{
> +	struct usb_drd	*drd;
> +	struct usb_drd_gadget *drd_gadget;
> +
> +	drd = usb_drd_get_dev(parent);
> +	if (!drd)
> +		return -ENODEV;
> +	drd_gadget = drd->gadget;
> +
> +	spin_lock(&drd_lock);
> +	drd->state &= ~DRD_DEVICE_ACTIVE;
> +	drd_gadget->g_driver = NULL;
> +	spin_unlock(&drd_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(usb_drd_unregister_udc_driver);
> +
> +int usb_drd_start_udc(struct device *parent)
> +{
> +	struct usb_drd	*drd;
> +	struct usb_drd_gadget *drd_gadget;
> +	struct usb_drd_setup *setup;
> +
> +	drd = usb_drd_get_dev(parent);
> +	if (!drd)
> +		return -ENODEV;
> +
> +	if (WARN_ON(!(drd->state & DRD_DEVICE_REGISTERED)))
> +		return -EINVAL;
> +
> +	drd_gadget = drd->gadget;
> +	setup = drd_gadget->gadget_setup;
> +
> +	if (setup && setup->ll_start)
> +		setup->ll_start(setup->data);
> +
> +	usb_add_gadget_udc_release(parent, drd_gadget->gadget,
> +				   setup->ll_release);
> +	spin_lock(&drd_lock);
> +	drd->state |= DRD_DEVICE_ACTIVE;
> +	spin_unlock(&drd_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(usb_drd_start_udc);
> +
> +int usb_drd_stop_udc(struct device *parent)
> +{
> +	struct usb_drd	*drd;
> +	struct usb_drd_gadget *drd_gadget;
> +	struct usb_drd_setup *setup;
> +
> +	drd = usb_drd_get_dev(parent);
> +	if (!drd)
> +		return -ENODEV;
> +
> +	if (WARN_ON(!(drd->state & DRD_DEVICE_REGISTERED)))
> +		return -EINVAL;
> +
> +	drd_gadget = drd->gadget;
> +	setup = drd_gadget->gadget_setup;
> +	if (setup && setup->ll_stop)
> +		setup->ll_stop(setup->data);
> +
> +	usb_del_gadget_udc(drd_gadget->gadget);
> +
> +	spin_lock(&drd_lock);
> +	drd->state = drd->state & ~DRD_DEVICE_ACTIVE;
> +	spin_unlock(&drd_lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(usb_drd_stop_udc);
> +
> +MODULE_DESCRIPTION("USB-DRD Library");
> +MODULE_AUTHOR("George Cherian <george.cherian@ti.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/usb/drd.h b/include/linux/usb/drd.h
> new file mode 100644
> index 0000000..71c64dc
> --- /dev/null
> +++ b/include/linux/usb/drd.h
> @@ -0,0 +1,77 @@
> +#include <linux/usb/gadget.h>
> +#include <linux/usb/otg.h>
> +#include <linux/usb/hcd.h>
> +
> +struct usb_drd_setup {
> +	int	(*ll_start)(void *);
> +	int	(*ll_stop)(void *);
> +	void	(*ll_release)(struct device *);
> +	void	*data;
> +};
> +
> +struct usb_drd_host {
> +	struct usb_hcd		*main_hcd;
> +	struct usb_hcd		*shared_hcd;
> +	int			hcd_irq;
> +	struct usb_drd_setup *host_setup;
> +};
> +
> +struct usb_drd_gadget {
> +	struct usb_gadget_driver *g_driver;
> +	struct usb_gadget *gadget;
> +	struct usb_drd_setup *gadget_setup;
> +};
> +
> +#define DRD_UNREGISTERED	0x0
> +#define DRD_DEVICE_REGISTERED	0x1
> +#define DRD_HOST_REGISTERED	0x2
> +#define DRD_HOST_ACTIVE		0x4
> +#define DRD_DEVICE_ACTIVE	0x8
> +
> +#if IS_ENABLED(CONFIG_DRD_LIB)
> +int usb_drd_release(struct device *parent);
> +int usb_drd_add(struct device *parent);
> +int usb_drd_register_udc(struct device *parent,
> +			 struct usb_drd_gadget *gadget);
> +int usb_drd_register_udc_driver(struct device *parent,
> +				struct usb_gadget_driver *driver);
> +int usb_drd_unregister_udc(struct device *parent);
> +int usb_drd_unregister_udc_driver(struct device *parent);
> +int usb_drd_register_hcd(struct device *parent,
> +			 struct usb_drd_host *host);
> +int usb_drd_unregister_hcd(struct device *parent);
> +int usb_drd_start_hcd(struct device *parent);
> +int usb_drd_stop_hcd(struct device *parent);
> +int usb_drd_start_udc(struct device *parent);
> +int usb_drd_stop_udc(struct device *parent);
> +int usb_drd_get_state(struct device *parent);
> +#else
> +static inline int usb_drd_release(struct device *parent)
> +{ return 0; }
> +static inline int usb_drd_add(struct device *parent)
> +{ return 0; }
> +static inline int usb_drd_register_udc(struct device *parent,
> +				       struct usb_drd_gadget *gadget)
> +{ return 0; }
> +static inline int usb_drd_register_udc_driver(struct device *parent,
> +					      struct usb_gadget_driver *driver)
> +{ return 0; }
> +static inline int usb_drd_unregister_udc(struct device *parent,
> +					 struct usb_drd_gadget *gadget)
> +{ return 0; }
> +static inline int usb_drd_unregister_udc_driver(struct device *parent)
> +{ return 0; }
> +static inline int usb_drd_register_hcd(struct device *parent,
> +				       struct usb_drd_host *host)
> +{ return 0; }
> +static inline int usb_drd_unregister_hcd(struct device *parent)
> +{ return 0; }
> +static inline int usb_drd_stop_hcd(struct device *parent)
> +{ return 0; }
> +static inline int usb_drd_start_udc(struct device *parent)
> +{ return 0; }
> +static inline int usb_drd_stop_udc(struct device *parent)
> +{ return 0; }
> +static inline int usb_drd_get_state(struct device *parent)
> +{ return 0; }
> +#endif
> -- 
> 1.8.3.1
> 

-- 

Best Regards,
Peter Chen
