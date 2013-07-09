Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3GIKVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 06:21:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab3GIKVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 06:21:51 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH net 1/2] tuntap: correctly linearize skb when zerocopy is used
Date: Tue,  9 Jul 2013 18:10:50 +0800
Message-Id: <1373364651-10474-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
This patch is needed for stable.
---
 drivers/net/tun.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7eab5fc..01d5a86 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1109,7 +1109,8 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	} else
 		copylen = len;
 
-	skb = tun_alloc_skb(tfile, align, copylen, gso.hdr_len, noblock);
+	skb = tun_alloc_skb(tfile, align, copylen,
+			    zerocopy ? copylen : gso.hdr_len, noblock);
 	if (IS_ERR(skb)) {
 		if (PTR_ERR(skb) != -EAGAIN)
 			tun->dev->stats.rx_dropped++;
-- 
1.7.1

