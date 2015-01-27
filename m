Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbbA0MWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:22:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35475 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758754AbbA0MUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:20:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 120/126] tcm_loop: Fixup tag handling
Date: Tue, 27 Jan 2015 12:17:05 +0000
Message-Id: <1422361031-19364-121-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@suse.de>

commit 6375f8908255ea7438b60bb5998e6b3e1628500d upstream.

The SCSI command tag is set to the tag assigned from the block
layer, not the SCSI-II tag message. So we need to convert
it into the correct SCSI-II tag message based on the
device flags, not the tag value itself.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[ luis: backported to 3.16:
  - adjusted context, as commit 506787a2c7da ("tcm_loop: Fix wrong I_T
    nexus association") had already been applied to 3.16 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/target/loopback/tcm_loop.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 6177ed38121e..939c4af2d487 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -153,18 +153,11 @@ static int tcm_loop_change_queue_type(struct scsi_device *sdev, int tag)
 /*
  * Locate the SAM Task Attr from struct scsi_cmnd *
  */
-static int tcm_loop_sam_attr(struct scsi_cmnd *sc)
-{
-	if (sc->device->tagged_supported) {
-		switch (sc->tag) {
-		case HEAD_OF_QUEUE_TAG:
-			return MSG_HEAD_TAG;
-		case ORDERED_QUEUE_TAG:
-			return MSG_ORDERED_TAG;
-		default:
-			break;
-		}
-	}
+static int tcm_loop_sam_attr(struct scsi_cmnd *sc, int tag)
+{
+	if (sc->device->tagged_supported &&
+	    sc->device->ordered_tags && tag >= 0)
+		return MSG_ORDERED_TAG;
 
 	return MSG_SIMPLE_TAG;
 }
@@ -227,7 +220,7 @@ static void tcm_loop_submission_work(struct work_struct *work)
 
 	rc = target_submit_cmd_map_sgls(se_cmd, tl_nexus->se_sess, sc->cmnd,
 			&tl_cmd->tl_sense_buf[0], tl_cmd->sc->device->lun,
-			transfer_length, tcm_loop_sam_attr(sc),
+			transfer_length, tcm_loop_sam_attr(sc, tl_cmd->sc_cmd_tag),
 			sc->sc_data_direction, 0,
 			scsi_sglist(sc), scsi_sg_count(sc),
 			sgl_bidi, sgl_bidi_count,
@@ -266,7 +259,7 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 	}
 
 	tl_cmd->sc = sc;
-	tl_cmd->sc_cmd_tag = sc->tag;
+	tl_cmd->sc_cmd_tag = sc->request->tag;
 	INIT_WORK(&tl_cmd->work, tcm_loop_submission_work);
 	queue_work(tcm_loop_workqueue, &tl_cmd->work);
 	return 0;
@@ -366,7 +359,7 @@ static int tcm_loop_abort_task(struct scsi_cmnd *sc)
 	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
 	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
 	ret = tcm_loop_issue_tmr(tl_tpg, sc->device->lun,
-				 sc->tag, TMR_ABORT_TASK);
+				 sc->request->tag, TMR_ABORT_TASK);
 	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
 }
 
-- 
2.1.4

