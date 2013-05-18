Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521Ab3ERCy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:54:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54799 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab3ERCy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:54:26 -0400
From: Jonghwan Choi <jhbird.choi@gmail.com>
To: Jon Mason <jon.mason@intel.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH 3.9-stable] NTB: memcpy lockup workaround
Date: Sat, 18 May 2013 11:52:17 +0900
Message-Id: <1368845537-4250-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Mason <jon.mason@intel.com>

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Jon Mason <jon.mason@intel.com>"

commit c336acd3331dcc191a97dbc66a557d47741657c7 upstream

The system will appear to lockup for long periods of time due to the NTB
driver spending too much time in memcpy.  Avoid this by reducing the
number of packets that can be serviced on a given interrupt.

Cc: <stable@vger.kernel.org> # 3.9.x: ad3e2751: ntb: off by one
Cc: <stable@vger.kernel.org> # 3.9.x: cc0f868d: NTB: fix pointer math
Cc: <stable@vger.kernel.org> # 3.9.x: 113fc505: NTB: Handle 64bit BAR
Cc: <stable@vger.kernel.org> # 3.9.x: b77b2637: NTB: Link toggle memory
Cc: <stable@vger.kernel.org> # 3.9.x: 90f9e934: NTB: reset tx_index on
Cc: <stable@vger.kernel.org> # 3.9.x: c9d534c8: NTB: Correctly handle receive
Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/ntb/ntb_transport.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index a288a26..0f66daa 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1034,11 +1034,16 @@ out:
 static void ntb_transport_rx(unsigned long data)
 {
 	struct ntb_transport_qp *qp = (struct ntb_transport_qp *)data;
-	int rc;
+	int rc, i;
 
-	do {
+	/* Limit the number of packets processed in a single interrupt to
+	 * provide fairness to others
+	 */
+	for (i = 0; i < qp->rx_max_entry; i++) {
 		rc = ntb_process_rxc(qp);
-	} while (!rc);
+		if (rc)
+			break;
+	}
 }
 
 static void ntb_transport_rxc_db(void *data, int db_num)
-- 
1.8.1.2

