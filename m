Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770Ab3EGB5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:57:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:20011 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932943Ab3EGB4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:56:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,624,1363158000"; 
   d="scan'208";a="237793545"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 08/10] NTB: memcpy lockup workaround
Date: Mon,  6 May 2013 18:55:27 -0700
Message-Id: <1367891729-11738-9-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
References: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The system will appear to lockup for long periods of time due to the NTB
driver spending too much time in memcpy.  Avoid this by reducing the
number of packets that can be serviced on a given interrupt.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_transport.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index cd9745b..583a7d3 100644
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
1.7.9.5

