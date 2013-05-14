Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab3ENDzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 23:55:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43346 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788Ab3ENDzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 23:55:44 -0400
X-Sasl-enc: fQcRX0Pez3OiRuhxu909JLQ35Aya/aXT62W3e7X8dga9 1368503742
Message-ID: <5191B5C4.2020609@signal11.us>
Date: Mon, 13 May 2013 23:55:48 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: David Hauweele <david@hauweele.net>
CC: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-zigbee-devel] [PATCH 2/2] mrf24j40: Keep the interrupt
 line enabled
References: <1368112788-25701-1-git-send-email-david@hauweele.net> <1368112788-25701-2-git-send-email-david@hauweele.net>
In-Reply-To: <1368112788-25701-2-git-send-email-david@hauweele.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/13 11:19 AM, David Hauweele wrote:
> Disabling the interrupt line could miss an IRQ and leave the line into a
> low state hence locking the driver.
>

Have you observed this? My understanding is that the interrupt won't be 
lost but instead delayed until enable_irq() is called.

I got this pattern from the other 802.15.4 drivers. Perhaps my 
understanding is wrong.


> Signed-off-by: David Hauweele <david@hauweele.net>
> ---
>   drivers/net/ieee802154/mrf24j40.c |    7 +------
>   1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/drivers/net/ieee802154/mrf24j40.c b/drivers/net/ieee802154/mrf24j40.c
> index 1e3ddf3..6ef32f7 100644
> --- a/drivers/net/ieee802154/mrf24j40.c
> +++ b/drivers/net/ieee802154/mrf24j40.c
> @@ -603,8 +603,6 @@ static irqreturn_t mrf24j40_isr(int irq, void *data)
>   {
>   	struct mrf24j40 *devrec = data;
>
> -	disable_irq_nosync(irq);
> -
>   	schedule_work(&devrec->irqwork);
>
>   	return IRQ_HANDLED;
> @@ -619,7 +617,7 @@ static void mrf24j40_isrwork(struct work_struct *work)
>   	/* Read the interrupt status */
>   	ret = read_short_reg(devrec, REG_INTSTAT, &intstat);
>   	if (ret)
> -		goto out;
> +		return;
>
>   	/* Check for TX complete */
>   	if (intstat & 0x1)
> @@ -628,9 +626,6 @@ static void mrf24j40_isrwork(struct work_struct *work)
>   	/* Check for Rx */
>   	if (intstat & 0x8)
>   		schedule_work(&devrec->rxwork);
> -
> -out:
> -	enable_irq(devrec->spi->irq);
>   }
>
>   static void mrf24j40_rxwork(struct work_struct *work)
>

