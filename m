Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaLTXOO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 18:14:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbaLTXOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 18:14:10 -0500
Date: Sun, 21 Dec 2014 01:14:05 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: [PATCH] vhost: relax used address alignment
Message-ID: <1419117201-24590-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio 1.0 only requires used address to be 4 byte aligned,
vhost required 8 bytes (size of vring_used_elem).
Fix up vhost to match that.

Additionally, while vhost correctly requires 8 byte
alignment for log, it's unconnected to used ring:
it's a consequence that log has u64 entries.
Tweak code to make that clearer.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index ed71b53..97996fc 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -713,9 +713,12 @@ long vhost_vring_ioctl(struct vhost_dev *d, int ioctl, void __user *argp)
 			r = -EFAULT;
 			break;
 		}
-		if ((a.avail_user_addr & (sizeof *vq->avail->ring - 1)) ||
-		    (a.used_user_addr & (sizeof *vq->used->ring - 1)) ||
-		    (a.log_guest_addr & (sizeof *vq->used->ring - 1))) {
+
+		BUILD_BUG_ON(__alignof__ *vq->avail != 2);
+		BUILD_BUG_ON(__alignof__ *vq->used != 4);
+		if ((a.avail_user_addr & (__alignof__ *vq->avail - 1)) ||
+		    (a.used_user_addr & (__alignof__ *vq->used - 1)) ||
+		    (a.log_guest_addr & (sizeof(u64) - 1))) {
 			r = -EINVAL;
 			break;
 		}
-- 
MST
