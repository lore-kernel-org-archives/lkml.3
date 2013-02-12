Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787Ab3BLWKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:10:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53100 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab3BLWKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:10:40 -0500
Date: Tue, 12 Feb 2013 23:10:32 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Marek Szyprowski <m.szyprowski@samsung.com>
cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>,
        Kevin Liu <keyuan.liu@gmail.com>
Subject: Re: [PATCH 3/3 RESEND] mmc: sdhci: check voltage range only on
 regulators aware of voltage value
In-Reply-To: <1360656096-1671-1-git-send-email-m.szyprowski@samsung.com>
Message-ID: <Pine.LNX.4.64.1302122309470.14434@axis700.grange>
References: <87bobqrcb4.fsf@octavius.laptop.org>
 <1360656096-1671-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:raOE5YBZaHIXKbhZYj2iW4K6OVojMRT10om3Df093x3
 pOAv3AXEqsX7MubvG8d65N1qd2KmYmndO1vek1DenLzx9zsaZp
 b057hm2q4hjLq1tX5nMZV6OJ8Ep2xPG8hmVNhmZBjgvsrxLFv5
 iBlI3rB8CwQpXlJyXSwi9sqwp7wt5AsnDDFrC0yWzQ1c6WjPnT
 STETiRW//snEfz4Ee3K5KnjQl748+JrSuE702/PQHAXOarTKb3
 twT4pbx1IATuG5ZBzLjpcwoy/A7YrN0IjiT6/xnySp+uNh5wIm
 WuNstM0a2i2Z/mJU253HFkin3OPX8CmMbsy6b7i5dgZoN2tpQS
 tUEif5PRtS5rg9gReH+gl1DOwvhc52z7Vh1W1nyebazttJyMwC
 AcUeY9aWTRZVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek

On Tue, 12 Feb 2013, Marek Szyprowski wrote:

> Some regulators don't report any voltage values, so checking supported
> voltage range results in disabling all SDHCI_CAN_VDD_* flags and
> registration failure. This patch finally provides a correct fix for the
> registration of SDHCI driver with all possible voltage regulators:
> dummy, fixed and regulated without using regulator_count_voltages()
> hacks.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/mmc/host/sdhci.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index ba586ae..735526b 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -2976,7 +2976,11 @@ int sdhci_add_host(struct sdhci_host *host)
>  	}
>  
>  #ifdef CONFIG_REGULATOR
> -	if (host->vmmc) {
> +	/*
> +	 * Voltage range check makes sense only if regulator reports
> +	 * any voltage value.
> +	 */
> +	if (host->vmmc && regulator_get_voltage(host->vmmc) > 0) {
>  		ret = regulator_is_supported_voltage(host->vmmc, 2700000,
>  			3600000);

Wouldn't using mmc_regulator_get_ocrmask() be a better option?

Thanks
Guennadi

>  		if ((ret <= 0) || (!(caps[0] & SDHCI_CAN_VDD_330)))
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
