Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbaLBLoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:44:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbaLBLoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:44:14 -0500
Date: Tue, 2 Dec 2014 13:44:06 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-api@vger.kernel.org
Subject: [PATCH RFC 1/2] virtio_balloon: convert to virtio 1.0 endian-ness
Message-ID: <1417520617-2135-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

balloon device is not part of virtio 1.0 spec.  Still, it's easy enough
to make it handle endian-ness exactly as other virtio 1.0 devices: what
we gain from this, is that there's no need to special-case it in virtio
core.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/uapi/linux/virtio_balloon.h | 5 +++--
 drivers/virtio/virtio_balloon.c     | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/virtio_balloon.h b/include/uapi/linux/virtio_balloon.h
index 5e26f61..5bee71c 100644
--- a/include/uapi/linux/virtio_balloon.h
+++ b/include/uapi/linux/virtio_balloon.h
@@ -27,6 +27,7 @@
  * SUCH DAMAGE. */
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
+#include <linux/virtio_types.h>
 
 /* The feature bitmap for virtio balloon */
 #define VIRTIO_BALLOON_F_MUST_TELL_HOST	0 /* Tell before reclaiming pages */
@@ -52,8 +53,8 @@ struct virtio_balloon_config
 #define VIRTIO_BALLOON_S_NR       6
 
 struct virtio_balloon_stat {
-	__u16 tag;
-	__u64 val;
+	__virtio16 tag;
+	__virtio64 val;
 } __attribute__((packed));
 
 #endif /* _LINUX_VIRTIO_BALLOON_H */
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 4497def..721e32f 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -201,8 +201,8 @@ static inline void update_stat(struct virtio_balloon *vb, int idx,
 			       u16 tag, u64 val)
 {
 	BUG_ON(idx >= VIRTIO_BALLOON_S_NR);
-	vb->stats[idx].tag = tag;
-	vb->stats[idx].val = val;
+	vb->stats[idx].tag = cpu_to_virtio16(vb->vdev, tag);
+	vb->stats[idx].val = cpu_to_virtio64(vb->vdev, val);
 }
 
 #define pages_to_bytes(x) ((u64)(x) << PAGE_SHIFT)
-- 
MST

