Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934094AbaFQQY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:24:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50820 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933997AbaFQQYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:24:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 106/121] Bluetooth: Fix triggering BR/EDR L2CAP Connect too early
Date: Tue, 17 Jun 2014 09:18:04 -0700
Message-Id: <1403021899-16708-79-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021899-16708-2-git-send-email-kamal@canonical.com>
References: <1403021899-16708-2-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit 9eb1fbfa0a737fd4d3a6d12d71c5ea9af622b887 upstream.

Commit 1c2e004183178 introduced an event handler for the encryption key
refresh complete event with the intent of fixing some LE/SMP cases.
However, this event is shared with BR/EDR and there we actually want to
act only on the auth_complete event (which comes after the key refresh).

If we do not do this we may trigger an L2CAP Connect Request too early
and cause the remote side to return a security block error.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bluetooth/hci_event.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index b719a83..ba6f399 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3406,6 +3406,12 @@ static void hci_key_refresh_complete_evt(struct hci_dev *hdev,
 	if (!conn)
 		goto unlock;
 
+	/* For BR/EDR the necessary steps are taken through the
+	 * auth_complete event.
+	 */
+	if (conn->type != LE_LINK)
+		goto unlock;
+
 	if (!ev->status)
 		conn->sec_level = conn->pending_sec_level;
 
-- 
1.9.1

