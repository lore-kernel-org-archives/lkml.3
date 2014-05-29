Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933987AbaE2IuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:50:14 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:64629 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbaE2IuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:50:09 -0400
Date: Thu, 29 May 2014 10:50:02 +0200
From: Alexander Aring <alex.aring@gmail.com>
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: alan@signal11.us, Varka Bhadram <varkab@cdac.in>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-zigbee-devel@lists.sourceforge.net,
        alex.aing@gmail.com, davem@davemloft.net
Subject: Re: [Linux-zigbee-devel] [PATCH net-next v2] mrf24j40: add managed
 API's provided by device layer
Message-ID: <20140529084959.GA26220@omega>
References: <1401343536-20361-1-git-send-email-varkab@cdac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1401343536-20361-1-git-send-email-varkab@cdac.in>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Varka,

On Thu, May 29, 2014 at 11:35:35AM +0530, Varka Bhadram wrote:
> forgot to use devm_* for spi buff.
> sorry for that.
> 
> -Varka Bhadram
> 
> Signed-off-by: Varka Bhadram <varkab@cdac.in>
> ---
>  drivers/net/ieee802154/mrf24j40.c |   21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
> index 78a6552..90aed9b 100644
> --- a/drivers/net/ieee802154/mrf24j40.c
> +++ b/drivers/net/ieee802154/mrf24j40.c
> @@ -618,10 +618,10 @@ static int mrf24j40_probe(struct spi_device *spi)
>  
>  	printk(KERN_INFO "mrf24j40: probe(). IRQ: %d\n", spi->irq);
>  
> -	devrec = kzalloc(sizeof(struct mrf24j40), GFP_KERNEL);
> +	devrec = devm_kzalloc(&spi->dev, sizeof(struct mrf24j40), GFP_KERNEL);
>  	if (!devrec)
>  		goto err_devrec;
> -	devrec->buf = kzalloc(3, GFP_KERNEL);
> +	devrec->buf = devm_kzalloc(&spi->dev, 3, GFP_KERNEL);
>  	if (!devrec->buf)
>  		goto err_buf;
>  
> @@ -676,12 +676,13 @@ static int mrf24j40_probe(struct spi_device *spi)
>  	val &= ~0x3; /* Clear RX mode (normal) */
>  	write_short_reg(devrec, REG_RXMCR, val);
>  
> -	ret = request_threaded_irq(spi->irq,
> -				   NULL,
> -				   mrf24j40_isr,
> -				   IRQF_TRIGGER_LOW|IRQF_ONESHOT,
> -				   dev_name(&spi->dev),
> -				   devrec);
> +	ret = devm_request_threaded_irq(&spi->dev,
> +					spi->irq,
> +					NULL,
> +					mrf24j40_isr,
> +					IRQF_TRIGGER_LOW|IRQF_ONESHOT,
> +					dev_name(&spi->dev),
> +					devrec);
>  

when using devm_* it's also freed when the probe function failed, so you
can also remove the error path handling.

err_alloc_dev:
        kfree(devrec->buf);
err_buf:
        kfree(devrec);

and so on...

- Alex
