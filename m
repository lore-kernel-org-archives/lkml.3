Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbaLIUyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:54:25 -0500
Received: from mout.web.de ([212.227.15.3]:59582 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbaLIUyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:54:23 -0500
From: Alexander Stein <alexanders83@web.de>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH v3 05/11] memory: add Atmel EBI (External Bus Interface) driver
Date: Tue, 09 Dec 2014 21:53:12 +0100
Message-ID: <5455670.EDnhYEk7hP@kongar>
User-Agent: KMail/4.14.3 (Linux/3.14.14-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1417429647-3419-6-git-send-email-boris.brezillon@free-electrons.com>
References: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com> <1417429647-3419-6-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:BIQRPPPMsxownJtaOeuXD0lA7IYkDYCSK8TPj6EjzNetVv2ZRQv
 oi1ybI6SQXjOe4OOyjp96hREa0Vf8mXjGsq8RmOFBHYAfI4Rofn3gDNvf3G36R5yWIvSwCb
 Oaw9eI9IHTjG5Fq0ENyIFMgNd23z5PCHGMmJvQEKgr1bChSAECqH6SUs6H5Pfw8PEK9D8Jo
 BjSvaGLNyy+dRtdAHu/ag==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 01 December 2014, 11:27:21 wrote Boris Brezillon:
> +static int at91_ebi_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *match;
> +	struct device_node *child;
> +	struct device_node *np;
> +	struct at91_ebi *ebi;
> +	struct clk *clk;
> +	int ret;
> +
> +	match = of_match_device(at91_ebi_id_table, &pdev->dev);
> +	if (!match || !match->data)
> +		return -EINVAL;
> +
> +	ebi = devm_kzalloc(&pdev->dev, sizeof(*ebi), GFP_KERNEL);
> +	if (!ebi)
> +		return -ENOMEM;
> +
> +	ebi->caps = match->data;
> +	ebi->dev = &pdev->dev;
> +
> +	clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
> +
> +	ebi->clk = clk;
> +
> +	np = of_parse_phandle(pdev->dev.of_node, "atmel,smc", 0);
> +	if (!np)
> +		return -EINVAL;
> +
> +	ebi->smc = syscon_node_to_regmap(np);
> +	if (IS_ERR(ebi->smc))
> +		return PTR_ERR(ebi->smc);
> +
> +	/*
> +	 * The sama5d3 does not provide an EBICSA register and thus does need
> +	 * to access the matrix registers.
> +	 */
> +	if (ebi->caps->ebi_csa) {
> +		np = of_parse_phandle(pdev->dev.of_node, "atmel,matrix", 0);
> +		if (np)
         ^^^^^^^
Shouldn't this be if (!np)?

> +			return -EINVAL;
> +
> +		ebi->matrix = syscon_node_to_regmap(np);
> +		if (IS_ERR(ebi->matrix))
> +			return PTR_ERR(ebi->matrix);
> +
> +		ebi->ebi_csa = regmap_field_alloc(ebi->matrix,
> +						  *ebi->caps->ebi_csa);
> +		if (IS_ERR(ebi->ebi_csa))
> +			return PTR_ERR(ebi->ebi_csa);
> +	}
> +
> +	ret = ebi->caps->init(ebi);
> +	if (ret)
> +		return ret;
> +
> +	for_each_child_of_node(pdev->dev.of_node, child) {
> +		ret = at91_ebi_dev_setup(ebi, child);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +static struct platform_driver at91_ebi_driver = {
> +	.driver = {
> +		.name = "atmel-ebi",
> +		.of_match_table	= at91_ebi_id_table,
> +	},
> +};
> +module_platform_driver_probe(at91_ebi_driver, at91_ebi_probe);
> +
> +MODULE_AUTHOR("JJ Hiblot");
> +MODULE_DESCRIPTION("Atmel's EBI driver");
> +MODULE_LICENSE("GPL");


Best regards,
Alexander

