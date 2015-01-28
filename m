Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760381AbbA2KVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:21:11 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756784AbbA2JAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:54 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nicholas Bellinger <nab@linux-iscsi.org>,
        Christoph Hellwig <hch@lst.de>, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 130/176] vhost-scsi: Add missing virtio-scsi -> TCM attribute conversion
Date: Wed, 28 Jan 2015 15:29:20 +0100
Message-Id: <0dc7138d884d21a4bc0091830c2cad3acb532f77.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 46243860806bdc2756f3ce8ac86b4d7c616bcd6c upstream.

While looking at hch's recent conversion to drop the MSG_*_TAG
definitions, I noticed a long standing bug in vhost-scsi where
the VIRTIO_SCSI_S_* attribute definitions where incorrectly
being passed directly into target_submit_cmd_map_sgls().

This patch adds the missing virtio-scsi to TCM/SAM task attribute
conversion.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/vhost/scsi.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index c5b631cceb4c..d7fddc7d10d5 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -861,6 +861,23 @@ vhost_scsi_map_iov_to_sgl(struct tcm_vhost_cmd *cmd,
 	return 0;
 }
 
+static int vhost_scsi_to_tcm_attr(int attr)
+{
+	switch (attr) {
+	case VIRTIO_SCSI_S_SIMPLE:
+		return MSG_SIMPLE_TAG;
+	case VIRTIO_SCSI_S_ORDERED:
+		return MSG_ORDERED_TAG;
+	case VIRTIO_SCSI_S_HEAD:
+		return MSG_HEAD_TAG;
+	case VIRTIO_SCSI_S_ACA:
+		return MSG_ACA_TAG;
+	default:
+		break;
+	}
+	return MSG_SIMPLE_TAG;
+}
+
 static void tcm_vhost_submission_work(struct work_struct *work)
 {
 	struct tcm_vhost_cmd *cmd =
@@ -887,9 +904,9 @@ static void tcm_vhost_submission_work(struct work_struct *work)
 	rc = target_submit_cmd_map_sgls(se_cmd, tv_nexus->tvn_se_sess,
 			cmd->tvc_cdb, &cmd->tvc_sense_buf[0],
 			cmd->tvc_lun, cmd->tvc_exp_data_len,
-			cmd->tvc_task_attr, cmd->tvc_data_direction,
-			TARGET_SCF_ACK_KREF, sg_ptr, cmd->tvc_sgl_count,
-			sg_bidi_ptr, sg_no_bidi);
+			vhost_scsi_to_tcm_attr(cmd->tvc_task_attr),
+			cmd->tvc_data_direction, TARGET_SCF_ACK_KREF,
+			sg_ptr, cmd->tvc_sgl_count, sg_bidi_ptr, sg_no_bidi);
 	if (rc < 0) {
 		transport_send_check_condition_and_sense(se_cmd,
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
-- 
2.2.2

