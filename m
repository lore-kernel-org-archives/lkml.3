Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbbAYTFq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:05:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397AbbAYSJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 82/98] tcm_loop: Fixup tag handling
Date: Sun, 25 Jan 2015 10:07:40 -0800
Message-Id: <20150125180716.446379477@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/loopback/tcm_loop.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -153,18 +153,11 @@ static int tcm_loop_change_queue_type(st
 /*
  * Locate the SAM Task Attr from struct scsi_cmnd *
  */
-static int tcm_loop_sam_attr(struct scsi_cmnd *sc)
+static int tcm_loop_sam_attr(struct scsi_cmnd *sc, int tag)
 {
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
+	if (sc->device->tagged_supported &&
+	    sc->device->ordered_tags && tag >= 0)
+		return MSG_ORDERED_TAG;
 
 	return MSG_SIMPLE_TAG;
 }
@@ -214,7 +207,7 @@ static void tcm_loop_submission_work(str
 	}
 	rc = target_submit_cmd_map_sgls(se_cmd, tl_nexus->se_sess, sc->cmnd,
 			&tl_cmd->tl_sense_buf[0], tl_cmd->sc->device->lun,
-			scsi_bufflen(sc), tcm_loop_sam_attr(sc),
+			scsi_bufflen(sc), tcm_loop_sam_attr(sc, tl_cmd->sc_cmd_tag),
 			sc->sc_data_direction, 0,
 			scsi_sglist(sc), scsi_sg_count(sc),
 			sgl_bidi, sgl_bidi_count,
@@ -252,7 +245,7 @@ static int tcm_loop_queuecommand(struct
 	}
 
 	tl_cmd->sc = sc;
-	tl_cmd->sc_cmd_tag = sc->tag;
+	tl_cmd->sc_cmd_tag = sc->request->tag;
 	INIT_WORK(&tl_cmd->work, tcm_loop_submission_work);
 	queue_work(tcm_loop_workqueue, &tl_cmd->work);
 	return 0;
@@ -356,7 +349,7 @@ static int tcm_loop_abort_task(struct sc
 	 */
 	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
 	ret = tcm_loop_issue_tmr(tl_tpg, tl_nexus, sc->device->lun,
-				 sc->tag, TMR_ABORT_TASK);
+				 sc->request->tag, TMR_ABORT_TASK);
 	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
 }
 


