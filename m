Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbaHUVoC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 17:44:02 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:35001 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbaHUVn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 17:43:59 -0400
MIME-Version: 1.0
In-Reply-To: <1408459784-9385-2-git-send-email-jonas.jensen@gmail.com>
References: <1408459784-9385-1-git-send-email-jonas.jensen@gmail.com> <1408459784-9385-2-git-send-email-jonas.jensen@gmail.com>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Thu, 21 Aug 2014 23:43:38 +0200
Message-ID: <CAHXqBFJ3bWW8NVYcjxLnkk=6qxcRv75iCuBLrHuF91wxcL=61g@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] net: moxa: replace build_skb() with
 netdev_alloc_skb_ip_align() / memcpy()
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, f.fainelli@gmail.com,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-19 16:49 GMT+02:00 Jonas Jensen <jonas.jensen@gmail.com>:
[...]
> diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
> index aa45607..17c9f0e 100644
> --- a/drivers/net/ethernet/moxa/moxart_ether.c
> +++ b/drivers/net/ethernet/moxa/moxart_ether.c
> @@ -226,14 +226,21 @@ static int moxart_rx_poll(struct napi_struct *napi, int budget)
>                 if (len > RX_BUF_SIZE)
>                         len = RX_BUF_SIZE;
>
> -               skb = build_skb(priv->rx_buf[rx_head], priv->rx_buf_size);
> +               dma_sync_single_for_cpu(&ndev->dev,
> +                                       priv->rx_mapping[rx_head],
> +                                       priv->rx_buf_size, DMA_FROM_DEVICE);
> +               skb = netdev_alloc_skb_ip_align(ndev, len);
>                 if (unlikely(!skb)) {
> -                       net_dbg_ratelimited("build_skb failed\n");
> +                       net_dbg_ratelimited("netdev_alloc_skb_ip_align failed\n");
>                         priv->stats.rx_dropped++;
>                         priv->stats.rx_errors++;
>                 }
> -
> +               memcpy(skb->data, priv->rx_buf[rx_head], len);

This has implicit: if (!skb) BUG(); There should probably be a return
or continue inside the if (!skb).

>                 skb_put(skb, len);
> +               dma_sync_single_for_device(&ndev->dev,
> +                                          priv->rx_mapping[rx_head],
> +                                          priv->rx_buf_size, DMA_FROM_DEVICE);
> +

dma_sync_single_for_device() is not needed here as CPU does not and
should not write to the DMA_FROM_DEVICE mapping.


>                 skb->protocol = eth_type_trans(skb, ndev);
>                 napi_gro_receive(&priv->napi, skb);
>                 rx++;

Best Regards,
Michał Mirosław
