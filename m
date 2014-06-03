Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934342AbaFCV1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:27:04 -0400
Received: from p01c11o144.mxlogic.net ([208.65.144.67]:39556 "EHLO
	p01c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934007AbaFCV1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:27:01 -0400
X-MXL-Hash: 538e3da576a4cdd9-f851b9f36ff2dbcdae7a2962a18864453199fd75
X-MXL-Hash: 538e3d985146811d-f391a87d528ba76bf17c9f8e95db4a8993c4e7c3
Date: Tue, 3 Jun 2014 17:26:46 -0400
From: Joe Lawrence <joe.lawrence@stratus.com>
To: Jeff Moyer <jmoyer@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] block,scsi: convert and handle ERR_PTR from
 blk_get_request
Message-ID: <20140603172646.769e90d6@jlaw-desktop.mno.stratus.com>
In-Reply-To: <x49mwdtvjtm.fsf@segfault.boston.devel.redhat.com>
References: <1401396529-17275-1-git-send-email-joe.lawrence@stratus.com>
	<1401396529-17275-3-git-send-email-joe.lawrence@stratus.com>
	<x49mwdtvjtm.fsf@segfault.boston.devel.redhat.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-AnalysisOut: [v=2.1 cv=SPfMVYfH c=1 sm=1 tr=0 a=VNTQBUOG7PJoPU2GWtE7Ww==]
X-AnalysisOut: [:117 a=VNTQBUOG7PJoPU2GWtE7Ww==:17 a=jt-5_Eo0nRcA:10 a=_KQ]
X-AnalysisOut: [qW7t0BisA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=uelBKuK]
X-AnalysisOut: [pAAAA:8 a=YlVTAMxIAAAA:8 a=20KFwNOVAAAA:8 a=P0yh3Z9Q3BPMAl]
X-AnalysisOut: [L9Bx0A:9 a=ilquQ7XQFEwyq6Yw:21 a=6wzNcpPV0YgmoKew:21 a=Cju]
X-AnalysisOut: [IK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=kSViFEBMy1sA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014060327); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014 16:07:01 -0400
Jeff Moyer <jmoyer@redhat.com> wrote:

> Joe Lawrence <joe.lawrence@stratus.com> writes:
> 
> > diff --git a/block/bsg.c b/block/bsg.c
> > index 420a5a9..2b1c322 100644
> > --- a/block/bsg.c
> > +++ b/block/bsg.c
> > @@ -271,8 +271,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
> >  	 * map scatter-gather elements separately and string them to request
> >  	 */
> >  	rq = blk_get_request(q, rw, GFP_KERNEL);
> > -	if (!rq)
> > -		return ERR_PTR(-ENOMEM);
> > +	if (IS_ERR(rq))
> > +		return rq;
> >  	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, bd, has_write_perm);
> >  	if (ret)
> >  		goto out;
> > @@ -284,8 +284,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
> >  		}
> >  
> >  		next_rq = blk_get_request(q, READ, GFP_KERNEL);
> > -		if (!next_rq) {
> > -			ret = -ENOMEM;
> > +		if (IS_ERR(next_rq)) {
> > +			ret = PTR_ERR(rq);
> 
> ITYM ret = PTR_ERR(next_rq), right?

Oops, you are right of course.  I can include this change if there should be another version (Jens?)

> > diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> > index 084062b..1cf4019 100644
> > --- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> > +++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> > @@ -117,7 +117,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
> >  
> >  retry:
> >  	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
> > -	if (!req)
> > +	if (IS_ERR(req))
> >  		return SCSI_DH_RES_TEMP_UNAVAIL;
> >  
> 
> Don't we have an opportunity here to differentiate between enomem and
> eio?  I have no idea what the right SCSI_DH error would be, I'm just
> asking the question.
> 
> >  	req->cmd_type = REQ_TYPE_BLOCK_PC;
> > @@ -247,7 +247,7 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
> >  	struct request *req;
> >  
> >  	req = blk_get_request(h->sdev->request_queue, WRITE, GFP_ATOMIC);
> > -	if (!req)
> > +	if (IS_ERR(req))
> >  		return SCSI_DH_RES_TEMP_UNAVAIL;
> 
> Same goes here.

This sounded familiar, so I dug through my mailbox and found the
following patch.  When the blk_get_request patches stalled, I stopped
working on the scsi_dh patch.  But I think you would be talking about
the introduction of something like "errno_to_SCSI_DH" below...

Thanks,

-- Joe

-- >8 --

>From dd6d4a0753ca056f85df411507a17284e08b0da7 Mon Sep 17 00:00:00 2001
From: Joe Lawrence <joe.lawrence@stratus.com>
Date: Thu, 25 Apr 2013 16:00:51 -0400
Subject: [PATCH draft 2/2] scsi_dh: cleanup blk_get_request callers

Collect common code scattered throughout the SCSI device handler drivers
that call blk_get_request.  Create a wrapper in scsi_dh that gets the
request, maps a kernel buffer, and sets command failfast behavior.
Callers should be prepared to handle various SCSI_DH_* error codes.

Also fix the callers of the scsi_dh_emc routine send_inquiry_cmd to
properly handle errors when the sense length is zero.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/scsi/device_handler/scsi_dh.c       |  58 +++++++++++++++
 drivers/scsi/device_handler/scsi_dh_alua.c  |  58 +++++----------
 drivers/scsi/device_handler/scsi_dh_emc.c   | 111 ++++++++++------------------
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  36 ++++-----
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  60 +++++----------
 include/scsi/scsi_dh.h                      |  10 +++
 6 files changed, 161 insertions(+), 172 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 33e422e..b629de0 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -561,6 +561,64 @@ const char *scsi_dh_attached_handler_name(struct request_queue *q, gfp_t gfp)
 }
 EXPORT_SYMBOL_GPL(scsi_dh_attached_handler_name);
 
+#define errno_to_SCSI_DH(errno)						\
+	(((errno) == -ENODEV) ? SCSI_DH_DEV_OFFLINED			\
+			      : SCSI_DH_RES_TEMP_UNAVAIL)		\
+
+/*
+ * scsi_dh_get_request - Wrapper of blk_get_request for device handlers
+ * @rqp - pointer to new request pointer
+ * @rw - request RW and SYNC flags
+ * @sdev - SCSI device of associated request queue
+ * @buf - kernel buffer to map into request
+ * @buflen - kernel buffer length
+ * @timeout - request timeout
+ * @retries - request retries
+ *
+ * Get a free request from SCSI device request queue.  Maps kernel data
+ * buffer if @buf and @buflen are non-zero.  Sets new request structure
+ * timeout and retries members.
+ *
+ * Returns SCSI_DH_OK and sets @*rqp on success, SCSI_DH_* on error.
+ */
+int scsi_dh_get_request(struct request **rqp, int rw, gfp_t gfp_mask,
+	struct scsi_device *sdev, void *buf, unsigned buflen,
+	unsigned timeout, int retries)
+{
+	struct request *rq;
+	struct request_queue *q = sdev->request_queue;
+	int err;
+
+	rq = blk_get_request(q, rw, gfp_mask);
+
+	if (IS_ERR(rq)) {
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: blk_get_request failed\n", __func__);
+		return errno_to_SCSI_DH(PTR_ERR(rq));
+	}
+
+	if (buf && buflen) {
+		err = blk_rq_map_kern(q, rq, buf, buflen, gfp_mask);
+		if (err) {
+			blk_put_request(rq);
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: blk__rq_map_kern failed.\n", __func__);
+			return errno_to_SCSI_DH(err);
+		}
+	}
+
+	rq->cmd_type = REQ_TYPE_BLOCK_PC;
+	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
+			 REQ_FAILFAST_DRIVER;
+	rq->timeout = timeout;
+	rq->retries = retries;
+
+	*rqp = rq;
+
+	return SCSI_DH_OK;
+}
+EXPORT_SYMBOL_GPL(scsi_dh_get_request);
+
 static struct notifier_block scsi_dh_nb = {
 	.notifier_call = scsi_dh_notifier
 };
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index f07f152..ed9e0c7 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -107,36 +107,6 @@ static int realloc_buffer(struct alua_dh_data *h, unsigned len)
 	return 0;
 }
 
-static struct request *get_alua_req(struct scsi_device *sdev,
-				    void *buffer, unsigned buflen, int rw)
-{
-	struct request *rq;
-	struct request_queue *q = sdev->request_queue;
-
-	rq = blk_get_request(q, rw, GFP_NOIO);
-
-	if (IS_ERR(rq)) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: blk_get_request failed\n", __func__);
-		return NULL;
-	}
-
-	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_NOIO)) {
-		blk_put_request(rq);
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: blk_rq_map_kern failed\n", __func__);
-		return NULL;
-	}
-
-	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-			 REQ_FAILFAST_DRIVER;
-	rq->retries = ALUA_FAILOVER_RETRIES;
-	rq->timeout = ALUA_FAILOVER_TIMEOUT * HZ;
-
-	return rq;
-}
-
 /*
  * submit_vpd_inquiry - Issue an INQUIRY VPD page 0x83 command
  * @sdev: sdev the command should be sent to
@@ -144,10 +114,12 @@ static struct request *get_alua_req(struct scsi_device *sdev,
 static int submit_vpd_inquiry(struct scsi_device *sdev, struct alua_dh_data *h)
 {
 	struct request *rq;
-	int err = SCSI_DH_RES_TEMP_UNAVAIL;
+	int err;
 
-	rq = get_alua_req(sdev, h->buff, h->bufflen, READ);
-	if (!rq)
+	err = scsi_dh_get_request(&rq, READ, GFP_NOIO, sdev, h->buff,
+				  h->bufflen, ALUA_FAILOVER_TIMEOUT * HZ,
+				  ALUA_FAILOVER_RETRIES);
+	if (err)
 		goto done;
 
 	/* Prepare the command. */
@@ -182,10 +154,12 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
 			    bool rtpg_ext_hdr_req)
 {
 	struct request *rq;
-	int err = SCSI_DH_RES_TEMP_UNAVAIL;
+	int err;
 
-	rq = get_alua_req(sdev, h->buff, h->bufflen, READ);
-	if (!rq)
+	err = scsi_dh_get_request(&rq, READ, GFP_NOIO, sdev, h->buff,
+				  h->bufflen, ALUA_FAILOVER_TIMEOUT * HZ,
+				  ALUA_FAILOVER_RETRIES);
+	if (err)
 		goto done;
 
 	/* Prepare the command. */
@@ -285,6 +259,7 @@ static unsigned submit_stpg(struct alua_dh_data *h)
 	struct request *rq;
 	int stpg_len = 8;
 	struct scsi_device *sdev = h->sdev;
+	int err;
 
 	/* Prepare the data buffer */
 	memset(h->buff, 0, stpg_len);
@@ -292,9 +267,11 @@ static unsigned submit_stpg(struct alua_dh_data *h)
 	h->buff[6] = (h->group_id >> 8) & 0xff;
 	h->buff[7] = h->group_id & 0xff;
 
-	rq = get_alua_req(sdev, h->buff, stpg_len, WRITE);
-	if (!rq)
-		return SCSI_DH_RES_TEMP_UNAVAIL;
+	err = scsi_dh_get_request(&rq, WRITE, GFP_NOIO, sdev, h->buff,
+				  stpg_len, ALUA_FAILOVER_TIMEOUT * HZ,
+				  ALUA_FAILOVER_RETRIES);
+	if (err)
+		goto done;
 
 	/* Prepare the command. */
 	rq->cmd[0] = MAINTENANCE_OUT;
@@ -311,7 +288,8 @@ static unsigned submit_stpg(struct alua_dh_data *h)
 	rq->end_io_data = h;
 
 	blk_execute_rq_nowait(rq->q, NULL, rq, 1, stpg_endio);
-	return SCSI_DH_OK;
+done:
+	return err;
 }
 
 /*
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 2ec3261..eab62c5 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -260,82 +260,32 @@ out:
 	return sp_model;
 }
 
-/*
- * Get block request for REQ_BLOCK_PC command issued to path.  Currently
- * limited to MODE_SELECT (trespass) and INQUIRY (VPD page 0xC0) commands.
- *
- * Uses data and sense buffers in hardware handler context structure and
- * assumes serial servicing of commands, both issuance and completion.
- */
-static struct request *get_req(struct scsi_device *sdev, int cmd,
-				unsigned char *buffer)
-{
-	struct request *rq;
-	int len = 0;
-
-	rq = blk_get_request(sdev->request_queue,
-			(cmd != INQUIRY) ? WRITE : READ, GFP_NOIO);
-	if (IS_ERR(rq)) {
-		sdev_printk(KERN_INFO, sdev, "get_req: blk_get_request failed");
-		return NULL;
-	}
-
-	rq->cmd_len = COMMAND_SIZE(cmd);
-	rq->cmd[0] = cmd;
-
-	switch (cmd) {
-	case MODE_SELECT:
-		len = sizeof(short_trespass);
-		rq->cmd[1] = 0x10;
-		rq->cmd[4] = len;
-		break;
-	case MODE_SELECT_10:
-		len = sizeof(long_trespass);
-		rq->cmd[1] = 0x10;
-		rq->cmd[8] = len;
-		break;
-	case INQUIRY:
-		len = CLARIION_BUFFER_SIZE;
-		rq->cmd[4] = len;
-		memset(buffer, 0, len);
-		break;
-	default:
-		BUG_ON(1);
-		break;
-	}
-
-	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-			 REQ_FAILFAST_DRIVER;
-	rq->timeout = CLARIION_TIMEOUT;
-	rq->retries = CLARIION_RETRIES;
-
-	if (blk_rq_map_kern(rq->q, rq, buffer, len, GFP_NOIO)) {
-		blk_put_request(rq);
-		return NULL;
-	}
-
-	return rq;
-}
-
 static int send_inquiry_cmd(struct scsi_device *sdev, int page,
 			    struct clariion_dh_data *csdev)
 {
-	struct request *rq = get_req(sdev, INQUIRY, csdev->buffer);
+	struct request *rq;
 	int err;
 
-	if (!rq)
-		return SCSI_DH_RES_TEMP_UNAVAIL;
-
-	rq->sense = csdev->sense;
-	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
-	rq->sense_len = csdev->senselen = 0;
+	err = scsi_dh_get_request(&rq, READ, GFP_NOIO, sdev, csdev->buffer,
+				  CLARIION_BUFFER_SIZE, CLARIION_TIMEOUT,
+				  CLARIION_RETRIES);
+	if (err)
+		goto done;
 
+	/* Prepare the command. */
 	rq->cmd[0] = INQUIRY;
 	if (page != 0) {
 		rq->cmd[1] = 1;
 		rq->cmd[2] = page;
 	}
+	rq->cmd[4] = CLARIION_BUFFER_SIZE;
+	memset(csdev->buffer, 0, CLARIION_BUFFER_SIZE);
+	rq->cmd_len = COMMAND_SIZE(INQUIRY);
+
+	rq->sense = csdev->sense;
+	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
+	rq->sense_len = csdev->senselen = 0;
+
 	err = blk_execute_rq(sdev->request_queue, NULL, rq, 1);
 	if (err == -EIO) {
 		sdev_printk(KERN_INFO, sdev,
@@ -347,7 +297,7 @@ static int send_inquiry_cmd(struct scsi_device *sdev, int page,
 	}
 
 	blk_put_request(rq);
-
+done:
 	return err;
 }
 
@@ -376,9 +326,19 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 	BUG_ON((len > CLARIION_BUFFER_SIZE));
 	memcpy(csdev->buffer, page22, len);
 
-	rq = get_req(sdev, cmd, csdev->buffer);
-	if (!rq)
-		return SCSI_DH_RES_TEMP_UNAVAIL;
+	err = scsi_dh_get_request(&rq, WRITE, GFP_NOIO, sdev, csdev->buffer,
+				  len, CLARIION_TIMEOUT, CLARIION_RETRIES);
+	if (err)
+		goto done;
+
+	/* Prepare the command. */
+	rq->cmd[0] = cmd;
+	rq->cmd[1] = 0x10;
+	if (cmd == MODE_SELECT)
+		rq->cmd[4] = len;
+	else if (cmd == MODE_SELECT_10)
+		rq->cmd[8] = len;
+	rq->cmd_len = COMMAND_SIZE(cmd);
 
 	rq->sense = csdev->sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
@@ -396,7 +356,7 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 	}
 
 	blk_put_request(rq);
-
+done:
 	return err;
 }
 
@@ -468,9 +428,12 @@ static int clariion_std_inquiry(struct scsi_device *sdev,
 	char *sp_model;
 
 	err = send_inquiry_cmd(sdev, 0, csdev);
-	if (err != SCSI_DH_OK && csdev->senselen) {
+	if (err != SCSI_DH_OK) {
 		struct scsi_sense_hdr sshdr;
 
+		if (!csdev->senselen)
+			goto out;
+
 		if (scsi_normalize_sense(csdev->sense, SCSI_SENSE_BUFFERSIZE,
 					 &sshdr)) {
 			sdev_printk(KERN_ERR, sdev, "%s: INQUIRY sense code "
@@ -507,9 +470,12 @@ static int clariion_send_inquiry(struct scsi_device *sdev,
 
 retry:
 	err = send_inquiry_cmd(sdev, 0xC0, csdev);
-	if (err != SCSI_DH_OK && csdev->senselen) {
+	if (err != SCSI_DH_OK) {
 		struct scsi_sense_hdr sshdr;
 
+		if (!csdev->senselen)
+			goto done;
+
 		err = scsi_normalize_sense(csdev->sense, SCSI_SENSE_BUFFERSIZE,
 					   &sshdr);
 		if (!err)
@@ -527,6 +493,7 @@ retry:
 	} else {
 		err = parse_sp_info_reply(sdev, csdev);
 	}
+done:
 	return err;
 }
 
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 1cf4019..2d03c4d 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -116,16 +116,15 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	int ret;
 
 retry:
-	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
-	if (IS_ERR(req))
-		return SCSI_DH_RES_TEMP_UNAVAIL;
+	ret = scsi_dh_get_request(&req, WRITE, GFP_NOIO, sdev, 0, 0,
+				  HP_SW_TIMEOUT, 0);
+	if (ret)
+		goto done;
 
-	req->cmd_type = REQ_TYPE_BLOCK_PC;
-	req->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-			  REQ_FAILFAST_DRIVER;
-	req->cmd_len = COMMAND_SIZE(TEST_UNIT_READY);
+	/* Prepare the command. */
 	req->cmd[0] = TEST_UNIT_READY;
-	req->timeout = HP_SW_TIMEOUT;
+	req->cmd_len = COMMAND_SIZE(TEST_UNIT_READY);
+
 	req->sense = h->sense;
 	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	req->sense_len = 0;
@@ -154,7 +153,7 @@ retry:
 	}
 
 	blk_put_request(req);
-
+done:
 	return ret;
 }
 
@@ -245,25 +244,26 @@ done:
 static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 {
 	struct request *req;
+	int ret;
 
-	req = blk_get_request(h->sdev->request_queue, WRITE, GFP_ATOMIC);
-	if (IS_ERR(req))
-		return SCSI_DH_RES_TEMP_UNAVAIL;
+	ret = scsi_dh_get_request(&req, WRITE, GFP_ATOMIC, h->sdev, 0, 0,
+				  HP_SW_TIMEOUT, 0);
+	if (ret)
+		goto done;
 
-	req->cmd_type = REQ_TYPE_BLOCK_PC;
-	req->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-			  REQ_FAILFAST_DRIVER;
-	req->cmd_len = COMMAND_SIZE(START_STOP);
+	/* Prepare the command. */
 	req->cmd[0] = START_STOP;
 	req->cmd[4] = 1;	/* Start spin cycle */
-	req->timeout = HP_SW_TIMEOUT;
+	req->cmd_len = COMMAND_SIZE(START_STOP);
+
 	req->sense = h->sense;
 	memset(req->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	req->sense_len = 0;
 	req->end_io_data = h;
 
 	blk_execute_rq_nowait(req->q, NULL, req, 1, start_stop_endio);
-	return SCSI_DH_OK;
+done:
+	return ret;
 }
 
 static int hp_sw_prep_fn(struct scsi_device *sdev, struct request *req)
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 009bd8f..26ed28f 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -266,44 +266,16 @@ static inline struct rdac_dh_data *get_rdac_data(struct scsi_device *sdev)
 	return ((struct rdac_dh_data *) scsi_dh_data->buf);
 }
 
-static struct request *get_rdac_req(struct scsi_device *sdev,
-			void *buffer, unsigned buflen, int rw)
-{
-	struct request *rq;
-	struct request_queue *q = sdev->request_queue;
-
-	rq = blk_get_request(q, rw, GFP_NOIO);
-
-	if (IS_ERR(rq)) {
-		sdev_printk(KERN_INFO, sdev,
-				"get_rdac_req: blk_get_request failed.\n");
-		return NULL;
-	}
-
-	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_NOIO)) {
-		blk_put_request(rq);
-		sdev_printk(KERN_INFO, sdev,
-				"get_rdac_req: blk_rq_map_kern failed.\n");
-		return NULL;
-	}
-
-	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
-			 REQ_FAILFAST_DRIVER;
-	rq->retries = RDAC_RETRIES;
-	rq->timeout = RDAC_TIMEOUT;
-
-	return rq;
-}
-
-static struct request *rdac_failover_get(struct scsi_device *sdev,
-			struct rdac_dh_data *h, struct list_head *list)
+static int rdac_failover_get(struct request **rqp,
+		struct scsi_device *sdev, struct rdac_dh_data *h,
+		struct list_head *list)
 {
 	struct request *rq;
 	struct rdac_mode_common *common;
 	unsigned data_size;
 	struct rdac_queue_data *qdata;
 	u8 *lun_table;
+	int err;
 
 	if (h->ctlr->use_ms10) {
 		struct rdac_pg_expanded *rdac_pg;
@@ -337,9 +309,11 @@ static struct request *rdac_failover_get(struct scsi_device *sdev,
 	}
 
 	/* get request for block layer packet command */
-	rq = get_rdac_req(sdev, &h->ctlr->mode_select, data_size, WRITE);
-	if (!rq)
-		return NULL;
+	err = scsi_dh_get_request(&rq, WRITE, GFP_NOIO, sdev,
+				  &h->ctlr->mode_select, data_size,
+				  RDAC_TIMEOUT, RDAC_RETRIES);
+	if (err)
+		goto done;
 
 	/* Prepare the command. */
 	if (h->ctlr->use_ms10) {
@@ -356,7 +330,9 @@ static struct request *rdac_failover_get(struct scsi_device *sdev,
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	rq->sense_len = 0;
 
-	return rq;
+	*rqp = rq;
+done:
+	return err;
 }
 
 static void release_controller(struct kref *kref)
@@ -408,10 +384,11 @@ static int submit_inquiry(struct scsi_device *sdev, int page_code,
 {
 	struct request *rq;
 	struct request_queue *q = sdev->request_queue;
-	int err = SCSI_DH_RES_TEMP_UNAVAIL;
+	int err;
 
-	rq = get_rdac_req(sdev, &h->inq, len, READ);
-	if (!rq)
+	err = scsi_dh_get_request(&rq, READ, GFP_NOIO, sdev, &h->inq, len,
+				  RDAC_TIMEOUT, RDAC_RETRIES);
+	if (err)
 		goto done;
 
 	/* Prepare the command. */
@@ -603,9 +580,8 @@ static void send_mode_select(struct work_struct *work)
 	spin_unlock(&ctlr->ms_lock);
 
 retry:
-	err = SCSI_DH_RES_TEMP_UNAVAIL;
-	rq = rdac_failover_get(sdev, h, &list);
-	if (!rq)
+	err = rdac_failover_get(&rq, sdev, h, &list);
+	if (err)
 		goto done;
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index 620c723..c3bc702 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -62,6 +62,9 @@ extern int scsi_dh_attach(struct request_queue *, const char *);
 extern void scsi_dh_detach(struct request_queue *);
 extern const char *scsi_dh_attached_handler_name(struct request_queue *, gfp_t);
 extern int scsi_dh_set_params(struct request_queue *, const char *);
+extern int scsi_dh_get_request(struct request **, int, gfp_t,
+			       struct scsi_device *, void *, unsigned len,
+			       unsigned timeout, int retries);
 #else
 static inline int scsi_dh_activate(struct request_queue *req,
 					activate_complete fn, void *data)
@@ -90,4 +93,11 @@ static inline int scsi_dh_set_params(struct request_queue *req, const char *para
 {
 	return -SCSI_DH_NOSYS;
 }
+static inline int scsi_dh_get_request(struct request **rqp, int rw,
+				      gfp_t gfp_mask, struct scsi_device *sdev,
+				      void *buf, unsigned len, unsigned timeout,
+				      int retries)
+{
+	return SCSI_DH_NOSYS;
+}
 #endif
-- 
1.8.1.4

