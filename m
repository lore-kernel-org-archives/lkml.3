Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaGGXyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:54:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbaGGXy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.14 05/94] virtio-scsi: fix various bad behavior on aborted requests
Date: Mon,  7 Jul 2014 16:56:55 -0700
Message-Id: <20140707235756.938073555@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235756.780319003@linuxfoundation.org>
References: <20140707235756.780319003@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/virtio_scsi.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -273,6 +273,16 @@ static void virtscsi_req_done(struct vir
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
@@ -607,6 +617,18 @@ static int virtscsi_tmf(struct virtio_sc
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


