Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaAOV5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:57:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40933 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbaAOV5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:14 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vlad Yasevich <vyasevich@gmail.com>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 144/166] macvtap: signal truncated packets
Date: Wed, 15 Jan 2014 13:52:38 -0800
Message-Id: <1389822780-4729-145-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit ce232ce01d61b184202bb185103d119820e1260c ]

macvtap_put_user() never return a value grater than iov length, this in fact
bypasses the truncated checking in macvtap_recvmsg(). Fix this by always
returning the size of packet plus the possible vlan header to let the trunca
checking work.

Cc: Vlad Yasevich <vyasevich@gmail.com>
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/macvtap.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index c8c9bcc..894613c 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -808,7 +808,7 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 	int ret;
 	int vnet_hdr_len = 0;
 	int vlan_offset = 0;
-	int copied;
+	int copied, total;
 
 	if (q->flags & IFF_VNET_HDR) {
 		struct virtio_net_hdr vnet_hdr;
@@ -823,7 +823,8 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 		if (memcpy_toiovecend(iv, (void *)&vnet_hdr, 0, sizeof(vnet_hdr)))
 			return -EFAULT;
 	}
-	copied = vnet_hdr_len;
+	total = copied = vnet_hdr_len;
+	total += skb->len;
 
 	if (!vlan_tx_tag_present(skb))
 		len = min_t(int, skb->len, len);
@@ -838,6 +839,7 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 
 		vlan_offset = offsetof(struct vlan_ethhdr, h_vlan_proto);
 		len = min_t(int, skb->len + VLAN_HLEN, len);
+		total += VLAN_HLEN;
 
 		copy = min_t(int, vlan_offset, len);
 		ret = skb_copy_datagram_const_iovec(skb, 0, iv, copied, copy);
@@ -855,10 +857,9 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 	}
 
 	ret = skb_copy_datagram_const_iovec(skb, vlan_offset, iv, copied, len);
-	copied += len;
 
 done:
-	return ret ? ret : copied;
+	return ret ? ret : total;
 }
 
 static ssize_t macvtap_do_read(struct macvtap_queue *q, struct kiocb *iocb,
@@ -910,7 +911,7 @@ static ssize_t macvtap_aio_read(struct kiocb *iocb, const struct iovec *iv,
 	}
 
 	ret = macvtap_do_read(q, iocb, iv, len, file->f_flags & O_NONBLOCK);
-	ret = min_t(ssize_t, ret, len); /* XXX copied from tun.c. Why? */
+	ret = min_t(ssize_t, ret, len);
 	if (ret > 0)
 		iocb->ki_pos = ret;
 out:
-- 
1.8.3.2

