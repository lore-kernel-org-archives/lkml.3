Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760401AbaEMJ4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:56:23 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60848 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760086AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 073/182] SCSI: qla2xxx: fix error handling of qla2x00_mem_alloc()
Date: Tue, 13 May 2014 11:27:05 +0200
Message-Id: <2e81ba2967ee85177d6ae3c729eb5efe3e94e9fe.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/qla2xxx/qla_os.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9f01bbbf3a26..36d62fd53511 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2616,7 +2616,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    ha->flags.enable_64bit_addressing ? "enable" :
 	    "disable");
 	ret = qla2x00_mem_alloc(ha, req_length, rsp_length, &req, &rsp);
-	if (!ret) {
+	if (ret) {
 		ql_log_pci(ql_log_fatal, pdev, 0x0031,
 		    "Failed to allocate memory for adapter, aborting.\n");
 
@@ -3541,10 +3541,10 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
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
1.9.3

