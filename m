Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaJPUlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:41:23 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:52454
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbaJPUlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:41:22 -0400
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: [PATCH net-next,v3] hyperv: Add handling of IP header with option field in netvsc_set_hash()
Date: Thu, 16 Oct 2014 14:47:58 -0700
Message-Id: <1413496078-25066-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case that the IP header has optional field at the end, this patch will
get the port numbers after that field, and compute the hash. The general
parser skb_flow_dissect() is used here.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 0fcb5e7..9e17d1a 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -162,7 +162,7 @@ union sub_key {
  * data: network byte order
  * return: host byte order
  */
-static u32 comp_hash(u8 *key, int klen, u8 *data, int dlen)
+static u32 comp_hash(u8 *key, int klen, void *data, int dlen)
 {
 	union sub_key subk;
 	int k_next = 4;
@@ -176,7 +176,7 @@ static u32 comp_hash(u8 *key, int klen, u8 *data, int dlen)
 	for (i = 0; i < dlen; i++) {
 		subk.kb = key[k_next];
 		k_next = (k_next + 1) % klen;
-		dt = data[i];
+		dt = ((u8 *)data)[i];
 		for (j = 0; j < 8; j++) {
 			if (dt & 0x80)
 				ret ^= subk.ka;
@@ -190,26 +190,20 @@ static u32 comp_hash(u8 *key, int klen, u8 *data, int dlen)
 
 static bool netvsc_set_hash(u32 *hash, struct sk_buff *skb)
 {
-	struct iphdr *iphdr;
+	struct flow_keys flow;
 	int data_len;
-	bool ret = false;
 
-	if (eth_hdr(skb)->h_proto != htons(ETH_P_IP))
+	if (!skb_flow_dissect(skb, &flow) || flow.n_proto != htons(ETH_P_IP))
 		return false;
 
-	iphdr = ip_hdr(skb);
+	if (flow.ip_proto == IPPROTO_TCP)
+		data_len = 12;
+	else
+		data_len = 8;
 
-	if (iphdr->version == 4) {
-		if (iphdr->protocol == IPPROTO_TCP)
-			data_len = 12;
-		else
-			data_len = 8;
-		*hash = comp_hash(netvsc_hash_key, HASH_KEYLEN,
-				  (u8 *)&iphdr->saddr, data_len);
-		ret = true;
-	}
+	*hash = comp_hash(netvsc_hash_key, HASH_KEYLEN, &flow, data_len);
 
-	return ret;
+	return true;
 }
 
 static u16 netvsc_select_queue(struct net_device *ndev, struct sk_buff *skb,
-- 
1.7.1

