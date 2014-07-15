Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791AbaGOViw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:38:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54928 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933989AbaGOViq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:38:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 164/198] Bluetooth: Fix setting correct authentication information for SMP STK
Date: Tue, 15 Jul 2014 14:30:34 -0700
Message-Id: <1405459868-15089-165-git-send-email-kamal@canonical.com>
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

commit fff3490f47810e2d34b91fb9e31103e923b11c2f upstream.

When we store the STK in slave role we should set the correct
authentication information for it. If the pairing is producing a HIGH
security level the STK is considered authenticated, and otherwise it's
considered unauthenticated. This patch fixes the value passed to the
hci_add_ltk() function when adding the STK on the slave side.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Tested-by: Marcin Kraglak <marcin.kraglak@tieto.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bluetooth/smp.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 4b07acb..7e355bb 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -467,7 +467,7 @@ static void random_work(struct work_struct *work)
 		hci_le_start_enc(hcon, ediv, rand, stk);
 		hcon->enc_key_size = smp->enc_key_size;
 	} else {
-		u8 stk[16], r[16], rand[8];
+		u8 stk[16], r[16], rand[8], auth;
 		__le16 ediv;
 
 		memset(rand, 0, sizeof(rand));
@@ -482,8 +482,13 @@ static void random_work(struct work_struct *work)
 		memset(stk + smp->enc_key_size, 0,
 		       SMP_MAX_ENC_KEY_SIZE - smp->enc_key_size);
 
+		if (hcon->pending_sec_level == BT_SECURITY_HIGH)
+			auth = 1;
+		else
+			auth = 0;
+
 		hci_add_ltk(hcon->hdev, &hcon->dst, hcon->dst_type,
-			    HCI_SMP_STK_SLAVE, 0, 0, stk, smp->enc_key_size,
+			    HCI_SMP_STK_SLAVE, 0, auth, stk, smp->enc_key_size,
 			    ediv, rand);
 	}
 
-- 
1.9.1

