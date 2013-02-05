Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab3BEI53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:57:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43386 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab3BEI5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:57:25 -0500
Message-ID: <1360054634.4612.37.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v8 2/4] misc: Generic on-chip SRAM allocation driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
Date: Tue, 05 Feb 2013 09:57:14 +0100
In-Reply-To: <20130204155344.GA14171@linux-sh.org>
References: <1359977538-5859-1-git-send-email-p.zabel@pengutronix.de>
	 <1359977538-5859-3-git-send-email-p.zabel@pengutronix.de>
	 <20130204155344.GA14171@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 05.02.2013, 00:53 +0900 schrieb Paul Mundt:
> On Mon, Feb 04, 2013 at 12:32:16PM +0100, Philipp Zabel wrote:
> > This driver requests and remaps a memory region as configured in the
> > device tree. It serves memory from this region via the genalloc API.
> > It optionally enables the SRAM clock.
> > 
> > Other drivers can retrieve the genalloc pool from a phandle pointing
> > to this drivers' device node in the device tree.
> > 
> > The allocation granularity is hard-coded to 32 bytes for now,
> > to make the SRAM driver useful for the 6502 remoteproc driver.
> > There is overhead for bigger SRAMs, where only a much coarser
> > allocation granularity is needed: At 32 bytes minimum allocation
> > size, a 256 KiB SRAM needs a 1 KiB bitmap to track allocations.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
> 
> How exactly is this "generic" if you have randomly hard-coded an
> allocation granularity that is larger than half of the in-tree SRAM pool
> users today can even support? Did you even bother to look at in-tree SRAM
> pool users other than the one you are working on?

I agree it should be configurable. As stated in the thread pointed out
by Matt, I'd just like to separate the discussion about the device tree
bindings for the allocation granularity from this patchset.

About the "generic" labeling, I had a look around for users of
gen_pool_create() - I admit to overlooking arch/sh/mm/sram.c, and most
of the others (except arch/arm/kernel/tcm.c drivers/acpi/apei/ghes.c,
both of which I didn't consider potential users of the sram driver) seem
to use a granularity significantly larger than 32 bytes.

> There also doesn't seem to be any real reason for the hard-coding either,
> this information could easily be fetched via platform data or the device
> tree,

True. Although the device tree is supposed to describe the hardware. The
allocation granularity is an implementation detail of the gen_pool
allocator (or possibly kind of a hardware detail of the gen_pool user,
if there are alignment requirements). That is why I didn't want to press
on with the device tree granularity configuration part yet.

> and the driver in question would simply need to be able to
> determine whether the size is suitable for it or not.

Sounds sensible to me. I'd like to follow up with Matt's patch and
something like this in a second step.

regards
Philipp

