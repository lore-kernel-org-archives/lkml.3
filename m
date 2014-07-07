Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbaGHBGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:06:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbaGGXx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hedberg <johan.hedberg@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.15 058/122] Bluetooth: Reuse hci_stop_discovery function when cleaning up HCI state
Date: Mon,  7 Jul 2014 16:57:00 -0700
Message-Id: <20140707235736.012456141@linuxfoundation.org>
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

commit f8680f128b01212895a9afb31032f6ffe91bd771 upstream.

When cleaning up the HCI state as part of the power-off procedure we can
reuse the hci_stop_discovery() function instead of explicitly sending
HCI command related to discovery. The added benefit of this is that it
takes care of canceling name resolving and inquiry which were not
previously covered by the code.

Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/mgmt.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -1098,9 +1098,7 @@ static int clean_up_hci_state(struct hci
 	if (test_bit(HCI_ADVERTISING, &hdev->dev_flags))
 		disable_advertising(&req);
 
-	if (test_bit(HCI_LE_SCAN, &hdev->dev_flags)) {
-		hci_req_add_le_scan_disable(&req);
-	}
+	hci_stop_discovery(&req);
 
 	list_for_each_entry(conn, &hdev->conn_hash.list, list) {
 		struct hci_cp_disconnect dc;


