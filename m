Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbaJJWv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 18:51:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbaJJWv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 18:51:56 -0400
From: Amos Kong <akong@redhat.com>
To: stable@vger.kernel.org
Cc: rusty@rustcorp.com.au, amit.shah@redhat.com, gregkh@linuxfoundation.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [3.16 stable PATCH 1/2] virtio-rng: fix stuck of hot-unplugging busy device
Date: Sat, 11 Oct 2014 06:51:48 +0800
Message-Id: <1412981509-30025-2-git-send-email-akong@redhat.com>
In-Reply-To: <1412981509-30025-1-git-send-email-akong@redhat.com>
References: <1412981509-30025-1-git-send-email-akong@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we try to hot-remove a busy virtio-rng device from QEMU monitor,
the device can't be hot-removed. Because virtio-rng driver hangs at
wait_for_completion_killable().

This patch exits the waiting by completing have_data completion before
unregistering, resets data_avail to avoid the hwrng core use wrong
buffer bytes.

Signed-off-by: Amos Kong <akong@redhat.com>
Reviewed-by: Amit Shah <amit.shah@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
(cherry picked from commit 3856e548372513665670ca5db60d9a74b970fe0d)
Signed-off-by: Amos Kong <akong@redhat.com>
---
 drivers/char/hw_random/virtio-rng.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index f1aa13b..b50252c 100644
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
1.9.3

