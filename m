Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaLOKqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:46:34 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:57965 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaLOKqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:46:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] mfd: cottula: add cottula board
Date: Mon, 15 Dec 2014 11:46:20 +0100
Message-ID: <4307800.p21Sk5E3dV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418598606-21352-1-git-send-email-robert.jarzmik@free.fr>
References: <1418598606-21352-1-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:nAT18YiDT17ezHc4UVLm3DNu+CGWT6O8EdNRqOMA/BjR9JOgaDu
 meg6y+gNkEdSR5ng1QvhSbQvyVzovPMEPtlWMtv5NMNhd2nuHAu/NG8C1XWAfriruMVcqC0
 PTMBMDEU+qfMLdD/Z7ftJph96S7dJZ2KF2NfWijtplabHBRUMNuipe5cwiFpgaCunJkrt9Y
 A8BMwyz3LTy9O3XR+1Wtw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 December 2014 00:10:06 Robert Jarzmik wrote:
> +
> +       platform_set_drvdata(pdev, cot);
> +       cot->gpio0 = gpiod_get(&pdev->dev, "lubbock_irq", 0);
> +       if (IS_ERR(cot->gpio0)) {
> +               dev_err(&pdev->dev, "Couldn't request GPIO : ret = %d\n", ret);
> +               return PTR_ERR(cot->gpio0);
> +       }
> +       cot->irq = gpiod_to_irq(cot->gpio0);
> +       if (cot->irq < 0)
> +               return cot->irq;
> +
> +       cot->irqdomain =
> +               irq_domain_add_linear(pdev->dev.of_node, COTTULA_NB_IRQ,
> +                                     &cottula_irq_domain_ops, cot);
> +       if (!cot->irqdomain)
> +               return -ENODEV;
> +
> +       ret = 0;
> +       if (base_irq)
> +               ret = irq_create_strict_mappings(cot->irqdomain, base_irq, 0,
> +                                                COTTULA_NB_IRQ);
> 

This looks a bit ambiguous: You get a GPIO line for the purpose of the
IRQ nesting but don't use the GPIO otherwise, and you pass the device's
own irq domain start as an IORESOURCE_IRQ resource.

For consistency between DT and ATAGS based uses, and with similar DT
based drivers, I would instead recommend passing the parent irq (from
the GPIO) as an IORESOURCE_IRQ resource instead of a gpio lookup,
and passing the base_irq as platform_data for the ATAGS case.

	Arnd
