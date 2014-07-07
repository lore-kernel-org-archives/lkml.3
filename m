Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbaGHBGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:06:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55249 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbaGGXyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcin Kraglak <marcin.kraglak@tieto.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.15 059/122] Bluetooth: Fix setting correct authentication information for SMP STK
Date: Mon,  7 Jul 2014 16:57:01 -0700
Message-Id: <20140707235736.041789995@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/smp.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -533,7 +533,7 @@ static void random_work(struct work_stru
 		hci_le_start_enc(hcon, ediv, rand, stk);
 		hcon->enc_key_size = smp->enc_key_size;
 	} else {
-		u8 stk[16];
+		u8 stk[16], auth;
 		__le64 rand = 0;
 		__le16 ediv = 0;
 
@@ -545,8 +545,13 @@ static void random_work(struct work_stru
 		memset(stk + smp->enc_key_size, 0,
 		       SMP_MAX_ENC_KEY_SIZE - smp->enc_key_size);
 
+		if (hcon->pending_sec_level == BT_SECURITY_HIGH)
+			auth = 1;
+		else
+			auth = 0;
+
 		hci_add_ltk(hcon->hdev, &hcon->dst, hcon->dst_type,
-			    HCI_SMP_STK_SLAVE, 0, stk, smp->enc_key_size,
+			    HCI_SMP_STK_SLAVE, auth, stk, smp->enc_key_size,
 			    ediv, rand);
 	}
 


