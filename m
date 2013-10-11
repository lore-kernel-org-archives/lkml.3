Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab3JKKv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:51:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58734 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299Ab3JKKoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:44:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andre Guedes <andre.guedes@openbossa.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 077/100] Bluetooth: Fix security level for peripheral role
Date: Fri, 11 Oct 2013 11:41:47 +0100
Message-Id: <1381488130-30235-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/bluetooth/hci_event.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 843d048..9871e8b 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3452,7 +3452,9 @@ static inline void hci_le_ltk_request_evt(struct hci_dev *hdev,
 	cp.handle = cpu_to_le16(conn->handle);
 
 	if (ltk->authenticated)
-		conn->sec_level = BT_SECURITY_HIGH;
+		conn->pending_sec_level = BT_SECURITY_HIGH;
+	else
+		conn->pending_sec_level = BT_SECURITY_MEDIUM;
 
 	hci_send_cmd(hdev, HCI_OP_LE_LTK_REPLY, sizeof(cp), &cp);
 
-- 
1.8.3.2

