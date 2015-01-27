Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbbA0MTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:19:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35333 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665AbbA0MT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Hellwig <hch@lst.de>, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 092/126] vhost-scsi: Add missing virtio-scsi -> TCM attribute conversion
Date: Tue, 27 Jan 2015 12:16:37 +0000
Message-Id: <1422361031-19364-93-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

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
[ luis: backported to 3.16:
  - replaced TCM_*_TAG by MSG_*_TAG ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/vhost/scsi.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index a17f11850669..befe07b1e71d 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -909,6 +909,23 @@ vhost_scsi_map_iov_to_prot(struct tcm_vhost_cmd *cmd,
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
@@ -934,9 +951,10 @@ static void tcm_vhost_submission_work(struct work_struct *work)
 	rc = target_submit_cmd_map_sgls(se_cmd, tv_nexus->tvn_se_sess,
 			cmd->tvc_cdb, &cmd->tvc_sense_buf[0],
 			cmd->tvc_lun, cmd->tvc_exp_data_len,
-			cmd->tvc_task_attr, cmd->tvc_data_direction,
-			TARGET_SCF_ACK_KREF, sg_ptr, cmd->tvc_sgl_count,
-			NULL, 0, sg_prot_ptr, cmd->tvc_prot_sgl_count);
+			vhost_scsi_to_tcm_attr(cmd->tvc_task_attr),
+			cmd->tvc_data_direction, TARGET_SCF_ACK_KREF,
+			sg_ptr, cmd->tvc_sgl_count, NULL, 0, sg_prot_ptr,
+			cmd->tvc_prot_sgl_count);
 	if (rc < 0) {
 		transport_send_check_condition_and_sense(se_cmd,
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
-- 
2.1.4

