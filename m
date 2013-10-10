Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab3JJPsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:48:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52853 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab3JJPsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:48:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hedberg <johan.hedberg@intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 085/104] Bluetooth: Introduce a new HCI_RFKILLED flag
Date: Thu, 10 Oct 2013 08:42:13 -0700
Message-Id: <1381419752-29733-86-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit 5e130367d43ff22836bbae380d197d600fe8ddbb upstream.

This makes it more convenient to check for rfkill (no need to check for
dev->rfkill before calling rfkill_blocked()) and also avoids potential
races if the RFKILL state needs to be checked from within the rfkill
callback.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/net/bluetooth/hci.h |  1 +
 net/bluetooth/hci_core.c    | 15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 45eee08..5fb3600 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -104,6 +104,7 @@ enum {
 enum {
 	HCI_SETUP,
 	HCI_AUTO_OFF,
+	HCI_RFKILLED,
 	HCI_MGMT,
 	HCI_PAIRABLE,
 	HCI_SERVICE_CACHE,
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 7a1dd72..916fc10 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -709,7 +709,7 @@ int hci_dev_open(__u16 dev)
 		goto done;
 	}
 
-	if (hdev->rfkill && rfkill_blocked(hdev->rfkill)) {
+	if (test_bit(HCI_RFKILLED, &hdev->dev_flags)) {
 		ret = -ERFKILL;
 		goto done;
 	}
@@ -1124,10 +1124,12 @@ static int hci_rfkill_set_block(void *data, bool blocked)
 
 	BT_DBG("%p name %s blocked %d", hdev, hdev->name, blocked);
 
-	if (!blocked)
-		return 0;
-
-	hci_dev_do_close(hdev);
+	if (blocked) {
+		set_bit(HCI_RFKILLED, &hdev->dev_flags);
+		hci_dev_do_close(hdev);
+	} else {
+		clear_bit(HCI_RFKILLED, &hdev->dev_flags);
+}
 
 	return 0;
 }
@@ -1817,6 +1819,9 @@ int hci_register_dev(struct hci_dev *hdev)
 		}
 	}
 
+	if (hdev->rfkill && rfkill_blocked(hdev->rfkill))
+		set_bit(HCI_RFKILLED, &hdev->dev_flags);
+
 	set_bit(HCI_SETUP, &hdev->dev_flags);
 
 	if (hdev->dev_type != HCI_AMP)
-- 
1.8.1.2

