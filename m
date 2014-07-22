Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbaGVQj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:39:57 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:61339 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbaGVQj4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:39:56 -0400
MIME-Version: 1.0
In-Reply-To: <53CE9109.9040407@atmel.com>
References: <cover.1405689937.git.cyrille.pitchen@atmel.com>
 <f29965fee23dc0de99b388373017efeffa1aac10.1405689937.git.cyrille.pitchen@atmel.com>
 <1405697784.10255.99.camel@edumazet-glaptop2.roam.corp.google.com> <53CE9109.9040407@atmel.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 22 Jul 2014 09:39:15 -0700
Message-ID: <CAGVrzca2YWZkVkUs_c06ApXrE3hdDgbsC7-6x2M4DS-Qn6S0aQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] net/macb: add RX checksum offload feature
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, netdev <netdev@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Miller <davem@davemloft.net>, soren.brinkmann@xilinx.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-22 9:27 GMT-07:00 Cyrille Pitchen <cyrille.pitchen@atmel.com>:
> Le 18/07/2014 17:36, Eric Dumazet a écrit :
>> On Fri, 2014-07-18 at 16:21 +0200, Cyrille Pitchen wrote:
>>> Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
>>> ---
>>>  drivers/net/ethernet/cadence/macb.c | 29 ++++++++++++++++++++++++++++-
>>>  drivers/net/ethernet/cadence/macb.h |  2 ++
>>>  2 files changed, 30 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
>>> index 9bdcd1b..6acd6e2 100644
>>> --- a/drivers/net/ethernet/cadence/macb.c
>>> +++ b/drivers/net/ethernet/cadence/macb.c
>>> @@ -766,6 +766,8 @@ static int gem_rx(struct macb *bp, int budget)
>>>
>>>              skb->protocol = eth_type_trans(skb, bp->dev);
>>>              skb_checksum_none_assert(skb);
>>> +            if (bp->dev->features & NETIF_F_RXCSUM)
>>> +                    skb->ip_summed = CHECKSUM_UNNECESSARY;
>>>
>>
>>
>> Really ?
>>
>> If this is what you meant, this deserves a big and fat comment.
>>
>>
>>
> Hi Eric,
>
> Isn't it the proper way to do? According to Cadence documentation about RX checksum offload:
> "If any of the checksums (IP, TCP or UDP) are verified incorrect by the GEM, the packet is discarded."
>
> If I understand, when RX checksum offload is enabled setting bit 24 of the Network Configuration Register, the driver only receives RX frames with correct checksum. Then it tells the kernel that there's no need to verify the checksum again in software. This is done setting skb->ip_summed to CHECKSUM_UNNECESSARY. Intel e1000 driver does the same in e1000_rx_checksum() function.

This is not the same thing as what the e1000 driver is doing, the
e1000 driver is checking a per-packet status mask which tells it
whether a given packet had its protocol level checksum computed by the
HW.

I think there might be some slight confusion here between the Ethernet
frame Frame Control Checksum which is at the Ethernet level, and will
(with most adapters not supporting RX_FCS_ERR) cause the Ethernet
controller to drop frames at the MAC level, and the higher level
protocol checksums such as the TCP or UDP checksum.

>
> Also bit 24 of the Network Configuration Register is updated by macb_open() and macb_set_features() so it always matches the state of NETIF_F_RXCSUM flag in dev->features, once the network interface is up. That's why I'd rather read from dev->features than read from register.

I don't think the Cadence GEM Ethernet controller is any different
than other hardware out there, there must be a per-packet status bit
which tells whether the TCP/UDP or other protocol checksum was
successfully validated by the hardware. One of the reason for that, is
that depending on the type of traffic your receive (e.g: ARP), there
might be no protocol-level checksum at all in the packet, and the
hardware should know about that.

>
> Did I make a mistake? Is it the kind of comment you expect to be added?
>
> Regards,
>
> Cyrille
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel



-- 
Florian
