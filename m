Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934039AbaGVW6k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:58:40 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:41656 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933436AbaGVW6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:58:36 -0400
Message-ID: <1406069908.3363.7.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 4/6] net/macb: add RX checksum offload feature
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Cc: nicolas.ferre@atmel.com, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        soren.brinkmann@xilinx.com, linux-kernel@vger.kernel.org
Date: Wed, 23 Jul 2014 00:58:28 +0200
In-Reply-To: <53CE9109.9040407@atmel.com>
References: <cover.1405689937.git.cyrille.pitchen@atmel.com>
		 <f29965fee23dc0de99b388373017efeffa1aac10.1405689937.git.cyrille.pitchen@atmel.com>
	 <1405697784.10255.99.camel@edumazet-glaptop2.roam.corp.google.com>
	 <53CE9109.9040407@atmel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-22 at 18:27 +0200, Cyrille Pitchen wrote:
> Le 18/07/2014 17:36, Eric Dumazet a écrit :
> > On Fri, 2014-07-18 at 16:21 +0200, Cyrille Pitchen wrote:
> >> Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
> >> ---
> >>  drivers/net/ethernet/cadence/macb.c | 29 ++++++++++++++++++++++++++++-
> >>  drivers/net/ethernet/cadence/macb.h |  2 ++
> >>  2 files changed, 30 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> >> index 9bdcd1b..6acd6e2 100644
> >> --- a/drivers/net/ethernet/cadence/macb.c
> >> +++ b/drivers/net/ethernet/cadence/macb.c
> >> @@ -766,6 +766,8 @@ static int gem_rx(struct macb *bp, int budget)
> >>  
> >>  		skb->protocol = eth_type_trans(skb, bp->dev);
> >>  		skb_checksum_none_assert(skb);
> >> +		if (bp->dev->features & NETIF_F_RXCSUM)
> >> +			skb->ip_summed = CHECKSUM_UNNECESSARY;
> >>  
> > 
> > 
> > Really ?
> > 
> > If this is what you meant, this deserves a big and fat comment.
> > 
> > 
> > 
> Hi Eric,
> 
> Isn't it the proper way to do? According to Cadence documentation
> about RX checksum offload:
> "If any of the checksums (IP, TCP or UDP) are verified incorrect by
> the GEM, the packet is discarded."
> 
> If I understand, when RX checksum offload is enabled setting bit 24 of
> the Network Configuration Register, the driver only receives RX frames
> with correct checksum. Then it tells the kernel that there's no need
> to verify the checksum again in software. This is done setting
> skb->ip_summed to CHECKSUM_UNNECESSARY. Intel e1000 driver does the
> same in e1000_rx_checksum() function.
> 
> Also bit 24 of the Network Configuration Register is updated by
> macb_open() and macb_set_features() so it always matches the state of
> NETIF_F_RXCSUM flag in dev->features, once the network interface is
> up. That's why I'd rather read from dev->features than read from
> register.
> 
> Did I make a mistake? Is it the kind of comment you expect to be
> added?
> 
> Regards,

Usually, frames are not discarded, and a bit is present in rx descriptor
to tell us if (TCP) checksum was validated by the NIC

We want tcpdump to get a copy of corrupted TCP frames, even if TCP stack
drops them later.

If this NIC drops incorrect frames, I am afraid we cant use this RX
offload at all.



