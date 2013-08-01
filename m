Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab3HAJCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 05:02:40 -0400
Received: from bosmailout13.eigbox.net ([66.96.186.13]:46670 "EHLO
	bosmailout13.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab3HAJCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 05:02:37 -0400
X-Greylist: delayed 2390 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Aug 2013 05:02:37 EDT
X-Authority-Analysis: v=2.0 cv=dt1Z+ic4 c=1 sm=1
 a=TYXDnRmJwPKvQ+ShACQTnw==:17 a=bc2JKO6qiGsA:10 a=FB6NmUnAAagA:10
 a=N_gP7I_xuFwA:10 a=8nJEP1OIZ-IA:10 a=KbYSTru-VlQA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=Z-oWcdMlAAAA:8 a=pGLkceISAAAA:8
 a=DTMDNysTthNgaN8lg8AA:9 a=wPNLvfGTeEIA:10 a=kqLNnRbnKloA:10
 a=MSl-tDqOz04A:10 a=wx0GOVZTcu8EuaXTIXj3VQ==:117
X-EN-OrigOutIP: 10.20.18.12
X-EN-IMPSID: 7LNi1m0040FdZ9W01LNiLd
Message-ID: <51FA1AB7.8030105@yahoo.es>
Date: Thu, 01 Aug 2013 16:22:15 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: majianpeng <majianpeng@gmail.com>
CC: balajitk <balajitk@ti.com>, cjb <cjb@laptop.org>,
        mayuzheng <mayuzheng@kedacom.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] mmc: omap_hsmmc: Fix sleep too long in ISR context.
References: <201308011017566117580@gmail.com>
In-Reply-To: <201308011017566117580@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.58.140
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jianpeng Ma,

On 8/1/2013 10:18 AM, majianpeng wrote:
> We found a problem when we removed a working sd card that the irqaction
> of omap_hsmmc can sleep to 3.6s. This cause our watchdog to work.
> In func omap_hsmmc_reset_controller_fsm, it should watch a 0->1
> transition.It used loops_per_jiffy as the timer.
> The code is:
>> while ((!(OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
>>                && (i++ < limit))
>>                        cpu_relax();
> But the loops_per_jiffy is:
>>  while(i++ < limit)
>> 	cpu_relax();
> It add some codes so the time became long.
> Becasue those codes in ISR context, it can't use timer_before/after.
> I divived the time into 1ms and used udelay(1) to instead.
> It will cause do additional udelay(1).But from my test,it looks good.
>
> Reported-by: Yuzheng Ma <mayuzheng@kedacom.com>
> Tested-by: Yuzheng Ma <mayuzheng@kedacom.com>
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/mmc/host/omap_hsmmc.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 1865321..96daca1 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -977,6 +977,8 @@ static inline void omap_hsmmc_reset_controller_fsm(struct omap_hsmmc_host *host,
>  	unsigned long limit = (loops_per_jiffy *
>  				msecs_to_jiffies(MMC_TIMEOUT_MS));
>  
> +	/*Divided time into us for unit 1,we can use udelay(1)*/
> +	i = limit / (MMC_TIMEOUT_MS * 1000);

'limit' is a number of loops, which you now divide by 20,000?

To get uS, you could just change:

-	unsigned long limit = (loops_per_jiffy *
-				msecs_to_jiffies(MMC_TIMEOUT_MS));
+	unsigned long limit = 1000 * MMC_TIMEOUT_MS;

and make this amount of loops using udelay().

>  	OMAP_HSMMC_WRITE(host->base, SYSCTL,
>  			 OMAP_HSMMC_READ(host->base, SYSCTL) | bit);
>  
> @@ -985,15 +987,19 @@ static inline void omap_hsmmc_reset_controller_fsm(struct omap_hsmmc_host *host,
>  	 * Monitor a 0->1 transition first
>  	 */
>  	if (mmc_slot(host).features & HSMMC_HAS_UPDATED_RESET) {
> -		while ((!(OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
> -					&& (i++ < limit))
> -			cpu_relax();

I still don't see why any of these loops could last 3.6 seconds?
Yes the __raw_readl() will add some time, but so much?
I'd like to see which value you get for 'limit' on your machine
Would PM play a role? Or cpu-freq, and 'loops_per_jiffy' isn't updated
on time?

> +		while (i--) {
> +			if ((OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
> +				break;
> +			udelay(1);

In earlier threads, the use of udelay was disliked because it's a waste
of cpu cycles. The desired bit in SYSCTL will change, while udelay()
is still making many useless loops.

> +		}
>  	}
> -	i = 0;
>  
> -	while ((OMAP_HSMMC_READ(host->base, SYSCTL) & bit) &&
> -		(i++ < limit))
> -		cpu_relax();
> +	i = limit / (MMC_TIMEOUT_MS * 1000);
> +	while (i--) {
> +		if (!(OMAP_HSMMC_READ(host->base, SYSCTL) & bit))
> +			break;
> +		udealy(1);
> +	}
>  
>  	if (OMAP_HSMMC_READ(host->base, SYSCTL) & bit)
>  		dev_err(mmc_dev(host->mmc),
Hein
