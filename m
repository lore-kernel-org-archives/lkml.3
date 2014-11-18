Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbaKROMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:12:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158AbaKROKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:33 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 027/206] Bluetooth: Fix endian and alignment issue with ath3k version handling
Date: Tue, 18 Nov 2014 15:06:22 +0100
Message-Id: <6ac01731d51012e9faa8875c0b4437bc0ccd51c7.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 72dd2b2a44d82118714e0821fa16c65f9e40eb00 upstream.

The ath3k driver is treating the version information badly when it
comes to loading the right firmware version and comparing that it
actually matches with the hardware.

Initially this showed up as this:

  CHECK   drivers/bluetooth/ath3k.c
drivers/bluetooth/ath3k.c:373:17: warning: cast to restricted __le32
drivers/bluetooth/ath3k.c:435:17: warning: cast to restricted __le32

However when fixing this by actually using __packed and __le32 for
the ath3_version structure, more issues came up:

  CHECK   drivers/bluetooth/ath3k.c
drivers/bluetooth/ath3k.c:381:32: warning: incorrect type in assignment (different base types)
drivers/bluetooth/ath3k.c:381:32:    expected restricted __le32 [usertype] rom_version
drivers/bluetooth/ath3k.c:381:32:    got int [signed] <noident>
drivers/bluetooth/ath3k.c:382:34: warning: incorrect type in assignment (different base types)
drivers/bluetooth/ath3k.c:382:34:    expected restricted __le32 [usertype] build_version
drivers/bluetooth/ath3k.c:382:34:    got int [signed] <noident>
drivers/bluetooth/ath3k.c:386:28: warning: restricted __le32 degrades to integer
drivers/bluetooth/ath3k.c:386:56: warning: restricted __le32 degrades to integer

This patch fixes every instance of the firmware version handling and
makes sure it is endian safe and uses proper unaligned access.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/bluetooth/ath3k.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index ed48ce54278c..c7ea25618f34 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -27,6 +27,7 @@
 #include <linux/device.h>
 #include <linux/firmware.h>
 #include <linux/usb.h>
+#include <asm/unaligned.h>
 #include <net/bluetooth/bluetooth.h>
 
 #define VERSION "1.0"
@@ -50,12 +51,12 @@
 #define ATH3K_NAME_LEN				0xFF
 
 struct ath3k_version {
-	unsigned int	rom_version;
-	unsigned int	build_version;
-	unsigned int	ram_version;
-	unsigned char	ref_clock;
-	unsigned char	reserved[0x07];
-};
+	__le32	rom_version;
+	__le32	build_version;
+	__le32	ram_version;
+	__u8	ref_clock;
+	__u8	reserved[7];
+} __packed;
 
 static struct usb_device_id ath3k_table[] = {
 	/* Atheros AR3011 */
@@ -335,7 +336,8 @@ static int ath3k_load_patch(struct usb_device *udev)
 	unsigned char fw_state;
 	char filename[ATH3K_NAME_LEN] = {0};
 	const struct firmware *firmware;
-	struct ath3k_version fw_version, pt_version;
+	struct ath3k_version fw_version;
+	__u32 pt_rom_version, pt_build_version;
 	int ret;
 
 	ret = ath3k_get_state(udev, &fw_state);
@@ -356,7 +358,7 @@ static int ath3k_load_patch(struct usb_device *udev)
 	}
 
 	snprintf(filename, ATH3K_NAME_LEN, "ar3k/AthrBT_0x%08x.dfu",
-		le32_to_cpu(fw_version.rom_version));
+		 le32_to_cpu(fw_version.rom_version));
 
 	ret = request_firmware(&firmware, filename, &udev->dev);
 	if (ret < 0) {
@@ -364,12 +366,13 @@ static int ath3k_load_patch(struct usb_device *udev)
 		return ret;
 	}
 
-	pt_version.rom_version = *(int *)(firmware->data + firmware->size - 8);
-	pt_version.build_version = *(int *)
-		(firmware->data + firmware->size - 4);
+	pt_rom_version = get_unaligned_le32(firmware->data +
+					    firmware->size - 8);
+	pt_build_version = get_unaligned_le32(firmware->data +
+					      firmware->size - 4);
 
-	if ((pt_version.rom_version != fw_version.rom_version) ||
-		(pt_version.build_version <= fw_version.build_version)) {
+	if (pt_rom_version != le32_to_cpu(fw_version.rom_version) ||
+	    pt_build_version <= le32_to_cpu(fw_version.build_version)) {
 		BT_ERR("Patch file version did not match with firmware");
 		release_firmware(firmware);
 		return -EINVAL;
-- 
2.1.3

