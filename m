Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbaGHTje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:39:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54125 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755687AbaGHTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marcel Holtmann" <marcel@holtmann.org>,
        "Johan Hedberg" <johan.hedberg@intel.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.136906955@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 088/125] Bluetooth: Fix check for connection encryption
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bluetooth/hci_conn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -617,7 +617,7 @@ static int hci_conn_auth(struct hci_conn
 		/* If we're already encrypted set the REAUTH_PEND flag,
 		 * otherwise set the ENCRYPT_PEND.
 		 */
-		if (conn->key_type != 0xff)
+		if (conn->link_mode & HCI_LM_ENCRYPT)
 			set_bit(HCI_CONN_REAUTH_PEND, &conn->pend);
 		else
 			set_bit(HCI_CONN_ENCRYPT_PEND, &conn->pend);

