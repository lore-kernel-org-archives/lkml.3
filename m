Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaG1LZC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:25:02 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:42963
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752499AbaG1LY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:24:56 -0400
Date: Mon, 28 Jul 2014 19:23:24 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Nicolin Chen <nicoleotsuka@gmail.com>
CC: <broonie@kernel.org>, <alsa-devel@alsa-project.org>,
        <patches@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>,
        <b42378@freescale.com>, <b02247@freescale.com>
Subject: Re: [PATCH] ASoC: wm8962: Let CODEC driver enable and disable its
 own MCLK
Message-ID: <20140728112322.GA3350@MrMyself>
References: <1406544961-19923-1-git-send-email-nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1406544961-19923-1-git-send-email-nicoleotsuka@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(24454002)(199002)(189002)(92566001)(46102001)(87936001)(85306003)(86362001)(74502001)(74662001)(26826002)(50466002)(4396001)(92726001)(77982001)(46406003)(31966008)(79102001)(110136001)(76482001)(83072002)(104016003)(1411001)(6806004)(106466001)(102836001)(105606002)(23726002)(33656002)(95666004)(47776003)(64706001)(80022001)(97736001)(107046002)(33716001)(76176999)(84676001)(81342001)(54356999)(85852003)(50986999)(20776003)(99396002)(83506001)(97756001)(81542001)(68736004)(21056001)(19580405001)(19580395003)(44976005)(83322001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB325;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0286D7B531
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PLEASE IGNORE THIS VERSION

On Mon, Jul 28, 2014 at 06:56:01PM +0800, Nicolin Chen wrote:
> snd_soc_open() will trigger pm_runtime resume() which will then enable
> the regulator and initialization. So we should make sure the MCLK is
> enabled before this resume().
> 
> Previously we let the machine driver get the clock and enable it in
> its probe(). However, considering about power saving, it'll be better
> to enable it when it's going to be used and disable it after using.
> 
> So this patch just simply adds clk_get() and clk_enable() to WM8962
> driver. Meanwhile, it marks clock pointer to NULL if no clock assigned
> to it so it will not break any current function.
> 
> Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>

Sorry, the patch has some problem. I'll send v2 to fix it.

Please ignore this version.

Thank you,
Nicolin

> ---
>  include/sound/wm8962.h    |  1 +
>  sound/soc/codecs/wm8962.c | 11 +++++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/include/sound/wm8962.h b/include/sound/wm8962.h
> index 79e6d42..0af7c16 100644
> --- a/include/sound/wm8962.h
> +++ b/include/sound/wm8962.h
> @@ -37,6 +37,7 @@
>  #define WM8962_GPIO_FN_MICSCD          22
>  
>  struct wm8962_pdata {
> +	struct clk *mclk;
>  	int gpio_base;
>  	u32 gpio_init[WM8962_MAX_GPIO];
>  
> diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
> index ca2fda9..256ae51 100644
> --- a/sound/soc/codecs/wm8962.c
> +++ b/sound/soc/codecs/wm8962.c
> @@ -14,6 +14,7 @@
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
>  #include <linux/init.h>
> +#include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/pm.h>
>  #include <linux/gcd.h>
> @@ -3541,6 +3542,8 @@ static int wm8962_set_pdata_from_of(struct i2c_client *i2c,
>  				pdata->gpio_init[i] = 0x0;
>  		}
>  
> +	pdata->mclk = devm_clk_get(&i2c->dev, NULL);
> +
>  	return 0;
>  }
>  
> @@ -3572,6 +3575,10 @@ static int wm8962_i2c_probe(struct i2c_client *i2c,
>  			return ret;
>  	}
>  
> +	/* Mark the mclk pointer to NULL if no mclk assigned */
> +	if (IS_ERR(pdata->mclk))
> +		pdata->mclk = NULL;
> +
>  	for (i = 0; i < ARRAY_SIZE(wm8962->supplies); i++)
>  		wm8962->supplies[i].supply = wm8962_supply_names[i];
>  
> @@ -3780,6 +3787,8 @@ static int wm8962_runtime_resume(struct device *dev)
>  	struct wm8962_priv *wm8962 = dev_get_drvdata(dev);
>  	int ret;
>  
> +	clk_prepare_enable(wm8962->pdata.mclk);
> +
>  	ret = regulator_bulk_enable(ARRAY_SIZE(wm8962->supplies),
>  				    wm8962->supplies);
>  	if (ret != 0) {
> @@ -3839,6 +3848,8 @@ static int wm8962_runtime_suspend(struct device *dev)
>  	regulator_bulk_disable(ARRAY_SIZE(wm8962->supplies),
>  			       wm8962->supplies);
>  
> +	clk_disable_unprepare(wm8962->pdata.mclk);
> +
>  	return 0;
>  }
>  #endif
> -- 
> 1.8.4
> 
