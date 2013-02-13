Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab3BMHqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:46:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57265 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab3BMHqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:46:05 -0500
Date: Wed, 13 Feb 2013 08:45:56 +0100 (CET)
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
In-Reply-To: <511B41B8.3060506@samsung.com>
Message-ID: <Pine.LNX.4.64.1302130844530.18535@axis700.grange>
References: <87bobqrcb4.fsf@octavius.laptop.org>
 <1360656096-1671-1-git-send-email-m.szyprowski@samsung.com>
 <Pine.LNX.4.64.1302122309470.14434@axis700.grange> <511B41B8.3060506@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:H1iYgoPB0DtINyqbIDG/HTrudNkwzvcBP3QNeML5M/L
 VjeoZ+sTeai6DtNu4Eaq/WPtH7vVqhcqnQAG3tkU6cAOZ2XHsz
 pzt2o6JwOlicfuip6To0dB00J1FG7yO4QUL08njh0EbCQuh6ed
 IMdsSTTvTlwi+lEmbz+4ORApuGsISn6A2XVFe4NO9QZJJCLGjI
 SuBKJC5NadPEiZV/1eQojJsPyJHohHX78qn3hcqHySGYpLQyWK
 4kqzM3/7K63XwUh8y+qc/vNxmsZQE8GwP0z2sdPqe1TW7/z3Fz
 QAubEtw6+/O5zCL7WuyNOGn4VRi/3JowuPQwKS7TORr0+nOKFk
 vI1wv48TTI8CgI8PlmQoCjn37IFeVGPzZOSKwVydo5zNQJX1a7
 ix1us4kiapRJA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2013, Marek Szyprowski wrote:

> Hello,
> 
> On 2/12/2013 11:10 PM, Guennadi Liakhovetski wrote:
> > Hi Marek
> > 
> > On Tue, 12 Feb 2013, Marek Szyprowski wrote:
> > 
> > > Some regulators don't report any voltage values, so checking supported
> > > voltage range results in disabling all SDHCI_CAN_VDD_* flags and
> > > registration failure. This patch finally provides a correct fix for the
> > > registration of SDHCI driver with all possible voltage regulators:
> > > dummy, fixed and regulated without using regulator_count_voltages()
> > > hacks.
> > >
> > > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > > ---
> > >  drivers/mmc/host/sdhci.c |    6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> > > index ba586ae..735526b 100644
> > > --- a/drivers/mmc/host/sdhci.c
> > > +++ b/drivers/mmc/host/sdhci.c
> > > @@ -2976,7 +2976,11 @@ int sdhci_add_host(struct sdhci_host *host)
> > >  	}
> > >
> > >  #ifdef CONFIG_REGULATOR
> > > -	if (host->vmmc) {
> > > +	/*
> > > +	 * Voltage range check makes sense only if regulator reports
> > > +	 * any voltage value.
> > > +	 */
> > > +	if (host->vmmc && regulator_get_voltage(host->vmmc) > 0) {
> > >  		ret = regulator_is_supported_voltage(host->vmmc, 2700000,
> > >  			3600000);
> > 
> > Wouldn't using mmc_regulator_get_ocrmask() be a better option?
> 
> The idea behind this patch it to avoid messing ocr mask and voltage
> regulators when voltage regulator is a simple on/off switch, which doesn't
> report any value.

Wouldn't mmc_regulator_get_ocrmask() also report an error back in this 
case?

> This solves the serious problems with sdhci driver when
> dummy regulator is enabled in kconfig, otherwise the sdhci driver
> concludes that no supported voltage is available and fails to initialize.
> Using mmc_regulator_get_ocrmask() won't solve this problem.
> 
> BTW, mmc_regulator_get_ocrmask() won't work with continuous range regulators.

This seems like a problem, that has to be fixed...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
