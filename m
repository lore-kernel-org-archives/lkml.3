Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012AbaGYH7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:59:11 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:21801
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750828AbaGYH7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:59:09 -0400
Date: Fri, 25 Jul 2014 15:57:56 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Varka Bhadram <varkabhadram@gmail.com>
CC: Nicolin Chen <nicoleotsuka@gmail.com>, <broonie@kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <timur@tabi.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <shawn.guo@linaro.org>, <b02247@freescale.com>, <b42378@freescale.com>,
        <tklauser@distanz.ch>
Subject: Re: [PATCH v4 2/2] ASoC: fsl_asrc: Add ASRC ASoC CPU DAI and
 platform drivers
Message-ID: <20140725075755.GA29564@MrMyself>
References: <cover.1406271541.git.nicoleotsuka@gmail.com>
 <69b75ae4b0335cd3c9bedad67f57aaba13c0048c.1406271541.git.nicoleotsuka@gmail.com>
 <53D208A9.3040903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53D208A9.3040903@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(479174003)(189002)(377454003)(51704005)(199002)(50466002)(83072002)(64706001)(1411001)(97756001)(99396002)(26826002)(31966008)(107046002)(106466001)(95666004)(46406003)(6806004)(33656002)(47776003)(87936001)(81156004)(81542001)(33716001)(110136001)(79102001)(83506001)(50986999)(68736004)(46102001)(44976005)(76482001)(105606002)(20776003)(21056001)(81342001)(85306003)(84676001)(97736001)(76176999)(80022001)(74662001)(4396001)(54356999)(92566001)(86362001)(102836001)(74502001)(104016003)(92726001)(77982001)(69596002)(23726002)(83322001)(85852003)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB329;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Varka,

Thank you for the comments!

On Fri, Jul 25, 2014 at 01:05:05PM +0530, Varka Bhadram wrote:
> On 07/25/2014 12:49 PM, Nicolin Chen wrote:
> (...)
> 
> >+static const struct platform_device_id fsl_asrc_devtype[] = {
> >+	{
> >+		.name = "imx35-asrc",
> >+		.driver_data = IMX35_ASRC,
> >+	}, {
> >+		.name = "imx53-asrc",
> >+		.driver_data = IMX53_ASRC,
> >+	}, {
> >+		/* sentinel */
> >+	}
> >+};
> >+MODULE_DEVICE_TABLE(platform, fsl_asrc_devtype);
> >+
> 
> where are you using fsl_asrc_devtype,,,?
> 
> >+static const struct of_device_id fsl_asrc_ids[] = {
> >+	{
> >+		.compatible = "fsl,imx35-asrc",
> >+		.data = &fsl_asrc_devtype[IMX35_ASRC],
> 
> Ya here ... but what is the use...?

I got your point. I will drop all these and move ids behind probe/remove()
as you suggested at the first place and then use of_device_is_compatible()
inside the probe() instead.

> >+	asrc_priv->regmap = devm_regmap_init_mmio_clk(&pdev->dev,
> >+			"mem", regs, &fsl_asrc_regmap_config);
> 
> devm_regmap_init_mmio_clk(&pdev->dev,
> 			  "mem", regs,
> 			  &fsl_asrc_regmap_config);

I'll refine to

 devm_regmap_init_mmio_clk(&pdev->dev, "mem", regs,
                           &fsl_asrc_regmap_config);

> 
> >+	if (IS_ERR(asrc_priv->regmap)) {
> >+		dev_err(&pdev->dev, "failed to init regmap\n");
> >+		return PTR_ERR(asrc_priv->regmap);
> >+	}
> >+
> >+	irq = platform_get_irq(pdev, 0);
> >+	if (irq < 0) {
> >+		dev_err(&pdev->dev, "no irq for node %s\n", np->full_name);
> >+		return irq;
> >+	}
> >+
> >+	ret = devm_request_irq(&pdev->dev, irq, fsl_asrc_isr, 0,
> >+			       asrc_priv->name, asrc_priv);
>
> same...

Sorry I don't see any problem with this devm_request_irq()...

Thank you,
Nicolin
