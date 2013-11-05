Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab3KELiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:38:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:47692 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab3KELiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:38:09 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-64-5278d8a0f77a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2 10/11] skd: reorder construct/destruct code
Date: Tue, 05 Nov 2013 12:37:08 +0100
Message-id: <1383651429-4322-11-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
References: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e+xoO6CGxVBBl+XK1n09pxkt1h9t5/N
	YuOM9awWZ39dZbE42/SG3eLyrjlsDmwel8+Werzfd5XNo2/LKkaPO+c+MHl83iQXwBrFZZOS
	mpNZllqkb5fAlbF87heWgrMRFZOfHWRtYFzr2cXIySEhYCKxp+87M4QtJnHh3no2EFtIYDqj
	RPfV4C5GLiC7i0ni9tPX7CAJNgEriYntqxhBbBEBYYn9Ha0sIEXMAgsYJSbvmANUxMEhLGAn
	MWWHLkgNi4CqxKwXd5lAbF4BD4mZO/9DLZOXeHq/D2wZJ1D8yqU37BCL3SW2fdzLOoGRdwEj
	wypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4EB6JrWDcWWDxSFGAQ5GJR7eB2fLg4RYE8uK
	K3MPMUpwMCuJ8LYdqQgS4k1JrKxKLcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1ILUI
	JsvEwSnVwOjp/TI/Y/1fw9W/sg+aNZz/O+Vq9iH1nwWqV5tP6z5e/O03r/tTjnl790lvPv4m
	+ixjprtsDm9gdI3iFNHQjQyGb9ead9VnRM66cfFRkiNvPk/eG8P6uT0cwYfWnPJe4B/Ft178
	cHekj+pKpV+qzfPfnHwTwxElcOYjw+WOjy++dX39+sv0V5sSS3FGoqEWc1FxIgCmBLm6IAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder placement of skd_construct(), skd_cons_sg_list(), skd_destruct()
and skd_free_sg_list() functions. Then remove no longer needed function
prototypes.

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/block/skd_main.c | 305 ++++++++++++++++++++++-------------------------
 1 file changed, 141 insertions(+), 164 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 2886a8c..9199c93 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -449,7 +449,6 @@ MODULE_PARM_DESC(skd_isr_comp_limit, "s1120 isr comp limit (0=none) default=4");
 /* Major device number dynamically assigned. */
 static u32 skd_major;
 
-static struct skd_device *skd_construct(struct pci_dev *pdev);
 static void skd_destruct(struct skd_device *skdev);
 static const struct block_device_operations skd_blockdev_ops;
 static void skd_send_fitmsg(struct skd_device *skdev,
@@ -4115,96 +4114,6 @@ static void skd_release_irq(struct skd_device *skdev)
  *****************************************************************************
  */
 
-static int skd_cons_skcomp(struct skd_device *skdev);
-static int skd_cons_skmsg(struct skd_device *skdev);
-static int skd_cons_skreq(struct skd_device *skdev);
-static int skd_cons_skspcl(struct skd_device *skdev);
-static int skd_cons_sksb(struct skd_device *skdev);
-static struct fit_sg_descriptor *skd_cons_sg_list(struct skd_device *skdev,
-						  u32 n_sg,
-						  dma_addr_t *ret_dma_addr);
-static int skd_cons_disk(struct skd_device *skdev);
-
-#define SKD_N_DEV_TABLE         16u
-static u32 skd_next_devno;
-
-static struct skd_device *skd_construct(struct pci_dev *pdev)
-{
-	struct skd_device *skdev;
-	int blk_major = skd_major;
-	int rc;
-
-	skdev = kzalloc(sizeof(*skdev), GFP_KERNEL);
-
-	if (!skdev) {
-		pr_err(PFX "(%s): memory alloc failure\n",
-		       pci_name(pdev));
-		return NULL;
-	}
-
-	skdev->state = SKD_DRVR_STATE_LOAD;
-	skdev->pdev = pdev;
-	skdev->devno = skd_next_devno++;
-	skdev->major = blk_major;
-	skdev->irq_type = skd_isr_type;
-	sprintf(skdev->name, DRV_NAME "%d", skdev->devno);
-	skdev->dev_max_queue_depth = 0;
-
-	skdev->num_req_context = skd_max_queue_depth;
-	skdev->num_fitmsg_context = skd_max_queue_depth;
-	skdev->n_special = skd_max_pass_thru;
-	skdev->cur_max_queue_depth = 1;
-	skdev->queue_low_water_mark = 1;
-	skdev->proto_ver = 99;
-	skdev->sgs_per_request = skd_sgs_per_request;
-	skdev->dbg_level = skd_dbg_level;
-
-	atomic_set(&skdev->device_count, 0);
-
-	spin_lock_init(&skdev->lock);
-
-	INIT_WORK(&skdev->completion_worker, skd_completion_worker);
-
-	pr_debug("%s:%s:%d skcomp\n", skdev->name, __func__, __LINE__);
-	rc = skd_cons_skcomp(skdev);
-	if (rc < 0)
-		goto err_out;
-
-	pr_debug("%s:%s:%d skmsg\n", skdev->name, __func__, __LINE__);
-	rc = skd_cons_skmsg(skdev);
-	if (rc < 0)
-		goto err_out;
-
-	pr_debug("%s:%s:%d skreq\n", skdev->name, __func__, __LINE__);
-	rc = skd_cons_skreq(skdev);
-	if (rc < 0)
-		goto err_out;
-
-	pr_debug("%s:%s:%d skspcl\n", skdev->name, __func__, __LINE__);
-	rc = skd_cons_skspcl(skdev);
-	if (rc < 0)
-		goto err_out;
-
-	pr_debug("%s:%s:%d sksb\n", skdev->name, __func__, __LINE__);
-	rc = skd_cons_sksb(skdev);
-	if (rc < 0)
-		goto err_out;
-
-	pr_debug("%s:%s:%d disk\n", skdev->name, __func__, __LINE__);
-	rc = skd_cons_disk(skdev);
-	if (rc < 0)
-		goto err_out;
-
-	pr_debug("%s:%s:%d VICTORY\n", skdev->name, __func__, __LINE__);
-	return skdev;
-
-err_out:
-	pr_debug("%s:%s:%d construct failed\n",
-		 skdev->name, __func__, __LINE__);
-	skd_destruct(skdev);
-	return NULL;
-}
-
 static int skd_cons_skcomp(struct skd_device *skdev)
 {
 	int rc = 0;
@@ -4292,6 +4201,35 @@ err_out:
 	return rc;
 }
 
+static struct fit_sg_descriptor *skd_cons_sg_list(struct skd_device *skdev,
+						  u32 n_sg,
+						  dma_addr_t *ret_dma_addr)
+{
+	struct fit_sg_descriptor *sg_list;
+	u32 nbytes;
+
+	nbytes = sizeof(*sg_list) * n_sg;
+
+	sg_list = pci_alloc_consistent(skdev->pdev, nbytes, ret_dma_addr);
+
+	if (sg_list != NULL) {
+		uint64_t dma_address = *ret_dma_addr;
+		u32 i;
+
+		memset(sg_list, 0, nbytes);
+
+		for (i = 0; i < n_sg - 1; i++) {
+			uint64_t ndp_off;
+			ndp_off = (i + 1) * sizeof(struct fit_sg_descriptor);
+
+			sg_list[i].next_desc_ptr = dma_address + ndp_off;
+		}
+		sg_list[i].next_desc_ptr = 0LL;
+	}
+
+	return sg_list;
+}
+
 static int skd_cons_skreq(struct skd_device *skdev)
 {
 	int rc = 0;
@@ -4465,35 +4403,6 @@ err_out:
 	return rc;
 }
 
-static struct fit_sg_descriptor *skd_cons_sg_list(struct skd_device *skdev,
-						  u32 n_sg,
-						  dma_addr_t *ret_dma_addr)
-{
-	struct fit_sg_descriptor *sg_list;
-	u32 nbytes;
-
-	nbytes = sizeof(*sg_list) * n_sg;
-
-	sg_list = pci_alloc_consistent(skdev->pdev, nbytes, ret_dma_addr);
-
-	if (sg_list != NULL) {
-		uint64_t dma_address = *ret_dma_addr;
-		u32 i;
-
-		memset(sg_list, 0, nbytes);
-
-		for (i = 0; i < n_sg - 1; i++) {
-			uint64_t ndp_off;
-			ndp_off = (i + 1) * sizeof(struct fit_sg_descriptor);
-
-			sg_list[i].next_desc_ptr = dma_address + ndp_off;
-		}
-		sg_list[i].next_desc_ptr = 0LL;
-	}
-
-	return sg_list;
-}
-
 static int skd_cons_disk(struct skd_device *skdev)
 {
 	int rc = 0;
@@ -4550,50 +4459,92 @@ err_out:
 	return rc;
 }
 
-/*
- *****************************************************************************
- * DESTRUCT (FREE)
- *****************************************************************************
- */
-
-static void skd_free_skcomp(struct skd_device *skdev);
-static void skd_free_skmsg(struct skd_device *skdev);
-static void skd_free_skreq(struct skd_device *skdev);
-static void skd_free_skspcl(struct skd_device *skdev);
-static void skd_free_sksb(struct skd_device *skdev);
-static void skd_free_sg_list(struct skd_device *skdev,
-			     struct fit_sg_descriptor *sg_list,
-			     u32 n_sg, dma_addr_t dma_addr);
-static void skd_free_disk(struct skd_device *skdev);
+#define SKD_N_DEV_TABLE         16u
+static u32 skd_next_devno;
 
-static void skd_destruct(struct skd_device *skdev)
+static struct skd_device *skd_construct(struct pci_dev *pdev)
 {
-	if (skdev == NULL)
-		return;
+	struct skd_device *skdev;
+	int blk_major = skd_major;
+	int rc;
 
+	skdev = kzalloc(sizeof(*skdev), GFP_KERNEL);
 
-	pr_debug("%s:%s:%d disk\n", skdev->name, __func__, __LINE__);
-	skd_free_disk(skdev);
+	if (!skdev) {
+		pr_err(PFX "(%s): memory alloc failure\n",
+		       pci_name(pdev));
+		return NULL;
+	}
 
-	pr_debug("%s:%s:%d sksb\n", skdev->name, __func__, __LINE__);
-	skd_free_sksb(skdev);
+	skdev->state = SKD_DRVR_STATE_LOAD;
+	skdev->pdev = pdev;
+	skdev->devno = skd_next_devno++;
+	skdev->major = blk_major;
+	skdev->irq_type = skd_isr_type;
+	sprintf(skdev->name, DRV_NAME "%d", skdev->devno);
+	skdev->dev_max_queue_depth = 0;
 
-	pr_debug("%s:%s:%d skspcl\n", skdev->name, __func__, __LINE__);
-	skd_free_skspcl(skdev);
+	skdev->num_req_context = skd_max_queue_depth;
+	skdev->num_fitmsg_context = skd_max_queue_depth;
+	skdev->n_special = skd_max_pass_thru;
+	skdev->cur_max_queue_depth = 1;
+	skdev->queue_low_water_mark = 1;
+	skdev->proto_ver = 99;
+	skdev->sgs_per_request = skd_sgs_per_request;
+	skdev->dbg_level = skd_dbg_level;
 
-	pr_debug("%s:%s:%d skreq\n", skdev->name, __func__, __LINE__);
-	skd_free_skreq(skdev);
+	atomic_set(&skdev->device_count, 0);
 
-	pr_debug("%s:%s:%d skmsg\n", skdev->name, __func__, __LINE__);
-	skd_free_skmsg(skdev);
+	spin_lock_init(&skdev->lock);
+
+	INIT_WORK(&skdev->completion_worker, skd_completion_worker);
 
 	pr_debug("%s:%s:%d skcomp\n", skdev->name, __func__, __LINE__);
-	skd_free_skcomp(skdev);
+	rc = skd_cons_skcomp(skdev);
+	if (rc < 0)
+		goto err_out;
 
-	pr_debug("%s:%s:%d skdev\n", skdev->name, __func__, __LINE__);
-	kfree(skdev);
+	pr_debug("%s:%s:%d skmsg\n", skdev->name, __func__, __LINE__);
+	rc = skd_cons_skmsg(skdev);
+	if (rc < 0)
+		goto err_out;
+
+	pr_debug("%s:%s:%d skreq\n", skdev->name, __func__, __LINE__);
+	rc = skd_cons_skreq(skdev);
+	if (rc < 0)
+		goto err_out;
+
+	pr_debug("%s:%s:%d skspcl\n", skdev->name, __func__, __LINE__);
+	rc = skd_cons_skspcl(skdev);
+	if (rc < 0)
+		goto err_out;
+
+	pr_debug("%s:%s:%d sksb\n", skdev->name, __func__, __LINE__);
+	rc = skd_cons_sksb(skdev);
+	if (rc < 0)
+		goto err_out;
+
+	pr_debug("%s:%s:%d disk\n", skdev->name, __func__, __LINE__);
+	rc = skd_cons_disk(skdev);
+	if (rc < 0)
+		goto err_out;
+
+	pr_debug("%s:%s:%d VICTORY\n", skdev->name, __func__, __LINE__);
+	return skdev;
+
+err_out:
+	pr_debug("%s:%s:%d construct failed\n",
+		 skdev->name, __func__, __LINE__);
+	skd_destruct(skdev);
+	return NULL;
 }
 
+/*
+ *****************************************************************************
+ * DESTRUCT (FREE)
+ *****************************************************************************
+ */
+
 static void skd_free_skcomp(struct skd_device *skdev)
 {
 	if (skdev->skcomp_table != NULL) {
@@ -4636,6 +4587,19 @@ static void skd_free_skmsg(struct skd_device *skdev)
 	skdev->skmsg_table = NULL;
 }
 
+static void skd_free_sg_list(struct skd_device *skdev,
+			     struct fit_sg_descriptor *sg_list,
+			     u32 n_sg, dma_addr_t dma_addr)
+{
+	if (sg_list != NULL) {
+		u32 nbytes;
+
+		nbytes = sizeof(*sg_list) * n_sg;
+
+		pci_free_consistent(skdev->pdev, nbytes, sg_list, dma_addr);
+	}
+}
+
 static void skd_free_skreq(struct skd_device *skdev)
 {
 	u32 i;
@@ -4732,19 +4696,6 @@ static void skd_free_sksb(struct skd_device *skdev)
 	skspcl->req.sksg_dma_address = 0;
 }
 
-static void skd_free_sg_list(struct skd_device *skdev,
-			     struct fit_sg_descriptor *sg_list,
-			     u32 n_sg, dma_addr_t dma_addr)
-{
-	if (sg_list != NULL) {
-		u32 nbytes;
-
-		nbytes = sizeof(*sg_list) * n_sg;
-
-		pci_free_consistent(skdev->pdev, nbytes, sg_list, dma_addr);
-	}
-}
-
 static void skd_free_disk(struct skd_device *skdev)
 {
 	struct gendisk *disk = skdev->disk;
@@ -4761,7 +4712,33 @@ static void skd_free_disk(struct skd_device *skdev)
 	skdev->disk = NULL;
 }
 
+static void skd_destruct(struct skd_device *skdev)
+{
+	if (skdev == NULL)
+		return;
+
+
+	pr_debug("%s:%s:%d disk\n", skdev->name, __func__, __LINE__);
+	skd_free_disk(skdev);
+
+	pr_debug("%s:%s:%d sksb\n", skdev->name, __func__, __LINE__);
+	skd_free_sksb(skdev);
+
+	pr_debug("%s:%s:%d skspcl\n", skdev->name, __func__, __LINE__);
+	skd_free_skspcl(skdev);
+
+	pr_debug("%s:%s:%d skreq\n", skdev->name, __func__, __LINE__);
+	skd_free_skreq(skdev);
+
+	pr_debug("%s:%s:%d skmsg\n", skdev->name, __func__, __LINE__);
+	skd_free_skmsg(skdev);
 
+	pr_debug("%s:%s:%d skcomp\n", skdev->name, __func__, __LINE__);
+	skd_free_skcomp(skdev);
+
+	pr_debug("%s:%s:%d skdev\n", skdev->name, __func__, __LINE__);
+	kfree(skdev);
+}
 
 /*
  *****************************************************************************
-- 
1.8.2.3

