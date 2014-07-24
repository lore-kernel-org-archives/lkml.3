Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934591AbaGXJsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:48:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54911 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934555AbaGXJsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 067/128] virtio-scsi: fix various bad behavior on aborted requests
Date: Thu, 24 Jul 2014 10:45:16 +0100
Message-Id: <1406195177-8656-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 8faeb529b2dabb9df691d614dda18910a43d05c9 upstream.

Even though the virtio-scsi spec guarantees that all requests related
to the TMF will have been completed by the time the TMF itself completes,
the request queue's callback might not have run yet.  This causes requests
to be completed more than once, and as a result triggers a variety of
BUGs or oopses.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Venkatesh Srinivas <venkateshs@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/virtio_scsi.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 57c39e1e6681..11f5326f449f 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -270,6 +270,16 @@ static void virtscsi_req_done(struct virtqueue *vq)
 	virtscsi_vq_done(vscsi, req_vq, virtscsi_complete_cmd);
 };
 
+static void virtscsi_poll_requests(struct virtio_scsi *vscsi)
+{
+	int i, num_vqs;
+
+	num_vqs = vscsi->num_queues;
+	for (i = 0; i < num_vqs; i++)
+		virtscsi_vq_done(vscsi, &vscsi->req_vqs[i],
+				 virtscsi_complete_cmd);
+}
+
 static void virtscsi_complete_free(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_cmd *cmd = buf;
@@ -604,6 +614,18 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 	    cmd->resp.tmf.response == VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
 		ret = SUCCESS;
 
+	/*
+	 * The spec guarantees that all requests related to the TMF have
+	 * been completed, but the callback might not have run yet if
+	 * we're using independent interrupts (e.g. MSI).  Poll the
+	 * virtqueues once.
+	 *
+	 * In the abort case, sc->scsi_done will do nothing, because
+	 * the block layer must have detected a timeout and as a result
+	 * REQ_ATOM_COMPLETE has been set.
+	 */
+	virtscsi_poll_requests(vscsi);
+
 out:
 	mempool_free(cmd, virtscsi_cmd_pool);
 	return ret;
-- 
1.9.1

