Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352Ab3JKTha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:37:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236Ab3JKThX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:37:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andre Guedes <andre.guedes@openbossa.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 26/48] Bluetooth: Fix security level for peripheral role
Date: Fri, 11 Oct 2013 12:36:33 -0700
Message-Id: <20131011193640.075910395@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193637.253208688@linuxfoundation.org>
References: <20131011193637.253208688@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_event.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3375,7 +3375,9 @@ static inline void hci_le_ltk_request_ev
 	cp.handle = cpu_to_le16(conn->handle);
 
 	if (ltk->authenticated)
-		conn->sec_level = BT_SECURITY_HIGH;
+		conn->pending_sec_level = BT_SECURITY_HIGH;
+	else
+		conn->pending_sec_level = BT_SECURITY_MEDIUM;
 
 	hci_send_cmd(hdev, HCI_OP_LE_LTK_REPLY, sizeof(cp), &cp);
 


