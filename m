Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867AbaJWT77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:59:59 -0400
Received: from mail.kernel.org ([198.145.19.201]:48315 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129AbaJWT74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:59:56 -0400
Date: Thu, 23 Oct 2014 23:03:27 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Jason Wang <jasowang@redhat.com>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Tom Herbert <therbert@google.com>, Masatake YAMATO <yamato@redhat.com>,
        Xi Wang <xii@google.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, cornelia.huck@de.ibm.com
Subject: [PATCH RFC] tun: fix sparse warnings for virtio headers
Message-ID: <1414094496-26646-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.0.0.545.gd9cabeb
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: stub out endian-ness conversion for now.
We'll add a flag to control it for BE guests later.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

This will be needed once __virtio16 typedefs come in.

 drivers/net/tun.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 186ce54..ee27ecb 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1043,10 +1043,10 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 			return -EFAULT;
 
 		if ((gso.flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
-		    gso.csum_start + gso.csum_offset + 2 > gso.hdr_len)
-			gso.hdr_len = gso.csum_start + gso.csum_offset + 2;
+		    __virtio16_to_cpu(false, gso.csum_start) + __virtio16_to_cpu(false, gso.csum_offset) + 2 > __virtio16_to_cpu(false, gso.hdr_len))
+			gso.hdr_len = __cpu_to_virtio16(false, __virtio16_to_cpu(false, gso.csum_start) + __virtio16_to_cpu(false, gso.csum_offset) + 2);
 
-		if (gso.hdr_len > len)
+		if (__virtio16_to_cpu(false, gso.hdr_len) > len)
 			return -EINVAL;
 		offset += tun->vnet_hdr_sz;
 	}
@@ -1054,7 +1054,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	if ((tun->flags & TUN_TYPE_MASK) == TUN_TAP_DEV) {
 		align += NET_IP_ALIGN;
 		if (unlikely(len < ETH_HLEN ||
-			     (gso.hdr_len && gso.hdr_len < ETH_HLEN)))
+			     (gso.hdr_len && __virtio16_to_cpu(false, gso.hdr_len) < ETH_HLEN)))
 			return -EINVAL;
 	}
 
@@ -1065,7 +1065,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		 * enough room for skb expand head in case it is used.
 		 * The rest of the buffer is mapped from userspace.
 		 */
-		copylen = gso.hdr_len ? gso.hdr_len : GOODCOPY_LEN;
+		copylen = gso.hdr_len ? __virtio16_to_cpu(false, gso.hdr_len) : GOODCOPY_LEN;
 		if (copylen > good_linear)
 			copylen = good_linear;
 		linear = copylen;
@@ -1075,10 +1075,10 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 	if (!zerocopy) {
 		copylen = len;
-		if (gso.hdr_len > good_linear)
+		if (__virtio16_to_cpu(false, gso.hdr_len) > good_linear)
 			linear = good_linear;
 		else
-			linear = gso.hdr_len;
+			linear = __virtio16_to_cpu(false, gso.hdr_len);
 	}
 
 	skb = tun_alloc_skb(tfile, align, copylen, linear, noblock);
@@ -1105,8 +1105,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	}
 
 	if (gso.flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
-		if (!skb_partial_csum_set(skb, gso.csum_start,
-					  gso.csum_offset)) {
+		if (!skb_partial_csum_set(skb, __virtio16_to_cpu(false, gso.csum_start),
+					  __virtio16_to_cpu(false, gso.csum_offset))) {
 			tun->dev->stats.rx_frame_errors++;
 			kfree_skb(skb);
 			return -EINVAL;
@@ -1160,7 +1160,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		if (gso.gso_type & VIRTIO_NET_HDR_GSO_ECN)
 			skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_ECN;
 
-		skb_shinfo(skb)->gso_size = gso.gso_size;
+		skb_shinfo(skb)->gso_size = __virtio16_to_cpu(false, gso.gso_size);
 		if (skb_shinfo(skb)->gso_size == 0) {
 			tun->dev->stats.rx_frame_errors++;
 			kfree_skb(skb);
@@ -1245,8 +1245,8 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 			struct skb_shared_info *sinfo = skb_shinfo(skb);
 
 			/* This is a hint as to how much should be linear. */
-			gso.hdr_len = skb_headlen(skb);
-			gso.gso_size = sinfo->gso_size;
+			gso.hdr_len = __cpu_to_virtio16(false, skb_headlen(skb));
+			gso.gso_size = __cpu_to_virtio16(false, sinfo->gso_size);
 			if (sinfo->gso_type & SKB_GSO_TCPV4)
 				gso.gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
 			else if (sinfo->gso_type & SKB_GSO_TCPV6)
@@ -1256,12 +1256,12 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 			else {
 				pr_err("unexpected GSO type: "
 				       "0x%x, gso_size %d, hdr_len %d\n",
-				       sinfo->gso_type, gso.gso_size,
-				       gso.hdr_len);
+				       sinfo->gso_type, __virtio16_to_cpu(false, gso.gso_size),
+				       __virtio16_to_cpu(false, gso.hdr_len));
 				print_hex_dump(KERN_ERR, "tun: ",
 					       DUMP_PREFIX_NONE,
 					       16, 1, skb->head,
-					       min((int)gso.hdr_len, 64), true);
+					       min((int)__virtio16_to_cpu(false, gso.hdr_len), 64), true);
 				WARN_ON_ONCE(1);
 				return -EINVAL;
 			}
@@ -1272,8 +1272,8 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 
 		if (skb->ip_summed == CHECKSUM_PARTIAL) {
 			gso.flags = VIRTIO_NET_HDR_F_NEEDS_CSUM;
-			gso.csum_start = skb_checksum_start_offset(skb);
-			gso.csum_offset = skb->csum_offset;
+			gso.csum_start = __cpu_to_virtio16(false, skb_checksum_start_offset(skb));
+			gso.csum_offset = __cpu_to_virtio16(false, skb->csum_offset);
 		} else if (skb->ip_summed == CHECKSUM_UNNECESSARY) {
 			gso.flags = VIRTIO_NET_HDR_F_DATA_VALID;
 		} /* else everything is zero */
-- 
MST
