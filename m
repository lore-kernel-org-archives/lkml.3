Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab3JKUcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:32:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758987Ab3JKTkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 065/110] Bluetooth: Fix rfkill functionality during the HCI setup stage
Date: Fri, 11 Oct 2013 12:38:45 -0700
Message-Id: <20131011193814.914062826@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit bf5430360ebe4b2d0c51d91f782e649107b502eb upstream.

We need to let the setup stage complete cleanly even when the HCI device
is rfkilled. Otherwise the HCI device will stay in an undefined state
and never get notified to user space through mgmt (even when it gets
unblocked through rfkill).

This patch makes sure that hci_dev_open() can be called in the HCI_SETUP
stage, that blocking the device doesn't abort the setup stage, and that
the device gets proper powered down as soon as the setup stage completes
in case it was blocked meanwhile.

The bug that this patch fixed can be very easily reproduced using e.g.
the rfkill command line too. By running "rfkill block all" before
inserting a Bluetooth dongle the resulting HCI device goes into a state
where it is never announced over mgmt, not even when "rfkill unblock all"
is run.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_core.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1123,7 +1123,11 @@ int hci_dev_open(__u16 dev)
 		goto done;
 	}
 
-	if (test_bit(HCI_RFKILLED, &hdev->dev_flags)) {
+	/* Check for rfkill but allow the HCI setup stage to proceed
+	 * (which in itself doesn't cause any RF activity).
+	 */
+	if (test_bit(HCI_RFKILLED, &hdev->dev_flags) &&
+	    !test_bit(HCI_SETUP, &hdev->dev_flags)) {
 		ret = -ERFKILL;
 		goto done;
 	}
@@ -1547,7 +1551,8 @@ static int hci_rfkill_set_block(void *da
 
 	if (blocked) {
 		set_bit(HCI_RFKILLED, &hdev->dev_flags);
-		hci_dev_do_close(hdev);
+		if (!test_bit(HCI_SETUP, &hdev->dev_flags))
+			hci_dev_do_close(hdev);
 	} else {
 		clear_bit(HCI_RFKILLED, &hdev->dev_flags);
 }
@@ -1572,9 +1577,13 @@ static void hci_power_on(struct work_str
 		return;
 	}
 
-	if (test_bit(HCI_AUTO_OFF, &hdev->dev_flags))
+	if (test_bit(HCI_RFKILLED, &hdev->dev_flags)) {
+		clear_bit(HCI_AUTO_OFF, &hdev->dev_flags);
+		hci_dev_do_close(hdev);
+	} else if (test_bit(HCI_AUTO_OFF, &hdev->dev_flags)) {
 		queue_delayed_work(hdev->req_workqueue, &hdev->power_off,
 				   HCI_AUTO_OFF_TIMEOUT);
+	}
 
 	if (test_and_clear_bit(HCI_SETUP, &hdev->dev_flags))
 		mgmt_index_added(hdev);


