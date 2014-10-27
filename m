Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaJ0Wcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 18:32:45 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:17007 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaJ0Wcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 18:32:43 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18Urx2lFv2RqfRZChZYBMNQ
Date: Mon, 27 Oct 2014 15:31:14 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Felipe Balbi <balbi@ti.com>, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: USB Ethernet gadget on Nokia n900
Message-ID: <20141027223114.GU2560@atomide.com>
References: <20141019090107.GA19132@amd>
 <201410262222.39892@pali>
 <20141026215548.GA9004@amd>
 <201410262323.17891@pali>
 <20141027195209.GP2560@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141027195209.GP2560@atomide.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [141027 12:55]:
> * Pali Rohár <pali.rohar@gmail.com> [141026 15:24]:
> > On Sunday 26 October 2014 22:55:48 Pavel Machek wrote:
> > > > > I have root prepared on /dev/mmcblk0p6. I tried 3.17 with
> > > > > rx51_defconfig, but no, it refuses to mount it.
> > > > > 
> > > > > VFS: Cannot open root device "mmcblk0p6" or ....: error
> > > > > -19.
> > > > > 
> > > > > And then it proceeds to list mmcblk0p6 as one of available
> > > > > options
> > > > > 
> > > > > :-(.
> > > > > 
> > > > > Ideas welcome.
> > > > 
> > > > Try to add rootdelay=30 or rootwait to kernel cmdline.
> > > 
> > > I had rootdelay=3. Will try rootwait... no change. This is
> > > v3.17 with rx51_defconfig. CONFIG_MACH_NOKIA_RX51=y => device
> > > tree will not be used AFAICT.
> > > 
> > > Now I'm back at 3.14 without device tree; same setup works
> > > there. I tried disabling RX51 support in 3.14 (to make it
> > > boot using device tree) but that did not work.
> > > 								Pavel
> > 
> > I remember that there was some problem with initializing mmc 
> > device. Sometimes something failed and reading from eMMC was not 
> > possible. Try to boot kernel from uboot. Maybe it can help.
> 
> Would be nice to have both the USB and the MMC issues sorted
> out in the mainline kernel naturally and get rid of any bootloader
> dependencies.
> 
> I think the USB issue because usb_gadget_probe_driver() bails
> out with -ENODEV before the USB controller is found. Felipe, got
> any ideas how to fix this to work with -EPROBE_DEFER? Should this
> get called only from the USB controller probe?

Here's a patch that should fix the issues for built-in USB
gadgets.

Pavel, care to see if this gets NFSroot over USB working again
for you?

Regards,

Tony

8< ---------------------
From: Tony Lindgren <tony@atomide.com>
Date: Mon, 27 Oct 2014 14:42:42 -0700
Subject: [PATCH] usb: gadget: Fix regressions for initializing built-in gadgets

Up to v3.14 we used to have built-in gadgets work just fine
because they got initialized in the Makefile order and the
dependencies were taken care of by the platform init code.

With device tree based booting, nothing currently assures the
USB controller is initialized by the time the gadgets probe.
This is because we may have GPIOs and PHYs on I2C bus that
cause EPROBE_DEFER to happen for the USB controller.

As the gadgets are not currently bound to any device, they
get initialized with just an initcall.

Let's fix the issue by adding delayed work for the gadgets
to try binding to the USB controller driver. And while at it,
let's make the subsys_initcall() into a late_initcall_sync()
as the gadget won't be able to do anything on it's own early
anyways.

Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/drivers/usb/gadget/udc/udc-core.c
+++ b/drivers/usb/gadget/udc/udc-core.c
@@ -440,13 +440,20 @@ out:
 }
 EXPORT_SYMBOL_GPL(udc_attach_driver);
 
-int usb_gadget_probe_driver(struct usb_gadget_driver *driver)
+#define USB_GADGET_BIND_RETRIES		5
+#define USB_GADGET_BIND_TIMEOUT		(3 * HZ)
+static void usb_gadget_work(struct work_struct *work)
 {
+	struct usb_gadget_driver *driver = container_of(work,
+						struct usb_gadget_driver,
+						work.work);
 	struct usb_udc		*udc = NULL;
 	int			ret;
 
-	if (!driver || !driver->bind || !driver->setup)
-		return -EINVAL;
+	if (driver->retries++ > USB_GADGET_BIND_RETRIES) {
+		pr_err("couldn't find an available UDC\n");
+		return;
+	}
 
 	mutex_lock(&udc_lock);
 	list_for_each_entry(udc, &udc_list, list) {
@@ -455,13 +462,24 @@ int usb_gadget_probe_driver(struct usb_gadget_driver *driver)
 			goto found;
 	}
 
-	pr_debug("couldn't find an available UDC\n");
 	mutex_unlock(&udc_lock);
-	return -ENODEV;
+	schedule_delayed_work(&driver->work, USB_GADGET_BIND_TIMEOUT);
+	return;
+
 found:
 	ret = udc_bind_to_driver(udc, driver);
 	mutex_unlock(&udc_lock);
-	return ret;
+}
+
+int usb_gadget_probe_driver(struct usb_gadget_driver *driver)
+{
+	if (!driver || !driver->bind || !driver->setup)
+		return -EINVAL;
+
+	INIT_DELAYED_WORK(&driver->work, usb_gadget_work);
+	schedule_delayed_work(&driver->work, 0);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(usb_gadget_probe_driver);
 
@@ -473,6 +491,8 @@ int usb_gadget_unregister_driver(struct usb_gadget_driver *driver)
 	if (!driver || !driver->unbind)
 		return -EINVAL;
 
+	cancel_delayed_work(&driver->work);
+
 	mutex_lock(&udc_lock);
 	list_for_each_entry(udc, &udc_list, list)
 		if (udc->driver == driver) {
@@ -621,7 +641,7 @@ static int __init usb_udc_init(void)
 	udc_class->dev_uevent = usb_udc_uevent;
 	return 0;
 }
-subsys_initcall(usb_udc_init);
+late_initcall_sync(usb_udc_init);
 
 static void __exit usb_udc_exit(void)
 {
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -819,6 +819,8 @@ static inline int usb_gadget_disconnect(struct usb_gadget *gadget)
  * @resume: Invoked on USB resume.  May be called in_interrupt.
  * @reset: Invoked on USB bus reset. It is mandatory for all gadget drivers
  *	and should be called in_interrupt.
+ * @work: Gadget work used to bind to the USB controller.
+ * @retries: Gadget retries to bind to the USB controller.
  * @driver: Driver model state for this driver.
  *
  * Devices are disabled till a gadget driver successfully bind()s, which
@@ -877,6 +879,8 @@ struct usb_gadget_driver {
 	void			(*suspend)(struct usb_gadget *);
 	void			(*resume)(struct usb_gadget *);
 	void			(*reset)(struct usb_gadget *);
+	struct delayed_work	work;
+	int			retries;
 
 	/* FIXME support safe rmmod */
 	struct device_driver	driver;
