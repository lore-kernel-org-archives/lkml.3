Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaA0P0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 10:26:49 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:64185 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbaA0P0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 10:26:47 -0500
MIME-Version: 1.0
In-Reply-To: <1390834190.2735.143.camel@deadeye.wl.decadent.org.uk>
References: <1385227995-3956-1-git-send-email-alchark@gmail.com>
	<1390823503-24087-1-git-send-email-alchark@gmail.com>
	<1390823503-24087-2-git-send-email-alchark@gmail.com>
	<1390834190.2735.143.camel@deadeye.wl.decadent.org.uk>
Date: Mon, 27 Jan 2014 19:26:45 +0400
Message-ID: <CABjd4Yyq_Mia=2DkC83Wpi6o1o3m5+yoMcDL4WdZmuLvRtu6qg@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: via-rhine: switch to generic DMA functions
From: Alexey Charkov <alchark@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: netdev@vger.kernel.org, Tony Prisk <linux@prisktech.co.nz>,
        devicetree@vger.kernel.org, Roger Luethi <rl@hellgate.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/27 Ben Hutchings <ben@decadent.org.uk>:
> On Mon, 2014-01-27 at 15:51 +0400, Alexey Charkov wrote:
>> Remove legacy PCI DMA wrappers and instead use generic DMA functions
>> directly in preparation for OF bus binding
>>
>> Signed-off-by: Alexey Charkov <alchark@gmail.com>
>> Signed-off-by: Roger Luethi <rl@hellgate.ch>
>> ---
>>  drivers/net/ethernet/via/via-rhine.c | 56 +++++++++++++++++++-----------------
>>  1 file changed, 29 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
>> index ef312bc..fee8732 100644
>> --- a/drivers/net/ethernet/via/via-rhine.c
>> +++ b/drivers/net/ethernet/via/via-rhine.c
>> @@ -919,10 +919,10 @@ static int rhine_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>               goto err_out;
>>
>>       /* this should always be supported */
>> -     rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
>> +     rc = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
>>       if (rc) {
>>               dev_err(&pdev->dev,
>> -                     "32-bit PCI DMA addresses not supported by the card!?\n");
>> +                     "32-bit DMA addresses not supported by the card!?\n");
>>               goto err_out;
>>       }
>>
>> @@ -1094,20 +1094,22 @@ static int alloc_ring(struct net_device* dev)
>>       void *ring;
>>       dma_addr_t ring_dma;
>>
>> -     ring = pci_alloc_consistent(rp->pdev,
>> +     ring = dma_alloc_coherent(&rp->pdev->dev,
>>                                   RX_RING_SIZE * sizeof(struct rx_desc) +
>>                                   TX_RING_SIZE * sizeof(struct tx_desc),
>> -                                 &ring_dma);
>> +                                 &ring_dma,
>> +                                     GFP_ATOMIC);
> [...]
>
> Indentation is messed up here (and in several other function calls
> you're changing).  You should align the function arguments so each line
> begins in the column after the opening parenthesis.

Ben, thanks for pointing out. I actually just tried to follow the
style of surrounding code, but happy to adjust if that's the preferred
option. From what I can see, these lines should still fit in below 80
cols even with increased indents...

Should we then also adjust other function calls within the driver with
similar indentation (if any), that are currently not touched by this
patch series?

Thanks,
Alexey
