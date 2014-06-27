Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286AbaF0QYX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:24:23 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45382 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751084AbaF0QYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:24:21 -0400
Date: Fri, 27 Jun 2014 17:24:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andy Gross <agross@codeaurora.org>
Cc: Mark Brown <broonie@kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Daniel Sneddon <dsneddon@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Sagar Dharia <sdharia@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] spi: qup: Add DMA capabilities
Message-ID: <20140627162411.GO32514@n2100.arm.linux.org.uk>
References: <1403816781-31008-1-git-send-email-agross@codeaurora.org> <20140627105057.GF23300@sirena.org.uk> <20140627155422.GA13621@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140627155422.GA13621@qualcomm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 10:54:22AM -0500, Andy Gross wrote:
> On Fri, Jun 27, 2014 at 11:50:57AM +0100, Mark Brown wrote:
> > On Thu, Jun 26, 2014 at 04:06:21PM -0500, Andy Gross wrote:
> > 
> > > +	if (xfer->rx_buf) {
> > > +		rx_dma = dma_map_single(controller->dev, xfer->rx_buf,
> > > +			xfer->len, DMA_FROM_DEVICE);
> > 
> > It would be better to use the core DMA mapping code rather than open
> > coding.  This code won't work for vmalloc()ed addresses, or physically
> > non-contiguous addresses unless there's an IOMMU fixing things up.
> 
> Ah, ok.  So I just need a to setup the scatter gather page list and then do a
> dma_map_sg.  I'll resend once I have this in place.

Note that DMA from vmalloc'd memory is non-coherent on some platforms,
even if you use the DMA API.

The only thing that the DMA API guarantees is that the kernel mapping
will be made coherent for DMA purposes.  No other mapping has this
guarantee.

Consider a VIVT cache (like the older ARMs).  For this cache, you need
to find every alias of a physical page and flush it.  The DMA API doesn't
have that information - it can only deal with the kernel's lowmem mapping.

We have introduced a couple of helpers recently to solve the problem of
vmalloc() (since a number of filesystems now do this trick) but the
vmalloc() user has to deal with the problem:

	flush_kernel_vmap_range()
	invalidate_kernel_vmap_range()

See the bottom of Documentation/cachetlb.txt for details.

The long and the short of it is that it's better if vmalloc()'d memory
is avoided where possible.  It's also loads better if subsystems pass
physical references to memory for IO purposes where possible like our
block layer does (iow, struct page + offset, length) rather than
using randomly mapped virtual addresses, where the driver may not
know where the memory has come from.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
