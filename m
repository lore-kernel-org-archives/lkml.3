Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaKOKjq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 05:39:46 -0500
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:54235 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935AbaKOKjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 05:39:44 -0500
Message-ID: <54672D69.8060708@xs4all.nl>
Date: Sat, 15 Nov 2014 11:39:37 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Andrey Utkin <andrey.utkin@corp.bluecherry.net>, khalasa@piap.pl,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.chehab@samsung.com
Subject: Re: SOLO6x10: fix a race in IRQ handler.
References: <m3lhneez9h.fsf@t19.piap.pl> <m3lhneez9h.fsf@t19.piap.pl>
In-Reply-To: <m3lhneez9h.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

Please always prefix the subject line with [PATCH] when you post a patch. That way it
will be picked up by patchwork (https://patchwork.linuxtv.org/project/linux-media/list/)
and the patch won't be lost.

Can you repost with such a prefix?

Thanks!

	Hans

On 11/15/2014 11:34 AM, Andrey Utkin wrote:
> From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
> 
> The IRQs have to be acknowledged before they are serviced, otherwise some events
> may be skipped. Also, acknowledging IRQs just before returning from the handler
> doesn't leave enough time for the device to deassert the INTx line, and for
> bridges to propagate this change. This resulted in twice the IRQ rate on ARMv6
> dual core CPU.
> 
> Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
> Acked-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> Tested-by: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
> 
> --- a/drivers/media/pci/solo6x10/solo6x10-core.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-core.c
> @@ -105,11 +105,8 @@ static irqreturn_t solo_isr(int irq, void *data)
>  	if (!status)
>  		return IRQ_NONE;
>  
> -	if (status & ~solo_dev->irq_mask) {
> -		solo_reg_write(solo_dev, SOLO_IRQ_STAT,
> -			       status & ~solo_dev->irq_mask);
> -		status &= solo_dev->irq_mask;
> -	}
> +	/* Acknowledge all interrupts immediately */
> +	solo_reg_write(solo_dev, SOLO_IRQ_STAT, status);
>  
>  	if (status & SOLO_IRQ_PCI_ERR)
>  		solo_p2m_error_isr(solo_dev);
> @@ -132,9 +129,6 @@ static irqreturn_t solo_isr(int irq, void *data)
>  	if (status & SOLO_IRQ_G723)
>  		solo_g723_isr(solo_dev);
>  
> -	/* Clear all interrupts handled */
> -	solo_reg_write(solo_dev, SOLO_IRQ_STAT, status);
> -
>  	return IRQ_HANDLED;
>  }
> 
