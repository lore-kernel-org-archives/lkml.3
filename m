Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbbANIp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:45:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbbANHZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:25:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.18 034/150] Bluetooth: Fix check for direct advertising
Date: Tue, 13 Jan 2015 23:21:45 -0800
Message-Id: <20150114072057.416448720@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit 0b1db38ca26b322296cbd141f3080eccfe1cc3e1 upstream.

These days we allow simultaneous LE scanning and advertising. Checking
for whether advertising is enabled or not is therefore not a reliable
way to determine whether directed advertising was used to trigger the
connection creation. The appropriate place to check (instead of the hdev
context) is the connection role that's stored in the hci_conn. This
patch fixes such a check in le_conn_timeout() which could otherwise lead
to incorrect HCI commands being sent.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_conn.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -415,7 +415,7 @@ static void le_conn_timeout(struct work_
 	 * happen with broken hardware or if low duty cycle was used
 	 * (which doesn't have a timeout of its own).
 	 */
-	if (test_bit(HCI_ADVERTISING, &hdev->dev_flags)) {
+	if (conn->role == HCI_ROLE_SLAVE) {
 		u8 enable = 0x00;
 		hci_send_cmd(hdev, HCI_OP_LE_SET_ADV_ENABLE, sizeof(enable),
 			     &enable);


