Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab3LFISQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:18:16 -0500
Received: from smtprelay0196.hostedemail.com ([216.40.44.196]:55745 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751237Ab3LFISO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:18:14 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3865:3867:4419:5007:7652:7903:10004:10400:10848:11026:11473:11658:11914:12043:12438:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rose03_81d9ec035b507
X-Filterd-Recvd-Size: 1712
Message-ID: <1386317890.31845.26.camel@joe-AO722>
Subject: [PATCH -next] batadv: Slight optimization of batadv_compare_eth
From: Joe Perches <joe@perches.com>
To: Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <antonio@meshcoding.com>
Cc: "David S. Miller" <davem@davemloft.net>, b.a.t.m.a.n@lists.open-mesh.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 06 Dec 2013 00:18:10 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS to check if
this function can be optimized by using the generic
ether_addr_equal.

Remove the unnecessary ?: after the unoptimized memcmp.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/batman-adv/main.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
index f94f287b..74a7a3f 100644
--- a/net/batman-adv/main.h
+++ b/net/batman-adv/main.h
@@ -266,7 +266,11 @@ static inline void batadv_dbg(int type __always_unused,
  */
 static inline int batadv_compare_eth(const void *data1, const void *data2)
 {
-	return (memcmp(data1, data2, ETH_ALEN) == 0 ? 1 : 0);
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+	return ether_addr_equal(data1, data2);
+#else
+	return memcmp(data1, data2, ETH_ALEN) == 0;
+#endif
 }
 
 /**


