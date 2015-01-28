Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964958AbbA1FcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:32:23 -0500
Received: from mail.kernel.org ([198.145.29.136]:36837 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760502AbbA1EOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:14:03 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 009/177] Bluetooth: Fix setting correct security level when initiating SMP
Date: Wed, 28 Jan 2015 12:06:24 +0800
Message-Id: <1422418236-12852-17-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hedberg <johan.hedberg@intel.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 net/bluetooth/smp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 605156f..61e2494 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -325,8 +325,11 @@ static int tk_request(struct l2cap_conn *conn, u8 remote_oob, u8 auth,
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

