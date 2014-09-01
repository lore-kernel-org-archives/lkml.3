Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaIACMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 22:12:05 -0400
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:19179
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751000AbaIACMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 22:12:02 -0400
Date: Mon, 1 Sep 2014 10:11:35 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
CC: <linux-kernel@vger.kernel.org>, Todd Poynor <toddpoynor@google.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>,
        Benoit Goby <benoit@android.com>
Subject: Re: [RFC 1/2] USB: OTG: Hold wakeupsource when VBUS present
Message-ID: <20140901021134.GE3854@peterchendt>
References: <1408700972-8518-1-git-send-email-kiran.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408700972-8518-1-git-send-email-kiran.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(199003)(24454002)(189002)(80022001)(20776003)(77982001)(83072002)(64706001)(26826002)(4396001)(87936001)(79102001)(33656002)(97736001)(21056001)(92726001)(47776003)(107046002)(86362001)(85306004)(92566001)(90102001)(85852003)(102836001)(6806004)(99396002)(50466002)(23676002)(83506001)(106466001)(19580405001)(81542001)(74662001)(69596002)(81156004)(76176999)(31966008)(57986006)(46102001)(54356999)(81342001)(83322001)(19580395003)(44976005)(50986999)(76482001)(33716001)(110136001)(68736004)(105606002)(74502001)(104016003)(95666004)(15202345003)(84676001)(15975445006)(2004002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB564;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 03218BFD9F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 03:19:32PM +0530, Kiran Kumar Raparthy wrote:
> From: Todd Poynor <toddpoynor@google.com>
> 
> USB: OTG: Hold wakeupsource when VBUS present
> 

It is not related to OTG, would you change a name?

> Enabled by default, can disable with:
>    echo N > /sys/module/otg_wakeupsource/parameters/enabled
> 
> This is one of the number of patches from the Android AOSP common.git tree,
> which is used on almost all Android devices. so I wanted to submit it for
> review to see if it should go upstream.
> 
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Cc: Android Kernel Team <kernel-team@android.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Arve Hj�nnev�g <arve@android.com>
> Cc: Benoit Goby <benoit@android.com>
> Signed-off-by: Todd Poynor <toddpoynor@google.com>
> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
> [kiran: Added context to commit message
> 	Included build fix from Benoit Goby and Arve Arve Hj�nnev�g
> 	Removed lock->held field in driver as this mechanism is provided in wakeup.c
> 	wakelock(wl) terminology replaced with wakeup_source(ws)
> 	sys entry(module param) field modified to otg_wakeupsource
> 	__pm_stay_awake and __pm_relax called directly from the main
> 	code instead of calling them via otgws_grab,otgws_drop]
> ---
>  drivers/usb/phy/Kconfig            |   8 ++
>  drivers/usb/phy/Makefile           |   1 +
>  drivers/usb/phy/otg-wakeupsource.c | 171 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 180 insertions(+)
>  create mode 100644 drivers/usb/phy/otg-wakeupsource.c
> 
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index e253fa0..9c747b2 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -6,6 +6,14 @@ menu "USB Physical Layer drivers"
>  config USB_PHY
>  	def_bool n
>  
> +config USB_OTG_WAKEUPSOURCE
> +	bool "Hold a wakeupsource when USB connected"
> +	depends on PM_SLEEP
> +	select USB_PHY
> +	help
> +	  Select this to automatically hold a wakeupsource when USB is
> +	  connected, preventing suspend.
> +

I think it is a common driver, the UDC drivers are its best user, we
may only want to prevent the system entering suspend after UDC get
enumerated, not only just vbus is present, the PHY driver should not know
the UDC get enumerated or not, the state of enumeration belongs to
chapter 9 at USB 2.0 spec.

Peter
 
>  #
>  # USB Transceiver Drivers
>  #
> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
> index 24a9133..ca2fbaf 100644
> --- a/drivers/usb/phy/Makefile
> +++ b/drivers/usb/phy/Makefile
> @@ -3,6 +3,7 @@
>  #
>  obj-$(CONFIG_USB_PHY)			+= phy.o
>  obj-$(CONFIG_OF)			+= of.o
> +obj-$(CONFIG_USB_OTG_WAKEUPSOURCE)		+= otg-wakeupsource.o
>  
>  # transceiver drivers, keep the list sorted
>  
> diff --git a/drivers/usb/phy/otg-wakeupsource.c b/drivers/usb/phy/otg-wakeupsource.c
> new file mode 100644
> index 0000000..fa44e11
> --- /dev/null
> +++ b/drivers/usb/phy/otg-wakeupsource.c
> @@ -0,0 +1,171 @@
> +/*
> + * otg-wakeupsource.c
> + *
> + * Copyright (C) 2011 Google, Inc.
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/notifier.h>
> +#include <linux/pm_wakeup.h>
> +#include <linux/spinlock.h>
> +#include <linux/usb/otg.h>
> +
> +static bool enabled = true;
> +static struct usb_phy *otgws_xceiv;
> +static struct notifier_block otgws_nb;
> +
> +
> +static DEFINE_SPINLOCK(otgws_spinlock);
> +
> +/*
> + * Only one lock, but since these 2 fields are associated with each other...
> + */
> +
> +struct otgws_lock {
> +	char name[40];
> +	struct wakeup_source wsource;
> +};
> +
> +/*
> + * VBUS present lock.
> + */
> +
> +static struct otgws_lock vbus_lock;
> +
> +static int otgws_otg_notifications(struct notifier_block *nb,
> +				   unsigned long event, void *unused)
> +{
> +	unsigned long irqflags;
> +
> +	if (!enabled)
> +		return NOTIFY_OK;
> +
> +	spin_lock_irqsave(&otgws_spinlock, irqflags);
> +
> +	switch (event) {
> +	case USB_EVENT_VBUS:
> +	case USB_EVENT_ENUMERATED:
> +		__pm_stay_awake(&vbus_lock.wsource);
> +		break;
> +
> +	case USB_EVENT_NONE:
> +	case USB_EVENT_ID:
> +	case USB_EVENT_CHARGER:
> +		__pm_relax(&vbus_lock.wsource);
> +		break;
> +
> +	default:
> +		break;
> +	}
> +
> +	spin_unlock_irqrestore(&otgws_spinlock, irqflags);
> +	return NOTIFY_OK;
> +}
> +
> +static void sync_with_xceiv_state(void)
> +{
> +	if ((otgws_xceiv->last_event == USB_EVENT_VBUS) ||
> +	    (otgws_xceiv->last_event == USB_EVENT_ENUMERATED))
> +		__pm_stay_awake(&vbus_lock.wsource);
> +	else
> +		__pm_relax(&vbus_lock.wsource);
> +}
> +
> +static int init_for_xceiv(void)
> +{
> +	int rv;
> +	struct usb_phy *phy;
> +
> +	if (!otgws_xceiv) {
> +		phy = usb_get_phy(USB_PHY_TYPE_USB2);
> +
> +		if (IS_ERR(phy)) {
> +			pr_err("%s: No USB transceiver found\n", __func__);
> +			return PTR_ERR(phy);
> +		}
> +		otgws_xceiv = phy;
> +
> +		snprintf(vbus_lock.name, sizeof(vbus_lock.name), "vbus-%s",
> +			 dev_name(otgws_xceiv->dev));
> +		wakeup_source_init(&vbus_lock.wsource, vbus_lock.name);
> +
> +		rv = usb_register_notifier(otgws_xceiv, &otgws_nb);
> +
> +		if (rv) {
> +			pr_err("%s: usb_register_notifier on transceiver %s
> +				failed\n", __func__,
> +			       dev_name(otgws_xceiv->dev));
> +			otgws_xceiv = NULL;
> +			wakeup_source_trash(&vbus_lock.wsource);
> +			return rv;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int set_enabled(const char *val, const struct kernel_param *kp)
> +{
> +	unsigned long irqflags;
> +	int rv = param_set_bool(val, kp);
> +
> +	if (rv)
> +		return rv;
> +
> +	rv = init_for_xceiv();
> +
> +	if (rv)
> +		return rv;
> +
> +	spin_lock_irqsave(&otgws_spinlock, irqflags);
> +
> +	if (enabled)
> +		sync_with_xceiv_state();
> +	else
> +		__pm_relax(&vbus_lock.wsource);
> +
> +	spin_unlock_irqrestore(&otgws_spinlock, irqflags);
> +	return 0;
> +}
> +
> +static struct kernel_param_ops enabled_param_ops = {
> +	.set = set_enabled,
> +	.get = param_get_bool,
> +};
> +
> +module_param_cb(enabled, &enabled_param_ops, &enabled, 0644);
> +MODULE_PARM_DESC(enabled, "Hold wakeupsource when VBUS present");
> +
> +static int __init otg_wakeupsource_init(void)
> +{
> +	unsigned long irqflags;
> +
> +	otgws_nb.notifier_call = otgws_otg_notifications;
> +
> +	if (!init_for_xceiv()) {
> +		spin_lock_irqsave(&otgws_spinlock, irqflags);
> +
> +		if (enabled)
> +			sync_with_xceiv_state();
> +
> +		spin_unlock_irqrestore(&otgws_spinlock, irqflags);
> +	} else {
> +		enabled = false;
> +	}
> +
> +	return 0;
> +}
> +
> +late_initcall(otg_wakeupsource_init);
> -- 
> 1.8.2.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Best Regards,
Peter Chen
