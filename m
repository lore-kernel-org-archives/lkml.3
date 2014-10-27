Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaJ0T1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:27:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52415 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaJ0S5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:57:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 019/105] Bluetooth: Fix setting correct security level when initiating SMP
Date: Mon, 27 Oct 2014 11:55:54 -0700
Message-Id: <1414436240-13879-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit 5eb596f55cacc2389554a8d7572d90d5e9d4269d upstream.

We can only determine the final security level when both pairing request
and response have been exchanged. When initiating pairing the starting
target security level is set to MEDIUM unless explicitly specified to be
HIGH, so that we can still perform pairing even if the remote doesn't
have MITM capabilities. However, once we've received the pairing
response we should re-consult the remote and local IO capabilities and
upgrade the target security level if necessary.

Without this patch the resulting Long Term Key will occasionally be
reported to be unauthenticated when it in reality is an authenticated
one.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bluetooth/smp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 7e355bb..cd52609 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -326,8 +326,11 @@ static int tk_request(struct l2cap_conn *conn, u8 remote_oob, u8 auth,
 	}
 
 	/* Not Just Works/Confirm results in MITM Authentication */
-	if (method != JUST_CFM)
+	if (method != JUST_CFM) {
 		set_bit(SMP_FLAG_MITM_AUTH, &smp->smp_flags);
+		if (hcon->pending_sec_level < BT_SECURITY_HIGH)
+			hcon->pending_sec_level = BT_SECURITY_HIGH;
+	}
 
 	/* If both devices have Keyoard-Display I/O, the master
 	 * Confirms and the slave Enters the passkey.
-- 
1.9.1

