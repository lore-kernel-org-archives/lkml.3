Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab3BLUwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:52:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966Ab3BLUlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:41:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 05/36] Bluetooth: Fix handling of unexpected SMP PDUs
Date: Tue, 12 Feb 2013 12:40:59 -0800
Message-Id: <20130212203857.958240877@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203857.305594226@linuxfoundation.org>
References: <20130212203857.305594226@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/smp.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -852,6 +852,19 @@ int smp_sig_channel(struct l2cap_conn *c
 
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


