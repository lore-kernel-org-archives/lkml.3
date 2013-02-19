Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934587Ab3BSTMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:12:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54240 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934043Ab3BSSvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:51:25 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hedberg <johan.hedberg@intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 23/81] Bluetooth: Fix handling of unexpected SMP PDUs
Date: Tue, 19 Feb 2013 15:48:46 -0300
Message-Id: <1361299784-8830-24-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit 8cf9fa1240229cbdd888236c0c43fcbad680cf00 upstream.

The conn->smp_chan pointer can be NULL if SMP PDUs arrive at unexpected
moments. To avoid NULL pointer dereferences the code should be checking
for this and disconnect if an unexpected SMP PDU arrives. This patch
fixes the issue by adding a check for conn->smp_chan for all other PDUs
except pairing request and security request (which are are the first
PDUs to come to initialize the SMP context).

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Acked-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/bluetooth/smp.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 22fe004..9c97f7a 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -855,6 +855,19 @@ int smp_sig_channel(struct l2cap_conn *conn, struct sk_buff *skb)
 
 	skb_pull(skb, sizeof(code));
 
+	/*
+	 * The SMP context must be initialized for all other PDUs except
+	 * pairing and security requests. If we get any other PDU when
+	 * not initialized simply disconnect (done if this function
+	 * returns an error).
+	 */
+	if (code != SMP_CMD_PAIRING_REQ && code != SMP_CMD_SECURITY_REQ &&
+	    !conn->smp_chan) {
+		BT_ERR("Unexpected SMP command 0x%02x. Disconnecting.", code);
+		kfree_skb(skb);
+		return -ENOTSUPP;
+	}
+
 	switch (code) {
 	case SMP_CMD_PAIRING_REQ:
 		reason = smp_cmd_pairing_req(conn, skb);
-- 
1.7.9.5

