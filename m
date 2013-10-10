Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab3JJPru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:47:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52814 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035Ab3JJPrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:47:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andre Guedes <andre.guedes@openbossa.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 082/104] Bluetooth: Fix security level for peripheral role
Date: Thu, 10 Oct 2013 08:42:10 -0700
Message-Id: <1381419752-29733-83-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Guedes <andre.guedes@openbossa.org>

commit f8776218e8546397be64ad2bc0ebf4748522d6e3 upstream.

While playing the peripheral role, the host gets a LE Long Term Key
Request Event from the controller when a connection is established
with a bonded device. The host then informs the LTK which should be
used for the connection. Once the link is encrypted, the host gets
an Encryption Change Event.

Therefore we should set conn->pending_sec_level instead of conn->
sec_level in hci_le_ltk_request_evt. This way, conn->sec_level is
properly updated in hci_encrypt_change_evt.

Moreover, since we have a LTK associated to the device, we have at
least BT_SECURITY_MEDIUM security level.

Signed-off-by: Andre Guedes <andre.guedes@openbossa.org>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bluetooth/hci_event.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 81b4448..259776a 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3967,7 +3967,9 @@ static void hci_le_ltk_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	cp.handle = cpu_to_le16(conn->handle);
 
 	if (ltk->authenticated)
-		conn->sec_level = BT_SECURITY_HIGH;
+		conn->pending_sec_level = BT_SECURITY_HIGH;
+	else
+		conn->pending_sec_level = BT_SECURITY_MEDIUM;
 
 	hci_send_cmd(hdev, HCI_OP_LE_LTK_REPLY, sizeof(cp), &cp);
 
-- 
1.8.1.2

