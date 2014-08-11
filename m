Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaHKMmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 08:42:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbaHKMmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 08:42:43 -0400
From: Amit Shah <amit.shah@redhat.com>
To: stable@vger.kernel.org
Cc: Amos Kong <akong@redhat.com>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Amit Shah <amit.shah@redhat.com>
Subject: [3.16 stable PATCH 1/1] virtio-rng: fix multi-device startup
Date: Mon, 11 Aug 2014 18:11:47 +0530
Message-Id: <5ef3aa4ea1932b7655d9db5a0139b8a2922af0db.1407760907.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a 3.16-only patch.  The linux.git fix is
5c06273401f2eb7b290cadbae18ee00f8f65e893, which fixes this issue in a
different way.

Amos reported using multiple virtio-rng devices cause boot to freeze
even after the recent fixes.  We need the probe_done test per device
rather than just once for the driver.

Reported-by: Amos Kong <akong@redhat.com>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/char/hw_random/virtio-rng.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index e9b15bc..124cac5 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -34,12 +34,11 @@ struct virtrng_info {
 	unsigned int data_avail;
 	struct completion have_data;
 	bool busy;
+	bool probe_done;
 	char name[25];
 	int index;
 };
 
-static bool probe_done;
-
 static void random_recv_done(struct virtqueue *vq)
 {
 	struct virtrng_info *vi = vq->vdev->priv;
@@ -73,7 +72,7 @@ static int virtio_read(struct hwrng *rng, void *buf, size_t size, bool wait)
 	 * Don't ask host for data till we're setup.  This call can
 	 * happen during hwrng_register(), after commit d9e7972619.
 	 */
-	if (unlikely(!probe_done))
+	if (unlikely(!vi->probe_done))
 		return 0;
 
 	if (!vi->busy) {
@@ -146,7 +145,7 @@ static int probe_common(struct virtio_device *vdev)
 		return err;
 	}
 
-	probe_done = true;
+	vi->probe_done = true;
 	return 0;
 }
 
-- 
1.9.3

