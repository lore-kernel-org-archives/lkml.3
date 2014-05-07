Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933795AbaEGNW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:22:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45588 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933259AbaEGNO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:14:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 48/70] [SCSI] qla2xxx: fix error handling of qla2x00_mem_alloc()
Date: Wed,  7 May 2014 14:12:51 +0100
Message-Id: <1399468393-10140-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit b2a72ec32d0f499aaadf41264232517a12326df0 upstream.

qla2x00_mem_alloc() returns 1 on success and -ENOMEM on failure.  On the
one hand the caller assumes non-zero is success but on the other hand
the caller also assumes that it returns an error code.

I've fixed it to return zero on success and a negative error code on
failure.  This matches the documentation as well.

[jejb: checkpatch fix]
Fixes: e315cd28b9ef ('[SCSI] qla2xxx: Code changes for qla data structure refactoring')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3e21e9f..f441a40 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2552,7 +2552,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    ha->flags.enable_64bit_addressing ? "enable" :
 	    "disable");
 	ret = qla2x00_mem_alloc(ha, req_length, rsp_length, &req, &rsp);
-	if (!ret) {
+	if (ret) {
 		ql_log_pci(ql_log_fatal, pdev, 0x0031,
 		    "Failed to allocate memory for adapter, aborting.\n");
 
@@ -3454,10 +3454,10 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	else {
 		qla2x00_set_reserved_loop_ids(ha);
 		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0123,
-		    "loop_id_map=%p. \n", ha->loop_id_map);
+		    "loop_id_map=%p.\n", ha->loop_id_map);
 	}
 
-	return 1;
+	return 0;
 
 fail_async_pd:
 	dma_pool_free(ha->s_dma_pool, ha->ex_init_cb, ha->ex_init_cb_dma);
-- 
1.9.1

