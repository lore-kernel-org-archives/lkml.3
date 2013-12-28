Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab3L1RXG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 12:23:06 -0500
Received: from smtprelay0147.hostedemail.com ([216.40.44.147]:58632 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755432Ab3L1RXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 12:23:04 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:152:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:1801:2194:2199:2393:2559:2562:2914:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3871:3872:3873:4250:4304:4321:4605:5007:7652:8957:10004:10400:10481:10848:11026:11232:11657:11658:11783:11914:12043:12296:12438:12517:12519:12555:12740:13160:13229:13894:19900:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: maid59_378a10bbc3a05
X-Filterd-Recvd-Size: 4055
Message-ID: <1388251380.24123.15.camel@joe-AO722>
Subject: Re: [PATCH net-next v2 11/20] net: packetengines: slight
 optimization of addr
From: Joe Perches <joe@perches.com>
To: Ding Tianhong <dthxman@gmail.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 28 Dec 2013 09:23:00 -0800
In-Reply-To: <52BEEBD5.1040301@gmail.com>
References: <52BE6D0D.9050301@huawei.com>
	 <52BED8ED.2040908@cogentembedded.com> <52BEEBD5.1040301@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-28 at 23:18 +0800, Ding Tianhong wrote:
> 于 2013/12/28 21:58, Sergei Shtylyov 写道:
> > Hello.
> > 
> > On 28-12-2013 10:17, Ding Tianhong wrote:
> > 
> >> Use possibly more efficient ether_addr_equal
> >> to instead of memcmp.
> > 
> >> Cc: "David S. Miller" <davem@davemloft.net>
> >> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
> >> ---
> >>   drivers/net/ethernet/packetengines/yellowfin.c |   12 ++++++------
> >>   1 files changed, 6 insertions(+), 6 deletions(-)
> > 
> >> diff --git a/drivers/net/ethernet/packetengines/yellowfin.c b/drivers/net/ethernet/packetengines/yellowfin.c
> >> index d28593b..b83ac0e 100644
> >> --- a/drivers/net/ethernet/packetengines/yellowfin.c
> >> +++ b/drivers/net/ethernet/packetengines/yellowfin.c
> >> @@ -1097,12 +1097,12 @@ static int yellowfin_rx(struct net_device *dev)
> >>               if (status2 & 0x80) dev->stats.rx_dropped++;
> >>   #ifdef YF_PROTOTYPE        /* Support for prototype hardware errata. */
> >>           } else if ((yp->flags & HasMACAddrBug)  &&
> >> -            memcmp(le32_to_cpu(yp->rx_ring_dma +
> >> -                entry*sizeof(struct yellowfin_desc)),
> >> -                dev->dev_addr, 6) != 0 &&
> >> -            memcmp(le32_to_cpu(yp->rx_ring_dma +
> >> -                entry*sizeof(struct yellowfin_desc)),
> >> -                "\377\377\377\377\377\377", 6) != 0) {
> >> +            !ether_addr_equal(le32_to_cpu(yp->rx_ring_dma +
> >> +                              entry * sizeof(struct yellowfin_desc)),
> >> +                              dev->dev_addr) &&
> > 
> >    Previous line was aligned correctly, the above line should start under le32_to_cpu.
> > 
> >> +            !ether_addr_equal(le32_to_cpu(yp->rx_ring_dma +
> >> +                              entry * sizeof(struct yellowfin_desc)),
> > 
> >    Start the continuation lines under 'yp', please.
> > 
> >> +                              "\377\377\377\377\377\377")) {
> > 
> >    This line should start under le32_to_cpu.
> > 
> > WBR, Sergei
> > 
> 
> Hi sergei:
> you mean this way?
> 	!ether_addr_equal(le32_to_cpu(yp->rx_ring_dma +
> 				      entry * sizeof(struct yellowfin_desc)),
> 			  dev->dev_addr) &&
> 
> 	!ether_addr_equal(le32_to_cpu(yp->rx_ring_dma +
> 				      entry * sizeof(struct yellowfin_desc)),
> 			  "\377\377\377\377\377\377")) {

Does this really matter?
Does anyone have a packetengine NIC anymore?

\377 octal is 0xff, so this is matching a broadcast address.
is_broadcast_ether_addr(addr) would be appropriate.

So would using a temporary address.

u8 *addr = (u8 *)(unsigned long)le32_to_cpu(etc)

but the whole thing looks very suspect as an le32
value could not be added to correctly on a
big-endian arch anyway.

My guess is this was tested only on an x86 and
it should be:

	u8 *addr = (u8 *)(unsigned long)(le32_to_cpu(yp->rx_ring_dma) +
					 entry * sizeof(struct yellowfin_desc));

It maybe better just to leave these two alone.

