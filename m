Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaETRmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:42:42 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:46884 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbaETRmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:42:39 -0400
Date: Tue, 20 May 2014 11:42:26 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>
Subject: Re: [PATCH v1 5/5] pci: keystone: add pcie driver based on
 designware core driver
Message-ID: <20140520174226.GC5130@obsidianresearch.com>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com>
 <6048322.x3M3sdDEWO@wuerfel>
 <5374FD24.8000806@ti.com>
 <22200719.Jb5jnJylJH@wuerfel>
 <20140515183919.GC11650@obsidianresearch.com>
 <53751DDF.40304@ti.com>
 <20140515205210.GB14722@obsidianresearch.com>
 <3E54258959B69E4282D79E01AB1F32B704742133@DFLE11.ent.ti.com>
 <20140520170221.GA5130@obsidianresearch.com>
 <CAErSpo667uWybiHOh4tVQDh_JFpF0EbvxKwo_GQm+B1-wMtT1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo667uWybiHOh4tVQDh_JFpF0EbvxKwo_GQm+B1-wMtT1Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 11:22:22AM -0600, Bjorn Helgaas wrote:
> On Tue, May 20, 2014 at 11:02 AM, Jason Gunthorpe
> <jgunthorpe@obsidianresearch.com> wrote:
> > On Fri, May 16, 2014 at 08:29:56PM +0000, Karicheri, Muralidharan wrote:
> >
> >> But pcie_bus_configure_settings just make sure the mrrs for a device
> >> is not greater than the max payload size.
> >
> > Not quite, it first scans the network checking the Maximum Payload Size
> > Supported (MPSS) for each device, and chooses the highest supported by
> > all as the MPS for all.
> 
> The "performance" setting, e.g., "pci=pcie_bus_perf", adds a few
> wrinkles by setting MRRS in ways that allow some devices to have
> larger MPS than others.  I don't think this is exactly what was
> envisioned in the spec, and it is not guaranteed to work if there is
> peer-to-peer DMA.  This isn't documented very well; the best I know of
> is the changelogs for:
> 
>   a1c473aa11e6 pci: Clamp pcie_set_readrq() when using "performance" settings
>   b03e7495a862 PCI: Set PCI-E Max Payload Size on fabric

Neat, and does pretty much confirm that setting the host bridge MPSS
properly is necessary to support all drivers, particularly the ones
that call pcie_set_readrq with any old value.

The 'performance' setting is a bit scary, it isn't just peer-to-peer
DMA that would be impacted but also CPU initiated burst writes. Eg
InfiniBand drivers burst a WQE to the NIC via the CPU. The MPS on the
root port bridge is used to segment the write. Probably not a problem
in practice because I think this is rare, and even rarer that a burst
would be > 128 bytes - but as you say, not really what the spec
intended..

Jason
