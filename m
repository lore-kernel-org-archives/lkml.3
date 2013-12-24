Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab3LXDWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 22:22:38 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61808 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab3LXDWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 22:22:37 -0500
MIME-Version: 1.0
In-Reply-To: <1387791224-29320-1-git-send-email-huawei.libin@huawei.com>
References: <1387791224-29320-1-git-send-email-huawei.libin@huawei.com>
Date: Tue, 24 Dec 2013 11:22:36 +0800
Message-ID: <CA+qZnSSebv-tM+nHEcUAqz4iE9ur7yZ6srQMpzi1pgAvYfFubw@mail.gmail.com>
Subject: Re: [PATCH] drivers/net: Fix potential incorrect call for udelay()
From: tingwei liu <tingw.liu@gmail.com>
To: Libin <huawei.libin@huawei.com>
Cc: davem@davemloft.net, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, tedheadster@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dingtianhong@huawei.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 5:33 PM, Libin <huawei.libin@huawei.com> wrote:
>
> From: Li Bin <huawei.libin@huawei.com>
>
> The variable delay_time as a module parameter can be set a value
> exceeding the limit of the udelay function. This patch checks the
> delay_time value to select mdelay() or udelay().
>
> Signed-off-by: Li Bin <huawei.libin@huawei.com>
> ---
>  drivers/net/ethernet/8390/pcnet_cs.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/8390/pcnet_cs.c b/drivers/net/ethernet/8390/pcnet_cs.c
> index 46c5aad..29fe157 100644
> --- a/drivers/net/ethernet/8390/pcnet_cs.c
> +++ b/drivers/net/ethernet/8390/pcnet_cs.c
> @@ -1284,8 +1284,12 @@ static void dma_block_output(struct net_device *dev, int count,
>         }
>
>      outb_p(ENISR_RDC, nic_base + EN0_ISR);     /* Ack intr. */
> -    if (info->flags & DELAY_OUTPUT)
> -       udelay((long)delay_time);
> +    if (info->flags & DELAY_OUTPUT) {
> +               if (delay_time >= 1000)
> +                       mdelay((long)delay_time/1000);

Indeed use of mdelay is discouraged.
I prefer to limit delay_time less than 1000.

Tingwei
>
> +               else
> +                       udelay(delay_time);
> +       }
>      ei_status.dmaing &= ~0x01;
>  }
>
> --
> 1.8.2.2
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
