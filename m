Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab3IKEah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26368 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab3IKE3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:06 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=0e6gR9K7iGkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=WZ6_UgRw9AIA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=COH8p13WmXq63JIno7sA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=xeakZP66ru9tOW8-:21 a=_eY4gYS8kAyocr-J:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042900.362019501@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [048/251] tuntap: correctly linearize skb when zerocopy is used
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0048-tuntap-correctly-linearize-skb-when-zerocopy-is-used.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 3dd5c3308e8b671e8e8882ba972f51cefbe9fd0d ]

Userspace may produce vectors greater than MAX_SKB_FRAGS. When we try to
linearize parts of the skb to let the rest of iov to be fit in
the frags, we need count copylen into linear when calling tun_alloc_skb()
instead of partly counting it into data_len. Since this breaks
zerocopy_sg_from_iovec() since its inner counter assumes nr_frags should
be zero at beginning. This cause nr_frags to be increased wrongly without
setting the correct frags.

This bug were introduced from 0690899b4d4501b3505be069b9a687e68ccbe15b
(tun: experimental zero copy tx support)

Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/tun.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index ef7710f..ad08dee 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -692,7 +692,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, void *msg_control,
 {
 	struct tun_pi pi = { 0, cpu_to_be16(ETH_P_IP) };
 	struct sk_buff *skb;
-	size_t len = total_len, align = NET_SKB_PAD;
+	size_t len = total_len, align = NET_SKB_PAD, linear;
 	struct virtio_net_hdr gso = { 0 };
 	int offset = 0;
 	int copylen;
@@ -755,10 +755,14 @@ static ssize_t tun_get_user(struct tun_struct *tun, void *msg_control,
 			copylen = gso.hdr_len;
 		if (!copylen)
 			copylen = GOODCOPY_LEN;
-	} else
+		linear = copylen;
+	} else {
 		copylen = len;
+		linear = gso.hdr_len;
+	}
 
 	skb = tun_alloc_skb(tun, align, copylen, gso.hdr_len, noblock);
+	skb = tun_alloc_skb(tun, align, copylen, linear, noblock);
 	if (IS_ERR(skb)) {
 		if (PTR_ERR(skb) != -EAGAIN)
 			tun->dev->stats.rx_dropped++;
-- 
1.7.10.4


