Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaBJCWa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:22:30 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39680 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbaBJCW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:22:28 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Gianluca Anzolin <gianluca@sottospazio.it>,
        Alexander Holler <holler@ahsoftware.de>,
        Andrey Vihrov <andrey.vihrov@gmail.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 03/24] Revert "Bluetooth: Move rfcomm_get_device() before rfcomm_dev_activate()"
Date: Sun,  9 Feb 2014 20:59:03 -0500
Message-Id: <1391997564-1805-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit e228b63390536f5b737056059a9a04ea016b1abf.

This is the third of a 3-patch revert, together with
Revert "Bluetooth: Remove rfcomm_carrier_raised()" and
Revert "Bluetooth: Always wait for a connection on RFCOMM open()".

Commit 4a2fb3ecc7467c775b154813861f25a0ddc11aa0,
"Bluetooth: Always wait for a connection on RFCOMM open()" open-codes
blocking on tty open(), rather than using the default behavior
implemented by the tty port.

The reasons for reverting that patch are detailed in that changelog;
this patch restores required functionality for that revert.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/bluetooth/rfcomm/tty.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 32ef9f9..a535ef1 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -103,22 +103,6 @@ static void rfcomm_dev_destruct(struct tty_port *port)
 	module_put(THIS_MODULE);
 }
 
-static struct device *rfcomm_get_device(struct rfcomm_dev *dev)
-{
-	struct hci_dev *hdev;
-	struct hci_conn *conn;
-
-	hdev = hci_get_route(&dev->dst, &dev->src);
-	if (!hdev)
-		return NULL;
-
-	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &dev->dst);
-
-	hci_dev_put(hdev);
-
-	return conn ? &conn->dev : NULL;
-}
-
 /* device-specific initialization: open the dlc */
 static int rfcomm_dev_activate(struct tty_port *port, struct tty_struct *tty)
 {
@@ -185,6 +169,22 @@ static struct rfcomm_dev *rfcomm_dev_get(int id)
 	return dev;
 }
 
+static struct device *rfcomm_get_device(struct rfcomm_dev *dev)
+{
+	struct hci_dev *hdev;
+	struct hci_conn *conn;
+
+	hdev = hci_get_route(&dev->dst, &dev->src);
+	if (!hdev)
+		return NULL;
+
+	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &dev->dst);
+
+	hci_dev_put(hdev);
+
+	return conn ? &conn->dev : NULL;
+}
+
 static ssize_t show_address(struct device *tty_dev, struct device_attribute *attr, char *buf)
 {
 	struct rfcomm_dev *dev = dev_get_drvdata(tty_dev);
-- 
1.8.1.2

