Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030729AbaGRNL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:11:59 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17595 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030711AbaGRNL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:11:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 089/170] Bluetooth: Fix indicating discovery state when canceling inquiry
Date: Fri, 18 Jul 2014 14:11:34 +0200
Message-Id: <634cf9cfd93db62d56afd3b70ef12331d200c523.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hedberg <johan.hedberg@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 50143a433b70e3145bcf8a4a4e54f0c11bdee32b upstream.

When inquiry is canceled through the HCI_Cancel_Inquiry command there is
no Inquiry Complete event generated. Instead, all we get is the command
complete for the HCI_Inquiry_Cancel command. This means that we must
call the hci_discovery_set_state() function from the respective command
complete handler in order to ensure that user space knows the correct
discovery state.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/bluetooth/hci_event.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index b093ef858e1f..729f516ecd63 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -47,6 +47,10 @@ static void hci_cc_inquiry_cancel(struct hci_dev *hdev, struct sk_buff *skb)
 	smp_mb__after_clear_bit(); /* wake_up_bit advises about this barrier */
 	wake_up_bit(&hdev->flags, HCI_INQUIRY);
 
+	hci_dev_lock(hdev);
+	hci_discovery_set_state(hdev, DISCOVERY_STOPPED);
+	hci_dev_unlock(hdev);
+
 	hci_conn_check_pending(hdev);
 }
 
-- 
2.0.0

