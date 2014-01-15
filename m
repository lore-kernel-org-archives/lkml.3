Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaAOAIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:08:47 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:51278 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaAOAIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:08:45 -0500
Date: Wed, 15 Jan 2014 00:08:32 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-mmc@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] mmc: add Toshiba PCI SD controller driver
Message-ID: <20140115000832.56c62878@alan.etchedpixels.co.uk>
In-Reply-To: <201401142238.21879.linux@rainbow-software.org>
References: <201401142238.21879.linux@rainbow-software.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	pr_debug("Command IRQ complete %d %d %x\n", cmd->opcode, cmd->error,
> +	    cmd->flags);

dev_dbg... (and a few other places)


> +/* Set MMC clock / power.
> + * Note: This controller uses a simple divider scheme therefore it cannot run
> + * SD/MMC cards at full speed (24/20MHz). HCLK (=33MHz PCI clock?) is too high
> + * and the next slowest is 16MHz (div=2).
> + */
> +static void toshsd_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)

This has some very long delays with interrupts off from the
spin_lock_irqsave. I guess thats hardly #1 priority though nor a killer.


> +	/* reset */
> +	toshsd_writew(host, SD_SOFTWARERESET, 0); /* assert */
> +	mdelay(2);
> +	toshsd_writew(host, SD_SOFTWARERESET, 1); /* deassert */
> +	mdelay(2);

This doesn't do quite what you might think - if the device is mmio mapped
then the write can be posted so the mdelay(2) may not be 2mS. I guess if
the old driver didn't do it then it was already plenty long enough...


> +	base = pci_resource_start(pdev, 0);
> +	dev_info(&pdev->dev, "MMIO %pa, IRQ %d\n", &base, pdev->irq);

dbg

