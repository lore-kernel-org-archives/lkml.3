Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaAYUG4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 15:06:56 -0500
Received: from mail-gg0-f181.google.com ([209.85.161.181]:45810 "EHLO
	mail-gg0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbaAYUGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 15:06:50 -0500
From: Leandro Dorileo <l@dorileo.org>
To: linux-kernel@vger.kernel.org
Cc: virtio-dev@lists.oasis-open.org, virtualization@lists.linux-foundation.org,
        rusty@rustcorp.com.au, mst@redhat.com, Leandro Dorileo <l@dorileo.org>
Subject: [PATCH] virtio_balloon: don't call virtio_has_feature() twice on init_vqs()
Date: Sat, 25 Jan 2014 17:59:32 -0200
Message-Id: <1390679972-1406-1-git-send-email-l@dorileo.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cchange init_vqs() to avoid calling twice the virtio_has_feature()
- attempting to find out if VIRTIO_BALLOON_F_STATS_VQ feature was negotiated -
consequently we prevent unnecessarily running the drivers' feature_table more
than needed.

Signed-off-by: Leandro Dorileo <l@dorileo.org>
---
 drivers/virtio/virtio_balloon.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 34bdaba..41771c1 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -320,19 +320,21 @@ static int init_vqs(struct virtio_balloon *vb)
 	vq_callback_t *callbacks[] = { balloon_ack, balloon_ack, stats_request };
 	const char *names[] = { "inflate", "deflate", "stats" };
 	int err, nvqs;
+	bool stats;
 
 	/*
 	 * We expect two virtqueues: inflate and deflate, and
 	 * optionally stat.
 	 */
-	nvqs = virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ) ? 3 : 2;
+	stats = virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ);
+	nvqs = stats ? 3 : 2;
 	err = vb->vdev->config->find_vqs(vb->vdev, nvqs, vqs, callbacks, names);
 	if (err)
 		return err;
 
 	vb->inflate_vq = vqs[0];
 	vb->deflate_vq = vqs[1];
-	if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
+	if (stats) {
 		struct scatterlist sg;
 		vb->stats_vq = vqs[2];
 
-- 
1.8.5.3

