Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923AbaFLRep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:34:45 -0400
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:44471 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964868AbaFLRen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:34:43 -0400
Subject: [PATCH v2 1/2] rt2800usb:fix efuse detection
To: Ivo van Doorn <IvDoorn@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
From: Michael Braun <michael-dev@fami-braun.de>
Cc: netdev@vger.kernel.org, users@rt2x00.serialmonkey.com,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 12 Jun 2014 19:33:36 +0200
Message-ID: <20140612173336.15935.17359.stgit@charlie.fem.tu-ilmenau.de>
In-Reply-To: <20140612173057.15935.14194.stgit@charlie.fem.tu-ilmenau.de>
References: <20140612173057.15935.14194.stgit@charlie.fem.tu-ilmenau.de>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device 057c:8501 (AVM Fritz! WLAN v2 rev. B) currently does not
load. One thing observed is that the vendors driver detects EFUSE mode
for this device, but rt2800usb does not. This is due to rt2800usb
lacking a check for the firmware mode present in the vendors driver,
that this patch adopts for rt2800usb.

With this patch applied, the 'RF chipset' detection does no longer fail.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |   30 +++++++++++++++++++++++++++++-
 drivers/net/wireless/rt2x00/rt2x00usb.h |    1 +
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index a49c3d7..11583ca 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -229,6 +229,27 @@ static enum hrtimer_restart rt2800usb_tx_sta_fifo_timeout(struct hrtimer *timer)
 /*
  * Firmware functions
  */
+static int rt2800usb_autorun_detect(struct rt2x00_dev *rt2x00dev)
+{
+	__le32 reg;
+	u32 fw_mode;
+
+	/* cannot use rt2x00usb_register_read here as it uses different
+	 * mode (MULTI_READ vs. DEVICE_MODE) and does not pass the
+	 * magic value USB_MODE_AUTORUN (0x11) to the device, thus the
+	 * returned value would be invalid.
+	 */
+	rt2x00usb_vendor_request(rt2x00dev, USB_DEVICE_MODE,
+				 USB_VENDOR_REQUEST_IN, 0, USB_MODE_AUTORUN,
+				 &reg, sizeof(reg), REGISTER_TIMEOUT_FIRMWARE);
+	fw_mode = le32_to_cpu(reg);
+
+	if ((fw_mode & 0x00000003) == 2)
+		return 1;
+
+	return 0;
+}
+
 static char *rt2800usb_get_firmware_name(struct rt2x00_dev *rt2x00dev)
 {
 	return FIRMWARE_RT2870;
@@ -735,11 +756,18 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 /*
  * Device probe functions.
  */
+static int rt2800usb_efuse_detect(struct rt2x00_dev *rt2x00dev)
+{
+	if (rt2800usb_autorun_detect(rt2x00dev))
+		return 1;
+	return rt2800_efuse_detect(rt2x00dev);
+}
+
 static int rt2800usb_read_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
 
-	if (rt2800_efuse_detect(rt2x00dev))
+	if (rt2800usb_efuse_detect(rt2x00dev))
 		retval = rt2800_read_eeprom_efuse(rt2x00dev);
 	else
 		retval = rt2x00usb_eeprom_read(rt2x00dev, rt2x00dev->eeprom,
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
index e7bcf62..831b65f 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -93,6 +93,7 @@ enum rt2x00usb_mode_offset {
 	USB_MODE_SLEEP = 7,	/* RT73USB */
 	USB_MODE_FIRMWARE = 8,	/* RT73USB */
 	USB_MODE_WAKEUP = 9,	/* RT73USB */
+	USB_MODE_AUTORUN = 17, /* RT2800USB */
 };
 
 /**

