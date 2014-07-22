Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679AbaGVWXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:23:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44506 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634AbaGVWXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:23:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 097/116] Bluetooth: Fix check for connection encryption
Date: Tue, 22 Jul 2014 15:21:48 -0700
Message-Id: <1406067727-19683-98-git-send-email-kamal@canonical.com>
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

commit e694788d73efe139b24f78b036deb97fe57fa8cb upstream.

The conn->link_key variable tracks the type of link key in use. It is
set whenever we respond to a link key request as well as when we get a
link key notification event.

These two events do not however always guarantee that encryption is
enabled: getting a link key request and responding to it may only mean
that the remote side has requested authentication but not encryption. On
the other hand, the encrypt change event is a certain guarantee that
encryption is enabled. The real encryption state is already tracked in
the conn->link_mode variable through the HCI_LM_ENCRYPT bit.

This patch fixes a check for encryption in the hci_conn_auth function to
use the proper conn->link_mode value and thereby eliminates the chance
of a false positive result.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bluetooth/hci_conn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 058897f..947a965 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -650,7 +650,7 @@ static int hci_conn_auth(struct hci_conn *conn, __u8 sec_level, __u8 auth_type)
 		/* If we're already encrypted set the REAUTH_PEND flag,
 		 * otherwise set the ENCRYPT_PEND.
 		 */
-		if (conn->key_type != 0xff)
+		if (conn->link_mode & HCI_LM_ENCRYPT)
 			set_bit(HCI_CONN_REAUTH_PEND, &conn->flags);
 		else
 			set_bit(HCI_CONN_ENCRYPT_PEND, &conn->flags);
-- 
1.9.1

