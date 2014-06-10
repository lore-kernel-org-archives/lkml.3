Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbaFJUYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:24:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35152 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbaFJTuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:50:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 131/160] Bluetooth: Fix redundant encryption request for reauthentication
Date: Tue, 10 Jun 2014 12:46:11 -0700
Message-Id: <1402429600-20477-132-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit 09da1f3463eb81d59685df723b1c5950b7570340 upstream.

When we're performing reauthentication (in order to elevate the
security level from an unauthenticated key to an authenticated one) we
do not need to issue any encryption command once authentication
completes. Since the trigger for the encryption HCI command is the
ENCRYPT_PEND flag this flag should not be set in this scenario.
Instead, the REAUTH_PEND flag takes care of all necessary steps for
reauthentication.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bluetooth/hci_conn.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index ba5366c..9a6bc9d 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -752,14 +752,17 @@ static int hci_conn_auth(struct hci_conn *conn, __u8 sec_level, __u8 auth_type)
 	if (!test_and_set_bit(HCI_CONN_AUTH_PEND, &conn->flags)) {
 		struct hci_cp_auth_requested cp;
 
-		/* encrypt must be pending if auth is also pending */
-		set_bit(HCI_CONN_ENCRYPT_PEND, &conn->flags);
-
 		cp.handle = cpu_to_le16(conn->handle);
 		hci_send_cmd(conn->hdev, HCI_OP_AUTH_REQUESTED,
 			     sizeof(cp), &cp);
+
+		/* If we're already encrypted set the REAUTH_PEND flag,
+		 * otherwise set the ENCRYPT_PEND.
+		 */
 		if (conn->key_type != 0xff)
 			set_bit(HCI_CONN_REAUTH_PEND, &conn->flags);
+		else
+			set_bit(HCI_CONN_ENCRYPT_PEND, &conn->flags);
 	}
 
 	return 0;
-- 
1.9.1

