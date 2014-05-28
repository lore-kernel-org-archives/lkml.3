Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaE1F5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 01:57:40 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:58376 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaE1F5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 01:57:38 -0400
From: Kiran Kumar Raparthy <kiran.kumar@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: "hyungseoung.yoo" <hyungseoung.yoo@samsung.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth@vger.kernel.org (open list:BLUETOOTH SUBSYSTEM),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Jaikumar Ganesh <jaikumarg@android.com>,
        Kiran Raparthy <kiran.kumar@linaro.org>
Subject: [RFC] Bluetooth: Keep master role when SCO or eSCO is active
Date: Wed, 28 May 2014 11:26:28 +0530
Message-Id: <1401256588-1467-1-git-send-email-kiran.kumar@linaro.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "hyungseoung.yoo" <hyungseoung.yoo@samsung.com>

Preserve the master role when SCO or eSCO is active
as this improves compatability with lots of
headset and chipset combinations.

This is one of the number of patches from the Android AOSP
common.git tree, which is used on almost all Android devices.
It looks like it would improve support for compatibility with
lot of headset,so I wanted to submit it for review to see
if it should go upstream.

Cc: Marcel Holtmann <marcel@holtmann.org> (maintainer:BLUETOOTH SUBSYSTEM)
Cc: Gustavo Padovan <gustavo@padovan.org> (maintainer:BLUETOOTH SUBSYSTEM)
Cc: Johan Hedberg <johan.hedberg@gmail.com> (maintainer:BLUETOOTH SUBSYSTEM)
Cc: "David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING [GENERAL])
Cc: linux-bluetooth@vger.kernel.org (open list:BLUETOOTH SUBSYSTEM)
Cc: netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Cc: linux-kernel@vger.kernel.org (open list)
Cc: Android Kernel Team <kernel-team@android.com>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: hyungseoung.yoo <hyungseoung.yoo@samsung.com>
Signed-off-by: Jaikumar Ganesh <jaikumarg@android.com>
[kiran: Added context to commit message]
Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
---
 net/bluetooth/hci_event.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 15010a2..6f944d5 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1915,6 +1915,15 @@ unlock:
 	hci_conn_check_pending(hdev);
 }
 
+static inline bool is_sco_active(struct hci_dev *hdev)
+{
+	if (hci_conn_hash_lookup_state(hdev, SCO_LINK, BT_CONNECTED) ||
+			(hci_conn_hash_lookup_state(hdev, ESCO_LINK,
+						    BT_CONNECTED)))
+		return true;
+	return false;
+}
+
 static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct hci_ev_conn_request *ev = (void *) skb->data;
@@ -1961,7 +1970,8 @@ static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 			bacpy(&cp.bdaddr, &ev->bdaddr);
 
-			if (lmp_rswitch_capable(hdev) && (mask & HCI_LM_MASTER))
+			if (lmp_rswitch_capable(hdev) && ((mask & HCI_LM_MASTER)
+						|| is_sco_active(hdev)))
 				cp.role = 0x00; /* Become master */
 			else
 				cp.role = 0x01; /* Remain slave */
-- 
1.8.2.1

