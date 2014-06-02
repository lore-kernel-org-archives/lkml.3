Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaFBS0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:26:01 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:62507 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaFBSZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:25:59 -0400
Date: Mon, 2 Jun 2014 13:08:00 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] thermal: ti-soc-thermal: ti-bandgap.c:  Cleaning up
 memory leak
Message-ID: <20140602170800.GA5198@developer>
References: <1401622431-13554-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401622431-13554-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 01:33:51PM +0200, Rickard Strandqvist wrote:
> There is a risk for memory leak in when something unexpected happens
> and the function returns.

I don't think there is a risk of memory leak, but wrong address access,
in this case.

> 
> This was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/thermal/ti-soc-thermal/ti-bandgap.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> index 3ab12ee..8401d2e 100644
> --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> @@ -1155,8 +1155,9 @@ static struct ti_bandgap *ti_bandgap_build(struct platform_device *pdev)
>  	/* register shadow for context save and restore */
>  	bgp->regval = devm_kzalloc(&pdev->dev, sizeof(*bgp->regval) *
>  				   bgp->conf->sensor_count, GFP_KERNEL);
> -	if (!bgp) {
> +	if (!bgp->regval) {

I agree with this fix.

>  		dev_err(&pdev->dev, "Unable to allocate mem for driver ref\n");
> +		devm_kfree(&pdev->dev, bgp);

But I think this is unnecessary, as it has been managed allocated.

Cheers,

Eduardo

>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
