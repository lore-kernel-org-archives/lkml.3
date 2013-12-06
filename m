Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422711Ab3LFWVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:21:13 -0500
Received: from smtprelay0024.hostedemail.com ([216.40.44.24]:38749 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161592Ab3LFWVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 17:21:07 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3867:3871:4321:5007:7652:7875:10004:10400:10848:11026:11473:11658:11914:12043:12114:12438:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: can27_4385bb4914d58
X-Filterd-Recvd-Size: 2543
Message-ID: <1386368461.31845.38.camel@joe-AO722>
Subject: [PATCH -next] etherdevice: Add ether_addr_equal_unaligned
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: mareklindner@neomailbox.ch, sw@simonwunderlich.de, antonio@meshcoding.com,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 06 Dec 2013 14:21:01 -0800
In-Reply-To: <20131206.163806.1555069105347405484.davem@davemloft.net>
References: <1386317890.31845.26.camel@joe-AO722>
	 <20131206.153944.1382127535160341376.davem@davemloft.net>
	 <1386364621.31845.32.camel@joe-AO722>
	 <20131206.163806.1555069105347405484.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a generic routine to test if possibly unaligned
to u16 Ethernet addresses are equal.

If CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is set,
this uses the slightly faster generic routine
ether_addr_equal, otherwise this uses memcmp.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/etherdevice.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 3526e81..eb36845 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -266,6 +266,24 @@ static inline bool ether_addr_equal_64bits(const u8 addr1[6+2],
 }
 
 /**
+ * ether_addr_equal_unaligned - Compare two not u16 aligned Ethernet addresses
+ * @addr1: Pointer to a six-byte array containing the Ethernet address
+ * @addr2: Pointer other six-byte array containing the Ethernet address
+ *
+ * Compare two Ethernet addresses, returns true if equal
+ *
+ * Please note: Use only when any Ethernet address may not be u16 aligned.
+ */
+static inline bool ether_addr_equal_unaligned(const u8 *addr1, const u8 *addr2)
+{
+#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
+	return ether_addr_equal(addr1, addr2);
+#else
+	return memcmp(addr1, addr2, ETH_ALEN) == 0;
+#endif
+}
+
+/**
  * is_etherdev_addr - Tell if given Ethernet address belongs to the device.
  * @dev: Pointer to a device structure
  * @addr: Pointer to a six-byte array containing the Ethernet address


