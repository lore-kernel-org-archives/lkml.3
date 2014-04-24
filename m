Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbaDXVxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:53:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008AbaDXVxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:53:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 10/27] vhost: validate vhost_get_vq_desc return value
Date: Thu, 24 Apr 2014 14:55:44 -0700
Message-Id: <20140424215552.262522955@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140424215551.942390050@linuxfoundation.org>
References: <20140424215551.942390050@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/net.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -324,9 +324,13 @@ static int get_rx_bufs(struct vhost_virt
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


