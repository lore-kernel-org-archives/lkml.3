Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaJJWwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 18:52:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbaJJWwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 18:52:00 -0400
From: Amos Kong <akong@redhat.com>
To: stable@vger.kernel.org
Cc: rusty@rustcorp.com.au, amit.shah@redhat.com, gregkh@linuxfoundation.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [3.16 stable PATCH 2/2] virtio-rng: skip reading when we start to remove the device
Date: Sat, 11 Oct 2014 06:51:49 +0800
Message-Id: <1412981509-30025-3-git-send-email-akong@redhat.com>
In-Reply-To: <1412981509-30025-1-git-send-email-akong@redhat.com>
References: <1412981509-30025-1-git-send-email-akong@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before we really unregister the hwrng device, reading will get stuck if
the virtio device is reset. We should return error for reading when we
start to remove the device.

Signed-off-by: Amos Kong <akong@redhat.com>
Reviewed-by: Amit Shah <amit.shah@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
(cherry picked from commit f49819560f53b7f3a596a8ea2e6764dc86695b62)
Signed-off-by: Amos Kong <akong@redhat.com>
---
 drivers/char/hw_random/virtio-rng.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index b50252c..cb1688a 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -37,6 +37,7 @@ struct virtrng_info {
 	char name[25];
 	int index;
 	bool hwrng_register_done;
+	bool hwrng_removed;
 };
 
 
@@ -69,6 +70,9 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
 	int ret;
 	struct virtrng_info *vi = (struct virtrng_info *)rng->priv;
 
+	if (vi->hwrng_removed)
+		return -ENODEV;
+
 	if (!vi->busy) {
 		vi->busy = true;
 		init_completion(&vi->have_data);
@@ -137,6 +141,7 @@ static void remove_common(struct virtio_device *vdev)
 {
 	struct virtrng_info *vi = vdev->priv;
 
+	vi->hwrng_removed = true;
 	vi->data_avail = 0;
 	complete(&vi->have_data);
 	vdev->config->reset(vdev);
-- 
1.9.3

