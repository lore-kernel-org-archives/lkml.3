Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbaDPKmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:42:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51758 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777AbaDPKcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 31/46] vhost: validate vhost_get_vq_desc return value
Date: Wed, 16 Apr 2014 11:31:47 +0100
Message-Id: <1397644322-13905-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit a39ee449f96a2cd44ce056d8a0a112211a9b1a1f upstream.

vhost fails to validate negative error code
from vhost_get_vq_desc causing
a crash: we are using -EFAULT which is 0xfffffff2
as vector size, which exceeds the allocated size.

The code in question was introduced in commit
8dd014adfea6f173c1ef6378f7e5e7924866c923
    vhost-net: mergeable buffers support

CVE-2014-0055

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/vhost/net.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 1284e7a..786b86d 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -510,9 +510,13 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 			r = -ENOBUFS;
 			goto err;
 		}
-		d = vhost_get_vq_desc(vq->dev, vq, vq->iov + seg,
+		r = vhost_get_vq_desc(vq->dev, vq, vq->iov + seg,
 				      ARRAY_SIZE(vq->iov) - seg, &out,
 				      &in, log, log_num);
+		if (unlikely(r < 0))
+			goto err;
+
+		d = r;
 		if (d == vq->num) {
 			r = 0;
 			goto err;
-- 
1.9.1

