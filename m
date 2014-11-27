Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbaK0MkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:40:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588AbaK0Mcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:32:46 -0500
Date: Thu, 27 Nov 2014 14:32:29 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v5 29/45] vhost/net: force len for TX to host endian
Message-ID: <1417091078-24611-30-git-send-email-mst@redhat.com>
References: <1417091078-24611-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417091078-24611-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vhost/net keeps a copy of some used ring but (ab)uses length
field for internal house-keeping. This works because
for tx used length is always 0.
Suppress sparse errors: we use native endian-ness internally but never
expose it to guest.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
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

