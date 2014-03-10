Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbaCJOdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:33:19 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45238 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752105AbaCJOdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:33:18 -0400
Date: Mon, 10 Mar 2014 14:32:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "mika.westerberg@linux.intel.com" <mika.westerberg@linux.intel.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Krogerus, Heikki" <heikki.krogerus@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Viresh Kumar <viresh.kumar@st.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@stericsson.com>, yuanyabin1978@sina.com,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Peter Pearse <peter.pearse@arm.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081
	PrimeCells
Message-ID: <20140310143247.GZ21483@n2100.arm.linux.org.uk>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com> <20101221182037.GA4783@n2100.arm.linux.org.uk> <20101222122904.GC14693@n2100.arm.linux.org.uk> <AANLkTikpyAggDCPef1pS=_QHnu9-FyLcpddGyVHnGwWx@mail.gmail.com> <20110101151545.GC25924@n2100.arm.linux.org.uk> <1394459790.2270.39.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394459790.2270.39.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 06:56:30AM -0700, David Woodhouse wrote:
> On Sat, 2011-01-01 at 15:15 +0000, Russell King - ARM Linux wrote:
> > On Wed, Dec 22, 2010 at 03:45:39PM -0800, Dan Williams wrote:
> > > Support for the DMA_COMPL flags are necessary if the DMA_MEMCPY
> > > capability is advertised, yes this driver got this wrong.  I'll update
> > > the documentation to make this requirement clear, and audit the other
> > > drivers.  With slave-only drivers the only usage model is one where
> > > the client driver owns dma-mapping.  In the non-slave (opportunistic
> > > memcpy offload) case the client is unaware of the engine so the driver
> > > owns unmapping.  The minimal fix is to disable memcpy offload.
> > 
> > As a side note, the DMA mapping for slaves should be done using the
> > DMA struct device, not the struct device of the peripheral making use
> > of the DMA engine.
> > 
> > Why?  The slave device has no knowledge of how the DMA engine is
> > connected into the system, or the DMA parameters associated with the
> > device performing the DMA, such as the DMA mask and boundaries.  (If
> > there are several generic DMA agents in the system, it can't know
> > which is the correct one to use until a channel has been allocated.)
> > The only struct device which has this information is the one for the
> > DMA engine itself.
> > 
> > Therefore, the struct device which is passed into the DMA mapping APIs
> > to prepare memory for DMA must always be the DMA engine struct device
> > (chan->device->dev) and never the slave struct device.
> 
> That all seems eminently sensible. However, I wonder if it always has to
> be true.
> 
> It is not impossible for the DMA controller to "delegate" transactions
> so that (to the IOMMU) they appear to come from the individual slave
> device rather than from itself.
> 
> The Intel IOMMU has now gained support for DMA mapping for devices
> enumerated by ACPI — essentially the ACPI "DMAR" table just has a lookup
> table of ACPI device paths, and tells us the PCI bus/devfn that their
> DMA transactions will *appear* to be from.
> 
> What we've seen is that it is the individual slave devices that are
> listed in these tables, *not* the DMA controller itself. It looks like
> we are actually expected to set up the IOMMU mapping for the *slave*,
> not the DMA controller. The system doesn't even *tell* me how to set up
> DMA mappings for the DMA controller device; only the slaves.

Okay, so how do you get the DMA address which is to be programmed into
the DMA controller - bearing in mind that different devices in the
system may have different bus:physical offsets?

ACPI may allow you to work this out for each slave device, but now
try thinking about this same problem without ACPI.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
