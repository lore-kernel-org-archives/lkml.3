Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaGGXyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:54:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbaGGXx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.15 053/122] Bluetooth: Fix incorrectly overriding conn->src_type
Date: Mon,  7 Jul 2014 16:56:55 -0700
Message-Id: <20140707235735.868466826@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hedberg <johan.hedberg@intel.com>

commit b62b65055bcc5372d5c3f4103629176cb8db3678 upstream.

The src_type member of struct hci_conn should always reflect the address
type of the src_member. It should never be overridden. There is already
code in place in the command status handler of HCI_LE_Create_Connection
to copy the right initiator address into conn->init_addr_type.

Without this patch, if privacy is enabled, we will send the wrong
address type in the SMP identity address information PDU (it'll e.g.
contain our public address but a random address type).

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_conn.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -584,11 +584,6 @@ static void hci_req_add_le_create_conn(s
 	if (hci_update_random_address(req, false, &own_addr_type))
 		return;
 
-	/* Save the address type used for this connnection attempt so we able
-	 * to retrieve this information if we need it.
-	 */
-	conn->src_type = own_addr_type;
-
 	cp.scan_interval = cpu_to_le16(hdev->le_scan_interval);
 	cp.scan_window = cpu_to_le16(hdev->le_scan_window);
 	bacpy(&cp.peer_addr, &conn->dst);


