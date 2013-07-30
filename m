Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab3G3SuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:50:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56695 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab3G3Ss6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:48:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 63/75] tuntap: correctly linearize skb when zerocopy is used
Date: Tue, 30 Jul 2013 11:45:07 -0700
Message-Id: <1375209919-1768-30-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/tun.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 2a56317..0ebfa18 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1045,7 +1045,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 {
 	struct tun_pi pi = { 0, cpu_to_be16(ETH_P_IP) };
 	struct sk_buff *skb;
-	size_t len = total_len, align = NET_SKB_PAD;
+	size_t len = total_len, align = NET_SKB_PAD, linear;
 	struct virtio_net_hdr gso = { 0 };
 	int offset = 0;
 	int copylen;
@@ -1109,10 +1109,13 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
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
-- 
1.8.1.2

