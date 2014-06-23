Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbaFWJEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:04:11 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55472 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Ludovic Drolez <ldrolez@debian.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 052/111] USB: io_ti: fix firmware download on big-endian machines (part 2)
Date: Mon, 23 Jun 2014 10:31:27 +0200
Message-Id: <130f4c5a1899ca488a2c501311d9f5a746330f32.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c03890ff5e24a4bf59059f2d179f427559b7330a upstream.

A recent patch that purported to fix firmware download on big-endian
machines failed to add the corresponding sparse annotation to the
i2c-header. This was reported by the kbuild test robot.

Adding the appropriate annotation revealed another endianess bug related
to the i2c-header Size-field in a code path that is exercised when the
firmware is actually being downloaded (and not just verified and left
untouched unless older than the firmware at hand).

This patch adds the required sparse annotation to the i2c-header and
makes sure that the Size-field is sent in little-endian byte order
during firmware download also on big-endian machines.

Note that this patch is only compile-tested, but that there is no
functional change for little-endian systems.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Ludovic Drolez <ldrolez@debian.org>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/serial/io_ti.c      | 2 +-
 drivers/usb/serial/io_usbvend.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 1c7bc5249cc1..0385bc4efefa 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -832,7 +832,7 @@ static int build_i2c_fw_hdr(__u8 *header, struct device *dev)
 	firmware_rec =  (struct ti_i2c_firmware_rec*)i2c_header->Data;
 
 	i2c_header->Type	= I2C_DESC_TYPE_FIRMWARE_BLANK;
-	i2c_header->Size	= (__u16)buffer_size;
+	i2c_header->Size	= cpu_to_le16(buffer_size);
 	i2c_header->CheckSum	= cs;
 	firmware_rec->Ver_Major	= OperationalMajorVersion;
 	firmware_rec->Ver_Minor	= OperationalMinorVersion;
diff --git a/drivers/usb/serial/io_usbvend.h b/drivers/usb/serial/io_usbvend.h
index 51f83fbb73bb..6f6a856bc37c 100644
--- a/drivers/usb/serial/io_usbvend.h
+++ b/drivers/usb/serial/io_usbvend.h
@@ -594,7 +594,7 @@ struct edge_boot_descriptor {
 
 struct ti_i2c_desc {
 	__u8	Type;			// Type of descriptor
-	__u16	Size;			// Size of data only not including header
+	__le16	Size;			// Size of data only not including header
 	__u8	CheckSum;		// Checksum (8 bit sum of data only)
 	__u8	Data[0];		// Data starts here
 } __attribute__((packed));
-- 
2.0.0

