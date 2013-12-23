Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab3LWI2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 03:28:48 -0500
Received: from smtprelay0170.hostedemail.com ([216.40.44.170]:35727 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751190Ab3LWI2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 03:28:47 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4605:5007:7652:9121:10004:10400:10481:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13071:13161:13229:13311:13357:19900:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boats60_2f63838191f51
X-Filterd-Recvd-Size: 2285
Message-ID: <1387787324.22671.57.camel@joe-AO722>
Subject: Re: [PATCH 00/21] slight optimization of addr compare for some
 modules
From: Joe Perches <joe@perches.com>
To: Ding Tianhong <dingtianhong@huawei.com>
Cc: Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 23 Dec 2013 00:28:44 -0800
In-Reply-To: <52B7C58B.9000602@huawei.com>
References: <52B7C58B.9000602@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-23 at 13:09 +0800, Ding Tianhong wrote:
> I use the recently added and possibly more efficient
> ether_addr_equal_unaligned to instead of memcmp for slight
> optimization.

Hi again.

These are the sorts of conversions that could be
either ether_addr_equal or ether_addr_equal_unaligned
depending on the existing alignment of the addresses
being compared.

For instance, in patch 21:
---
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
[]
@@ -131,12 +131,13 @@ static inline struct pppoe_net *pppoe_pernet(struct net *net)
 
 static inline int cmp_2_addr(struct pppoe_addr *a, struct pppoe_addr *b)
 {
-	return a->sid == b->sid && !memcmp(a->remote, b->remote, ETH_ALEN);
+	return a->sid == b->sid && ether_addr_equal_unaligned(a->remote,
+		ther					      b->remote);
---

This could be ether_addr_equal instead as remote is after a be16
and so remote is aligned to a u16.

include/uapi/linux/if_pppox.h:typedef __be16 sid_t;
[]
include/uapi/linux/if_pppox.h:struct pppoe_addr {
include/uapi/linux/if_pppox.h-  sid_t         sid;                    /* Session identifier */
include/uapi/linux/if_pppox.h-  unsigned char remote[ETH_ALEN];       /* Remote address */
include/uapi/linux/if_pppox.h-  char          dev[IFNAMSIZ];          /* Local device to use */
include/uapi/linux/if_pppox.h-}; 

It's of course possible to convert the appropriate
ether_addr_equal_unaligned uses to ether_addr_equal later.

