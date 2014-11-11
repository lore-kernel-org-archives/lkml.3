Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaKKLxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:53:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57429 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902AbaKKLKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amos Kong <akong@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 066/170] virtio-rng: skip reading when we start to remove the device
Date: Tue, 11 Nov 2014 11:07:05 +0000
Message-Id: <1415704129-12709-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amos Kong <akong@redhat.com>

commit f49819560f53b7f3a596a8ea2e6764dc86695b62 upstream.

Before we really unregister the hwrng device, reading will get stuck if
the virtio device is reset. We should return error for reading when we
start to remove the device.

Signed-off-by: Amos Kong <akong@redhat.com>
Reviewed-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/hw_random/virtio-rng.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index b50252c08009..cb1688aff6fc 100644
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
2.1.0

