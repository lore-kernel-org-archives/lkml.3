Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaFDXVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:21:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaFDXVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.14 096/228] Bluetooth: Fix redundant encryption request for reauthentication
Date: Wed,  4 Jun 2014 16:22:05 -0700
Message-Id: <20140604232351.132254556@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit 09da1f3463eb81d59685df723b1c5950b7570340 upstream.

When we're performing reauthentication (in order to elevate the
security level from an unauthenticated key to an authenticated one) we
do not need to issue any encryption command once authentication
completes. Since the trigger for the encryption HCI command is the
ENCRYPT_PEND flag this flag should not be set in this scenario.
Instead, the REAUTH_PEND flag takes care of all necessary steps for
reauthentication.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_conn.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -752,14 +752,17 @@ static int hci_conn_auth(struct hci_conn
 	if (!test_and_set_bit(HCI_CONN_AUTH_PEND, &conn->flags)) {
 		struct hci_cp_auth_requested cp;
 
-		/* encrypt must be pending if auth is also pending */
-		set_bit(HCI_CONN_ENCRYPT_PEND, &conn->flags);
-
 		cp.handle = cpu_to_le16(conn->handle);
 		hci_send_cmd(conn->hdev, HCI_OP_AUTH_REQUESTED,
 			     sizeof(cp), &cp);
+
+		/* If we're already encrypted set the REAUTH_PEND flag,
+		 * otherwise set the ENCRYPT_PEND.
+		 */
 		if (conn->key_type != 0xff)
 			set_bit(HCI_CONN_REAUTH_PEND, &conn->flags);
+		else
+			set_bit(HCI_CONN_ENCRYPT_PEND, &conn->flags);
 	}
 
 	return 0;


