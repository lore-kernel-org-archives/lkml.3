Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab3JKTmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:42:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab3JKTl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 079/135] Bluetooth: Introduce a new HCI_RFKILLED flag
Date: Fri, 11 Oct 2013 12:39:20 -0700
Message-Id: <20131011193953.853975831@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/bluetooth/hci.h |    1 +
 net/bluetooth/hci_core.c    |   15 ++++++++++-----
 2 files changed, 11 insertions(+), 5 deletions(-)

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
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1134,7 +1134,7 @@ int hci_dev_open(__u16 dev)
 		goto done;
 	}
 
-	if (hdev->rfkill && rfkill_blocked(hdev->rfkill)) {
+	if (test_bit(HCI_RFKILLED, &hdev->dev_flags)) {
 		ret = -ERFKILL;
 		goto done;
 	}
@@ -1554,10 +1554,12 @@ static int hci_rfkill_set_block(void *da
 
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
@@ -2197,6 +2199,9 @@ int hci_register_dev(struct hci_dev *hde
 		}
 	}
 
+	if (hdev->rfkill && rfkill_blocked(hdev->rfkill))
+		set_bit(HCI_RFKILLED, &hdev->dev_flags);
+
 	set_bit(HCI_SETUP, &hdev->dev_flags);
 
 	if (hdev->dev_type != HCI_AMP)


