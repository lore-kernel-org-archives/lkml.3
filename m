Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbaCaR7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:59:43 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:45139 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbaCaR7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:59:41 -0400
Message-ID: <5339AD0A.6050404@cogentembedded.com>
Date: Mon, 31 Mar 2014 21:59:38 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tejun Heo <tj@kernel.org>
CC: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-ide@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_at91: fix ata_host_activate() failure handling
References: <3354637.ASvWtLs5Rq@amdc1032>
In-Reply-To: <3354637.ASvWtLs5Rq@amdc1032>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03/31/2014 09:51 PM, Bartlomiej Zolnierkiewicz wrote:

> Add missing clk_put() call to ata_host_activate() failure path.

> Cc: Andrew Victor <linux@maxim.org.za>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
>   drivers/ata/pata_at91.c |   11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)

> Index: b/drivers/ata/pata_at91.c
> ===================================================================
> --- a/drivers/ata/pata_at91.c	2014-03-14 16:45:04.196724381 +0100
> +++ b/drivers/ata/pata_at91.c	2014-03-31 17:46:40.127677782 +0200
> @@ -407,12 +407,13 @@ static int pata_at91_probe(struct platfo
>
>   	host->private_data = info;
>
> -	return ata_host_activate(host, gpio_is_valid(irq) ? gpio_to_irq(irq) : 0,
> -			gpio_is_valid(irq) ? ata_sff_interrupt : NULL,
> -			irq_flags, &pata_at91_sht);
> +	ret = ata_host_activate(host, gpio_is_valid(irq) ? gpio_to_irq(irq) : 0,
> +				gpio_is_valid(irq) ? ata_sff_interrupt : NULL,
> +				irq_flags, &pata_at91_sht);
> +	if (ret)
> +		goto err_put;
>
> -	if (!ret)
> -		return 0;
> +	return 0;

    Hm, I have once fixed that (see that *if* (!ret)) but looks like a later 
commit 477c87e90853d136b188c50c0e4a93d01cad872e (ARM: at91/pata: use 
gpio_is_valid to check the gpio) broke it again. :-( Would be good if the 
changelog did mention that...

MBR, Sergei

