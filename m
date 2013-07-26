Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760664Ab3GZVgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:36:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759934Ab3GZUse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 23/79] tuntap: correctly linearize skb when zerocopy is used
Date: Fri, 26 Jul 2013 13:47:13 -0700
Message-Id: <20130726204724.377912151@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1044,7 +1044,7 @@ static ssize_t tun_get_user(struct tun_s
 {
 	struct tun_pi pi = { 0, cpu_to_be16(ETH_P_IP) };
 	struct sk_buff *skb;
-	size_t len = total_len, align = NET_SKB_PAD;
+	size_t len = total_len, align = NET_SKB_PAD, linear;
 	struct virtio_net_hdr gso = { 0 };
 	int offset = 0;
 	int copylen;
@@ -1108,10 +1108,13 @@ static ssize_t tun_get_user(struct tun_s
 			copylen = gso.hdr_len;
 		if (!copylen)
 			copylen = GOODCOPY_LEN;
-	} else
+		linear = copylen;
+	} else {
 		copylen = len;
+		linear = gso.hdr_len;
+	}
 
-	skb = tun_alloc_skb(tfile, align, copylen, gso.hdr_len, noblock);
+	skb = tun_alloc_skb(tfile, align, copylen, linear, noblock);
 	if (IS_ERR(skb)) {
 		if (PTR_ERR(skb) != -EAGAIN)
 			tun->dev->stats.rx_dropped++;


