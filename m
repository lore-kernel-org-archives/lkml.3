Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964968AbaFLRes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:34:48 -0400
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:58263 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964867AbaFLRem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:34:42 -0400
Subject: [PATCH v2 2/2] rt2800usb:fix hang during firmware load
To: Ivo van Doorn <IvDoorn@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
From: Michael Braun <michael-dev@fami-braun.de>
Cc: netdev@vger.kernel.org, users@rt2x00.serialmonkey.com,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 12 Jun 2014 19:33:41 +0200
Message-ID: <20140612173341.15935.7058.stgit@charlie.fem.tu-ilmenau.de>
In-Reply-To: <20140612173057.15935.14194.stgit@charlie.fem.tu-ilmenau.de>
References: <20140612173057.15935.14194.stgit@charlie.fem.tu-ilmenau.de>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device 057c:8501 (AVM Fritz! WLAN v2 rev. B) boots into a state that does
not actually require loading a firmware file. The vendors driver finds out
about this by checking a firmware state register, so this patch adds this here.

Finally, with this patch applied, my wifi dongle actually becomes
useful (scan + connect to wpa network works).

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 11583ca..e11dab2 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -278,8 +278,13 @@ static int rt2800usb_write_firmware(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Write firmware to device.
 	 */
-	rt2x00usb_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
-				      data + offset, length);
+	if (rt2800usb_autorun_detect(rt2x00dev)) {
+		rt2x00_info(rt2x00dev,
+			    "Firmware loading not required - NIC in AutoRun mode\n");
+	} else {
+		rt2x00usb_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
+					      data + offset, length);
+	}
 
 	rt2x00usb_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
 	rt2x00usb_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);

