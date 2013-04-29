Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab3D2SCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:02:37 -0400
Received: from nm4.access.bullet.mail.mud.yahoo.com ([66.94.237.205]:38214
	"EHLO nm4.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751449Ab3D2SCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:02:36 -0400
X-Yahoo-Newman-Id: 125016.33354.bm@smtp115.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: xmKYj7UVM1nB6cagX7HZOrTJpSDCiI32UkF6E9t2P7xaNxo
 6zh3D_HCCHbIrPdljtm.gvbZ1UQ9rRydhmQRfvOqyWXAO2O1XRcVymdIqa5p
 P0mkZ2BmfRh34E1KGHvixnsUJPocI09w7RP3gITgqP6fZx4jFCfpbLOBpsTk
 6ptq5Jf_oAON00UNvTVi3GMzS3tedWkRB1o1Kaclh8lWgBXxQ_eyh81xyqtd
 T2zSLnmo6YGIyhDr94iLkBuEksuvzLS7fdmCaOH4IuXC5fhN7hHOZpsxGuM8
 iwEK.pz5VWht.tzst_wGOn_95Wp_jQk7Hf1zXJVweVxEEpducHNFKv6JpeOr
 VB82qXm._RsfXsK6quixreLTyuRqPUte7D3ibgEYzHaVsiqReP4bAa2JMSjr
 KPWs4nkLjW1yPM9JceeWeqRRF7DTN_LqHFPyJXXwh7HX05s.zaWv62gnVYAV
 eN9LIYUmaMeqqvTfXIadkx_bpFQ0Auw9vwKs-
X-Yahoo-SMTP: zfeO.4KswBCc_PdwTE8HfYDCQ1aNmIcSvQHkDP4uSDBNBSXeKQ--
X-Rocket-Received: from localhost (linux@108.223.40.66 with plain)
        by smtp115.sbc.mail.ne1.yahoo.com with SMTP; 29 Apr 2013 11:02:35 -0700 PDT
Date: Mon, 29 Apr 2013 11:02:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH RESEND 4/7] watchdog: nuc900_wdt: use devm_*() functions
Message-ID: <20130429180235.GD5183@roeck-us.net>
References: <000e01ce44bc$e5d1dec0$b1759c40$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000e01ce44bc$e5d1dec0$b1759c40$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 06:35:33PM +0900, Jingoo Han wrote:
> Use devm_*() functions to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/watchdog/nuc900_wdt.c |   45 ++++++++--------------------------------
>  1 files changed, 9 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/watchdog/nuc900_wdt.c b/drivers/watchdog/nuc900_wdt.c
> index 04c45a1..89e8991 100644
> --- a/drivers/watchdog/nuc900_wdt.c
> +++ b/drivers/watchdog/nuc900_wdt.c
> @@ -246,7 +246,8 @@ static int nuc900wdt_probe(struct platform_device *pdev)
>  {
>  	int ret = 0;
>  
> -	nuc900_wdt = kzalloc(sizeof(struct nuc900_wdt), GFP_KERNEL);
> +	nuc900_wdt = devm_kzalloc(&pdev->dev, sizeof(struct nuc900_wdt),
> +				GFP_KERNEL);

General hint: sizeof(*nuc900_wdt) is preferred by most maintainers.

>  	if (!nuc900_wdt)
>  		return -ENOMEM;
>  
> @@ -257,30 +258,18 @@ static int nuc900wdt_probe(struct platform_device *pdev)
>  	nuc900_wdt->res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (nuc900_wdt->res == NULL) {

It is no longer necessary to save the resource in nuc900_wdt, as it is only
used in the probe function. So you might as well drop the variable from the
structure and declare it locally.

>  		dev_err(&pdev->dev, "no memory resource specified\n");
> -		ret = -ENOENT;
> -		goto err_get;
> +		return -ENOENT;
>  	}
>  
> -	if (!request_mem_region(nuc900_wdt->res->start,
> -				resource_size(nuc900_wdt->res), pdev->name)) {
> -		dev_err(&pdev->dev, "failed to get memory region\n");
> -		ret = -ENOENT;
> -		goto err_get;
> -	}
> -
> -	nuc900_wdt->wdt_base = ioremap(nuc900_wdt->res->start,
> -					resource_size(nuc900_wdt->res));
> -	if (nuc900_wdt->wdt_base == NULL) {
> -		dev_err(&pdev->dev, "failed to ioremap() region\n");
> -		ret = -EINVAL;
> -		goto err_req;
> -	}
> +	nuc900_wdt->wdt_base = devm_ioremap_resource(&pdev->dev,
> +						nuc900_wdt->res);
> +	if (IS_ERR(nuc900_wdt->wdt_base))
> +		return PTR_ERR(nuc900_wdt->wdt_base);
>  
Does devm_ioremap_resource() spit out an error if it fails ?
If not, you might want to add an error message for consistency
with the other messages.

Thanks,
Guenter
