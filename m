Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415AbaEPMvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:51:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49567 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753717AbaEPMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:48:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ludovic Drolez" <ldrolez@debian.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <jhovold@gmail.com>
Date: Fri, 16 May 2014 13:47:21 +0100
Message-ID: <lsq.1400244441.943404503@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 27/34] USB: io_ti: fix firmware download on big-endian
 machines
In-Reply-To: <lsq.1400244440.390103756@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.59-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/io_ti.c | 50 ++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 17 deletions(-)

--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -36,6 +36,7 @@
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/serial.h>
+#include <linux/swab.h>
 #include <linux/kfifo.h>
 #include <linux/ioctl.h>
 #include <linux/firmware.h>
@@ -306,7 +307,7 @@ static int read_download_mem(struct usb_
 {
 	int status = 0;
 	__u8 read_length;
-	__be16 be_start_address;
+	u16 be_start_address;
 
 	dbg("%s - @ %x for %d", __func__, start_address, length);
 
@@ -323,10 +324,14 @@ static int read_download_mem(struct usb_
 			dbg("%s - @ %x for %d", __func__,
 			     start_address, read_length);
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
@@ -426,7 +431,7 @@ static int write_i2c_mem(struct edgeport
 {
 	int status = 0;
 	int write_length;
-	__be16 be_start_address;
+	u16 be_start_address;
 
 	/* We can only send a maximum of 1 aligned byte page at a time */
 
@@ -442,11 +447,16 @@ static int write_i2c_mem(struct edgeport
 	usb_serial_debug_data(debug, &serial->serial->dev->dev,
 						__func__, write_length, buffer);
 
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
 		dbg("%s - ERROR %d", __func__, status);
@@ -470,11 +480,16 @@ static int write_i2c_mem(struct edgeport
 		usb_serial_debug_data(debug, &serial->serial->dev->dev,
 					__func__, write_length, buffer);
 
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
 			dev_err(&serial->serial->dev->dev, "%s - ERROR %d\n",
@@ -681,8 +696,8 @@ static int get_descriptor_addr(struct ed
 		if (rom_desc->Type == desc_type)
 			return start_address;
 
-		start_address = start_address + sizeof(struct ti_i2c_desc)
-							+ rom_desc->Size;
+		start_address = start_address + sizeof(struct ti_i2c_desc) +
+						le16_to_cpu(rom_desc->Size);
 
 	} while ((start_address < TI_MAX_I2C_SIZE) && rom_desc->Type);
 
@@ -695,7 +710,7 @@ static int valid_csum(struct ti_i2c_desc
 	__u16 i;
 	__u8 cs = 0;
 
-	for (i = 0; i < rom_desc->Size; i++)
+	for (i = 0; i < le16_to_cpu(rom_desc->Size); i++)
 		cs = (__u8)(cs + buffer[i]);
 
 	if (cs != rom_desc->CheckSum) {
@@ -749,7 +764,7 @@ static int check_i2c_image(struct edgepo
 			break;
 
 		if ((start_address + sizeof(struct ti_i2c_desc) +
-					rom_desc->Size) > TI_MAX_I2C_SIZE) {
+			le16_to_cpu(rom_desc->Size)) > TI_MAX_I2C_SIZE) {
 			status = -ENODEV;
 			dbg("%s - structure too big, erroring out.", __func__);
 			break;
@@ -764,7 +779,8 @@ static int check_i2c_image(struct edgepo
 			/* Read the descriptor data */
 			status = read_rom(serial, start_address +
 						sizeof(struct ti_i2c_desc),
-						rom_desc->Size, buffer);
+						le16_to_cpu(rom_desc->Size),
+						buffer);
 			if (status)
 				break;
 
@@ -773,7 +789,7 @@ static int check_i2c_image(struct edgepo
 				break;
 		}
 		start_address = start_address + sizeof(struct ti_i2c_desc) +
-								rom_desc->Size;
+						le16_to_cpu(rom_desc->Size);
 
 	} while ((rom_desc->Type != I2C_DESC_TYPE_ION) &&
 				(start_address < TI_MAX_I2C_SIZE));
@@ -812,7 +828,7 @@ static int get_manuf_info(struct edgepor
 
 	/* Read the descriptor data */
 	status = read_rom(serial, start_address+sizeof(struct ti_i2c_desc),
-						rom_desc->Size, buffer);
+					le16_to_cpu(rom_desc->Size), buffer);
 	if (status)
 		goto exit;
 

