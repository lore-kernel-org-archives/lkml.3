Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967312AbaFQWRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:17:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54512 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966731AbaFQVvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ludovic Drolez <ldrolez@debian.org>, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 191/212] USB: io_ti: fix firmware download on big-endian machines (part 2)
Date: Tue, 17 Jun 2014 14:44:45 -0700
Message-Id: <1403041506-13646-192-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/io_ti.c      | 2 +-
 drivers/usb/serial/io_usbvend.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 1c7bc52..0385bc4 100644
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
index 51f83fb..6f6a856 100644
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
1.9.1

