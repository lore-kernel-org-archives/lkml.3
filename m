Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaLPNGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 08:06:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbaLPNF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 08:05:26 -0500
Date: Tue, 16 Dec 2014 15:05:10 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Wang <jasowang@redhat.com>, Tom Herbert <therbert@google.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/5] macvtap: drop broken IFF_VNET_LE
Message-ID: <1418732988-3535-5-git-send-email-mst@redhat.com>
References: <1418732988-3535-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418732988-3535-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use TUNSETVNETLE/TUNGETVNETLE instead.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/macvtap.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index de88285..f1f0df1 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -45,16 +45,18 @@ struct macvtap_queue {
 	struct list_head next;
 };
 
-#define MACVTAP_FEATURES (IFF_VNET_HDR | IFF_VNET_LE | IFF_MULTI_QUEUE)
+#define MACVTAP_FEATURES (IFF_VNET_HDR | IFF_MULTI_QUEUE)
+
+#define MACVTAP_VNET_LE 0x80000000
 
 static inline u16 macvtap16_to_cpu(struct macvtap_queue *q, __virtio16 val)
 {
-	return __virtio16_to_cpu(q->flags & IFF_VNET_LE, val);
+	return __virtio16_to_cpu(q->flags & MACVTAP_VNET_LE, val);
 }
 
 static inline __virtio16 cpu_to_macvtap16(struct macvtap_queue *q, u16 val)
 {
-	return __cpu_to_virtio16(q->flags & IFF_VNET_LE, val);
+	return __cpu_to_virtio16(q->flags & MACVTAP_VNET_LE, val);
 }
 
 static struct proto macvtap_proto = {
@@ -1082,6 +1084,21 @@ static long macvtap_ioctl(struct file *file, unsigned int cmd,
 		q->vnet_hdr_sz = s;
 		return 0;
 
+	case TUNGETVNETLE:
+		s = !!(q->flags & MACVTAP_VNET_LE);
+		if (put_user(s, sp))
+			return -EFAULT;
+		return 0;
+
+	case TUNSETVNETLE:
+		if (get_user(s, sp))
+			return -EFAULT;
+		if (s)
+			q->flags |= MACVTAP_VNET_LE;
+		else
+			q->flags &= ~MACVTAP_VNET_LE;
+		return 0;
+
 	case TUNSETOFFLOAD:
 		/* let the user check for future flags */
 		if (arg & ~(TUN_F_CSUM | TUN_F_TSO4 | TUN_F_TSO6 |
-- 
MST

