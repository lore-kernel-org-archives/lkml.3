Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805AbaGVWr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:47:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44521 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688AbaGVWXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:23:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 099/116] Bluetooth: Fix setting correct authentication information for SMP STK
Date: Tue, 22 Jul 2014 15:21:50 -0700
Message-Id: <1406067727-19683-100-git-send-email-kamal@canonical.com>
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

commit fff3490f47810e2d34b91fb9e31103e923b11c2f upstream.

When we store the STK in slave role we should set the correct
authentication information for it. If the pairing is producing a HIGH
security level the STK is considered authenticated, and otherwise it's
considered unauthenticated. This patch fixes the value passed to the
hci_add_ltk() function when adding the STK on the slave side.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Tested-by: Marcin Kraglak <marcin.kraglak@tieto.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
[ kamal: backport to 3.8-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bluetooth/smp.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 5abefb1..ba765a4 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -464,7 +464,7 @@ static void random_work(struct work_struct *work)
 		hci_le_start_enc(hcon, ediv, rand, stk);
 		hcon->enc_key_size = smp->enc_key_size;
 	} else {
-		u8 stk[16], r[16], rand[8];
+		u8 stk[16], r[16], rand[8], auth;
 		__le16 ediv;
 
 		memset(rand, 0, sizeof(rand));
@@ -479,8 +479,13 @@ static void random_work(struct work_struct *work)
 		memset(stk + smp->enc_key_size, 0,
 				SMP_MAX_ENC_KEY_SIZE - smp->enc_key_size);
 
+		if (hcon->pending_sec_level == BT_SECURITY_HIGH)
+			auth = 1;
+		else
+			auth = 0;
+
 		hci_add_ltk(hcon->hdev, conn->dst, hcon->dst_type,
-			    HCI_SMP_STK_SLAVE, 0, 0, stk, smp->enc_key_size,
+			    HCI_SMP_STK_SLAVE, 0, auth, stk, smp->enc_key_size,
 			    ediv, rand);
 	}
 
-- 
1.9.1

