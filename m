Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaJ0T1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:27:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52413 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaJ0S5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:57:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Loic Poulain <loic.poulain@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 001/105] Bluetooth: Fix HCI H5 corrupted ack value
Date: Mon, 27 Oct 2014 11:55:36 -0700
Message-Id: <1414436240-13879-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@intel.com>

commit 4807b51895dce8aa650ebebc51fa4a795ed6b8b8 upstream.

In this expression: seq = (seq - 1) % 8
seq (u8) is implicitly converted to an int in the arithmetic operation.
So if seq value is 0, operation is ((0 - 1) % 8) => (-1 % 8) => -1.
The new seq value is 0xff which is an invalid ACK value, we expect 0x07.
It leads to frequent dropped ACK and retransmission.
Fix this by using '&' binary operator instead of '%'.

Signed-off-by: Loic Poulain <loic.poulain@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/bluetooth/hci_h5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
index e36a024..5651992 100644
--- a/drivers/bluetooth/hci_h5.c
+++ b/drivers/bluetooth/hci_h5.c
@@ -237,7 +237,7 @@ static void h5_pkt_cull(struct h5 *h5)
 			break;
 
 		to_remove--;
-		seq = (seq - 1) % 8;
+		seq = (seq - 1) & 0x07;
 	}
 
 	if (seq != h5->rx_ack)
-- 
1.9.1

