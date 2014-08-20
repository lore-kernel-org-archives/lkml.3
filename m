Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaHTRKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 13:10:15 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:55910 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaHTRKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 13:10:13 -0400
Message-ID: <1408554610.5604.11.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH v5 1/2] net: moxa: clear TX descriptor length bits
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        f.fainelli@gmail.com
Date: Wed, 20 Aug 2014 10:10:10 -0700
In-Reply-To: <1408544322-32023-1-git-send-email-jonas.jensen@gmail.com>
References: <1408459784-9385-1-git-send-email-jonas.jensen@gmail.com>
	 <1408544322-32023-1-git-send-email-jonas.jensen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-20 at 16:18 +0200, Jonas Jensen wrote:
> TX buffer length is not cleared on ndo_start_xmit().
> Failing to do so can bug/hang the controller and
> cause TX interrupts to stop altogether.

> 
> diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
> index 5020fd4..aa45607 100644
> --- a/drivers/net/ethernet/moxa/moxart_ether.c
> +++ b/drivers/net/ethernet/moxa/moxart_ether.c
> @@ -348,7 +348,8 @@ static int moxart_mac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
>  
>  	txdes1 = readl(desc + TX_REG_OFFSET_DESC1);
>  	txdes1 |= TX_DESC1_LTS | TX_DESC1_FTS;
> -	txdes1 &= ~(TX_DESC1_FIFO_COMPLETE | TX_DESC1_INTR_COMPLETE);
> +	txdes1 &= ~(TX_DESC1_FIFO_COMPLETE | TX_DESC1_INTR_COMPLETE |
> +		    TX_DESC1_BUF_SIZE_MASK);
>  	txdes1 |= (len & TX_DESC1_BUF_SIZE_MASK);
>  	writel(txdes1, desc + TX_REG_OFFSET_DESC1);
>  	writel(TX_DESC0_DMA_OWN, desc + TX_REG_OFFSET_DESC0);

Wouldnt it be faster to not use readl() at all here ?

readl() is only used to get TX_DESC1_END bit.

It seems you could replace the thing by :

txdes1 = TX_DESC1_LTS | TX_DESC1_FTS | (len & TX_DESC1_BUF_SIZE_MASK);
if (tx_head == TX_DESC_NUM_MASK)
	txdes1 |= TX_DESC1_END;



