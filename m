Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab3FYJFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:05:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51305 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3FYJFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:05:15 -0400
Message-ID: <1372151074.3981.21.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v2 1/6] misc: sram: fix error path in sram_probe
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 25 Jun 2013 11:04:34 +0200
In-Reply-To: <201306251046.38993.heiko@sntech.de>
References: <201306251046.04873.heiko@sntech.de>
	 <201306251046.38993.heiko@sntech.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

Am Dienstag, den 25.06.2013, 10:46 +0200 schrieb Heiko Stübner:
> The pool is created thru devm_gen_pool_create, so the call to
> gen_pool_destroy is not necessary.
> Instead the sram-clock must be turned off again if it exists.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  drivers/misc/sram.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
> index d87cc91..afe66571 100644
> --- a/drivers/misc/sram.c
> +++ b/drivers/misc/sram.c
> @@ -68,7 +68,8 @@ static int sram_probe(struct platform_device *pdev)
>  	ret = gen_pool_add_virt(sram->pool, (unsigned long)virt_base,
>  				res->start, size, -1);
>  	if (ret < 0) {
> -		gen_pool_destroy(sram->pool);

Right, thanks.

> +		if (sram->clk)
> +			clk_disable_unprepare(sram->clk);
>  		return ret;
>  	}
>  

In light of the following patch, I'd rather move the
clk_prepare_enable() call after gen_pool_add_virt() and its error path.

regards
Philipp

