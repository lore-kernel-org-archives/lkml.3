Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814AbaE2Fdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:33:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268AbaE2EfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ludovic Drolez <ldrolez@debian.org>, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.14 044/140] USB: io_ti: fix firmware download on big-endian machines
Date: Wed, 28 May 2014 21:33:03 -0700
Message-Id: <20140529043055.054101442@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 5509076d1b4485ce9fb07705fcbcd2695907ab5b upstream.

During firmware download the device expects memory addresses in
big-endian byte order. As the wIndex parameter which hold the address is
sent in little-endian byte order regardless of host byte order, we need
to use swab16 rather than cpu_to_be16.

Also make sure to handle the struct ti_i2c_desc size parameter which is
returned in little-endian byte order.

Reported-by: Ludovic Drolez <ldrolez@debian.org>
Tested-by: Ludovic Drolez <ldrolez@debian.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/io_ti.c |   50 +++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 17 deletions(-)

--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -28,6 +28,7 @@
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/serial.h>
+#include <linux/swab.h>
 #include <linux/kfifo.h>
 #include <linux/ioctl.h>
 #include <linux/firmware.h>
@@ -280,7 +281,7 @@ static int read_download_mem(struct usb_
 {
 	int status = 0;
 	__u8 read_length;
-	__be16 be_start_address;
+	u16 be_start_address;
 
 	dev_dbg(&dev->dev, "%s - @ %x for %d\n", __func__, start_address, length);
 
@@ -296,10 +297,14 @@ static int read_download_mem(struct usb_
 		if (read_length > 1) {
 			dev_dbg(&dev->dev, "%s - @ %x for %d\n", __func__, start_address, read_length);
 		}
-		be_start_address = cpu_to_be16(start_address);
+		/*
+		 * NOTE: Must use swab as wIndex is sent in little-endian
+		 *       byte order regardless of host byte order.
+		 */
+		be_start_address = swab16((u16)start_address);
 		status = ti_vread_sync(dev, UMPC_MEMORY_READ,
 					(__u16)address_type,
-					(__force __u16)be_start_address,
+					be_start_address,
 					buffer, read_length);
 
 		if (status) {
@@ -394,7 +399,7 @@ static int write_i2c_mem(struct edgeport
 	struct device *dev = &serial->serial->dev->dev;
 	int status = 0;
 	int write_length;
-	__be16 be_start_address;
+	u16 be_start_address;
 
 	/* We can only send a maximum of 1 aligned byte page at a time */
 
@@ -409,11 +414,16 @@ static int write_i2c_mem(struct edgeport
 		__func__, start_address, write_length);
 	usb_serial_debug_data(dev, __func__, write_length, buffer);
 
-	/* Write first page */
-	be_start_address = cpu_to_be16(start_address);
+	/*
+	 * Write first page.
+	 *
+	 * NOTE: Must use swab as wIndex is sent in little-endian byte order
+	 *       regardless of host byte order.
+	 */
+	be_start_address = swab16((u16)start_address);
 	status = ti_vsend_sync(serial->serial->dev,
 				UMPC_MEMORY_WRITE, (__u16)address_type,
-				(__force __u16)be_start_address,
+				be_start_address,
 				buffer,	write_length);
 	if (status) {
 		dev_dbg(dev, "%s - ERROR %d\n", __func__, status);
@@ -436,11 +446,16 @@ static int write_i2c_mem(struct edgeport
 			__func__, start_address, write_length);
 		usb_serial_debug_data(dev, __func__, write_length, buffer);
 
-		/* Write next page */
-		be_start_address = cpu_to_be16(start_address);
+		/*
+		 * Write next page.
+		 *
+		 * NOTE: Must use swab as wIndex is sent in little-endian byte
+		 *       order regardless of host byte order.
+		 */
+		be_start_address = swab16((u16)start_address);
 		status = ti_vsend_sync(serial->serial->dev, UMPC_MEMORY_WRITE,
 				(__u16)address_type,
-				(__force __u16)be_start_address,
+				be_start_address,
 				buffer, write_length);
 		if (status) {
 			dev_err(dev, "%s - ERROR %d\n", __func__, status);
@@ -585,8 +600,8 @@ static int get_descriptor_addr(struct ed
 		if (rom_desc->Type == desc_type)
 			return start_address;
 
-		start_address = start_address + sizeof(struct ti_i2c_desc)
-							+ rom_desc->Size;
+		start_address = start_address + sizeof(struct ti_i2c_desc) +
+						le16_to_cpu(rom_desc->Size);
 
 	} while ((start_address < TI_MAX_I2C_SIZE) && rom_desc->Type);
 
@@ -599,7 +614,7 @@ static int valid_csum(struct ti_i2c_desc
 	__u16 i;
 	__u8 cs = 0;
 
-	for (i = 0; i < rom_desc->Size; i++)
+	for (i = 0; i < le16_to_cpu(rom_desc->Size); i++)
 		cs = (__u8)(cs + buffer[i]);
 
 	if (cs != rom_desc->CheckSum) {
@@ -650,7 +665,7 @@ static int check_i2c_image(struct edgepo
 			break;
 
 		if ((start_address + sizeof(struct ti_i2c_desc) +
-					rom_desc->Size) > TI_MAX_I2C_SIZE) {
+			le16_to_cpu(rom_desc->Size)) > TI_MAX_I2C_SIZE) {
 			status = -ENODEV;
 			dev_dbg(dev, "%s - structure too big, erroring out.\n", __func__);
 			break;
@@ -665,7 +680,8 @@ static int check_i2c_image(struct edgepo
 			/* Read the descriptor data */
 			status = read_rom(serial, start_address +
 						sizeof(struct ti_i2c_desc),
-						rom_desc->Size, buffer);
+						le16_to_cpu(rom_desc->Size),
+						buffer);
 			if (status)
 				break;
 
@@ -674,7 +690,7 @@ static int check_i2c_image(struct edgepo
 				break;
 		}
 		start_address = start_address + sizeof(struct ti_i2c_desc) +
-								rom_desc->Size;
+						le16_to_cpu(rom_desc->Size);
 
 	} while ((rom_desc->Type != I2C_DESC_TYPE_ION) &&
 				(start_address < TI_MAX_I2C_SIZE));
@@ -712,7 +728,7 @@ static int get_manuf_info(struct edgepor
 
 	/* Read the descriptor data */
 	status = read_rom(serial, start_address+sizeof(struct ti_i2c_desc),
-						rom_desc->Size, buffer);
+					le16_to_cpu(rom_desc->Size), buffer);
 	if (status)
 		goto exit;
 


