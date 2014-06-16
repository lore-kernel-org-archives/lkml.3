Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaFPDEF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 23:04:05 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:15339
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752569AbaFPDEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 23:04:02 -0400
Date: Mon, 16 Jun 2014 09:36:39 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <r.baldyga@samsung.com>, <chanho61.park@samsung.com>
Subject: Re: Disable bus's drivers_autoprobe before rootfs has mounted
Message-ID: <20140616013637.GA6432@shlinux1.ap.freescale.net>
References: <fa47f0c3798b48c781bc0a8c344e6c57@BL2PR03MB226.namprd03.prod.outlook.com>
 <Pine.LNX.4.44L0.1406130944460.1059-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1406130944460.1059-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(24454002)(51704005)(80022001)(50466002)(33656002)(54356999)(50986999)(46102001)(97736001)(81342001)(97756001)(85306003)(83506001)(76482001)(81156003)(104016001)(102836001)(77982001)(19580395003)(76176999)(99396002)(79102001)(47776003)(15395725005)(74502001)(87936001)(81542001)(46406003)(23726002)(69596002)(15202345003)(44976005)(68736004)(6806004)(92566001)(15975445006)(84676001)(92726001)(31966008)(64706001)(20776003)(21056001)(2171001)(86362001)(4396001)(83072002)(74662001)(26826002)(83322001)(85852003)(21314002)(6606295002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0630;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0244637DEA
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 10:19:36AM -0400, Alan Stern wrote:
> On Fri, 13 Jun 2014, Peter Chen wrote:
> 
> > OK, we can keep our g_xxx gadget driver just support the basic feature. But
> > the bug that causes gadget driver load fail due to udc is probed deferral should
> > be fixed, do you think so, we can't wait until configfs has total been ready.
> 
> That problem has always existed.  There never has been a time when a
> gadget driver could be loaded before the UDC driver was ready.  Does it 
> really need to be fixed now?
> 

Yes, otherwise, the device which the udc is probed deferral and the
gadget driver is build-in will never work. If we skip fixing it, this
problem will exist for more than 2 years, it is too long.

I have a support request from android team that usb peripheral function
never works from 3.10.x kernel at one device, I think it is a common problem,
no only I meet it.

Below are links which this problem reports:

http://marc.info/?l=linux-usb&m=139380872501745&w=2
http://marc.info/?l=linux-usb&m=137706435611447&w=2

> If you do want to fix the problem, there's a much easier way than what
> you posted.  See below.
> 
Robert Baldyga posts the similar solution, but seems Felipe doesn't
agree it.
http://www.spinics.net/lists/linux-usb/msg102795.html

Then, you and Felipe has a discussion for this problem:
http://www.spinics.net/lists/linux-usb/msg106760.html

> 
> Index: usb-3.15/include/linux/usb/gadget.h
> ===================================================================
> --- usb-3.15.orig/include/linux/usb/gadget.h
> +++ usb-3.15/include/linux/usb/gadget.h
> @@ -821,6 +821,7 @@ static inline int usb_gadget_disconnect(
>   * @suspend: Invoked on USB suspend.  May be called in_interrupt.
>   * @resume: Invoked on USB resume.  May be called in_interrupt.
>   * @driver: Driver model state for this driver.
> + * @probe_list: List of drivers waiting to be probed.
>   *
>   * Devices are disabled till a gadget driver successfully bind()s, which
>   * means the driver will handle setup() requests needed to enumerate (and
> @@ -881,6 +882,7 @@ struct usb_gadget_driver {
>  
>  	/* FIXME support safe rmmod */
>  	struct device_driver	driver;
> +	struct list_head	probe_list;
>  };
>  
>  
> Index: usb-3.15/drivers/usb/gadget/udc-core.c
> ===================================================================
> --- usb-3.15.orig/drivers/usb/gadget/udc-core.c
> +++ usb-3.15/drivers/usb/gadget/udc-core.c
> @@ -47,8 +47,12 @@ struct usb_udc {
>  
>  static struct class *udc_class;
>  static LIST_HEAD(udc_list);
> +static LIST_HEAD(pending_drivers);
>  static DEFINE_MUTEX(udc_lock);
>  
> +static int udc_bind_to_driver(struct usb_udc *udc,
> +		struct usb_gadget_driver *driver);
> +
>  /* ------------------------------------------------------------------------- */
>  
>  #ifdef	CONFIG_HAS_DMA
> @@ -242,6 +246,15 @@ int usb_add_gadget_udc_release(struct de
>  
>  	usb_gadget_set_state(gadget, USB_STATE_NOTATTACHED);
>  
> +	while (!list_empty(&pending_drivers)) {
> +		struct usb_gadget_driver *driver;
> +
> +		driver = list_first_entry(&pending_drivers,
> +				struct usb_gadget_driver, probe_list);
> +		if (udc_bind_to_driver(udc, driver) == 0)
> +			break;
> +	}
> +
>  	mutex_unlock(&udc_lock);
>  
>  	return 0;
> @@ -338,6 +351,7 @@ static int udc_bind_to_driver(struct usb
>  
>  	dev_dbg(&udc->dev, "registering UDC driver [%s]\n",
>  			driver->function);
> +	list_del_init(&driver->probe_list);
>  
>  	udc->driver = driver;
>  	udc->dev.driver = &driver->driver;
> @@ -400,6 +414,7 @@ int usb_gadget_probe_driver(struct usb_g
>  		return -EINVAL;
>  
>  	mutex_lock(&udc_lock);
> +	INIT_LIST_HEAD(&driver->probe_list);
>  	list_for_each_entry(udc, &udc_list, list) {
>  		/* For now we take the first one */
>  		if (!udc->driver)
> @@ -407,8 +422,9 @@ int usb_gadget_probe_driver(struct usb_g
>  	}
>  
>  	pr_debug("couldn't find an available UDC\n");
> +	list_add_tail(&driver->probe_list, &pending_drivers);
>  	mutex_unlock(&udc_lock);
> -	return -ENODEV;
> +	return 0;
>  found:
>  	ret = udc_bind_to_driver(udc, driver);
>  	mutex_unlock(&udc_lock);
> @@ -425,6 +441,7 @@ int usb_gadget_unregister_driver(struct
>  		return -EINVAL;
>  
>  	mutex_lock(&udc_lock);
> +	list_del(&driver->probe_list);
>  	list_for_each_entry(udc, &udc_list, list)
>  		if (udc->driver == driver) {
>  			usb_gadget_remove_driver(udc);
> 
> 

-- 

Best Regards,
Peter Chen
