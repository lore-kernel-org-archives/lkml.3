Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab3CRVHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:07:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab3CRVHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Krempa <pkrempa@redhat.com>, yunzheng@redhat.com,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 03/48] virtio: rng: disallow multiple device registrations, fixes crashes
Date: Mon, 18 Mar 2013 14:08:11 -0700
Message-Id: <20130318210810.498262557@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210810.247845918@linuxfoundation.org>
References: <20130318210810.247845918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


