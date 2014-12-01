Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaLAQ0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:26:46 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:64337 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbaLAQ0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:26:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v3 05/11] memory: add Atmel EBI (External Bus Interface) driver
Date: Mon, 01 Dec 2014 17:26:27 +0100
Message-ID: <4214030.Z2iCEM6hVA@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417429647-3419-6-git-send-email-boris.brezillon@free-electrons.com>
References: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com> <1417429647-3419-6-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:2ETcSJP5tD8dk39kjw/+6AX6TshG8lufd/LqJhvTnHw
 H1QrVLJ56YWSt2poAfduSqySIlFqnuT4FRygZ3/0jMhC9wdptF
 +sqLGGMnjNIWpvIzP0s4JNlhfe6oQUCHyZa/LYtzr2s7Ol+foa
 0W6BkKOGOdo/dYheMvK0Ijks+UKJXENxPmKnD7MWYfK9PAn0W4
 fQDtxugU6S5IRuFciRukf8WvOObWidESB/BwIou+marRhcqwrn
 1Y3alfkIlu2tdqTQKgjJsCHld/kGKOxyBQxflxbCboJu4dnLjy
 7Sq06okwRwQwhzunvKWT980Cr7mAFR6AJ8O0Py0nitu8Rhl2Kk
 tjeQ+YcRH0t5Lp8NIUL0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2014 11:27:21 Boris Brezillon wrote:
> The EBI (External Bus Interface) is used to access external peripherals
> (NOR, SRAM, NAND, and other specific devices like ethernet controllers).
> Each device is assigned a CS line and an address range and can have its
> own configuration (timings, access mode, bus width, ...).
> This driver provides a generic DT binding to configure a device according
> to its requirements.
> For specific device controllers (like the NAND one) the SMC timings
> should be configured by the controller driver through the matrix and
> smc syscon regmaps.

Nice!

> +
> +#define AT91_EBICSA_REGFIELD(soc)			\
> +	REG_FIELD(soc ## _MATRIX_EBICSA_OFF, 0,		\
> +		  AT91_MATRIX_EBI_NUM_CS - 1)
> +
> +#define AT91_MULTI_EBICSA_REGFIELD(soc, n)		\
> +	REG_FIELD(soc ## _MATRIX_EBI ## n ## CSA_OFF,	\
> +		  0, AT91_MATRIX_EBI_NUM_CS - 1)

I don't like the use macros that concatenate symbol names like
this. Why not do either

- open-code the macro contents in the few uses, to allow
  grepping for them, or

- put the register number in the syscon reference and look it
  up from there (this would be slightly more complicated for the
  second macro)

> +
> +	np = of_parse_phandle(pdev->dev.of_node, "atmel,smc", 0);
> +	if (!np)
> +		return -EINVAL;
> +
> +	ebi->smc = syscon_node_to_regmap(np);
> +	if (IS_ERR(ebi->smc))
> +		return PTR_ERR(ebi->smc);

I think this and the second instance of it can be shortened to

	ebi->smc = syscon_regmap_lookup_by_phandle(pdev->dev.of_node, "atmel,smc");


	Arnd
