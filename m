Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaBJCUS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:20:18 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39574 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbaBJCUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:20:13 -0500
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
Subject: [PATCH 15/24] Bluetooth: Fix unsafe RFCOMM device parenting
Date: Sun,  9 Feb 2014 20:59:15 -0500
Message-Id: <1391997564-1805-16-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accessing the results of hci_conn_hash_lookup_ba() is unsafe without
holding the hci_dev_lock() during the lookup. For example:

CPU 0                             | CPU 1
hci_conn_hash_lookup_ba           | hci_conn_del
  rcu_read_lock                   |   hci_conn_hash_del
  list_for_each_entry_rcu         |     list_del_rcu
    if (.....)                    |       synchronize_rcu
      rcu_read_unlock             |
                                  |   hci_conn_del_sysfs
                                  |   hci_dev_put
                                  |   hci_conn_put
                                  |     put_device (last reference)
                                  |       bt_link_release
                                  |         kfree(conn)
      return p  << just freed     |

Even if a hci_conn reference were taken (via hci_conn_get), would
not guarantee the lifetime of the sysfs device, but only safe
access to the in-memory structure.

Ensure the hci_conn device stays valid while the rfcomm device
is reparented; rename rfcomm_get_device() to rfcomm_reparent_device()
and perform the reparenting within the function while holding the
hci_dev_lock.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/bluetooth/rfcomm/tty.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index a58d693..2975bc4 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -167,20 +167,29 @@ static struct rfcomm_dev *rfcomm_dev_get(int id)
 	return dev;
 }
 
-static struct device *rfcomm_get_device(struct rfcomm_dev *dev)
+static void rfcomm_reparent_device(struct rfcomm_dev *dev)
 {
 	struct hci_dev *hdev;
 	struct hci_conn *conn;
 
 	hdev = hci_get_route(&dev->dst, &dev->src);
 	if (!hdev)
-		return NULL;
+		return;
 
+	/* The lookup results are unsafe to access without the
+	 * hci device lock (FIXME: why is this not documented?)
+	 */
+	hci_dev_lock(hdev);
 	conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &dev->dst);
 
-	hci_dev_put(hdev);
+	/* Just because the acl link is in the hash table is no
+	 * guarantee the sysfs device has been added ...
+	 */
+	if (conn && device_is_registered(&conn->dev))
+		device_move(dev->tty_dev, &conn->dev, DPM_ORDER_DEV_AFTER_PARENT);
 
-	return conn ? &conn->dev : NULL;
+	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
 }
 
 static ssize_t show_address(struct device *tty_dev, struct device_attribute *attr, char *buf)
@@ -589,8 +598,7 @@ static void rfcomm_dev_state_change(struct rfcomm_dlc *dlc, int err)
 
 	dev->err = err;
 	if (dlc->state == BT_CONNECTED) {
-		device_move(dev->tty_dev, rfcomm_get_device(dev),
-			    DPM_ORDER_DEV_AFTER_PARENT);
+		rfcomm_reparent_device(dev);
 
 		wake_up_interruptible(&dev->port.open_wait);
 	} else if (dlc->state == BT_CLOSED)
-- 
1.8.1.2

