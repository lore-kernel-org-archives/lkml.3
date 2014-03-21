Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966267AbaCUAw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:52:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965576AbaCUAEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chad Dupuis <chad.dupuis@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.13 134/149] SCSI: qla2xxx: Fix multiqueue MSI-X registration.
Date: Thu, 20 Mar 2014 17:04:57 -0700
Message-Id: <20140321000441.601520912@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chad Dupuis <chad.dupuis@qlogic.com>

commit f324777ea88bab2522602671e46fc0851d7d5e35 upstream.

This fixes requesting of the MSI-X vectors for the base response queue.
The iteration in the for loop in qla24xx_enable_msix() was incorrect.
We should only iterate of the first two MSI-X vectors and not the total
number of MSI-X vectors that have given to the driver for this device
from pci_enable_msix() in this function.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_isr.c |   46 ++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 16 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2829,6 +2829,7 @@ static int
 qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 {
 #define MIN_MSIX_COUNT	2
+#define ATIO_VECTOR	2
 	int i, ret;
 	struct msix_entry *entries;
 	struct qla_msix_entry *qentry;
@@ -2885,34 +2886,47 @@ msix_failed:
 	}
 
 	/* Enable MSI-X vectors for the base queue */
-	for (i = 0; i < ha->msix_count; i++) {
+	for (i = 0; i < 2; i++) {
 		qentry = &ha->msix_entries[i];
-		if (QLA_TGT_MODE_ENABLED() && IS_ATIO_MSIX_CAPABLE(ha)) {
-			ret = request_irq(qentry->vector,
-				qla83xx_msix_entries[i].handler,
-				0, qla83xx_msix_entries[i].name, rsp);
-		} else if (IS_P3P_TYPE(ha)) {
+		if (IS_P3P_TYPE(ha))
 			ret = request_irq(qentry->vector,
 				qla82xx_msix_entries[i].handler,
 				0, qla82xx_msix_entries[i].name, rsp);
-		} else {
+		else
 			ret = request_irq(qentry->vector,
 				msix_entries[i].handler,
 				0, msix_entries[i].name, rsp);
-		}
-		if (ret) {
-			ql_log(ql_log_fatal, vha, 0x00cb,
-			    "MSI-X: unable to register handler -- %x/%d.\n",
-			    qentry->vector, ret);
-			qla24xx_disable_msix(ha);
-			ha->mqenable = 0;
-			goto msix_out;
-		}
+		if (ret)
+			goto msix_register_fail;
 		qentry->have_irq = 1;
 		qentry->rsp = rsp;
 		rsp->msix = qentry;
 	}
 
+	/*
+	 * If target mode is enable, also request the vector for the ATIO
+	 * queue.
+	 */
+	if (QLA_TGT_MODE_ENABLED() && IS_ATIO_MSIX_CAPABLE(ha)) {
+		qentry = &ha->msix_entries[ATIO_VECTOR];
+		ret = request_irq(qentry->vector,
+			qla83xx_msix_entries[ATIO_VECTOR].handler,
+			0, qla83xx_msix_entries[ATIO_VECTOR].name, rsp);
+		qentry->have_irq = 1;
+		qentry->rsp = rsp;
+		rsp->msix = qentry;
+	}
+
+msix_register_fail:
+	if (ret) {
+		ql_log(ql_log_fatal, vha, 0x00cb,
+		    "MSI-X: unable to register handler -- %x/%d.\n",
+		    qentry->vector, ret);
+		qla24xx_disable_msix(ha);
+		ha->mqenable = 0;
+		goto msix_out;
+	}
+
 	/* Enable MSI-X vector for response queue update for queue 0 */
 	if (IS_QLA83XX(ha)) {
 		if (ha->msixbase && ha->mqiobase &&


