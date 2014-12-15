Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbaLOVXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:23:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbaLOVXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:23:18 -0500
Date: Mon, 15 Dec 2014 23:23:12 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 2/6] virtio_config: fix virtio_cread_bytes
Message-ID: <1418678575-31755-3-git-send-email-mst@redhat.com>
References: <1418678575-31755-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418678575-31755-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio_cread_bytes is implemented incorrectly in case length happens to
be 2,4 or 8 bytes: transports and devices will assume it's an integer
value that has to be converted to LE format.

Let's just do multiple 1-byte reads: this also makes life easier
for transports who only need to implement 1,2,4 and 8 byte reads.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio_config.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 7979f85..a61cd37 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -305,7 +305,10 @@ static inline void virtio_cread_bytes(struct virtio_device *vdev,
 				      unsigned int offset,
 				      void *buf, size_t len)
 {
-	vdev->config->get(vdev, offset, buf, len);
+	int i;
+
+	for (i = 0; i < len; i++)
+		vdev->config->get(vdev, offset + i, buf + i, 1);
 }
 
 static inline void virtio_cwrite8(struct virtio_device *vdev,
-- 
MST

