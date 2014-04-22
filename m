Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbaDVVhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:37:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36157 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812AbaDVUPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:15:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 017/133] vhost: validate vhost_get_vq_desc return value
Date: Tue, 22 Apr 2014 13:12:35 -0700
Message-Id: <1398197671-12786-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

[ Upstream commit a39ee449f96a2cd44ce056d8a0a112211a9b1a1f ]

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/vhost/net.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 836f708..2235679 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -435,9 +435,13 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
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

