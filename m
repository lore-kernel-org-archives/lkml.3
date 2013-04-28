Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab3D1NiX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 09:38:23 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19663 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab3D1NiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 09:38:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 28 Apr 2013 06:38:20 -0700
From: Bibek Basu <bbasu@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pritesh Raithatha <praithatha@nvidia.com>
Date: Sun, 28 Apr 2013 19:08:15 +0530
Subject: RE: [PATCH 1/2] pinctrl: tegra: add suspend-resume support
Thread-Topic: [PATCH 1/2] pinctrl: tegra: add suspend-resume support
Thread-Index: Ac5AUoCXRZ80FS1tR6Kb0j/O3DRVdgDwUcmw
Message-ID: <77F7DB30C698A44DA22FB222C89DE941A6692E62BC@BGMAIL01.nvidia.com>
References: <1366740542-26127-1-git-send-email-bbasu@nvidia.com>
 <20130423184332.GA31374@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130423184332.GA31374@avionic-0098.mockup.avionic-design.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Thierry Reding [mailto:thierry.reding@avionic-design.de]
> Sent: Wednesday, April 24, 2013 12:14 AM
> To: Bibek Basu
> Cc: linus.walleij@linaro.org; swarren@wwwdotorg.org; linux-
> tegra@vger.kernel.org; linux-kernel@vger.kernel.org; Pritesh Raithatha
> Subject: Re: [PATCH 1/2] pinctrl: tegra: add suspend-resume support
> 
> * PGP Signed by an unknown key
> 
> > diff --git a/drivers/pinctrl/pinctrl-tegra.c
> > b/drivers/pinctrl/pinctrl-tegra.c
> [...]
> > @@ -41,6 +42,8 @@ struct tegra_pmx {
> >
> >  	int nbanks;
> >  	void __iomem **regs;
> > +	int *regs_size;
> 
> Perhaps this should be unsigned int *. The values stored in this array will
> never be negative, right?
Agree. 
> 
> >  int tegra_pinctrl_probe(struct platform_device *pdev,
> >  			const struct tegra_pinctrl_soc_data *soc_data)  {
> > -	struct tegra_pmx *pmx;
> >  	struct resource *res;
> > -	int i;
> > +	struct tegra_pmx *pmx;
> > +	int i, pg_data_size = 0;
> 
> There's a needless move of the pmx variable declaration here.
Agree
> 
> > @@ -735,6 +769,21 @@ int tegra_pinctrl_probe(struct platform_device
> *pdev,
> >  		return -ENODEV;
> >  	}
> >
> > +if (IS_ENABLED(CONFIG_PM_SLEEP))
> > +	pmx->regs_size = devm_kzalloc(&pdev->dev,
> > +				pmx->nbanks * sizeof(*(pmx->regs_size)),
> > +				GFP_KERNEL);
> > +	if (!pmx->regs_size) {
> > +		dev_err(&pdev->dev, "Can't alloc regs pointer\n");
> > +		return -ENODEV;
> > +	}
> > +
> > +	pmx->pg_data = devm_kzalloc(&pdev->dev, pg_data_size,
> GFP_KERNEL);
> > +	if (!pmx->pg_data) {
> > +		dev_err(&pdev->dev, "Can't alloc pingroup data pointer\n");
> > +		return -ENODEV;
> > +	}
> 
> I don't think this works the way you expect it to. The line
> 
> 	if (IS_ENABLED(CONFIG_PM_SLEEP))
> 
> is a standard conditional and therefore needs to be properly indented and
> use { and } to delimit the block.
> 
My Bad. Will fix
> > @@ -756,6 +805,9 @@ int tegra_pinctrl_probe(struct platform_device
> *pdev,
> >  			dev_err(&pdev->dev, "Couldn't ioremap regs %d\n",
> i);
> >  			return -ENODEV;
> >  		}
> > +
> > +if (IS_ENABLED(CONFIG_PM_SLEEP))
> > +		pmx->regs_size[i] = resource_size(res);
> 
> In this case it will actually work as expected, but the if () should be properly
> indented.
> 
> Thierry
> 
Thanks for the review
Bibek
> * Unknown Key
> * 0x7F3EB3A1
