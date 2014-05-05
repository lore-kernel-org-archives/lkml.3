Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbaEEM53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:57:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:40974 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932205AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Claudio Takahasi <claudio.takahasi@openbossa.org>,
        Johan Hedberg <johan.hedberg@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 35/50] Bluetooth: Fix removing Long Term Key
Date: Mon,  5 May 2014 14:43:17 +0200
Message-Id: <626d6cde21ad38e531efeb37f3ae81920e8c9a2f.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Claudio Takahasi <claudio.takahasi@openbossa.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5981a8821b774ada0be512fd9bad7c241e17657e upstream.

This patch fixes authentication failure on LE link re-connection when
BlueZ acts as slave (peripheral). LTK is removed from the internal list
after its first use causing PIN or Key missing reply when re-connecting
the link. The LE Long Term Key Request event indicates that the master
is attempting to encrypt or re-encrypt the link.

Pre-condition: BlueZ host paired and running as slave.
How to reproduce(master):

  1) Establish an ACL LE encrypted link
  2) Disconnect the link
  3) Try to re-establish the ACL LE encrypted link (fails)

> HCI Event: LE Meta Event (0x3e) plen 19
      LE Connection Complete (0x01)
        Status: Success (0x00)
        Handle: 64
        Role: Slave (0x01)
...
@ Device Connected: 00:02:72:DC:29:C9 (1) flags 0x0000
> HCI Event: LE Meta Event (0x3e) plen 13
      LE Long Term Key Request (0x05)
        Handle: 64
        Random number: 875be18439d9aa37
        Encryption diversifier: 0x76ed
< HCI Command: LE Long Term Key Request Reply (0x08|0x001a) plen 18
        Handle: 64
        Long term key: 2aa531db2fce9f00a0569c7d23d17409
> HCI Event: Command Complete (0x0e) plen 6
      LE Long Term Key Request Reply (0x08|0x001a) ncmd 1
        Status: Success (0x00)
        Handle: 64
> HCI Event: Encryption Change (0x08) plen 4
        Status: Success (0x00)
        Handle: 64
        Encryption: Enabled with AES-CCM (0x01)
...
@ Device Disconnected: 00:02:72:DC:29:C9 (1) reason 3
< HCI Command: LE Set Advertise Enable (0x08|0x000a) plen 1
        Advertising: Enabled (0x01)
> HCI Event: Command Complete (0x0e) plen 4
      LE Set Advertise Enable (0x08|0x000a) ncmd 1
        Status: Success (0x00)
> HCI Event: LE Meta Event (0x3e) plen 19
      LE Connection Complete (0x01)
        Status: Success (0x00)
        Handle: 64
        Role: Slave (0x01)
...
@ Device Connected: 00:02:72:DC:29:C9 (1) flags 0x0000
> HCI Event: LE Meta Event (0x3e) plen 13
      LE Long Term Key Request (0x05)
        Handle: 64
        Random number: 875be18439d9aa37
        Encryption diversifier: 0x76ed
< HCI Command: LE Long Term Key Request Neg Reply (0x08|0x001b) plen 2
        Handle: 64
> HCI Event: Command Complete (0x0e) plen 6
      LE Long Term Key Request Neg Reply (0x08|0x001b) ncmd 1
        Status: Success (0x00)
        Handle: 64
> HCI Event: Disconnect Complete (0x05) plen 4
        Status: Success (0x00)
        Handle: 64
        Reason: Authentication Failure (0x05)
@ Device Disconnected: 00:02:72:DC:29:C9 (1) reason 0

Signed-off-by: Claudio Takahasi <claudio.takahasi@openbossa.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/bluetooth/hci_event.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 8db3e89fae35..a3af2b750e96 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3565,7 +3565,13 @@ static void hci_le_ltk_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 	hci_send_cmd(hdev, HCI_OP_LE_LTK_REPLY, sizeof(cp), &cp);
 
-	if (ltk->type & HCI_SMP_STK) {
+	/* Ref. Bluetooth Core SPEC pages 1975 and 2004. STK is a
+	 * temporary key used to encrypt a connection following
+	 * pairing. It is used during the Encrypted Session Setup to
+	 * distribute the keys. Later, security can be re-established
+	 * using a distributed LTK.
+	 */
+	if (ltk->type == HCI_SMP_STK_SLAVE) {
 		list_del(&ltk->list);
 		kfree(ltk);
 	}
-- 
1.9.2

