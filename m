Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaFAR7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 13:59:44 -0400
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:49585 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaFAR7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 13:59:42 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Jun 2014 13:59:41 EDT
Subject: [PATCH 1/2] rt2800usb:fix efuse detection
To: Ivo van Doorn <IvDoorn@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
From: Michael Braun <michael-dev@fami-braun.de>
Cc: netdev@vger.kernel.org, users@rt2x00.serialmonkey.com,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 01 Jun 2014 19:52:47 +0200
Message-ID: <20140601175247.7980.2461.stgit@charlie.fem.tu-ilmenau.de>
In-Reply-To: <20140601174736.7980.18330.stgit@charlie.fem.tu-ilmenau.de>
References: <20140601174736.7980.18330.stgit@charlie.fem.tu-ilmenau.de>
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
 drivers/net/wireless/rt2x00/rt2800usb.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index a49c3d7..b601422 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -735,11 +735,25 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 /*
  * Device probe functions.
  */
+static int rt2800usb_efuse_detect(struct rt2x00_dev *rt2x00dev)
+{
+	__le32 fwMode;
+
+	rt2x00usb_vendor_request(rt2x00dev, USB_DEVICE_MODE,
+				 USB_VENDOR_REQUEST_IN, 0, 0x11, &fwMode,
+				 sizeof(fwMode), REGISTER_TIMEOUT_FIRMWARE);
+
+	if ((fwMode & 0x00000003) == 2)
+		return 1;
+
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

