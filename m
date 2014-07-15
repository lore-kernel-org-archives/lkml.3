Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964829AbaGOVi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:38:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54946 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934006AbaGOVit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:38:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 165/198] Bluetooth: Fix indicating discovery state when canceling inquiry
Date: Tue, 15 Jul 2014 14:30:35 -0700
Message-Id: <1405459868-15089-166-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit 50143a433b70e3145bcf8a4a4e54f0c11bdee32b upstream.

When inquiry is canceled through the HCI_Cancel_Inquiry command there is
no Inquiry Complete event generated. Instead, all we get is the command
complete for the HCI_Inquiry_Cancel command. This means that we must
call the hci_discovery_set_state() function from the respective command
complete handler in order to ensure that user space knows the correct
discovery state.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bluetooth/hci_event.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index aeda116..fa88469 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -48,6 +48,10 @@ static void hci_cc_inquiry_cancel(struct hci_dev *hdev, struct sk_buff *skb)
 	smp_mb__after_clear_bit(); /* wake_up_bit advises about this barrier */
 	wake_up_bit(&hdev->flags, HCI_INQUIRY);
 
+	hci_dev_lock(hdev);
+	hci_discovery_set_state(hdev, DISCOVERY_STOPPED);
+	hci_dev_unlock(hdev);
+
 	hci_conn_check_pending(hdev);
 }
 
-- 
1.9.1

