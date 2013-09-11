Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3IKEaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12659 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab3IKE3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:06 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=RRh5V6v78Y4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ls4hAc3YJ3cA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=COH8p13WmXq63JIno7sA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=YkVESfF7KhISncSb:21 a=nlVjDGyBJ5oYXQNa:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042900.524278953@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [049/251] macvtap: correctly linearize skb when zerocopy is used
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0049-macvtap-correctly-linearize-skb-when-zerocopy-is-use.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 61d46bf979d5cd7c164709a80ad5676a35494aae ]

Userspace may produce vectors greater than MAX_SKB_FRAGS. When we try to
linearize parts of the skb to let the rest of iov to be fit in
the frags, we need count copylen into linear when calling macvtap_alloc_skb()
instead of partly counting it into data_len. Since this breaks
zerocopy_sg_from_iovec() since its inner counter assumes nr_frags should
be zero at beginning. This cause nr_frags to be increased wrongly without
setting the correct frags.

This bug were introduced from b92946e2919134ebe2a4083e4302236295ea2a73
(macvtap: zerocopy: validate vectors before building skb).

Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/macvtap.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 0f0f9ce..28c8ad9 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -656,6 +656,7 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
 	int vnet_hdr_len = 0;
 	int copylen = 0;
 	bool zerocopy = false;
+	size_t linear;
 
 	if (q->flags & IFF_VNET_HDR) {
 		vnet_hdr_len = q->vnet_hdr_sz;
@@ -710,11 +711,14 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
 			copylen = vnet_hdr.hdr_len;
 		if (!copylen)
 			copylen = GOODCOPY_LEN;
-	} else
+		linear = copylen;
+	} else {
 		copylen = len;
+		linear = vnet_hdr.hdr_len;
+	}
 
 	skb = macvtap_alloc_skb(&q->sk, NET_IP_ALIGN, copylen,
-				vnet_hdr.hdr_len, noblock, &err);
+				linear, noblock, &err);
 	if (!skb)
 		goto err;
 
-- 
1.7.10.4


