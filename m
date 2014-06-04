Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaFDTVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:21:06 -0400
Received: from p01c11o145.mxlogic.net ([208.65.144.68]:52716 "EHLO
	p01c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaFDTVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:21:02 -0400
X-MXL-Hash: 538f719e6e12b533-e0851b01527702143d47a06c281b7ec295f6300f
From: Joe Lawrence <joe.lawrence@stratus.com>
To: <linux-kernel@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH v2 2/2] block,scsi: convert and handle ERR_PTR from blk_get_request
Date: Wed, 4 Jun 2014 15:20:33 -0400
Message-ID: <1401909633-25931-3-git-send-email-joe.lawrence@stratus.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401909633-25931-1-git-send-email-joe.lawrence@stratus.com>
References: <1401909633-25931-1-git-send-email-joe.lawrence@stratus.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [134.111.199.152]
X-AnalysisOut: [v=2.1 cv=P8i0h0wu c=1 sm=1 tr=0 a=o2bo05G+d1rlxuoNbFVhCw==]
X-AnalysisOut: [:117 a=o2bo05G+d1rlxuoNbFVhCw==:17 a=Glimlxzx9zcA:10 a=_KQ]
X-AnalysisOut: [qW7t0BisA:10 a=CdzKgOd8jloA:10 a=BLceEmwcHowA:10 a=uelBKuK]
X-AnalysisOut: [pAAAA:8 a=YlVTAMxIAAAA:8 a=cOLrLDMxAAAA:8 a=20KFwNOVAAAA:8]
X-AnalysisOut: [ a=NebqWWrlVvnvOuHW3zEA:9 a=kSViFEBMy1sA:10 a=3QEBi2iB_nEA]
X-AnalysisOut: [:10 a=jEp0ucaQiEUA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014060421); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The blk_get_request function may fail in low-memory conditions or during
device removal (even if __GFP_WAIT is set). To distinguish between these
errors, modify the blk_get_request call stack to return the appropriate
ERR_PTR. Verify that all callers check the return status and consider
IS_ERR instead of a simple NULL pointer check.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Acked-by: Jiri Kosina <jkosina@suse.cz> [for pktdvd]
Acked-by: Boaz Harrosh <bharrosh@panasas.com> [for osd]
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
---
 block/blk-core.c                            | 34 ++++++++++++++---------------
 block/bsg.c                                 |  8 +++----
 block/scsi_ioctl.c                          | 12 +++++-----
 drivers/block/paride/pd.c                   |  4 ++--
 drivers/block/pktcdvd.c                     |  4 ++--
 drivers/block/sx8.c                         |  2 +-
 drivers/cdrom/cdrom.c                       |  4 ++--
 drivers/ide/ide-park.c                      |  2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c  |  2 +-
 drivers/scsi/device_handler/scsi_dh_emc.c   |  2 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  4 ++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  2 +-
 drivers/scsi/osd/osd_initiator.c            |  4 ++--
 drivers/scsi/osst.c                         |  2 +-
 drivers/scsi/scsi_error.c                   |  2 +-
 drivers/scsi/scsi_lib.c                     |  2 +-
 drivers/scsi/scsi_tgt_lib.c                 |  2 +-
 drivers/scsi/sg.c                           |  4 ++--
 drivers/scsi/st.c                           |  2 +-
 drivers/target/target_core_pscsi.c          |  2 +-
 20 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a0e3096..cd0e9f3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -891,9 +891,9 @@ static struct io_context *rq_ioc(struct bio *bio)
  * Get a free request from @q.  This function may fail under memory
  * pressure or if @q is dead.
  *
- * Must be callled with @q->queue_lock held and,
- * Returns %NULL on failure, with @q->queue_lock held.
- * Returns !%NULL on success, with @q->queue_lock *not held*.
+ * Must be called with @q->queue_lock held and,
+ * Returns ERR_PTR on failure, with @q->queue_lock held.
+ * Returns request pointer on success, with @q->queue_lock *not held*.
  */
 static struct request *__get_request(struct request_list *rl, int rw_flags,
 				     struct bio *bio, gfp_t gfp_mask)
@@ -907,7 +907,7 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 	int may_queue;
 
 	if (unlikely(blk_queue_dying(q)))
-		return NULL;
+		return ERR_PTR(-ENODEV);
 
 	may_queue = elv_may_queue(q, rw_flags);
 	if (may_queue == ELV_MQUEUE_NO)
@@ -932,7 +932,7 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 					 * process is not a "batcher", and not
 					 * exempted by the IO scheduler
 					 */
-					return NULL;
+					return ERR_PTR(-ENOMEM);
 				}
 			}
 		}
@@ -950,7 +950,7 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 	 * allocated with any setting of ->nr_requests
 	 */
 	if (rl->count[is_sync] >= (3 * q->nr_requests / 2))
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	q->nr_rqs[is_sync]++;
 	rl->count[is_sync]++;
@@ -1055,7 +1055,7 @@ fail_alloc:
 rq_starved:
 	if (unlikely(rl->count[is_sync] == 0))
 		rl->starved[is_sync] = 1;
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 
 /**
@@ -1068,9 +1068,9 @@ rq_starved:
  * Get a free request from @q.  If %__GFP_WAIT is set in @gfp_mask, this
  * function keeps retrying under memory pressure and fails iff @q is dead.
  *
- * Must be callled with @q->queue_lock held and,
- * Returns %NULL on failure, with @q->queue_lock held.
- * Returns !%NULL on success, with @q->queue_lock *not held*.
+ * Must be called with @q->queue_lock held and,
+ * Returns ERR_PTR on failure, with @q->queue_lock held.
+ * Returns request pointer on success, with @q->queue_lock *not held*.
  */
 static struct request *get_request(struct request_queue *q, int rw_flags,
 				   struct bio *bio, gfp_t gfp_mask)
@@ -1083,12 +1083,12 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 	rl = blk_get_rl(q, bio);	/* transferred to @rq on success */
 retry:
 	rq = __get_request(rl, rw_flags, bio, gfp_mask);
-	if (rq)
+	if (!IS_ERR(rq))
 		return rq;
 
 	if (!(gfp_mask & __GFP_WAIT) || unlikely(blk_queue_dying(q))) {
 		blk_put_rl(rl);
-		return NULL;
+		return rq;
 	}
 
 	/* wait on @rl and retry */
@@ -1125,7 +1125,7 @@ static struct request *blk_old_get_request(struct request_queue *q, int rw,
 
 	spin_lock_irq(q->queue_lock);
 	rq = get_request(q, rw, NULL, gfp_mask);
-	if (!rq)
+	if (IS_ERR(rq))
 		spin_unlock_irq(q->queue_lock);
 	/* q->queue_lock is unlocked at this point */
 
@@ -1177,8 +1177,8 @@ struct request *blk_make_request(struct request_queue *q, struct bio *bio,
 {
 	struct request *rq = blk_get_request(q, bio_data_dir(bio), gfp_mask);
 
-	if (unlikely(!rq))
-		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(rq))
+		return rq;
 
 	for_each_bio(bio) {
 		struct bio *bounce_bio = bio;
@@ -1559,8 +1559,8 @@ get_rq:
 	 * Returns with the queue unlocked.
 	 */
 	req = get_request(q, rw_flags, bio, GFP_NOIO);
-	if (unlikely(!req)) {
-		bio_endio(bio, -ENODEV);	/* @q is dead */
+	if (IS_ERR(req)) {
+		bio_endio(bio, PTR_ERR(req));	/* @q is dead */
 		goto out_unlock;
 	}
 
diff --git a/block/bsg.c b/block/bsg.c
index 420a5a9..50545e9 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -271,8 +271,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
 	 * map scatter-gather elements separately and string them to request
 	 */
 	rq = blk_get_request(q, rw, GFP_KERNEL);
-	if (!rq)
-		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(rq))
+		return rq;
 	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, bd, has_write_perm);
 	if (ret)
 		goto out;
@@ -284,8 +284,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
 		}
 
 		next_rq = blk_get_request(q, READ, GFP_KERNEL);
-		if (!next_rq) {
-			ret = -ENOMEM;
+		if (IS_ERR(next_rq)) {
+			ret = PTR_ERR(next_rq);
 			goto out;
 		}
 		rq->next_rq = next_rq;
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index e6485c9..f901fb5 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -313,8 +313,8 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 		}
 
 	rq = blk_get_request(q, writing ? WRITE : READ, GFP_KERNEL);
-	if (!rq)
-		return -ENOMEM;
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
 
 	if (blk_fill_sghdr_rq(q, rq, hdr, mode)) {
 		blk_put_request(rq);
@@ -442,8 +442,8 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 	}
 
 	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_WAIT);
-	if (!rq) {
-		err = -ENODEV;
+	if (IS_ERR(rq)) {
+		err = PTR_ERR(rq);
 		goto error_free_buffer;
 	}
 
@@ -533,8 +533,8 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	int err;
 
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
-	if (!rq)
-		return -ENODEV;
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
 	rq->cmd[0] = cmd;
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 856178a..2af4101 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -722,8 +722,8 @@ static int pd_special_command(struct pd_unit *disk,
 	int err = 0;
 
 	rq = blk_get_request(disk->gd->queue, READ, __GFP_WAIT);
-	if (!rq)
-		return -ENODEV;
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
 
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->special = func;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index ff39837..1de6e90 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -704,8 +704,8 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 
 	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?
 			     WRITE : READ, __GFP_WAIT);
-	if (!rq)
-		return -ENODEV;
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
 
 	if (cgc->buflen) {
 		ret = blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen,
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index d5e2d12..5d55285 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -568,7 +568,7 @@ static struct carm_request *carm_get_special(struct carm_host *host)
 		return NULL;
 
 	rq = blk_get_request(host->oob_q, WRITE /* bogus */, GFP_KERNEL);
-	if (!rq) {
+	if (IS_ERR(rq)) {
 		spin_lock_irqsave(&host->lock, flags);
 		carm_put_request(host, crq);
 		spin_unlock_irqrestore(&host->lock, flags);
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 8a3aff7..85e63d3 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2161,8 +2161,8 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 		len = nr * CD_FRAMESIZE_RAW;
 
 		rq = blk_get_request(q, READ, GFP_KERNEL);
-		if (!rq) {
-			ret = -ENOMEM;
+		if (IS_ERR(rq)) {
+			ret = PTR_ERR(rq);
 			break;
 		}
 
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index f41558a..ca95860 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -46,7 +46,7 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 	 * timeout has expired, so power management will be reenabled.
 	 */
 	rq = blk_get_request(q, READ, GFP_NOWAIT);
-	if (unlikely(!rq))
+	if (IS_ERR(rq))
 		goto out;
 
 	rq->cmd[0] = REQ_UNPARK_HEADS;
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 5248c88..5aefcf9 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -115,7 +115,7 @@ static struct request *get_alua_req(struct scsi_device *sdev,
 
 	rq = blk_get_request(q, rw, GFP_NOIO);
 
-	if (!rq) {
+	if (IS_ERR(rq)) {
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: blk_get_request failed\n", __func__);
 		return NULL;
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index e1c8be0..2ec3261 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -275,7 +275,7 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
 
 	rq = blk_get_request(sdev->request_queue,
 			(cmd != INQUIRY) ? WRITE : READ, GFP_NOIO);
-	if (!rq) {
+	if (IS_ERR(rq)) {
 		sdev_printk(KERN_INFO, sdev, "get_req: blk_get_request failed");
 		return NULL;
 	}
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 084062b..1cf4019 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -117,7 +117,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 
 retry:
 	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
-	if (!req)
+	if (IS_ERR(req))
 		return SCSI_DH_RES_TEMP_UNAVAIL;
 
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
@@ -247,7 +247,7 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	struct request *req;
 
 	req = blk_get_request(h->sdev->request_queue, WRITE, GFP_ATOMIC);
-	if (!req)
+	if (IS_ERR(req))
 		return SCSI_DH_RES_TEMP_UNAVAIL;
 
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 4b9cf93..5f6e5d8 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -274,7 +274,7 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
 
 	rq = blk_get_request(q, rw, GFP_NOIO);
 
-	if (!rq) {
+	if (IS_ERR(rq)) {
 		sdev_printk(KERN_INFO, sdev,
 				"get_rdac_req: blk_get_request failed.\n");
 		return NULL;
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index bac04c2..831f1f9 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -1567,8 +1567,8 @@ static struct request *_make_request(struct request_queue *q, bool has_write,
 		struct request *req;
 
 		req = blk_get_request(q, has_write ? WRITE : READ, flags);
-		if (unlikely(!req))
-			return ERR_PTR(-ENOMEM);
+		if (IS_ERR(req))
+			return req;
 
 		return req;
 	}
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 21883a2..826cda9 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -362,7 +362,7 @@ static int osst_execute(struct osst_request *SRpnt, const unsigned char *cmd,
 	int write = (data_direction == DMA_TO_DEVICE);
 
 	req = blk_get_request(SRpnt->stp->device->request_queue, write, GFP_KERNEL);
-	if (!req)
+	if (IS_ERR(req))
 		return DRIVER_ERROR << 24;
 
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d50531f..ca038ee 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1950,7 +1950,7 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	 * request becomes available
 	 */
 	req = blk_get_request(sdev->request_queue, READ, GFP_KERNEL);
-	if (!req)
+	if (IS_ERR(req))
 		return;
 
 	req->cmd[0] = ALLOW_MEDIUM_REMOVAL;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9db097a..b25fab0b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -193,7 +193,7 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	int ret = DRIVER_ERROR << 24;
 
 	req = blk_get_request(sdev->request_queue, write, __GFP_WAIT);
-	if (!req)
+	if (IS_ERR(req))
 		return ret;
 
 	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index e51add0..b14c15b 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -97,7 +97,7 @@ struct scsi_cmnd *scsi_host_get_command(struct Scsi_Host *shost,
 	 * we are in target mode we want the opposite.
 	 */
 	rq = blk_get_request(shost->uspace_req_q, !write, gfp_mask);
-	if (!rq)
+	if (IS_ERR(rq))
 		goto free_tcmd;
 
 	cmd = __scsi_get_command(shost, gfp_mask);
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index df5e961..2e54684 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1650,8 +1650,8 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 				   dxfer_len));
 
 	rq = blk_get_request(q, rw, GFP_ATOMIC);
-	if (!rq)
-		return -ENOMEM;
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
 
 	memcpy(rq->cmd, cmd, hp->cmd_len);
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index afc834e..48a6cef 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -481,7 +481,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 
 	req = blk_get_request(SRpnt->stp->device->request_queue, write,
 			      GFP_KERNEL);
-	if (!req)
+	if (IS_ERR(req))
 		return DRIVER_ERROR << 24;
 
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 0f199f6..23d340d 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1050,7 +1050,7 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 		req = blk_get_request(pdv->pdv_sd->request_queue,
 				(data_direction == DMA_TO_DEVICE),
 				GFP_KERNEL);
-		if (!req) {
+		if (IS_ERR(req)) {
 			pr_err("PSCSI: blk_get_request() failed\n");
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 			goto fail;
-- 
1.8.3.1

