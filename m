Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaIISiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:38:21 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:59927 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaIISiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:38:19 -0400
Date: Tue, 9 Sep 2014 11:38:05 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
Cc: timur@tabi.org, Li.Xiubo@freescale.com, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, mpa@pengutronix.de
Subject: Re: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140909183804.GA6944@Asurada>
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 05:18:07PM +0800, Shengjiu Wang wrote:
> @@ -1321,7 +1333,11 @@ static int fsl_ssi_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> -	ssi_private->regs = devm_regmap_init_mmio(&pdev->dev, iomem,
> +	if (ssi_private->soc->imx)
> +		ssi_private->regs = devm_regmap_init_mmio_clk(&pdev->dev,
> +			"ipg", iomem, &fsl_ssi_regconfig);
> +	else
> +		ssi_private->regs = devm_regmap_init_mmio(&pdev->dev, iomem,

As Markus mentioned, the key point here is to be compatible with those
non-clock-name platforms.

I think it would be safer to keep the current code while adding an extra
clk_disable_unprepare() at the end of probe() as a common routine. And
meantime, make sure to have the call for imx only because it seems that
the other platforms do not depend on the clock. //a bit guessing here :)

Then we can get a patch like:
open() {
+	clk_prepare_enable();
	....
}

close() {
	....
+	clk_disable_unprepare()
}

probe() {
	clk_get();
	clk_prepare_enable();
	....
	if (xxx)
-		goto err_xx;
+		return ret;
	....
+	clk_disable_unprepare();
	return 0;
-err_xx:
-	clk_disable_unprepare()
}

remove() {
	....
-	clk_disable_unprepare()
}

As long as you make the subject clear as 'Don't enable core/ipg clock
when SSI's idle', I'm sure you can make them within a single patch.

And an alternative way for open() and close() is to put those code into
pm_runtime_resume/suspend() instead (since we might have some internal
code need to be added by using pm_runtime as well), which would make
the further code neater IMO.

Thank you
Nicolin
