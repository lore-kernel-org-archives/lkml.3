Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbaGVWYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:24:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44545 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634AbaGVWYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:24:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 100/116] Bluetooth: Fix indicating discovery state when canceling inquiry
Date: Tue, 22 Jul 2014 15:21:51 -0700
Message-Id: <1406067727-19683-101-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

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
index 4d9e4b0..86cd8f5 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -55,6 +55,10 @@ static void hci_cc_inquiry_cancel(struct hci_dev *hdev, struct sk_buff *skb)
 
 	hci_req_complete(hdev, HCI_OP_INQUIRY_CANCEL, status);
 
+	hci_dev_lock(hdev);
+	hci_discovery_set_state(hdev, DISCOVERY_STOPPED);
+	hci_dev_unlock(hdev);
+
 	hci_conn_check_pending(hdev);
 }
 
-- 
1.9.1

