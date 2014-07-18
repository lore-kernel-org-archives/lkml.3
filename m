Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030499AbaGRNKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:10:17 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17484 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761196AbaGRNKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:10:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 090/170] Bluetooth: Fix locking of hdev when calling into SMP code
Date: Fri, 18 Jul 2014 14:11:35 +0200
Message-Id: <2a4de70a275f0f2af6d64b1e41c7a052563c8a40.1405685481.git.jslaby@suse.cz>
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

commit c73f94b8c093a615ce80eabbde0ac6eb9abfe31a upstream.

The SMP code expects hdev to be unlocked since e.g. crypto functions
will try to (re)lock it. Therefore, we need to release the lock before
calling into smp.c from mgmt.c. Without this we risk a deadlock whenever
the smp_user_confirm_reply() function is called.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Tested-by: Lukasz Rymanowski <lukasz.rymanowski@tieto.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/bluetooth/mgmt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index fedc5399d465..211fffb5dca8 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2319,8 +2319,13 @@ static int user_pairing_resp(struct sock *sk, struct hci_dev *hdev,
 	}
 
 	if (addr->type == BDADDR_LE_PUBLIC || addr->type == BDADDR_LE_RANDOM) {
-		/* Continue with pairing via SMP */
+		/* Continue with pairing via SMP. The hdev lock must be
+		 * released as SMP may try to recquire it for crypto
+		 * purposes.
+		 */
+		hci_dev_unlock(hdev);
 		err = smp_user_confirm_reply(conn, mgmt_op, passkey);
+		hci_dev_lock(hdev);
 
 		if (!err)
 			err = cmd_complete(sk, hdev->id, mgmt_op,
-- 
2.0.0

