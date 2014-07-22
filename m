Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319AbaGVWsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:48:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44500 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932635AbaGVWXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:23:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 101/116] Bluetooth: Fix locking of hdev when calling into SMP code
Date: Tue, 22 Jul 2014 15:21:52 -0700
Message-Id: <1406067727-19683-102-git-send-email-kamal@canonical.com>
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

commit c73f94b8c093a615ce80eabbde0ac6eb9abfe31a upstream.

The SMP code expects hdev to be unlocked since e.g. crypto functions
will try to (re)lock it. Therefore, we need to release the lock before
calling into smp.c from mgmt.c. Without this we risk a deadlock whenever
the smp_user_confirm_reply() function is called.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Tested-by: Lukasz Rymanowski <lukasz.rymanowski@tieto.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bluetooth/mgmt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index d8ba861..e470516 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2048,8 +2048,13 @@ static int user_pairing_resp(struct sock *sk, struct hci_dev *hdev,
 	}
 
 	if (type == BDADDR_LE_PUBLIC || type == BDADDR_LE_RANDOM) {
-		/* Continue with pairing via SMP */
+		/* Continue with pairing via SMP. The hdev lock must be
+		 * released as SMP may try to recquire it for crypto
+		 * purposes.
+		 */
+		hci_dev_unlock(hdev);
 		err = smp_user_confirm_reply(conn, mgmt_op, passkey);
+		hci_dev_lock(hdev);
 
 		if (!err)
 			err = cmd_status(sk, hdev->id, mgmt_op,
-- 
1.9.1

