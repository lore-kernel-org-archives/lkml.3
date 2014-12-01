Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbaLAT4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:56:35 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:63371 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbaLAT4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:56:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: Mark Brown <broonie@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        alsa-devel@alsa-project.org, Jiada Wang <jiada_wang@mentor.com>,
        linux-kernel@vger.kernel.org, Timur Tabi <timur@tabi.org>,
        lgirdwood@gmail.com, nicoleotsuka@gmail.com, tiwai@suse.de,
        Li.Xiubo@freescale.com, Markus Pargmann <mpa@pengutronix.de>
Subject: Re: [alsa-devel] [PATCH] ASoC: fsl_ssi: free irq before irq_dispose_mapping()
Date: Mon, 01 Dec 2014 20:56:23 +0100
Message-ID: <2547588.Qc4F2IfZke@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141201194147.GP7712@sirena.org.uk>
References: <1417402251-6596-1-git-send-email-jiada_wang@mentor.com> <547CC407.30308@metafoo.de> <20141201194147.GP7712@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:T+lubgdoGcGRWRuz13zcFX7TkyRSvqU+o5LqEm2jPpF
 phpa5wZ+Xo9v5LA1I2/f2KrT/jif2Q5NL1MLbN1X+R3ZpXrinJ
 0XtzgZ7J5e/IU3MsGU3DdzjKYnXE62O/dQLMBsp4D/uOS5ckp6
 NyRfhYpcFbiSCnLINROgjZduU1VzLV6vCGOYwGnXCx+C3VAo+Z
 K1FhJ8p4K3wm0Tg4WuGxRkH3kHJ/2tmYPgl/G/mHWV5z6ebntP
 /TJRYWCM+Qk32qmV/A1d1Obh2f0WXhqQ2x6W/GeFbPK7FfcFI0
 xyxPgRpDTMGojezcQ15nucc9qpDnbvbEYPFHQkeshQdEbi8uZd
 KuzsIoomESCG3DMGC030=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 December 2014 19:41:47 Mark Brown wrote:
> On Mon, Dec 01, 2014 at 08:39:51PM +0100, Lars-Peter Clausen wrote:
> > On 12/01/2014 07:48 PM, Timur Tabi wrote:
> 
> > >A quick grep shows the following drivers that call both functions:
> 
> > Most of these drivers will probably work fine without irq_of_parse_and_map().
> 
> I'd also note that quite a few of these drivers look pretty legacy - a
> very large proportion are for old PowerPC hardware, though by no means
> all.

Right, from the times before we were using platform_device for probing
device tree based devices and they had to map the interrupt themselves.

Some of them like arch/powerpc/sysdev/fsl_pci.c seem fine, this one
is does not expect to ever destroy a device, and it only unmaps the
interrupt if request_irq fails. drivers/ata/pata_mpc52xx.c on the
other hand seems wrong in the same was as drivers/edac/mpc85xx_edac.c
and sound/soc/fsl/fsl_ssi.c.

All other drivers that call irq_of_parse_and_map and pass that into
devm_request_irq just never unmap, and their interrupts are already
mapped by the platform code, so I think it's not even a leak.

	Arnd
