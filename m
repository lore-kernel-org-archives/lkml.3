Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbaDVU0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:26:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36793 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758296AbaDVUZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:25:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Claudio Takahasi <claudio.takahasi@openbossa.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 044/133] Bluetooth: Fix removing Long Term Key
Date: Tue, 22 Apr 2014 13:13:02 -0700
Message-Id: <1398197671-12786-45-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Takahasi <claudio.takahasi@openbossa.org>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/bluetooth/hci_event.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index ea5c902..b719a83 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3975,7 +3975,13 @@ static void hci_le_ltk_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
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
1.9.1

