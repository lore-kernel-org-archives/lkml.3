Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbaIVW1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:27:42 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:48536 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754AbaIVW1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:27:40 -0400
Date: Mon, 22 Sep 2014 16:27:27 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tanmay Inamdar <tinamdar@apm.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, Liviu Dudau <liviu.dudau@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>, Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH v9 1/4] pci:host: APM X-Gene PCIe host controller driver
Message-ID: <20140922222727.GC15822@obsidianresearch.com>
References: <1410906824-9321-1-git-send-email-tinamdar@apm.com>
 <1410906824-9321-2-git-send-email-tinamdar@apm.com>
 <20140919223258.GA32208@google.com>
 <CACoXjcnVU3+fQHQ0-zEVRjoedrrod-aua6AVybj7UuSHO9HBaw@mail.gmail.com>
 <CAErSpo4C_6mh7hais14254rYBeMYArvf=nETmgvBjgP290aD4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4C_6mh7hais14254rYBeMYArvf=nETmgvBjgP290aD4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 04:09:03PM -0600, Bjorn Helgaas wrote:
> On Mon, Sep 22, 2014 at 3:33 PM, Tanmay Inamdar <tinamdar@apm.com> wrote:
> 
> >>> +static void xgene_pcie_fixup_bridge(struct pci_dev *dev)
> >>> +{
> >>> +     int i;
> >>> +
> >>> +     /* Hide the PCI host BARs from the kernel as their content doesn't
> >>> +      * fit well in the resource management
> >>> +      */
> >>
> >> This needs a better explanation than "doesn't fit well."
> >>
> >> I *think* you're probably talking about something similar to the MVEBU
> >> devices mentioned here:
> >> http://lkml.kernel.org/r/CAErSpo56jB1Bf2JtYCGKXZBZqRF1jXFxGmeewPX_e6vSXueGyA@mail.gmail.com
> >>
> >> where the device can be configured as either an endpoint or a root port,
> >> and the endpoint BARs are still visible when configured as a root port.
> >>
> >
> > It is true that X-Gene PCIe port can be configured as EP, however the
> > the FIXUP is required not because of the BARs are still visible when
> > configured as EP in past. X-Gene PCIe port, when configured as RC,
> > uses BAR0-BAR1 of RC's configuration space as inbound BARs. Entire DDR
> > region is mapped in these BARs so that it is accessible for EP devices
> > for DMA. So if the fixup is not done during enumeration, whole
> > outbound memory resource space gets assigned to RC and nothing is left
> > EP devices.
> 
> I'm not familiar with the concept of an "inbound BAR"; at least I'm
> not aware of anything like this in the PCI specs.  I think it might
> reduce confusion if we avoided calling them "BARs".  They happen to be
> at the same addresses where real BARs would be, but they certainly
> don't behave like real BARs.

So what does the lspci look like?

If x-gene has an otherwise correct bridge config space and only the
0/1 BARs have a non-standard meaning, that I'd agree with Bjorn, hide
all access to these registers from the kernel (and tell your HW crew
to read the specs, because it is very clear what those registers are
supposed to do) .

If x-gene doesn't even have a bridge config space, then there are much
bigger problems, and these corrupt BARs are just the start.

Jason
