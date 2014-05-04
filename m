Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaEDQEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:04:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbaEDPmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.10 52/86] SCSI: qla2xxx: fix error handling of qla2x00_mem_alloc()
Date: Sun,  4 May 2014 11:41:27 -0400
Message-Id: <20140504154147.493342597@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_os.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2553,7 +2553,7 @@ qla2x00_probe_one(struct pci_dev *pdev,
 	    ha->flags.enable_64bit_addressing ? "enable" :
 	    "disable");
 	ret = qla2x00_mem_alloc(ha, req_length, rsp_length, &req, &rsp);
-	if (!ret) {
+	if (ret) {
 		ql_log_pci(ql_log_fatal, pdev, 0x0031,
 		    "Failed to allocate memory for adapter, aborting.\n");
 
@@ -3458,10 +3458,10 @@ qla2x00_mem_alloc(struct qla_hw_data *ha
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


