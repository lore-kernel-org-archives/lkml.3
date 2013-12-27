Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab3L0RG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 12:06:26 -0500
Received: from smtprelay0233.hostedemail.com ([216.40.44.233]:38111 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753653Ab3L0RGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 12:06:25 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:3874:4321:4605:5007:7652:8603:10004:10400:10450:10455:10481:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13161:13229:13311:13357:19900:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: day23_8f077562ecc40
X-Filterd-Recvd-Size: 2531
Message-ID: <1388163982.30298.12.camel@joe-AO722>
Subject: Re: [PATCH net-next 19/20] net: plip: slight optimization of addr
 compare
From: Joe Perches <joe@perches.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, Julia Lawall <julia.lawall@lip6.fr>
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 27 Dec 2013 09:06:22 -0800
In-Reply-To: <1388159283.12212.80.camel@edumazet-glaptop2.roam.corp.google.com>
References: <52BD22ED.4030302@huawei.com>
	 <1388159283.12212.80.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-12-27 at 07:48 -0800, Eric Dumazet wrote:
> On Fri, 2013-12-27 at 14:49 +0800, Ding Tianhong wrote:
> > Use possibly more efficient ether_addr_equal
> > to instead of memcmp.
[]
> > diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
[]
> > @@ -549,7 +549,7 @@ static __be16 plip_type_trans(struct sk_buff *skb, struct net_device *dev)
> >  
> >  	if(*eth->h_dest&1)
> >  	{
> > -		if(memcmp(eth->h_dest,dev->broadcast, ETH_ALEN)==0)
> > +		if(ether_addr_equal(eth->h_dest, dev->broadcast))
> >  			skb->pkt_type=PACKET_BROADCAST;
> >  		else
> >  			skb->pkt_type=PACKET_MULTICAST;
> 
> What about :
> 
>         if (is_multicast_ether_addr(eth->h_dest)) {
>                 if (ether_addr_equal_64bits(eth->h_dest, dev->broadcast))
>                         skb->pkt_type = PACKET_BROADCAST;
>                 else
>                         skb->pkt_type = PACKET_MULTICAST;
>         }

That is better though I wonder how many systems are
still using laplink via parallel null-printer cables.

No matter, better is better.

The same optimization using ether_addr_equal_64bits
may be possible to do in other places given other
structs too.

Perhaps it's a possible spatch/coccinelle conversion,

I don't know spatch well enough to know if a
mechanism to check if structure members have other
fields that follow them in the structure or if the
structure member is an array of a minimum size.

Maybe Julia does.  (cc'd)

