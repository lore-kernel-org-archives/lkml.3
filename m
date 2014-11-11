Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaKKLKJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:10:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57424 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbaKKLKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amos Kong <akong@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 065/170] virtio-rng: fix stuck of hot-unplugging busy device
Date: Tue, 11 Nov 2014 11:07:04 +0000
Message-Id: <1415704129-12709-66-git-send-email-luis.henriques@canonical.com>
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

commit 3856e548372513665670ca5db60d9a74b970fe0d upstream.

When we try to hot-remove a busy virtio-rng device from QEMU monitor,
the device can't be hot-removed. Because virtio-rng driver hangs at
wait_for_completion_killable().

This patch exits the waiting by completing have_data completion before
unregistering, resets data_avail to avoid the hwrng core use wrong
buffer bytes.

Signed-off-by: Amos Kong <akong@redhat.com>
Reviewed-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/char/hw_random/virtio-rng.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index f1aa13b21f74..b50252c08009 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -137,6 +137,8 @@ static void remove_common(struct virtio_device *vdev)
 {
 	struct virtrng_info *vi = vdev->priv;
 
+	vi->data_avail = 0;
+	complete(&vi->have_data);
 	vdev->config->reset(vdev);
 	vi->busy = false;
 	if (vi->hwrng_register_done)
-- 
2.1.0

