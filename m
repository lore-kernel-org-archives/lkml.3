Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab3I3N10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:27:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13923 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab3I3N1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:27:19 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-45-52497c367383
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 11/14] skd: reorder construct/destruct code
Date: Mon, 30 Sep 2013 15:25:52 +0200
Message-id: <1380547556-17719-12-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
References: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e+xgK5ZjWeQwew7XBa9PSfZLVbf7Wez
	2DhjPavF2V9XWSzONr1ht7i8aw6bA5vH5bOlHu/3XWXz6NuyitHjzrkPTB6fN8kFsEZx2aSk
	5mSWpRbp2yVwZfz/+IKx4FBgxe0fsxgbGJ87dTFycEgImEi8X6/XxcgJZIpJXLi3ng3EFhJY
	xCjR/tK1i5ELyO5iknj/YxIrSIJNwEpiYvsqRhBbREBYYn9HKwtIEbNAE6PExiVzwLqFBawl
	vj6YBdbAIqAqsWvedGYQm1fAU+LSth1MENvkJZ7e7wOr5wSK/799lBFis4fEt0OXmSYw8i5g
	ZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERxIz6R3MK5qsDjEKMDBqMTDa7HUI0iINbGs
	uDL3EKMEB7OSCK94mWeQEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp2ampBalF
	MFkmDk6pBsYqyUcGv0/oCzXum9a4r47dy2aW/4TZt2okgkybm4rZ/OO384sqtSQuT3/gfPN4
	2qNpj+Tftl4TyT89TaqLL7i36BK/m5zjwf3iZfXKlrWZR5fGL3XfzDzHebbe+0Mef6TCbv/l
	SHV07VTMEE/mnsb9ep/278u+Lxdf53R6IrDhk8EeNb+uLiWW4oxEQy3mouJEADPjFewgAgAA
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
 drivers/block/skd_main.c | 314 ++++++++++++++++++++++-------------------------
 1 file changed, 144 insertions(+), 170 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 2ff8e37..c72b0e4 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -497,7 +497,6 @@ MODULE_PARM_DESC(skd_bio,
 /* Major device number dynamically assigned. */
 static u32 skd_major;
 
-static struct skd_device *skd_construct(struct pci_dev *pdev);
 static void skd_destruct(struct skd_device *skdev);
 static const struct block_device_operations skd_blockdev_ops;
 static void skd_send_fitmsg(struct skd_device *skdev,
@@ -4408,102 +4407,6 @@ static void skd_release_irq(struct skd_device *skdev)
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
-	if (skd_bio)
-		bio_list_init(&skdev->bio_queue);
-
-
-	atomic_set(&skdev->device_count, 0);
-
-	spin_lock_init(&skdev->lock);
-
-	INIT_WORK(&skdev->completion_worker, skd_completion_worker);
-	INIT_LIST_HEAD(&skdev->flush_list);
-
-	VPRINTK(skdev, "skcomp\n");
-	rc = skd_cons_skcomp(skdev);
-	if (rc < 0)
-		goto err_out;
-
-	VPRINTK(skdev, "skmsg\n");
-	rc = skd_cons_skmsg(skdev);
-	if (rc < 0)
-		goto err_out;
-
-	VPRINTK(skdev, "skreq\n");
-	rc = skd_cons_skreq(skdev);
-	if (rc < 0)
-		goto err_out;
-
-	VPRINTK(skdev, "skspcl\n");
-	rc = skd_cons_skspcl(skdev);
-	if (rc < 0)
-		goto err_out;
-
-	VPRINTK(skdev, "sksb\n");
-	rc = skd_cons_sksb(skdev);
-	if (rc < 0)
-		goto err_out;
-
-	VPRINTK(skdev, "disk\n");
-	rc = skd_cons_disk(skdev);
-	if (rc < 0)
-		goto err_out;
-
-
-
-	DPRINTK(skdev, "VICTORY\n");
-	return skdev;
-
-err_out:
-	DPRINTK(skdev, "construct failed\n");
-	skd_destruct(skdev);
-	return NULL;
-}
-
 static int skd_cons_skcomp(struct skd_device *skdev)
 {
 	int rc = 0;
@@ -4590,6 +4493,35 @@ err_out:
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
@@ -4760,35 +4692,6 @@ err_out:
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
@@ -4855,50 +4758,96 @@ err_out:
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
 
-	VPRINTK(skdev, "disk\n");
-	skd_free_disk(skdev);
+	if (!skdev) {
+		pr_err(PFX "(%s): memory alloc failure\n",
+		       pci_name(pdev));
+		return NULL;
+	}
 
-	VPRINTK(skdev, "sksb\n");
-	skd_free_sksb(skdev);
+	skdev->state = SKD_DRVR_STATE_LOAD;
+	skdev->pdev = pdev;
+	skdev->devno = skd_next_devno++;
+	skdev->major = blk_major;
+	skdev->irq_type = skd_isr_type;
+	sprintf(skdev->name, DRV_NAME "%d", skdev->devno);
+	skdev->dev_max_queue_depth = 0;
 
-	VPRINTK(skdev, "skspcl\n");
-	skd_free_skspcl(skdev);
+	skdev->num_req_context = skd_max_queue_depth;
+	skdev->num_fitmsg_context = skd_max_queue_depth;
+	skdev->n_special = skd_max_pass_thru;
+	skdev->cur_max_queue_depth = 1;
+	skdev->queue_low_water_mark = 1;
+	skdev->proto_ver = 99;
+	skdev->sgs_per_request = skd_sgs_per_request;
+	skdev->dbg_level = skd_dbg_level;
 
-	VPRINTK(skdev, "skreq\n");
-	skd_free_skreq(skdev);
+	if (skd_bio)
+		bio_list_init(&skdev->bio_queue);
 
-	VPRINTK(skdev, "skmsg\n");
-	skd_free_skmsg(skdev);
+
+	atomic_set(&skdev->device_count, 0);
+
+	spin_lock_init(&skdev->lock);
+
+	INIT_WORK(&skdev->completion_worker, skd_completion_worker);
+	INIT_LIST_HEAD(&skdev->flush_list);
 
 	VPRINTK(skdev, "skcomp\n");
-	skd_free_skcomp(skdev);
+	rc = skd_cons_skcomp(skdev);
+	if (rc < 0)
+		goto err_out;
 
-	VPRINTK(skdev, "skdev\n");
-	kfree(skdev);
+	VPRINTK(skdev, "skmsg\n");
+	rc = skd_cons_skmsg(skdev);
+	if (rc < 0)
+		goto err_out;
+
+	VPRINTK(skdev, "skreq\n");
+	rc = skd_cons_skreq(skdev);
+	if (rc < 0)
+		goto err_out;
+
+	VPRINTK(skdev, "skspcl\n");
+	rc = skd_cons_skspcl(skdev);
+	if (rc < 0)
+		goto err_out;
+
+	VPRINTK(skdev, "sksb\n");
+	rc = skd_cons_sksb(skdev);
+	if (rc < 0)
+		goto err_out;
+
+	VPRINTK(skdev, "disk\n");
+	rc = skd_cons_disk(skdev);
+	if (rc < 0)
+		goto err_out;
+
+	DPRINTK(skdev, "VICTORY\n");
+	return skdev;
+
+err_out:
+	DPRINTK(skdev, "construct failed\n");
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
@@ -4941,6 +4890,19 @@ static void skd_free_skmsg(struct skd_device *skdev)
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
@@ -5037,19 +4999,6 @@ static void skd_free_sksb(struct skd_device *skdev)
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
@@ -5066,7 +5015,32 @@ static void skd_free_disk(struct skd_device *skdev)
 	skdev->disk = NULL;
 }
 
+static void skd_destruct(struct skd_device *skdev)
+{
+	if (skdev == NULL)
+		return;
+
+	VPRINTK(skdev, "disk\n");
+	skd_free_disk(skdev);
 
+	VPRINTK(skdev, "sksb\n");
+	skd_free_sksb(skdev);
+
+	VPRINTK(skdev, "skspcl\n");
+	skd_free_skspcl(skdev);
+
+	VPRINTK(skdev, "skreq\n");
+	skd_free_skreq(skdev);
+
+	VPRINTK(skdev, "skmsg\n");
+	skd_free_skmsg(skdev);
+
+	VPRINTK(skdev, "skcomp\n");
+	skd_free_skcomp(skdev);
+
+	VPRINTK(skdev, "skdev\n");
+	kfree(skdev);
+}
 
 /*
  *****************************************************************************
-- 
1.8.2.3

