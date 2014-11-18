Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbaKRPVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:21:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875AbaKROJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:28 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 024/206] Bluetooth: Handle Intel USB bootloader with buggy interrupt
Date: Tue, 18 Nov 2014 15:06:19 +0100
Message-Id: <35aaf24b19442db101a7fe7dbc9030a12203e3fa.1416319692.git.jslaby@suse.cz>
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

commit 3a5ef20c979c0f33b6fb2582d04957397a6bf51f upstream.

The interrupt interface for the Intel USB bootloader devices is only
enabled after receiving SetInterface(0, AltSetting=0). When this USB
command is not send, then no HCI events will be received.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/bluetooth/btusb.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 4e86b93b90f0..27dd68362639 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1495,6 +1495,18 @@ static int btusb_probe(struct usb_interface *intf,
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

