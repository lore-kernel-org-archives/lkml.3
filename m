Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab3LJGHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:07:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705Ab3LJGHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:07:53 -0500
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Vlad Yasevich <vyasevich@gmail.com>
Subject: [PATCH net V2 1/2] tun: unbreak truncated packet signalling
Date: Tue, 10 Dec 2013 13:49:45 +0800
Message-Id: <1386654586-18151-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6680ec68eff47d36f67b4351bc9836fd6cba9532
(tuntap: hardware vlan tx support) breaks the truncated packet signal by nev
return a length greater than iov length in tun_put_user(). This patch fixes
by always return the length of packet plus possible vlan header. Caller can
detect the truncated packet by comparing the return value and the size of io
length.

Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes from v1:
- increase total unconditionally
- do not move veth structure out of the vlan handing block
---
 drivers/net/tun.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index e26cbea..cd142134 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1184,7 +1184,7 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 {
 	struct tun_pi pi = { 0, skb->protocol };
 	ssize_t total = 0;
-	int vlan_offset = 0;
+	int vlan_offset = 0, offset;
 
 	if (!(tun->flags & TUN_NO_PI)) {
 		if ((len -= sizeof(pi)) < 0)
@@ -1248,6 +1248,8 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 		total += tun->vnet_hdr_sz;
 	}
 
+	offset = total;
+	total += skb->len;
 	if (!vlan_tx_tag_present(skb)) {
 		len = min_t(int, skb->len, len);
 	} else {
@@ -1262,24 +1264,24 @@ static ssize_t tun_put_user(struct tun_struct *tun,
 
 		vlan_offset = offsetof(struct vlan_ethhdr, h_vlan_proto);
 		len = min_t(int, skb->len + VLAN_HLEN, len);
+		total += VLAN_HLEN;
 
 		copy = min_t(int, vlan_offset, len);
-		ret = skb_copy_datagram_const_iovec(skb, 0, iv, total, copy);
+		ret = skb_copy_datagram_const_iovec(skb, 0, iv, offset, copy);
 		len -= copy;
-		total += copy;
+		offset += copy;
 		if (ret || !len)
 			goto done;
 
 		copy = min_t(int, sizeof(veth), len);
-		ret = memcpy_toiovecend(iv, (void *)&veth, total, copy);
+		ret = memcpy_toiovecend(iv, (void *)&veth, offset, copy);
 		len -= copy;
-		total += copy;
+		offset += copy;
 		if (ret || !len)
 			goto done;
 	}
 
-	skb_copy_datagram_const_iovec(skb, vlan_offset, iv, total, len);
-	total += len;
+	skb_copy_datagram_const_iovec(skb, vlan_offset, iv, offset, len);
 
 done:
 	tun->dev->stats.tx_packets++;
-- 
1.8.3.2

