Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab3JSGn7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:43:59 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:12827 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750944Ab3JSGn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:43:57 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 21/29] qla2xxx: Make use of pcim_enable_msix_range() interface
Date: Fri, 18 Oct 2013 19:12:21 +0200
Message-Id: <5476e68f2f260f7c5d14cf0fa27d0f2406decd49.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   28 ++++++++++++----------------
 1 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index df1b30b..3238a0ac 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2836,27 +2836,23 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	for (i = 0; i < ha->msix_count; i++)
 		entries[i].entry = i;
 
-	ret = pci_enable_msix(ha->pdev, entries, ha->msix_count);
-	if (ret) {
-		if (ret < MIN_MSIX_COUNT)
-			goto msix_failed;
-
+	ret = pcim_enable_msix_range(ha->pdev,
+				     entries, ha->msix_count, MIN_MSIX_COUNT);
+	if (ret < 0) {
+		ql_log(ql_log_fatal, vha, 0x00c7,
+		    "MSI-X: Failed to enable support, "
+		    "giving   up -- %d/%d.\n",
+		    ha->msix_count, ret);
+		goto msix_out;
+	}
+	if (ret < ha->msix_count) {
 		ql_log(ql_log_warn, vha, 0x00c6,
 		    "MSI-X: Failed to enable support "
 		    "-- %d/%d\n Retry with %d vectors.\n",
 		    ha->msix_count, ret, ret);
-		ha->msix_count = ret;
-		ret = pci_enable_msix(ha->pdev, entries, ha->msix_count);
-		if (ret) {
-msix_failed:
-			ql_log(ql_log_fatal, vha, 0x00c7,
-			    "MSI-X: Failed to enable support, "
-			    "giving   up -- %d/%d.\n",
-			    ha->msix_count, ret);
-			goto msix_out;
-		}
-		ha->max_rsp_queues = ha->msix_count - 1;
 	}
+	ha->msix_count = ret;
+	ha->max_rsp_queues = ha->msix_count - 1;
 	ha->msix_entries = kzalloc(sizeof(struct qla_msix_entry) *
 				ha->msix_count, GFP_KERNEL);
 	if (!ha->msix_entries) {
-- 
1.7.7.6

