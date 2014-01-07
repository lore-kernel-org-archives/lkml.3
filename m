Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaAGR2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:28:00 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:56123 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbaAGR1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:27:49 -0500
Date: Tue, 7 Jan 2014 10:27:34 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pci@vger.kernel.org,
        patches <patches@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jon Masters <jcm@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 2/3] arm64: dts: APM X-Gene PCIe device tree nodes
Message-ID: <20140107172734.GC4227@obsidianresearch.com>
References: <1387785725-24262-1-git-send-email-tinamdar@apm.com>
 <1387785725-24262-3-git-send-email-tinamdar@apm.com>
 <20131223174634.GD25089@obsidianresearch.com>
 <CACoXjcnPvgDX3s8OywLHP6Tu2OrpNzM1Phx+s3RLmKDgu3t8gA@mail.gmail.com>
 <20140103005253.GB12098@obsidianresearch.com>
 <CACoXjcnykxdjekfmz6B3Ovk-+naCCOCWFZ3t=ZaMWAEPyVs_eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACoXjcnykxdjekfmz6B3Ovk-+naCCOCWFZ3t=ZaMWAEPyVs_eQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 06, 2014 at 06:56:21PM -0800, Tanmay Inamdar wrote:

> > There is some kind of an addressing problem because you've done this:
> >
> > +static void xgene_pcie_fixup_bridge(struct pci_dev *dev)
> > +{
> > +       int i;
> > +
> > +       for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
> > +               dev->resource[i].start = dev->resource[i].end = 0;
> > +               dev->resource[i].flags = 0;
> > +       }
> > +}
> > +DECLARE_PCI_FIXUP_HEADER(XGENE_PCIE_VENDORID, XGENE_PCIE_BRIDGE_DEVICEID,
> > +                        xgene_pcie_fixup_bridge);
> >
> > Which is usually a sign that something is wonky with how the HW is
> > being fit into the PCI core.
> 
> We map the whole DDR range (eg 256 GB) into host's BAR. The Linux PCI
> resource management tries to fit the host's memory into the ranges
> provided (eg 0xe000000000).
> Please let me know if there is any use case to do this mapping.

If you need to set the bridge's BAR like this, then the bridge is not
non-conforming.. Bridge BAR's should be 0 size unless the bridge
itself has registers.

Do any registers in this config space work properly? Does the
secondary status reflect the physical link status properly?

If it is *really* broken you might just consider hiding it from the
Linux core.

> >>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> >> <TAbort- <MAbort- >SERR- <PERR- INTx-
> >>         Latency: 0, Cache Line Size: 64 bytes
> >>         Region 0: Memory at <ignored> (64-bit, prefetchable)
> >>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
> >>         I/O behind bridge: 0000f000-00000fff
> >>         Memory behind bridge: 00c00000-00cfffff
> >
> > [..]
> >
> >> 01:00.0 Class 0200: Device 15b3:1003
> >>         Region 0: Memory at e000c00000 (64-bit, non-prefetchable) [size=1M]
> >>         Region 2: Memory at e000000000 (64-bit, prefetchable)
> >>         [size=8M]
> >
> > Something funky is going on here too, the 64 bit address e000000000
> > should be reflected in the 'memory behind bridge' above, not
> > truncated.
> 
> That's the Mellanox device that is plugged into the system. The
> device's memory gets mapped at '0xe0xxxxxxxx'

Right, but the bridge setup above has:

> >>         Memory behind bridge: 00c00000-00cfffff

Which is wrong, it doesn't include the range '0xe0xxxxxxxx'

Jason
