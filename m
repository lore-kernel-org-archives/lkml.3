Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab3CREnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:43:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33561 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751763Ab3CREai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:38 -0400
Message-Id: <20130318042149.175740743@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:35 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Amit Shah <amit.shah@redhat.com>,
        Peter Krempa <pkrempa@redhat.com>, <yunzheng@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 51/82] virtio: rng: disallow multiple device registrations, fixes crashes
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Shah <amit.shah@redhat.com>

commit e84e7a56a3aa2963db506299e29a5f3f09377f9b upstream.

The code currently only supports one virtio-rng device at a time.
Invoking guests with multiple devices causes the guest to blow up.

Check if we've already registered and initialised the driver.  Also
cleanup in case of registration errors or hot-unplug so that a new
device can be used.

Reported-by: Peter Krempa <pkrempa@redhat.com>
Reported-by: <yunzheng@redhat.com>
Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/hw_random/virtio-rng.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -89,14 +89,22 @@ static int virtrng_probe(struct virtio_d
 {
 	int err;
 
+	if (vq) {
+		/* We only support one device for now */
+		return -EBUSY;
+	}
 	/* We expect a single virtqueue. */
 	vq = virtio_find_single_vq(vdev, random_recv_done, "input");
-	if (IS_ERR(vq))
-		return PTR_ERR(vq);
+	if (IS_ERR(vq)) {
+		err = PTR_ERR(vq);
+		vq = NULL;
+		return err;
+	}
 
 	err = hwrng_register(&virtio_hwrng);
 	if (err) {
 		vdev->config->del_vqs(vdev);
+		vq = NULL;
 		return err;
 	}
 
@@ -108,6 +116,7 @@ static void __devexit virtrng_remove(str
 	vdev->config->reset(vdev);
 	hwrng_unregister(&virtio_hwrng);
 	vdev->config->del_vqs(vdev);
+	vq = NULL;
 }
 
 static struct virtio_device_id id_table[] = {


