Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbaF3MwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:52:11 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442AbaF3MaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 181/181] Bluetooth: Fix check for connection encryption
Date: Mon, 30 Jun 2014 13:53:22 +0200
Message-Id: <59ef5356134399d0c78e47e9a4fe5b04445554ce.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hedberg <johan.hedberg@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Cc: stable@vger.kernel.org
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/bluetooth/hci_conn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 312915c23930..3d339414dc9e 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -697,7 +697,7 @@ static int hci_conn_auth(struct hci_conn *conn, __u8 sec_level, __u8 auth_type)
 		/* If we're already encrypted set the REAUTH_PEND flag,
 		 * otherwise set the ENCRYPT_PEND.
 		 */
-		if (conn->key_type != 0xff)
+		if (conn->link_mode & HCI_LM_ENCRYPT)
 			set_bit(HCI_CONN_REAUTH_PEND, &conn->flags);
 		else
 			set_bit(HCI_CONN_ENCRYPT_PEND, &conn->flags);
-- 
2.0.0

