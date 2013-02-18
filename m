Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab3BRLjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 06:39:53 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53772 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab3BRLiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 06:38:15 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: linville@tuxdriver.com
Cc: sarah.a.sharp@linux.intel.com, dan.carpenter@oracle.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] net: wireless: orinoco: orinoco_usb.c: fix DMA buffers on stack
Date: Mon, 18 Feb 2013 03:37:44 -0800
Message-Id: <1361187464-24174-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an instance of DMA buffer on stack(being passed to
usb_control_msg) for the wireless USB version of the Agere Orinoco card driver.
It also fixes the missing audit for the return value of firmware download
routine. Found using smatch.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/net/wireless/orinoco/orinoco_usb.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index 01624dc..7744f42 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -804,10 +804,15 @@ static inline int ezusb_8051_cpucs(struct ezusb_priv *upriv, int reset)
 static int ezusb_firmware_download(struct ezusb_priv *upriv,
 				   struct ez_usb_fw *fw)
 {
-	u8 fw_buffer[FW_BUF_SIZE];
+	u8 *fw_buffer;
 	int retval, addr;
 	int variant_offset;
 
+	fw_buffer = kmalloc(FW_BUF_SIZE, GFP_KERNEL);
+	if (!fw_buffer) {
+		printk(KERN_ERR PFX "Out of memory for firmware buffer.\n");
+		return -ENOMEM;
+	}
 	/*
 	 * This byte is 1 and should be replaced with 0.  The offset is
 	 * 0x10AD in version 0.0.6.  The byte in question should follow
@@ -859,6 +864,7 @@ static int ezusb_firmware_download(struct ezusb_priv *upriv,
 	printk(KERN_ERR PFX "Firmware download failed, error %d\n",
 	       retval);
  exit:
+	kfree(fw_buffer);
 	return retval;
 }
 
@@ -1681,7 +1687,8 @@ static int ezusb_probe(struct usb_interface *interface,
 		firmware.code = fw_entry->data;
 	}
 	if (firmware.size && firmware.code) {
-		ezusb_firmware_download(upriv, &firmware);
+		if (ezusb_firmware_download(upriv, &firmware))
+			goto error;
 	} else {
 		err("No firmware to download");
 		goto error;
-- 
1.7.9.5

