Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898Ab3GRS6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 14:58:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37132 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933065Ab3GRS6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 14:58:23 -0400
Message-ID: <51E83A9D.5020008@ti.com>
Date: Thu, 18 Jul 2013 13:57:33 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
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
        Arnd Bergmann <arnd@arndb.de>, <vinod.koul@intel.com>
Subject: Re: [PATCH 1/3] dmaengine: add dma_get_slave_sg_limits()
References: <1374166001-31340-1-git-send-email-joelf@ti.com> <1374166001-31340-2-git-send-email-joelf@ti.com> <20130718170825.GZ21614@n2100.arm.linux.org.uk>
In-Reply-To: <20130718170825.GZ21614@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 12:08 PM, Russell King - ARM Linux wrote:
> On Thu, Jul 18, 2013 at 11:46:39AM -0500, Joel Fernandes wrote:
>> The API is optionally implemented by dmaengine drivers and when
>> unimplemented will return a NULL pointer. A client driver using
>> this API provides the required dma channel, address width, and
>> burst size of the transfer. dma_get_slave_sg_limits() returns an
>> SG limits structure with the maximum number and size of SG segments
>> that the given channel can handle.
> 
> Please look at what's already in struct device:
> 
> struct device {
> ...
>         struct device_dma_parameters *dma_parms;
> ...
> };
> 
> This provides:
> 
> struct device_dma_parameters {
>         /*
>          * a low level driver may set these to teach IOMMU code about
>          * sg limitations.
>          */
>         unsigned int max_segment_size;
>         unsigned long segment_boundary_mask;
> };
> 
> Now, these are helpfully accessed via:
> 
> dma_get_max_seg_size(dev)
> dma_set_max_seg_size(dev)
> dma_get_seg_boundary(dev)
> dma_set_seg_boundary(dev, mask)
> Drivers already use these to work out how to construct the scatterlist
> before passing it to the DMA API, which means that they should also be
> used when creating a scatterlist for the DMA engine (think about it -
> you have to use the DMA API to map the buffers for the DMA engine too.)
> 
> So, we already have two properties defined on a per-device basis: the
> maximum size of a scatterlist segment, and the boundary over which any
> segment must not cross.
> 
> The former ties up with your max_seg_len() property, though arguably it
> may depend on the DMA engine access size.  The problem with implementing
> this new API though is that the subsystems (such as SCSI) which already
> use dma_get_max_seg_size() will be at odds with what is possible via the
> DMA engine.

Not very clear for this particular case, are you saying the DMAEngine
driver implementation should set the max_seg_size of its own struct dev,
and then the drivers retrieve it from the channel they are allocated?

> I strongly suggest using the infrastructure at device level and not
> implementing some private DMA engine API to convey this information.

Certainly see the value. OK with either approach. Can Vinod add to the
discussion here, and we can decide a way forward? Is it ok to use the
new CAPS API added for now so that we can keep AM33xx MMC alive?
seg_size atleast is a real regression, the number of slots limit however
is related more to MMC grabbing a lot of slots. Atleast for -rc cycle
the seg_size and MMC fixes should go in.

> As for the maximum number of scatterlist entries, really that's a bug in
> the DMA engine implementations if they can't accept arbitary lengths.
> I've created DMA engine drivers for implementations where you have to
> program each segment individually, ones which can have the current and
> next segments, as well as those which can walk a list.  Provided you get
> informed of a transfer being completed, there really is no reason for a
> DMA engine driver to limit the number of scatterlist entries that it
> will accept.

Sure, that makes sense. Can you point to such a typical example
implementation to get some ideas?

Thanks,

-Joel
