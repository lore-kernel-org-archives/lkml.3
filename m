Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3FZKjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 06:39:40 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:56601 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3FZKji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 06:39:38 -0400
Date: Wed, 26 Jun 2013 12:39:24 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Anders Hammarquist <iko@iko.pp.se>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/2] *** SUBJECT HERE ***
Message-ID: <20130626103924.GA30828@localhost>
References: <201306190012.r5J0CNJZ031854@eskarina.iko.pp.se>
 <20130619225315.GB12282@kroah.com>
 <201306212308.r5LN8C7M020720@eskarina.iko.pp.se>
 <20130621235603.GA1603@kroah.com>
 <201306221854.r5MIshv5013882@eskarina.iko.pp.se>
 <20130625233911.GA1087@kroah.com>
 <201306260829.r5Q8Txm5003881@eskarina.iko.pp.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306260829.r5Q8Txm5003881@eskarina.iko.pp.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 10:29:59AM +0200, Anders Hammarquist wrote:
> In a message of Tue, 25 Jun 2013 16:39:11 -0700, Greg KH writes:
> >> Indeed. I'd already had some (failed) thoughts about how to handle it
> >> nicely. Now I've had another think through, and I have something which
> >> deals with it and at least complains if TI_EXTRA_VID_PID_COUNT is changed
> >> without changing the initializer. Patch 2/2
> >
> >Why don't we just drop the extra id thing entirely?  The usb-serial
> >subsystem handles new device ids being added dynamically from sysfs for
> >a long time now.  Removing this module option would clean up the code a
> >lot, and prevent these errors from ever happening again.
> 
> Aha, yes, I'm all for that (had I only known I'd have done that to start
> with). I'll look in to it.

I already have a few patches here (part of a larger 3.11 clean-up series)
which removes the vid/pid module parameters from all usb-serial modules
including ti_usb_3410_5052.

I hope to be able to submit the whole series a later tonight, but here's
the ti_usb_3410_5052 part if anyone's interested.

Thanks,
Johan


From: Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] USB: ti_usb_3410_5052: remove vendor/product module parameters

Remove the vendor and product module parameters which were added a long
time ago when we did not have the dynamic sysfs interface to add
new device ids (and which isn't limited to five new vid/pid pair).

A vid/pid pair can be added dynamically using sysfs, for example:

  echo 0451 1234 >/sys/bus/usb-serial/drivers/ti_usb_3410_5052_1/new_id

for 1-port adapters, or

  echo 0451 1234 >/sys/bus/usb-serial/drivers/ti_usb_3410_5052_2/new_id

for 2-port adapters.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/usb/serial/ti_usb_3410_5052.c | 72 ++++-------------------------------
 1 file changed, 7 insertions(+), 65 deletions(-)

diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index f3e21f5..5585b20 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -141,20 +141,9 @@ static int ti_download_firmware(struct ti_device *tdev);
 
 /* module parameters */
 static int closing_wait = TI_DEFAULT_CLOSING_WAIT;
-static ushort vendor_3410[TI_EXTRA_VID_PID_COUNT];
-static unsigned int vendor_3410_count;
-static ushort product_3410[TI_EXTRA_VID_PID_COUNT];
-static unsigned int product_3410_count;
-static ushort vendor_5052[TI_EXTRA_VID_PID_COUNT];
-static unsigned int vendor_5052_count;
-static ushort product_5052[TI_EXTRA_VID_PID_COUNT];
-static unsigned int product_5052_count;
 
 /* supported devices */
-/* the array dimension is the number of default entries plus */
-/* TI_EXTRA_VID_PID_COUNT user defined entries plus 1 terminating */
-/* null entry */
-static struct usb_device_id ti_id_table_3410[15+TI_EXTRA_VID_PID_COUNT+1] = {
+static struct usb_device_id ti_id_table_3410[] = {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_EZ430_ID) },
 	{ USB_DEVICE(MTS_VENDOR_ID, MTS_GSM_NO_FW_PRODUCT_ID) },
@@ -171,16 +160,18 @@ static struct usb_device_id ti_id_table_3410[15+TI_EXTRA_VID_PID_COUNT+1] = {
 	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STEREO_PLUG_ID) },
 	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_STRIP_PORT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, FRI2_PRODUCT_ID) },
+	{ }	/* terminator */
 };
 
-static struct usb_device_id ti_id_table_5052[5+TI_EXTRA_VID_PID_COUNT+1] = {
+static struct usb_device_id ti_id_table_5052[] = {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_BOOT_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5152_BOOT_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_EEPROM_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_5052_FIRMWARE_PRODUCT_ID) },
+	{ }	/* terminator */
 };
 
-static struct usb_device_id ti_id_table_combined[19+2*TI_EXTRA_VID_PID_COUNT+1] = {
+static struct usb_device_id ti_id_table_combined[] = {
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, TI_3410_EZ430_ID) },
 	{ USB_DEVICE(MTS_VENDOR_ID, MTS_GSM_NO_FW_PRODUCT_ID) },
@@ -200,7 +191,7 @@ static struct usb_device_id ti_id_table_combined[19+2*TI_EXTRA_VID_PID_COUNT+1]
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_454C_PRODUCT_ID) },
 	{ USB_DEVICE(ABBOTT_VENDOR_ID, ABBOTT_PRODUCT_ID) },
 	{ USB_DEVICE(TI_VENDOR_ID, FRI2_PRODUCT_ID) },
-	{ }
+	{ }	/* terminator */
 };
 
 static struct usb_serial_driver ti_1port_device = {
@@ -289,61 +280,12 @@ module_param(closing_wait, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(closing_wait,
     "Maximum wait for data to drain in close, in .01 secs, default is 4000");
 
-module_param_array(vendor_3410, ushort, &vendor_3410_count, S_IRUGO);
-MODULE_PARM_DESC(vendor_3410,
-		"Vendor ids for 3410 based devices, 1-5 short integers");
-module_param_array(product_3410, ushort, &product_3410_count, S_IRUGO);
-MODULE_PARM_DESC(product_3410,
-		"Product ids for 3410 based devices, 1-5 short integers");
-module_param_array(vendor_5052, ushort, &vendor_5052_count, S_IRUGO);
-MODULE_PARM_DESC(vendor_5052,
-		"Vendor ids for 5052 based devices, 1-5 short integers");
-module_param_array(product_5052, ushort, &product_5052_count, S_IRUGO);
-MODULE_PARM_DESC(product_5052,
-		"Product ids for 5052 based devices, 1-5 short integers");
-
 MODULE_DEVICE_TABLE(usb, ti_id_table_combined);
 
+module_usb_serial_driver(serial_drivers, ti_id_table_combined);
 
 /* Functions */
 
-static int __init ti_init(void)
-{
-	int i, j, c;
-
-	/* insert extra vendor and product ids */
-	c = ARRAY_SIZE(ti_id_table_combined) - 2 * TI_EXTRA_VID_PID_COUNT - 1;
-	j = ARRAY_SIZE(ti_id_table_3410) - TI_EXTRA_VID_PID_COUNT - 1;
-	for (i = 0; i < min(vendor_3410_count, product_3410_count); i++, j++, c++) {
-		ti_id_table_3410[j].idVendor = vendor_3410[i];
-		ti_id_table_3410[j].idProduct = product_3410[i];
-		ti_id_table_3410[j].match_flags = USB_DEVICE_ID_MATCH_DEVICE;
-		ti_id_table_combined[c].idVendor = vendor_3410[i];
-		ti_id_table_combined[c].idProduct = product_3410[i];
-		ti_id_table_combined[c].match_flags = USB_DEVICE_ID_MATCH_DEVICE;
-	}
-	j = ARRAY_SIZE(ti_id_table_5052) - TI_EXTRA_VID_PID_COUNT - 1;
-	for (i = 0; i < min(vendor_5052_count, product_5052_count); i++, j++, c++) {
-		ti_id_table_5052[j].idVendor = vendor_5052[i];
-		ti_id_table_5052[j].idProduct = product_5052[i];
-		ti_id_table_5052[j].match_flags = USB_DEVICE_ID_MATCH_DEVICE;
-		ti_id_table_combined[c].idVendor = vendor_5052[i];
-		ti_id_table_combined[c].idProduct = product_5052[i];
-		ti_id_table_combined[c].match_flags = USB_DEVICE_ID_MATCH_DEVICE;
-	}
-
-	return usb_serial_register_drivers(serial_drivers, KBUILD_MODNAME, ti_id_table_combined);
-}
-
-static void __exit ti_exit(void)
-{
-	usb_serial_deregister_drivers(serial_drivers);
-}
-
-module_init(ti_init);
-module_exit(ti_exit);
-
-
 static int ti_startup(struct usb_serial *serial)
 {
 	struct ti_device *tdev;
-- 
1.8.2.1
