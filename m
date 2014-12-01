Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbaLATjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:39:49 -0500
Received: from smtp-out-249.synserver.de ([212.40.185.249]:1032 "EHLO
	smtp-out-249.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094AbaLATjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:39:48 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13987
Message-ID: <547CC407.30308@metafoo.de>
Date: Mon, 01 Dec 2014 20:39:51 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Timur Tabi <timur@tabi.org>, Markus Pargmann <mpa@pengutronix.de>,
        Jiada Wang <jiada_wang@mentor.com>
CC: alsa-devel@alsa-project.org, lgirdwood@gmail.com, tiwai@suse.de,
        Li.Xiubo@freescale.com, nicoleotsuka@gmail.com, broonie@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] ASoC: fsl_ssi: free irq before irq_dispose_mapping()
References: <1417402251-6596-1-git-send-email-jiada_wang@mentor.com> <20141201065046.GB27289@pengutronix.de> <547C9C34.9080602@metafoo.de> <547CB817.10806@tabi.org>
In-Reply-To: <547CB817.10806@tabi.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 07:48 PM, Timur Tabi wrote:
> On 12/01/2014 10:49 AM, Lars-Peter Clausen wrote:
>> The driver creates the mapping by calling irq_of_parse_and_map(), so it
>> also has to dispose the mapping.
>
> I agree with Markus, this does seem weird.  It sounds like you're saying
> that irq_of_parse_and_map() and devm_request_irq() are incompatible.

They probably are. You have to create the mapping before you request the IRQ 
and if devm_request_irq() is used the IRQ is only freed again after the 
remove function of the driver been called. Yet if a driver creates a mapping 
in its probe function it should also dispose it in its remove function. So 
you are stuck with either freeing the mapping before freeing the IRQ or 
leaking the mapping.

My opinion on this is that devices should not create mappings and should 
leave that to the core. This quite easily solves the dilemma.

> A quick grep shows the following drivers that call both functions:
>

Most of these drivers will probably work fine without irq_of_parse_and_map().

> ata/pata_mpc52xx.c
> built-in.o
> cpufreq/exynos5440-cpufreq.c
> crypto/omap-sham.c
> dma/moxart-dma.c
> edac/mpc85xx_edac.c
> hsi/clients/nokia-modem.c
> i2c/busses/i2c-wmt.c
> input/serio/apbps2.c
> mmc/host/omap_hsmmc.c
> mmc/host/moxart-mmc.c
> mtd/nand/mpc5121_nfc.c
> net/ethernet/arc/emac_main.c
> net/ethernet/moxa/moxart_ether.c
> pci/host/pcie-rcar.c
> pinctrl/samsung/pinctrl-exynos5440.c
> pinctrl/samsung/pinctrl-exynos.c
> pinctrl/pinctrl-bcm2835.c
> spi/spi-bcm2835.c
> spi/spi-mpc512x-psc.c
> staging/xillybus/xillybus_of.c
> thermal/samsung/exynos_tmu.c
>

