Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174Ab3GRRKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 13:10:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37477 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933016Ab3GRRK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 13:10:27 -0400
Date: Thu, 18 Jul 2013 18:08:25 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Joel Fernandes <joelf@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Balaji TK <balajitk@ti.com>, Gururaja Hebbar <gururaja.hebbar@ti.com>,
        Chris Ball <cjb@laptop.org>, Jason Kridner <jkridner@beagleboard.org>,
        Mark Jackson <mpfj-list@newflow.co.uk>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/3] dmaengine: add dma_get_slave_sg_limits()
Message-ID: <20130718170825.GZ21614@n2100.arm.linux.org.uk>
References: <1374166001-31340-1-git-send-email-joelf@ti.com> <1374166001-31340-2-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374166001-31340-2-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 11:46:39AM -0500, Joel Fernandes wrote:
> The API is optionally implemented by dmaengine drivers and when
> unimplemented will return a NULL pointer. A client driver using
> this API provides the required dma channel, address width, and
> burst size of the transfer. dma_get_slave_sg_limits() returns an
> SG limits structure with the maximum number and size of SG segments
> that the given channel can handle.

Please look at what's already in struct device:

struct device {
...
        struct device_dma_parameters *dma_parms;
...
};

This provides:

struct device_dma_parameters {
        /*
         * a low level driver may set these to teach IOMMU code about
         * sg limitations.
         */
        unsigned int max_segment_size;
        unsigned long segment_boundary_mask;
};

Now, these are helpfully accessed via:

dma_get_max_seg_size(dev)
dma_set_max_seg_size(dev)
dma_get_seg_boundary(dev)
dma_set_seg_boundary(dev, mask)

Drivers already use these to work out how to construct the scatterlist
before passing it to the DMA API, which means that they should also be
used when creating a scatterlist for the DMA engine (think about it -
you have to use the DMA API to map the buffers for the DMA engine too.)

So, we already have two properties defined on a per-device basis: the
maximum size of a scatterlist segment, and the boundary over which any
segment must not cross.

The former ties up with your max_seg_len() property, though arguably it
may depend on the DMA engine access size.  The problem with implementing
this new API though is that the subsystems (such as SCSI) which already
use dma_get_max_seg_size() will be at odds with what is possible via the
DMA engine.

I strongly suggest using the infrastructure at device level and not
implementing some private DMA engine API to convey this information.

As for the maximum number of scatterlist entries, really that's a bug in
the DMA engine implementations if they can't accept arbitary lengths.
I've created DMA engine drivers for implementations where you have to
program each segment individually, ones which can have the current and
next segments, as well as those which can walk a list.  Provided you get
informed of a transfer being completed, there really is no reason for a
DMA engine driver to limit the number of scatterlist entries that it
will accept.
