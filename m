Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaFBLGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 07:06:45 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:62345 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbaFBLGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:06:43 -0400
Date: Mon, 2 Jun 2014 12:06:39 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, chris@printf.net,
        ulf.hansson@linaro.org, kernel@stlinux.com, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 1/8] mmc: sdhci-st: Intial support for ST SDHCI controller
Message-ID: <20140602110639.GA1483@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
 <1400771902-26553-2-git-send-email-peter.griffin@linaro.org>
 <20140522165036.GK19747@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522165036.GK19747@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

Thanks for your feedback, all your other comments will be fixed in v2. 
However see comments below for this patch

> > +	clk_prepare_enable(clk);
> 
> Move this down as far as it will go.  When do you _need_ the clock
> running by?
> 
> > +	host->mmc->caps |= MMC_CAP_8_BIT_DATA | MMC_CAP_BUS_WIDTH_TEST
> > +			| MMC_CAP_1_8V_DDR;
> > +
> > +	if (of_property_read_bool(np, "non-removable"))
> > +		host->mmc->caps |= MMC_CAP_NONREMOVABLE;
> > +
> > +	pltfm_host = sdhci_priv(host);
> > +	pltfm_host->clk = clk;
> > +
> > +	ret = sdhci_add_host(host);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Failed sdhci_add_host\n");
> > +		goto err_out;
> 
> If it's possible to move the clk_prepare enable down past here, then
> you only need to do sdhci_pltfm_free() and you can remove all of the
> err_out error path.

No its not possible. sdhci_add_host() reads registers on
the IP, if the clock isn't enabled the system can hang.

> 
> > +	}
> > +
> > +	pltfm_host->priv = pdata;
> > +
> > +	platform_set_drvdata(pdev, host);
> > +
> > +	host_version = readw_relaxed((host->ioaddr + SDHCI_HOST_VERSION));
> 
> Do we want to be doing any error checking for unsupported devices
> here?

Not that I'm aware of. This is just a debug print I added as it is useful
for debugging. Its not unheard for software folks not to be told that the
IP version has changed in a new SoC, so comparing dmesg traces of working
kernels with non working ones which include IP versions etc can often
shed some light on whats happening.

Arguably if the maintainers think its helpful then it could be added in 
sdhci_add_host(), and every platform would benefit. Or if its deemed 
not helpful then it can be removed!

Cheers,

Peter.
