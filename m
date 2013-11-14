Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab3KNUMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:12:41 -0500
Received: from 17.mo6.mail-out.ovh.net ([46.105.36.150]:58211 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755737Ab3KNUMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:12:35 -0500
X-Greylist: delayed 12599 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Nov 2013 15:12:35 EST
Date: Thu, 14 Nov 2013 17:38:17 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, nicolas.ferre@atmel.com,
        alexandre.belloni@free-electrons.com, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 1/2] PWM: atmel-pwm: add PWM controller driver
Message-ID: <20131114163817.GK28304@ns203013.ovh.net>
References: <1383292767-11211-1-git-send-email-voice.shen@atmel.com>
 <20131113095628.GI28304@ns203013.ovh.net>
 <52846D94.5090608@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52846D94.5090608@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 18206645920100231987
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrieegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrieegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>+MODULE_DEVICE_TABLE(of, atmel_pwm_dt_ids);
> >>+#endif
> >>+
> >>+static int atmel_pwm_probe(struct platform_device *pdev)
> >>+{
> >>+	const struct of_device_id *of_id =
> >>+		of_match_device(atmel_pwm_dt_ids, &pdev->dev);
> >>+	const struct atmel_pwm_data *data;
> >>+	struct atmel_pwm_chip *atmel_pwm;
> >>+	struct resource *res;
> >>+	int ret;
> >>+
> >>+	atmel_pwm = devm_kzalloc(&pdev->dev, sizeof(*atmel_pwm), GFP_KERNEL);
> >>+	if (!atmel_pwm)
> >>+		return -ENOMEM;
> >>+
> >>+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >>+	if (!res)
> >>+		return -ENODEV;
> >>+
> >>+	atmel_pwm->base = devm_ioremap_resource(&pdev->dev, res);
> >>+	if (IS_ERR(atmel_pwm->base))
> >>+		return PTR_ERR(atmel_pwm->base);
> >>+
> >>+	atmel_pwm->clk = devm_clk_get(&pdev->dev, NULL);
> >>+	if (IS_ERR(atmel_pwm->clk))
> >>+		return PTR_ERR(atmel_pwm->clk);
> >>+
> >>+	ret = clk_prepare(atmel_pwm->clk);
> >>+	if (ret) {
> >>+		dev_err(&pdev->dev, "failed to prepare pwm clock\n");
> >>+		return ret;
> >>+	}
> >>+
> >>+	atmel_pwm->chip.dev = &pdev->dev;
> >>+	atmel_pwm->chip.ops = &atmel_pwm_ops;
> >I get one issue here for non-dt platform
> 
> I will fix this issue for none-dt in next version.
> 
> >>+	atmel_pwm->chip.of_xlate = of_pwm_xlate_with_flags;
> >>+	atmel_pwm->chip.of_pwm_n_cells = 3;
> >those 3 no need
> 
> Which "those 3"?
> for dt / none-dt compatible, I will use following code
> --->8---
> if (pdev->dev.of_node) {
> 	atmel_pwm->chip.of_xlate = of_pwm_xlate_with_flags;
>         atmel_pwm->chip.of_pwm_n_cells = 3;
>         atmel_pwm->chip.base = -1;
> } else {
> 	atmel_pwm->chip.base = 0;
base need to choose by the board not 0
> }
> ---8<---
> 
> >>+	atmel_pwm->chip.base = -1;
> >here we need specify the base from the board so we known which pwn to use
> >for DT -1 is good as we use phandle
> 
> I will fix this issue for none-dt in next version.
> 
Best Regards,
J.
