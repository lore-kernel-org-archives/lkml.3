Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaIIT7o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:59:44 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:45538 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaIIT7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:59:42 -0400
Date: Tue, 9 Sep 2014 12:59:29 -0700
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Timur Tabi <timur@tabi.org>
Cc: Shengjiu Wang <shengjiu.wang@freescale.com>, Li.Xiubo@freescale.com,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, mpa@pengutronix.de
Subject: Re: [PATCH V1] ASoC: fsl_ssi: refine ipg clock usage in this module
Message-ID: <20140909195928.GA5224@Asurada>
References: <e5a50d8bfde3aea5fcd092118da5aea4072c7e2f.1410254125.git.shengjiu.wang@freescale.com>
 <20140909183804.GA6944@Asurada>
 <540F5706.1050303@tabi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540F5706.1050303@tabi.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 02:37:42PM -0500, Timur Tabi wrote:
> On 09/09/2014 01:38 PM, Nicolin Chen wrote:
> >make sure to have the call for imx only because it seems that
> >the other platforms do not depend on the clock.
> 
> Although I doubt anyone will every add support for clocks to PowerPC "side"
> of this driver, I would prefer to avoid IMX-specific changes. Instead, the
> code should check if a clock is available.  That's why I suggested this
> change:
> 
> -	if (ssi_private->soc->imx)
> +	if (!IS_ERR(ssi_private->clk))

Hmm.... I think the following change may be better?

probe() {
	....
+	/*
+	 * Initially mark the clock to NULL for all platforms so that later
+	 * clk_prepare_enable() will ignore and return 0 for non-clock cases.
+	 */
+	ssi_private->clk = NULL;
	.....
	fsl_ssi_imx_probe();
}

In this way, all platforms, not confined to imx any more, will be able
to call clk_prepare_enable(). Then we don't need an extra platform check
before calling it.
