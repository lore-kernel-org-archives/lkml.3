Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252AbaHZJFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:05:11 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:58272 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634AbaHZJFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:05:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Jonas Jensen <jonas.jensen@gmail.com>, netdev@vger.kernel.org,
        f.fainelli@gmail.com, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org, mirqus@gmail.com, davem@davemloft.net
Subject: Re: [PATCH v6 2/4] net: moxa: replace build_skb() with netdev_alloc_skb_ip_align() / memcpy()
Date: Tue, 26 Aug 2014 11:04:30 +0200
Message-ID: <4449672.aCJ5J5rv4r@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1408976542-15624-1-git-send-email-jonas.jensen@gmail.com>
References: <1408544342-32058-1-git-send-email-jonas.jensen@gmail.com> <1408976542-15624-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:o95fdKvYf3bTnE3BFwbdc7JIpPIAnOuOXjig+dTYr2z
 NAtXTLxj6OheAWO4hZ21G057YKNPBBM3vFVqXnG739lgmBadm+
 2D8bLlOaR+93WvUS3aMc0/8meTzTNvC2qC6rHTYz94OG1d3+31
 1c4sFPz/O29qiaqSfcih5HHHt+T6mdoJe+1lCTwUKbsxeZzT+t
 lquQqP6oeMDPGKkuE69ofBit64wEVdR0ZRRNvNMf75ysEtSUaj
 YMK6mm12yI0MSxdCpp9pFW3l/p/7K7NLvfjW7MMvsTw7aoLb6z
 naV8w0MKIDklv8Dt+j3IkZRw8mmR6z8UL4IKceP+HcNjFzF5u2
 +7JUsEHoiHSqk8VuCE5A=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 August 2014 16:22:22 Jonas Jensen wrote:
> @@ -226,13 +226,15 @@ static int moxart_rx_poll(struct napi_struct *napi, int budget)
>                 if (len > RX_BUF_SIZE)
>                         len = RX_BUF_SIZE;
>  
> -               skb = build_skb(priv->rx_buf[rx_head], priv->rx_buf_size);
> +               skb = netdev_alloc_skb_ip_align(ndev, len);
> +
>                 if (unlikely(!skb)) {
> -                       net_dbg_ratelimited("build_skb failed\n");
> +                       net_dbg_ratelimited("netdev_alloc_skb_ip_align failed\n");
>                         priv->stats.rx_dropped++;
>                         priv->stats.rx_errors++;
>                 }
>  
> +               memcpy(skb->data, priv->rx_buf[rx_head], len);
>                 skb_put(skb, len);
>                 skb->protocol = eth_type_trans(skb, ndev);
>                 napi_gro_receive(&priv->napi, skb);

While this seems correct, I wonder why you don't do the normal approach of
dequeuing the skb from the chain and adding a newly allocated skb to it to
save the memcpy.

	Arnd
