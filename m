Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162592Ab3LFXo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:44:28 -0500
Received: from smtprelay0185.hostedemail.com ([216.40.44.185]:57603 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161471Ab3LFXoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:44:25 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2691:2828:2902:3138:3139:3140:3141:3142:3355:3865:3866:3867:3868:3871:4321:5007:7652:7903:7904:10004:10400:10481:10848:11026:11473:11658:11914:12043:12291:12438:12517:12519:12555:13101:13200:13229:19900,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bells57_4379009bf1c03
X-Filterd-Recvd-Size: 3939
Message-ID: <1386373461.31845.50.camel@joe-AO722>
Subject: [PATCH -next] etherdevice: Optimize a few is_<foo>_ether_addr
 functions
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 06 Dec 2013 15:44:21 -0800
In-Reply-To: <1386368461.31845.38.camel@joe-AO722>
References: <1386317890.31845.26.camel@joe-AO722>
	 <20131206.153944.1382127535160341376.davem@davemloft.net>
	 <1386364621.31845.32.camel@joe-AO722>
	 <20131206.163806.1555069105347405484.davem@davemloft.net>
	 <1386368461.31845.38.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is set,
several is_<foo>_ether_addr functions can be slightly
improved by using u32 dereferences.

I believe all current uses of is_zero_ether_addr and
is_broadcast_ether_addr are u16 aligned, so always use
u16 references to improve those functions performance.

Document the u16 alignment requirements.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/etherdevice.h | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 3526e81..9518e59 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -61,6 +61,8 @@ static const u8 eth_reserved_addr_base[ETH_ALEN] __aligned(2) =
  *
  * Return true if address is link local reserved addr (01:80:c2:00:00:0X) per
  * IEEE 802.1Q 8.6.3 Frame filtering.
+ *
+ * Please note: addr must be aligned to u16.
  */
 static inline bool is_link_local_ether_addr(const u8 *addr)
 {
@@ -68,7 +70,12 @@ static inline bool is_link_local_ether_addr(const u8 *addr)
 	static const __be16 *b = (const __be16 *)eth_reserved_addr_base;
 	static const __be16 m = cpu_to_be16(0xfff0);
 
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+	return (((*(const u32 *)addr) ^ (*(const u32 *)b)) |
+		((a[2] ^ b[2]) & m)) == 0;
+#else
 	return ((a[0] ^ b[0]) | (a[1] ^ b[1]) | ((a[2] ^ b[2]) & m)) == 0;
+#endif
 }
 
 /**
@@ -76,10 +83,18 @@ static inline bool is_link_local_ether_addr(const u8 *addr)
  * @addr: Pointer to a six-byte array containing the Ethernet address
  *
  * Return true if the address is all zeroes.
+ *
+ * Please note: addr must be aligned to u16.
  */
 static inline bool is_zero_ether_addr(const u8 *addr)
 {
-	return !(addr[0] | addr[1] | addr[2] | addr[3] | addr[4] | addr[5]);
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+	return ((*(const u32 *)addr) | (*(const u16 *)(addr + 4))) == 0;
+#else
+	return (*(const u16 *)(addr + 0) |
+		*(const u16 *)(addr + 2) |
+		*(const u16 *)(addr + 4)) == 0;
+#endif
 }
 
 /**
@@ -110,10 +125,14 @@ static inline bool is_local_ether_addr(const u8 *addr)
  * @addr: Pointer to a six-byte array containing the Ethernet address
  *
  * Return true if the address is the broadcast address.
+ *
+ * Please note: addr must be aligned to u16.
  */
 static inline bool is_broadcast_ether_addr(const u8 *addr)
 {
-	return (addr[0] & addr[1] & addr[2] & addr[3] & addr[4] & addr[5]) == 0xff;
+	return (*(const u16 *)(addr + 0) &
+		*(const u16 *)(addr + 2) &
+		*(const u16 *)(addr + 4)) == 0xffff;
 }
 
 /**
@@ -135,6 +154,8 @@ static inline bool is_unicast_ether_addr(const u8 *addr)
  * a multicast address, and is not FF:FF:FF:FF:FF:FF.
  *
  * Return true if the address is valid.
+ *
+ * Please note: addr must be aligned to u16.
  */
 static inline bool is_valid_ether_addr(const u8 *addr)
 {


