Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbbAYSXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:23:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132AbbAYSKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.18 181/183] vhost-scsi: Add missing virtio-scsi -> TCM attribute conversion
Date: Sun, 25 Jan 2015 10:08:23 -0800
Message-Id: <20150125180818.013078546@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/vhost/scsi.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -909,6 +909,23 @@ vhost_scsi_map_iov_to_prot(struct tcm_vh
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
@@ -934,9 +951,10 @@ static void tcm_vhost_submission_work(st
 	rc = target_submit_cmd_map_sgls(se_cmd, tv_nexus->tvn_se_sess,
 			cmd->tvc_cdb, &cmd->tvc_sense_buf[0],
 			cmd->tvc_lun, cmd->tvc_exp_data_len,
-			cmd->tvc_task_attr, cmd->tvc_data_direction,
-			TARGET_SCF_ACK_KREF, sg_ptr, cmd->tvc_sgl_count,
-			NULL, 0, sg_prot_ptr, cmd->tvc_prot_sgl_count);
+			vhost_scsi_to_tcm_attr(cmd->tvc_task_attr),
+			cmd->tvc_data_direction, TARGET_SCF_ACK_KREF,
+			sg_ptr, cmd->tvc_sgl_count, NULL, 0,
+			sg_prot_ptr, cmd->tvc_prot_sgl_count);
 	if (rc < 0) {
 		transport_send_check_condition_and_sense(se_cmd,
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);


