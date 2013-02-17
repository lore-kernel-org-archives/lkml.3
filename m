Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab3BQXIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:08:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45614 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754419Ab3BQWzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:02 -0500
Message-Id: <20130217225003.306954931@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:15 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 14/66] Bluetooth: Fix handling of unexpected SMP PDUs
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bluetooth/smp.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 68a9587..5abefb1 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -859,6 +859,19 @@ int smp_sig_channel(struct l2cap_conn *conn, struct sk_buff *skb)
 
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


