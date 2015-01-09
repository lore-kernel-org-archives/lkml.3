Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbbAIKoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:44:07 -0500
Received: from m01.upixeltek.com ([203.67.208.22]:44561 "EHLO sism01.sis.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932268AbbAIKoC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:44:02 -0500
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2015 05:44:00 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 2/2] INPUT/HID: add touch support for SiS touch driver
Date: Fri, 9 Jan 2015 18:38:29 +0800
Message-ID: <8322374EB97AA24A95D0DDBFC8F1CA1DBF96EA@SISMBEV01.sis.com.tw>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] INPUT/HID: add touch support for SiS touch driver
Thread-Index: AdAr+GhI5dpTktroTzK01FM9yRH4bw==
From: =?big5?B?tL+0QN+7ICh0YW1teV90c2VuZyk=?= <tammy_tseng@sis.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>
Cc: <tammy0524@gmail.com>
X-OriginalArrivalTime: 09 Jan 2015 10:38:30.0256 (UTC) FILETIME=[68B8A700:01D02BF8]
X-TM-AS-Product-Ver: SMEX-10.2.0.3176-7.500.1018-21236.004
X-TM-AS-Result: No--3.440000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-Received-IP: 192.168.50.87
X-Envelope-From: <tammy_tseng@sis.com>
X-Sherlock-Send: MailFilter (sism01.sis.com)
X-License: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
This package of patch is to add support for multitouch behavior for SiS touch products.
The patch of SiS hid multitouch driver is in hid.

Signed-off-by: Tammy Tseng <tammy_tseng@sis.com>
--

diff --git a/linux-3.18.1/drivers/hid/Kconfig b/linux-3.18.1/drivers/hid/Kconfig
index 2be7677..f42df4d 100644
--- a/linux-3.18.1/drivers/hid/Kconfig
+++ b/linux-3.18.1/drivers/hid/Kconfig
@@ -494,35 +494,7 @@ config HID_MULTITOUCH
 	  If unsure, say N.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called hid-multitouch.  
-	  
-config HID_MT_DBG_POINT
-	bool "HID Multitouch panels debug for touch point"
-	depends on HID_MULTITOUCH
-	default n
-	---help---
-	  Show debug message for touch point information.
-
-config HID_MT_DBG_MAP_INIT
-	bool "HID Multitouch panels debug mapping initial"
-	depends on HID_MULTITOUCH
-	default n
-	---help---
-	  Show debug message for mapping initial information.  
-
-config HID_SIS_CTRL
-	tristate "SiS Touch Device Controller"
-	depends on HID_MULTITOUCH
-	---help---
-	Support for SiS Touch devices update FW.
-
-config DEBUG_HID_SIS_UPDATE_FW
-	bool "SiS Touch device debug message(update firmware)"
-	depends on HID_SIS_CTRL
-	default n
-	---help---
-	  Say Y here if you want to enable debug message(update firmware) for SiS Touch 
-          devices. Must enable config HID_SIS_UPDATE_FW first.
+	  module will be called hid-multitouch.
 
 config HID_NTRIG
 	tristate "N-Trig touch screen"
diff --git a/linux-3.18.1/drivers/hid/Makefile b/linux-3.18.1/drivers/hid/Makefile
index 02dc20d..e2850d8 100644
--- a/linux-3.18.1/drivers/hid/Makefile
+++ b/linux-3.18.1/drivers/hid/Makefile
@@ -33,7 +33,6 @@ ifdef CONFIG_DEBUG_FS
 	hid-wiimote-y	+= hid-wiimote-debug.o
 endif
 
-obj-$(CONFIG_HID_SIS_CTRL)	+= hid-sis_ctrl.o
 obj-$(CONFIG_HID_A4TECH)	+= hid-a4tech.o
 obj-$(CONFIG_HID_ACRUX)		+= hid-axff.o
 obj-$(CONFIG_HID_APPLE)		+= hid-apple.o
diff --git a/linux-3.18.1/drivers/hid/hid-ids.h b/linux-3.18.1/drivers/hid/hid-ids.h
index c598e8d..7c86373 100644
--- a/linux-3.18.1/drivers/hid/hid-ids.h
+++ b/linux-3.18.1/drivers/hid/hid-ids.h
@@ -807,7 +807,6 @@
 #define USB_VENDOR_ID_SIS_TOUCH		0x0457
 #define USB_DEVICE_ID_SIS9200_TOUCH	0x9200
 #define USB_DEVICE_ID_SIS817_TOUCH	0x0817
-#define USB_PRODUCT_ID_SISF817_TOUCH	0xF817
 #define USB_DEVICE_ID_SIS_TS		0x1013
 #define USB_DEVICE_ID_SIS1030_TOUCH	0x1030
 
diff --git a/linux-3.18.1/drivers/hid/hid-multitouch.c b/linux-3.18.1/drivers/hid/hid-multitouch.c
index 31e28dd..51e25b9 100644
--- a/linux-3.18.1/drivers/hid/hid-multitouch.c
+++ b/linux-3.18.1/drivers/hid/hid-multitouch.c
@@ -45,7 +45,7 @@
 #include <linux/usb.h>
 #include <linux/input/mt.h>
 #include <linux/string.h>
-#include "hid-sis_ctrl.h"
+
 
 MODULE_AUTHOR("Stephane Chatty <chatty@enac.fr>");
 MODULE_AUTHOR("Benjamin Tissoires <benjamin.tissoires@gmail.com>");
@@ -1003,19 +1003,6 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (ret != 0)
 		return ret;
 
-	//SiS set noget for not init reports
-	hdev->quirks |= HID_QUIRK_NOGET;
-	printk(KERN_INFO "sis:sis-probe: quirk = %x\n", hdev->quirks);
-
-	//SiS FW update
-#ifdef CONFIG_HID_SIS_CTRL
-	ret = sis_setup_chardev(hdev);
-	if(ret)
-	{
-		printk( KERN_INFO "sis_setup_chardev fail\n");
-	}
-#endif	//CONFIG_HID_SIS_CTRL
-
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret)
 		return ret;
@@ -1054,10 +1041,6 @@ static int mt_resume(struct hid_device *hdev)
 
 static void mt_remove(struct hid_device *hdev)
 {
-	//SiS FW update
-#ifdef CONFIG_HID_SIS_CTRL
-	sis_deinit_chardev();
-#endif	//CONFIG_HID_SIS_CTRL
 	sysfs_remove_group(&hdev->dev.kobj, &mt_attribute_group);
 	hid_hw_stop(hdev);
 }
diff --git a/linux-3.18.1/drivers/hid/hid-sis_ctrl.c b/linux-3.18.1/drivers/hid/hid-sis_ctrl.c
deleted file mode 100644
index 2794b65..0000000
--- a/linux-3.18.1/drivers/hid/hid-sis_ctrl.c
+++ /dev/null
@@ -1,397 +0,0 @@
-/*
- *  Character device driver for SIS multitouch panels control
- *
- *  Copyright (c) 2009 SIS, Ltd.
- *
- */
-
-/*
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- */
-
-#include <linux/hid.h>
-#include <linux/module.h>
-#include <linux/usb.h>
-#include "usbhid/usbhid.h"
-#include <linux/init.h>
-
-//update FW
-#include <linux/fs.h>
-#include <linux/cdev.h>
-#include <asm/uaccess.h>	//copy_from_user() & copy_to_user()
-
-#include "hid-ids.h"
-#include "hid-sis_ctrl.h"
-
-static int sis_char_devs_count = 1;        /* device count */
-static int sis_char_major = 0;
-static struct cdev sis_char_cdev;
-static struct class *sis_char_class = NULL;
-
-static struct hid_device *hid_dev_backup = NULL;  //backup address
-static struct urb *backup_urb = NULL;
-
-#ifdef CONFIG_DEBUG_HID_SIS_UPDATE_FW
-	#define DBG_FW(fmt, arg...)	printk( fmt, ##arg )
-	void sis_dbg_dump_array( u8 *ptr, u32 size)
-	{
-		u32 i;
-		for (i=0; i<size; i++)  
-		{
-			DBG_FW ("%02X ", ptr[i]);
-			if( ((i+1)&0xF) == 0)
-				DBG_FW ("\n");
-		}
-		if( size & 0xF)
-			DBG_FW ("\n");
-	}
-#else
-	#define DBG_FW(...)
-	#define sis_dbg_dump_array(...)
-#endif	// CONFIG_DEBUG_HID_SIS_UPDATE_FW
-
-
-int sis_cdev_open(struct inode *inode, struct file *filp)	//20120306 Yuger ioctl for tool
-{
-	struct usbhid_device *usbhid; 
-
-	DBG_FW( "%s\n" , __FUNCTION__ );
-	//20110511, Yuger, kill current urb by method of usbhid_stop
-	if ( !hid_dev_backup )
-	{
-		printk( KERN_INFO "(stop)hid_dev_backup is not initialized yet" );
-		return -1;
-	}
-
-	usbhid = hid_dev_backup->driver_data;
-
-	printk( KERN_INFO "sys_sis_HID_stop\n" );
-
-	//printk( KERN_INFO "hid_dev_backup->vendor, hid_dev_backup->product = %x %x\n", hid_dev_backup->vendor, hid_dev_backup->product );
-
-	//20110602, Yuger, fix bug: not contact usb cause kernel panic
-	if( !usbhid )
-	{
-		printk( KERN_INFO "(stop)usbhid is not initialized yet" );
-		return -1;
-	}
-	else if ( !usbhid->urbin )
-	{
-		printk( KERN_INFO "(stop)usbhid->urbin is not initialized yet" );
-		return -1;
-	}
-	else if (hid_dev_backup->vendor == USB_VENDOR_ID_SIS2_TOUCH)
-	{
-		usb_fill_int_urb(backup_urb, usbhid->urbin->dev, usbhid->urbin->pipe,
-			usbhid->urbin->transfer_buffer, usbhid->urbin->transfer_buffer_length,
-			usbhid->urbin->complete, usbhid->urbin->context, usbhid->urbin->interval);
-
-                clear_bit( HID_STARTED, &usbhid->iofl );
-                set_bit( HID_DISCONNECTED, &usbhid->iofl );
-
-                usb_kill_urb( usbhid->urbin );
-                usb_free_urb( usbhid->urbin );
-                usbhid->urbin = NULL;
-		return 0;
-	}
-    else	
-	{
-		printk (KERN_INFO "This is not a SiS device");
-		return -801;
-	}
-}
-
-int sis_cdev_release(struct inode *inode, struct file *filp)
-{
-	//20110505, Yuger, rebuild the urb which is at the same urb address, then re-submit it
-
-	int ret;
-	struct usbhid_device *usbhid;
-	unsigned long flags;
-	
-	DBG_FW( "%s: " , __FUNCTION__ );
-	
-	if ( !hid_dev_backup )
-	{
-		printk( KERN_INFO "(stop)hid_dev_backup is not initialized yet" );
-		return -1;
-	}
-
-	usbhid = hid_dev_backup->driver_data;
-
-	printk( KERN_INFO "sys_sis_HID_start" );
-
-	if( !usbhid )
-	{
-		printk( KERN_INFO "(start)usbhid is not initialized yet" );
-		return -1;
-	}
-
-	if( !backup_urb )
-	{
-		printk( KERN_INFO "(start)backup_urb is not initialized yet" );
-		return -1;
-	}
-
-	clear_bit( HID_DISCONNECTED, &usbhid->iofl );
-	usbhid->urbin = usb_alloc_urb( 0, GFP_KERNEL );
-
-	if( !backup_urb->interval )
-	{
-		printk( KERN_INFO "(start)backup_urb->interval does not exist" );
-		return -1;
-	}
-
-	usb_fill_int_urb(usbhid->urbin, backup_urb->dev, backup_urb->pipe, 
-		backup_urb->transfer_buffer, backup_urb->transfer_buffer_length, 
-		backup_urb->complete, backup_urb->context, backup_urb->interval);
-	usbhid->urbin->transfer_dma = usbhid->inbuf_dma;
-	usbhid->urbin->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
-
-	set_bit( HID_STARTED, &usbhid->iofl );
-
-	//method at hid_start_in
-	spin_lock_irqsave( &usbhid->lock, flags );		
-	ret = usb_submit_urb( usbhid->urbin, GFP_ATOMIC );
-	spin_unlock_irqrestore( &usbhid->lock, flags );
-	//yy
-
-	DBG_FW( "ret = %d", ret );
-
-	return ret;
-}
-
-//SiS 817 only
-ssize_t sis_cdev_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
-{
-	int actual_length = 0, timeout = 0;
-	u8 *rep_data = NULL;
-	u16 size = 0;
-	long rep_ret;
-	struct usb_interface *intf = to_usb_interface(hid_dev_backup->dev.parent);
-	struct usb_device *dev = interface_to_usbdev(intf);
-
-	DBG_FW( "%s\n" , __FUNCTION__ );
-	
-	size = (((u16)(buf[64] & 0xff)) << 24) + (((u16)(buf[65] & 0xff)) << 16) + 
-		(((u16)(buf[66] & 0xff)) << 8) + (u16)(buf[67] & 0xff);
-	timeout = (((int)(buf[68] & 0xff)) << 24) + (((int)(buf[69] & 0xff)) << 16) + 
-		(((int)(buf[70] & 0xff)) << 8) + (int)(buf[71] & 0xff);
-
-	rep_data = kzalloc(size, GFP_KERNEL);
-	if (!rep_data)
-		return -12;
-
-	if ( copy_from_user( rep_data, (void*)buf, size) ) 
-	{
-		printk( KERN_INFO "copy_to_user fail\n" );
-		//free allocated data
-		kfree( rep_data );
-		rep_data = NULL;
-		return -19;
-	}
-
-	rep_ret = usb_interrupt_msg(dev, backup_urb->pipe,
-		rep_data, size, &actual_length, timeout);
-
-	DBG_FW( "%s: rep_data = ", __FUNCTION__);
-	sis_dbg_dump_array( rep_data, 8);
-		
-	if( rep_ret == 0 )
-	{
-		rep_ret = actual_length;
-		if ( copy_to_user( (void*)buf, rep_data, rep_ret ) ) 
-		{
-			printk( KERN_INFO "copy_to_user fail\n" );
-			//free allocated data
-			kfree( rep_data );
-			rep_data = NULL;
-			return -19;
-		}
-	}
-
-	//free allocated data
-	kfree( rep_data );
-	rep_data = NULL;
-	DBG_FW( "%s: rep_ret = %ld\n", __FUNCTION__,rep_ret );
-	return rep_ret;
-}
-
-ssize_t sis_cdev_write( struct file *file, const char __user *buf, size_t count, loff_t *f_pos )
-{
-	int actual_length = 0;
-	u8 *rep_data = NULL;
-	long rep_ret;
-	struct usb_interface *intf = to_usb_interface( hid_dev_backup->dev.parent );
-	struct usb_device *dev = interface_to_usbdev( intf );
-	struct usbhid_device *usbhid = hid_dev_backup->driver_data;
-
-	u16 size = (((u16)(buf[64] & 0xff)) << 24) + (((u16)(buf[65] & 0xff)) << 16) + 
-		(((u16)(buf[66] & 0xff)) << 8) + (u16)(buf[67] & 0xff);
-	int timeout = (((int)(buf[68] & 0xff)) << 24) + (((int)(buf[69] & 0xff)) << 16) + 
-		(((int)(buf[70] & 0xff)) << 8) + (int)(buf[71] & 0xff);
-	
-	DBG_FW( "%s: 817 method, " , __FUNCTION__ );
-	DBG_FW("timeout = %d, size %d\n", timeout, size);
-
-	rep_data = kzalloc(size, GFP_KERNEL);
-	if (!rep_data)
-		return -12;
-
-	if ( copy_from_user( rep_data, (void*)buf, size) ) 
-	{
-		printk( KERN_INFO "copy_to_user fail\n" );
-		//free allocated data
-		kfree( rep_data );
-		rep_data = NULL;
-		return -19;
-	}
-
-	rep_ret = usb_interrupt_msg( dev, usbhid->urbout->pipe,
-		rep_data, size, &actual_length, timeout );
-	
-	DBG_FW( "%s: rep_data = ", __FUNCTION__);
-	sis_dbg_dump_array( rep_data, size);
-	
-	if( rep_ret == 0 )
-	{
-		rep_ret = actual_length;
-		if ( copy_to_user( (void*)buf, rep_data, rep_ret ) ) 
-		{
-			printk( KERN_INFO "copy_to_user fail\n" );
-			//free allocated data
-			kfree( rep_data );
-			rep_data = NULL;
-			return -19;
-		}
-	}
-	DBG_FW( "%s: rep_ret = %ld\n", __FUNCTION__,rep_ret );
-	
-	//free allocated data
-	kfree( rep_data );
-	rep_data = NULL;
-
-	DBG_FW( "End of sys_sis_HID_IO\n" );
-	return rep_ret;
-}
-
-
-//for ioctl
-static const struct file_operations sis_cdev_fops = {
-	.owner	= THIS_MODULE,
-	.read	= sis_cdev_read,
-	.write	= sis_cdev_write,
-	.open	= sis_cdev_open,
-	.release= sis_cdev_release,
-};
-
-//for ioctl
-int sis_setup_chardev(struct hid_device *hdev)
-{
-	
-	dev_t dev = MKDEV(sis_char_major, 0);
-	int alloc_ret = 0;
-	int cdev_err = 0;
-	int input_err = 0;
-	struct device *class_dev = NULL;
-	void *ptr_err;
-	
-	printk("sis_setup_chardev.\n");
-	hid_dev_backup = hdev;
-	
-	backup_urb = usb_alloc_urb(0, GFP_KERNEL); //0721test
-	if (!backup_urb) {
-		dev_err(&hdev->dev, "cannot allocate backup_urb\n");
-		return -ENOMEM;
-	}
-/*	
-	if (nd == NULL) 
-	{
-          input_err = -ENOMEM;
-          goto error;
-	} 
-*/
-	// dynamic allocate driver handle
-	if (hdev->product == USB_PRODUCT_ID_SISF817_TOUCH)
-		alloc_ret = alloc_chrdev_region(&dev, 0, sis_char_devs_count, SISF817_DEVICE_NAME);
-	else
-		alloc_ret = alloc_chrdev_region(&dev, 0, sis_char_devs_count, SIS817_DEVICE_NAME);
-		
-	if (alloc_ret)
-		goto error;
-		
-	sis_char_major  = MAJOR(dev);
-	cdev_init(&sis_char_cdev, &sis_cdev_fops);
-	sis_char_cdev.owner = THIS_MODULE;
-	cdev_err = cdev_add(&sis_char_cdev, MKDEV(sis_char_major, 0), sis_char_devs_count);
-	if (cdev_err) 
-		goto error;
-
-	if (hdev->product == USB_PRODUCT_ID_SISF817_TOUCH)
-		printk(KERN_INFO "%s driver(major %d) installed.\n", SISF817_DEVICE_NAME, sis_char_major);
-	else
-		printk(KERN_INFO "%s driver(major %d) installed.\n", SIS817_DEVICE_NAME, sis_char_major);
-
-	// register class
-	if (hdev->product == USB_PRODUCT_ID_SISF817_TOUCH)
-		sis_char_class = class_create(THIS_MODULE, SISF817_DEVICE_NAME);
-	else if (hdev->product == USB_PRODUCT_ID_SIS817_TOUCH)
-		sis_char_class = class_create(THIS_MODULE, SIS817_DEVICE_NAME);
-
-	if(IS_ERR(ptr_err = sis_char_class)) 
-	{
-		goto err2;
-	}
-
-	if (hdev->product == USB_PRODUCT_ID_SISF817_TOUCH)
-		class_dev = device_create(sis_char_class, NULL, MKDEV(sis_char_major, 0), NULL, SISF817_DEVICE_NAME);
-	else if (hdev->product == USB_PRODUCT_ID_SIS817_TOUCH)
-		class_dev = device_create(sis_char_class, NULL, MKDEV(sis_char_major, 0), NULL, SIS817_DEVICE_NAME);
-
-	if(IS_ERR(ptr_err = class_dev)) 
-	{
-		goto err;
-	}
-	
-	return 0;
-error:
-	if (cdev_err == 0)
-		cdev_del(&sis_char_cdev);
-	if (alloc_ret == 0)
-		unregister_chrdev_region(MKDEV(sis_char_major, 0), sis_char_devs_count);
-	if(input_err != 0)
-	{
-		printk("sis_ts_bak error!\n");
-	}
-err:
-	device_destroy(sis_char_class, MKDEV(sis_char_major, 0));
-err2:
-	class_destroy(sis_char_class);
-	return -1;
-}
-EXPORT_SYMBOL(sis_setup_chardev);
-
-void sis_deinit_chardev(void)
-{
-	//for ioctl
-	dev_t dev;
-	printk(KERN_INFO "sis_remove\n");
-
-	dev = MKDEV(sis_char_major, 0);
-	cdev_del(&sis_char_cdev);
-	unregister_chrdev_region(dev, sis_char_devs_count);
-	device_destroy(sis_char_class, MKDEV(sis_char_major, 0));
-	class_destroy(sis_char_class);
-	usb_kill_urb( backup_urb );
-	usb_free_urb( backup_urb );
-	backup_urb = NULL;
-	hid_dev_backup = NULL;
-	
-}
-EXPORT_SYMBOL(sis_deinit_chardev);
-
-MODULE_DESCRIPTION("SiS 817 Touchscreen Control Driver");
-MODULE_LICENSE("GPL");
diff --git a/linux-3.18.1/drivers/hid/hid-sis_ctrl.h b/linux-3.18.1/drivers/hid/hid-sis_ctrl.h
deleted file mode 100644
index c7425c5..0000000
--- a/linux-3.18.1/drivers/hid/hid-sis_ctrl.h
+++ /dev/null
@@ -1,19 +0,0 @@
-#ifndef __HID_SIS_CTRL_H__
-#define __HID_SIS_CTRL_H__
-
-#define SIS817_DEVICE_NAME "sis_aegis_hid_touch_device"
-#define SISF817_DEVICE_NAME "sis_aegis_hid_bridge_touch_device"
-
-#define CTRL 0
-#define ENDP_01 1
-#define ENDP_02 2
-#define DIR_IN 0x1
-
-int sis_cdev_open(struct inode *inode, struct file *filp);
-int sis_cdev_release(struct inode *inode, struct file *filp);
-ssize_t sis_cdev_read(struct file *file, char __user *buf, size_t count, loff_t *ppos);
-ssize_t sis_cdev_write( struct file *file, const char __user *buf, size_t count, loff_t *f_pos );
-int sis_setup_chardev(struct hid_device *hdev);
-void sis_deinit_chardev(void);
-
-#endif	// __HID_SIS_CTRL_H__
