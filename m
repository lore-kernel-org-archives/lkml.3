Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940AbaFJUXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:23:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35180 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbaFJTue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:50:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 091/160] USB: io_ti: fix firmware download on big-endian machines
Date: Tue, 10 Jun 2014 12:45:31 -0700
Message-Id: <1402429600-20477-92-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/io_ti.c | 50 ++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index b7187bf..1c7bc52 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -29,6 +29,7 @@
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/serial.h>
+#include <linux/swab.h>
 #include <linux/kfifo.h>
 #include <linux/ioctl.h>
 #include <linux/firmware.h>
@@ -281,7 +282,7 @@ static int read_download_mem(struct usb_device *dev, int start_address,
 {
 	int status = 0;
 	__u8 read_length;
-	__be16 be_start_address;
+	u16 be_start_address;
 
 	dev_dbg(&dev->dev, "%s - @ %x for %d\n", __func__, start_address, length);
 
@@ -297,10 +298,14 @@ static int read_download_mem(struct usb_device *dev, int start_address,
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
@@ -397,7 +402,7 @@ static int write_i2c_mem(struct edgeport_serial *serial,
 	struct device *dev = &serial->serial->dev->dev;
 	int status = 0;
 	int write_length;
-	__be16 be_start_address;
+	u16 be_start_address;
 
 	/* We can only send a maximum of 1 aligned byte page at a time */
 
@@ -412,11 +417,16 @@ static int write_i2c_mem(struct edgeport_serial *serial,
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
@@ -439,11 +449,16 @@ static int write_i2c_mem(struct edgeport_serial *serial,
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
@@ -590,8 +605,8 @@ static int get_descriptor_addr(struct edgeport_serial *serial,
 		if (rom_desc->Type == desc_type)
 			return start_address;
 
-		start_address = start_address + sizeof(struct ti_i2c_desc)
-							+ rom_desc->Size;
+		start_address = start_address + sizeof(struct ti_i2c_desc) +
+						le16_to_cpu(rom_desc->Size);
 
 	} while ((start_address < TI_MAX_I2C_SIZE) && rom_desc->Type);
 
@@ -604,7 +619,7 @@ static int valid_csum(struct ti_i2c_desc *rom_desc, __u8 *buffer)
 	__u16 i;
 	__u8 cs = 0;
 
-	for (i = 0; i < rom_desc->Size; i++)
+	for (i = 0; i < le16_to_cpu(rom_desc->Size); i++)
 		cs = (__u8)(cs + buffer[i]);
 
 	if (cs != rom_desc->CheckSum) {
@@ -658,7 +673,7 @@ static int check_i2c_image(struct edgeport_serial *serial)
 			break;
 
 		if ((start_address + sizeof(struct ti_i2c_desc) +
-					rom_desc->Size) > TI_MAX_I2C_SIZE) {
+			le16_to_cpu(rom_desc->Size)) > TI_MAX_I2C_SIZE) {
 			status = -ENODEV;
 			dev_dbg(dev, "%s - structure too big, erroring out.\n", __func__);
 			break;
@@ -673,7 +688,8 @@ static int check_i2c_image(struct edgeport_serial *serial)
 			/* Read the descriptor data */
 			status = read_rom(serial, start_address +
 						sizeof(struct ti_i2c_desc),
-						rom_desc->Size, buffer);
+						le16_to_cpu(rom_desc->Size),
+						buffer);
 			if (status)
 				break;
 
@@ -682,7 +698,7 @@ static int check_i2c_image(struct edgeport_serial *serial)
 				break;
 		}
 		start_address = start_address + sizeof(struct ti_i2c_desc) +
-								rom_desc->Size;
+						le16_to_cpu(rom_desc->Size);
 
 	} while ((rom_desc->Type != I2C_DESC_TYPE_ION) &&
 				(start_address < TI_MAX_I2C_SIZE));
@@ -721,7 +737,7 @@ static int get_manuf_info(struct edgeport_serial *serial, __u8 *buffer)
 
 	/* Read the descriptor data */
 	status = read_rom(serial, start_address+sizeof(struct ti_i2c_desc),
-						rom_desc->Size, buffer);
+					le16_to_cpu(rom_desc->Size), buffer);
 	if (status)
 		goto exit;
 
-- 
1.9.1

