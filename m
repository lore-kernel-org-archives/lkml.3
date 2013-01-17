Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab3AQKf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:35:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:15924 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759489Ab3AQKfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:35:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,484,1355126400"; 
   d="scan'208";a="248242189"
Date: Thu, 17 Jan 2013 12:39:13 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        eric.y.miao@gmail.com, linux@arm.linux.org.uk,
        haojian.zhuang@gmail.com, broonie@opensource.wolfsonmicro.com,
        chao.bi@intel.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 07/11] spi/pxa2xx: add support for DMA engine
Message-ID: <20130117103913.GT2239@intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
 <1357555480-24022-8-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdb+W5Xiek24X00p+bY8CaeErfCWuLqGOfeVTXCsi1KJxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb+W5Xiek24X00p+bY8CaeErfCWuLqGOfeVTXCsi1KJxw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 10:48:15AM +0100, Linus Walleij wrote:
> On Mon, Jan 7, 2013 at 11:44 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > In order to use DMA with this driver on non-PXA platforms we implement support
> > for the generic DMA engine API. This allows to use different DMA engines with
> > little or no modification to the driver.
> >
> > Request lines and channel numbers can be passed to the driver from the
> > platform specific data.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> >  drivers/spi/spi-pxa2xx.c       |  351 +++++++++++++++++++++++++++++++++++++++-
> >  include/linux/spi/pxa2xx_spi.h |    6 +
> 
> So if the other DMA implementation could go into spi-pxa2xx-pxadma.c
> this could be spi-pxa2xx-dma.c and they could use the common header
> file spi-pxa2xx-dma.h and then Kconfig select which one to compile.
> 
> Just a suggestion to get the driver more readable.

Yes, it makes perfect sense. I'll do that in the next version.

> > +       /*
> > +        * Some DMA controllers have problems transferring buffers that are
> > +        * not multiple of 4 bytes. So we truncate the transfer so that it
> > +        * is suitable for such controllers, and handle the trailing bytes
> > +        * manually after the DMA completes.
> > +        */
> > +       len = ALIGN(drv_data->len, 4);
> 
> This is actually a property of the DMA controller.

Right and this is not the proper place for this but I wasn't sure where to
put this information...

> struct dma_device already has this:
> 
>  * @copy_align: alignment shift for memcpy operations
>  * @xor_align: alignment shift for xor operations
>  * @pq_align: alignment shift for pq operations
>  * @fill_align: alignment shift for memset operations
> (...)
>         u8 copy_align;
>         u8 xor_align;
>         u8 pq_align;
>         u8 fill_align;
> 
> To align memcpy's on 4 bytes you can e.g. set .copy_align
> to 2.
> 
> So the syntax is number of shifts 1 << 2 = 4.
> 
> If slave transfers can expose the same type of property we should
> maybe introdyce .slave_align in the same manner so you don't have
> to assume the worst in the driver.

... so this sounds good to me.
