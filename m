Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaBZSjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 13:39:06 -0500
Received: from [65.55.88.14] ([65.55.88.14]:52034 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750980AbaBZSjE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 13:39:04 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z551biz98dIc89bh936eI148cI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh906i1155h)
Date: Wed, 26 Feb 2014 10:36:42 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH RFC 1/2] net: macb: Check DMA mappings for error
References: <1393011025-18537-1-git-send-email-soren.brinkmann@xilinx.com>
 <1393011025-18537-2-git-send-email-soren.brinkmann@xilinx.com>
 <1393114393.6823.25.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1393114393.6823.25.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <bcd23902-b961-4c12-b577-29dec9b1d6d1@TX2EHSMHS010.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-23 at 12:13AM +0000, Ben Hutchings wrote:
> On Fri, 2014-02-21 at 11:30 -0800, Soren Brinkmann wrote:
> [...]
> > --- a/drivers/net/ethernet/cadence/macb.c
> > +++ b/drivers/net/ethernet/cadence/macb.c
> > @@ -632,11 +632,16 @@ static void gem_rx_refill(struct macb *bp)
> >  					   "Unable to allocate sk_buff\n");
> >  				break;
> >  			}
> > -			bp->rx_skbuff[entry] = skb;
> >  
> >  			/* now fill corresponding descriptor entry */
> >  			paddr = dma_map_single(&bp->pdev->dev, skb->data,
> >  					       bp->rx_buffer_size, DMA_FROM_DEVICE);
> > +			if (dma_mapping_error(&bp->pdev->dev, paddr)) {
> > +				dev_kfree_skb(skb);
> > +				break;
> > +			}
> > +
> > +			bp->rx_skbuff[entry] = skb;
> 
> This bit looks good.
> 
> >  			if (entry == RX_RING_SIZE - 1)
> >  				paddr |= MACB_BIT(RX_WRAP);
> > @@ -1040,6 +1045,10 @@ static int macb_start_xmit(struct sk_buff *skb, struct net_device *dev)
> >  	netdev_vdbg(bp->dev, "Allocated ring entry %u\n", entry);
> >  	mapping = dma_map_single(&bp->pdev->dev, skb->data,
> >  				 len, DMA_TO_DEVICE);
> > +	if (dma_mapping_error(&bp->pdev->dev, mapping)) {
> > +		dev_kfree_skb(skb);
> 
> You need to unlock bp->lock before returning.  Also, I think this should
> be kfree_skb(), as that can be observed through dropwatch whereas
> dev_kfree_skb() is completely silent.

I interpret Ben's comments as: This series is not utterly wrong and
wanted. I'll send a v2 with the changes Ben suggested.
Thanks for reviewing.

	Sören


