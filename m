Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaLOPDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:03:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38472 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaLOO1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 059/168] Bluetooth: Handle Intel USB bootloader with buggy interrupt
Date: Mon, 15 Dec 2014 14:25:13 +0000
Message-Id: <1418653622-21105-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcel Holtmann <marcel@holtmann.org>

commit 3a5ef20c979c0f33b6fb2582d04957397a6bf51f upstream.

The interrupt interface for the Intel USB bootloader devices is only
enabled after receiving SetInterface(0, AltSetting=0). When this USB
command is not send, then no HCI events will be received.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/bluetooth/btusb.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 1db4a6675151..9c63e20a46a4 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1699,6 +1699,18 @@ static int btusb_probe(struct usb_interface *intf,
 		data->isoc = NULL;
 	}
 
+	if (id->driver_info & BTUSB_INTEL_BOOT) {
+		/* A bug in the bootloader causes that interrupt interface is
+		 * only enabled after receiving SetInterface(0, AltSetting=0).
+		 */
+		err = usb_set_interface(data->udev, 0, 0);
+		if (err < 0) {
+			BT_ERR("failed to set interface 0, alt 0 %d", err);
+			hci_free_dev(hdev);
+			return err;
+		}
+	}
+
 	if (data->isoc) {
 		err = usb_driver_claim_interface(&btusb_driver,
 							data->isoc, data);
-- 
2.1.3

