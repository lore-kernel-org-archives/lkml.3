Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaAMOjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:39:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51561 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbaAMO0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vlad Yasevich <vyasevich@gmail.com>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 79/96] macvtap: signal truncated packets
Date: Mon, 13 Jan 2014 14:24:42 +0000
Message-Id: <1389623099-18783-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit ce232ce01d61b184202bb185103d119820e1260c upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/macvtap.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index b614ab4..eec890e 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -801,7 +801,7 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 	int ret;
 	int vnet_hdr_len = 0;
 	int vlan_offset = 0;
-	int copied;
+	int copied, total;
 
 	if (q->flags & IFF_VNET_HDR) {
 		struct virtio_net_hdr vnet_hdr;
@@ -816,7 +816,8 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 		if (memcpy_toiovecend(iv, (void *)&vnet_hdr, 0, sizeof(vnet_hdr)))
 			return -EFAULT;
 	}
-	copied = vnet_hdr_len;
+	total = copied = vnet_hdr_len;
+	total += skb->len;
 
 	if (!vlan_tx_tag_present(skb))
 		len = min_t(int, skb->len, len);
@@ -831,6 +832,7 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 
 		vlan_offset = offsetof(struct vlan_ethhdr, h_vlan_proto);
 		len = min_t(int, skb->len + VLAN_HLEN, len);
+		total += VLAN_HLEN;
 
 		copy = min_t(int, vlan_offset, len);
 		ret = skb_copy_datagram_const_iovec(skb, 0, iv, copied, copy);
@@ -848,10 +850,9 @@ static ssize_t macvtap_put_user(struct macvtap_queue *q,
 	}
 
 	ret = skb_copy_datagram_const_iovec(skb, vlan_offset, iv, copied, len);
-	copied += len;
 
 done:
-	return ret ? ret : copied;
+	return ret ? ret : total;
 }
 
 static ssize_t macvtap_do_read(struct macvtap_queue *q, struct kiocb *iocb,
@@ -905,7 +906,7 @@ static ssize_t macvtap_aio_read(struct kiocb *iocb, const struct iovec *iv,
 	}
 
 	ret = macvtap_do_read(q, iocb, iv, len, file->f_flags & O_NONBLOCK);
-	ret = min_t(ssize_t, ret, len); /* XXX copied from tun.c. Why? */
+	ret = min_t(ssize_t, ret, len);
 	if (ret > 0)
 		iocb->ki_pos = ret;
 out:
-- 
1.8.3.2

