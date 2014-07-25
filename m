Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086AbaGYIis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:38:48 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:53734 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758985AbaGYIiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:38:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Darren Hart <dvhart@linux.intel.com>, chiauee85@gmail.com,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH] spi/pxa2xx-pci: Enable DMA binding through device name
Date: Fri, 25 Jul 2014 10:38:36 +0200
Message-ID: <7309109.iKHmHOxjzD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140725082249.GX1857@lahna.fi.intel.com>
References: <1406196111-22861-1-git-send-email-hock.leong.kweh@intel.com> <5574058.fMy2hcvT92@wuerfel> <20140725082249.GX1857@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ikyCD7ClGIkSwz7MUh/ITOIAdbNVyV7NkwkMZtSNMe3
 A5UoCxkcWj38znQXUloWg/eTy4ZvFTZJhoZt9X57CF9CpYorA8
 Rfkw7FH1GmuFgo/H7KiKAzowGnsrg/4r0mtJY7xmQmOjdDasCE
 GWwo+L0IFpn6IYXFyrpjpIKgLdnlX423EqQpp9Y6ORCZiLgkb0
 zA7QTI/caN3vqUDJF+w7pIlWnM5cdw1z5zD62RO7ECaw0iQHOl
 NARfHe1ukrulTEHuDBZgp82jvvSP5YCeH5bIzr5hhp7WHOskRR
 gCM74KACTB1c6zWqJEjbErShj5wlt5q5+z9nbbtOPBXIj+3vHf
 IcJEh6lqCZKYsElGgMRo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 July 2014 11:22:49 Mika Westerberg wrote:
> > All you need to do is change your filter function to take the
> > slave id from pxa_spi_info and stick it in there, e.g.
> > 
> > static bool pxa2xx_spi_dw_dma_filter(struct dma_chan *chan, void *param)
> > {       
> >         const struct pxa2xx_spi_master *pdata = param;
> >         struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
> >         
> >         dwc->request_line = fargs->req;
> >         dwc->src_master = 0;
> >         dwc->dst_master = 0;
> >         
> >         return 1;
> > }           
> 
> Oh man. That makes pxa2xx_spi dependent on a certain specific DMA engine
> driver.

I think you can improve this by putting the filter function (and a pointer
to it) into the pxa2xx_spi_master data provided by the PCI driver.

On ARM, we usually provide those pointers through platform_data from
the board file.

> > Note that the filter function by definition is specific to the dma
> > controller, not the dma slave (that's why most people define it in
> > the dmaengine driver), and the pxa2xx_spi_dma_filter() function used
> > in spi-pxa2xx-dma.c looks like it was written for another dma engine:
> 
> I wonder what's the rationale that passing slave_id with
> dma_slave_config is wrong? The current code works fine with that and is
> is independent of the DMA engine driver (even though we know that it is
> going to be dw-dma).
> 
> The dw-dma handles slave_id in its implementation of
> dmaengine_slave_config().

The main point is that a single 'slave_id' is not actually enough to
identify what a slave needs. In case of dw_dma, the dma engine actually
requires three numbers (request line, source master, destination master)
to identify it, and there is no good way to put all that information into
a single integer. Other dma engines require a different set of data.

There are only two drivers left that actually use slave_id in this way,
and only for the legacy (no DT or ACPI) case, every other driver uses
either DT or a filter function. I believe the shmobile part will soon
be done with, after shmobile has been converted to DT, and after that
we should remove the slave_id field from the dma_slave_config interface.

	Arnd
