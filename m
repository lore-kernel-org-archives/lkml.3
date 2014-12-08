Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbaLHKTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:19:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51501 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaLHKTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:19:43 -0500
Date: Mon, 8 Dec 2014 10:19:36 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Zoltan Kiss <zoltan.kiss@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Durrant <paul.durrant@citrix.com>,
        xen-devel@lists.xenproject.org, Kamal Mostafa <kamal@canonical.com>
Subject: Re: [Xen-devel] [PATCH] xen-netfront: Fix handling packets on
 compound pages with skb_linearize
Message-ID: <20141208101936.GA7491@hercules>
References: <1407778343-13622-1-git-send-email-zoltan.kiss@citrix.com>
 <547C2CFC.7060908@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547C2CFC.7060908@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 09:55:24AM +0100, Stefan Bader wrote:
> On 11.08.2014 19:32, Zoltan Kiss wrote:
> > There is a long known problem with the netfront/netback interface: if the guest
> > tries to send a packet which constitues more than MAX_SKB_FRAGS + 1 ring slots,
> > it gets dropped. The reason is that netback maps these slots to a frag in the
> > frags array, which is limited by size. Having so many slots can occur since
> > compound pages were introduced, as the ring protocol slice them up into
> > individual (non-compound) page aligned slots. The theoretical worst case
> > scenario looks like this (note, skbs are limited to 64 Kb here):
> > linear buffer: at most PAGE_SIZE - 17 * 2 bytes, overlapping page boundary,
> > using 2 slots
> > first 15 frags: 1 + PAGE_SIZE + 1 bytes long, first and last bytes are at the
> > end and the beginning of a page, therefore they use 3 * 15 = 45 slots
> > last 2 frags: 1 + 1 bytes, overlapping page boundary, 2 * 2 = 4 slots
> > Although I don't think this 51 slots skb can really happen, we need a solution
> > which can deal with every scenario. In real life there is only a few slots
> > overdue, but usually it causes the TCP stream to be blocked, as the retry will
> > most likely have the same buffer layout.
> > This patch solves this problem by linearizing the packet. This is not the
> > fastest way, and it can fail much easier as it tries to allocate a big linear
> > area for the whole packet, but probably easier by an order of magnitude than
> > anything else. Probably this code path is not touched very frequently anyway.
> > 
> > Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> > Cc: Wei Liu <wei.liu2@citrix.com>
> > Cc: Ian Campbell <Ian.Campbell@citrix.com>
> > Cc: Paul Durrant <paul.durrant@citrix.com>
> > Cc: netdev@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: xen-devel@lists.xenproject.org
> 
> This does not seem to be marked explicitly as stable. Has someone already asked
> David Miller to put it on his stable queue? IMO it qualifies quite well and the
> actual change should be simple to pick/backport.
> 

Thank you Stefan, I'm queuing this for the next 3.16 kernel release.

Cheers,
--
Luís

> -Stefan
> 
> > 
> > diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> > index 055222b..23359ae 100644
> > --- a/drivers/net/xen-netfront.c
> > +++ b/drivers/net/xen-netfront.c
> > @@ -628,9 +628,10 @@ static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
> >  	slots = DIV_ROUND_UP(offset + len, PAGE_SIZE) +
> >  		xennet_count_skb_frag_slots(skb);
> >  	if (unlikely(slots > MAX_SKB_FRAGS + 1)) {
> > -		net_alert_ratelimited(
> > -			"xennet: skb rides the rocket: %d slots\n", slots);
> > -		goto drop;
> > +		net_dbg_ratelimited("xennet: skb rides the rocket: %d slots, %d bytes\n",
> > +				    slots, skb->len);
> > +		if (skb_linearize(skb))
> > +			goto drop;
> >  	}
> >  
> >  	spin_lock_irqsave(&queue->tx_lock, flags);
> > 
> > _______________________________________________
> > Xen-devel mailing list
> > Xen-devel@lists.xen.org
> > http://lists.xen.org/xen-devel
> > 
> 
> 


