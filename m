Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaLYPFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 10:05:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:32978 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbaLYPF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 10:05:28 -0500
Date: Thu, 25 Dec 2014 17:05:17 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v2 2/2] vhost: relax used address alignment
Message-ID: <1419517332-12291-3-git-send-email-mst@redhat.com>
References: <1419517332-12291-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419517332-12291-1-git-send-email-mst@redhat.com>
X-Mailer: git-send-email 2.0.0.545.gd9cabeb
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
 drivers/vhost/vhost.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index ed71b53..cb807d0 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -713,9 +713,13 @@ long vhost_vring_ioctl(struct vhost_dev *d, int ioctl, void __user *argp)
 			r = -EFAULT;
 			break;
 		}
-		if ((a.avail_user_addr & (sizeof *vq->avail->ring - 1)) ||
-		    (a.used_user_addr & (sizeof *vq->used->ring - 1)) ||
-		    (a.log_guest_addr & (sizeof *vq->used->ring - 1))) {
+
+		/* Make sure it's safe to cast pointers to vring types. */
+		BUILD_BUG_ON(__alignof__ *vq->avail > VRING_AVAIL_ALIGN_SIZE);
+		BUILD_BUG_ON(__alignof__ *vq->used > VRING_USED_ALIGN_SIZE);
+		if ((a.avail_user_addr & (VRING_AVAIL_ALIGN_SIZE - 1)) ||
+		    (a.used_user_addr & (VRING_USED_ALIGN_SIZE - 1)) ||
+		    (a.log_guest_addr & (sizeof(u64) - 1))) {
 			r = -EINVAL;
 			break;
 		}
-- 
MST
