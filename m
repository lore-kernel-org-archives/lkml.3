Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3GAUoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:44:17 -0400
Received: from mail.ispras.ru ([83.149.199.45]:59373 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818Ab3GAUoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:44:16 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] ath9k_htc: fix data race between request_firmware_nowait() callback and suspend()
Date: Tue,  2 Jul 2013 00:43:42 +0400
Message-Id: <1372711422-4604-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ath9k_hif_usb_probe() requests firmware asynchronically and
there is some initialization postponed till firmware is ready.
In particular, ath9k_hif_usb_firmware_cb() callback initializes
hif_dev->tx.tx_buf and hif_dev->tx.tx_pending lists.

At the same time, ath9k_hif_usb_suspend() iterates that lists through
ath9k_hif_usb_dealloc_urbs(). If suspend happens before request_firmware_nowait()
callback is called, it can lead to oops.

Similar issue could be in ath9k_hif_usb_disconnect(), but it is prevented
using hif_dev->fw_done completion and HIF_USB_READY flag. The patch extends
this approach to suspend() as well.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index f5dda84..fcd9aa5 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1076,7 +1076,7 @@ static void ath9k_hif_usb_firmware_fail(struct hif_device_usb *hif_dev)
 	struct device *dev = &hif_dev->udev->dev;
 	struct device *parent = dev->parent;
 
-	complete(&hif_dev->fw_done);
+	complete_all(&hif_dev->fw_done);
 
 	if (parent)
 		device_lock(parent);
@@ -1125,7 +1125,7 @@ static void ath9k_hif_usb_firmware_cb(const struct firmware *fw, void *context)
 
 	release_firmware(fw);
 	hif_dev->flags |= HIF_USB_READY;
-	complete(&hif_dev->fw_done);
+	complete_all(&hif_dev->fw_done);
 
 	return;
 
@@ -1310,7 +1310,10 @@ static int ath9k_hif_usb_suspend(struct usb_interface *interface,
 	if (!(hif_dev->flags & HIF_USB_START))
 		ath9k_htc_suspend(hif_dev->htc_handle);
 
-	ath9k_hif_usb_dealloc_urbs(hif_dev);
+	wait_for_completion(&hif_dev->fw_done);
+
+	if (hif_dev->flags & HIF_USB_READY)
+		ath9k_hif_usb_dealloc_urbs(hif_dev);
 
 	return 0;
 }
-- 
1.8.1.2

