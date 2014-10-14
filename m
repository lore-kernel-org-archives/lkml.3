Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbaJNVR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:17:29 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:57700
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbaJNVR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:17:28 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2014 17:17:28 EDT
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: [PATCH net-next,v2] hyperv: Add handling of IP header with option field in netvsc_set_hash()
Date: Tue, 14 Oct 2014 15:16:28 -0700
Message-Id: <1413324988-8863-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case that the IP header has optional field at the end, this patch will
get the port numbers after that field, and compute the hash.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 0fcb5e7..0d60c91 100644
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
@@ -191,6 +191,7 @@ static u32 comp_hash(u8 *key, int klen, u8 *data, int dlen)
 static bool netvsc_set_hash(u32 *hash, struct sk_buff *skb)
 {
 	struct iphdr *iphdr;
+	__be32 dbuf[3];
 	int data_len;
 	bool ret = false;
 
@@ -200,12 +201,15 @@ static bool netvsc_set_hash(u32 *hash, struct sk_buff *skb)
 	iphdr = ip_hdr(skb);
 
 	if (iphdr->version == 4) {
-		if (iphdr->protocol == IPPROTO_TCP)
+		dbuf[0] = iphdr->saddr;
+		dbuf[1] = iphdr->daddr;
+		if (iphdr->protocol == IPPROTO_TCP) {
+			dbuf[2] = *(__be32 *)&tcp_hdr(skb)->source;
 			data_len = 12;
-		else
+		} else {
 			data_len = 8;
-		*hash = comp_hash(netvsc_hash_key, HASH_KEYLEN,
-				  (u8 *)&iphdr->saddr, data_len);
+		}
+		*hash = comp_hash(netvsc_hash_key, HASH_KEYLEN, dbuf, data_len);
 		ret = true;
 	}
 
-- 
1.7.1

