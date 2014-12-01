Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbaLAQFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:05:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139AbaLAQFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:05:38 -0500
Date: Mon, 1 Dec 2014 18:05:20 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v8 31/50] vhost/net: force len for TX to host endian
Message-ID: <1417449619-24896-32-git-send-email-mst@redhat.com>
References: <1417449619-24896-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417449619-24896-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vhost/net keeps a copy of the used ring in host memory but (ab)uses
the length field for internal house-keeping. This works because the
length in the used ring for tx is always 0. In order to suppress sparse
warnings, we force native endianness here.
Note that these values are never exposed to guests.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 8dae2f7..dce5c58 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -48,15 +48,15 @@ MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
  * status internally; used for zerocopy tx only.
  */
 /* Lower device DMA failed */
-#define VHOST_DMA_FAILED_LEN	3
+#define VHOST_DMA_FAILED_LEN	((__force __virtio32)3)
 /* Lower device DMA done */
-#define VHOST_DMA_DONE_LEN	2
+#define VHOST_DMA_DONE_LEN	((__force __virtio32)2)
 /* Lower device DMA in progress */
-#define VHOST_DMA_IN_PROGRESS	1
+#define VHOST_DMA_IN_PROGRESS	((__force __virtio32)1)
 /* Buffer unused */
-#define VHOST_DMA_CLEAR_LEN	0
+#define VHOST_DMA_CLEAR_LEN	((__force __virtio32)0)
 
-#define VHOST_DMA_IS_DONE(len) ((len) >= VHOST_DMA_DONE_LEN)
+#define VHOST_DMA_IS_DONE(len) ((__force u32)(len) >= (__force u32)VHOST_DMA_DONE_LEN)
 
 enum {
 	VHOST_NET_FEATURES = VHOST_FEATURES |
-- 
MST

