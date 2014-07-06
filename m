Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaGGJyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 05:54:33 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:52988 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaGGJyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 05:54:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [RFC 01/10] iommu: Add IOMMU device registry
Date: Sun, 6 Jul 2014 20:17:22 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Thierry Reding <thierry.reding@gmail.com>, Joerg Roedel <joro@8bytes.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <amartin@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com> <20140704134709.GA4203@ulmo> <20140704134928.GA25714@arm.com>
In-Reply-To: <20140704134928.GA25714@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201407062017.23049.arnd@arndb.de>
X-Provags-ID: V02:K0:Zw3KPfcpa+iIHzz+29MIAuPR9OEkgcoAHs3zN+E7ZnA
 WO2iQvv0cN4h1n/dXUQrrYxd+4yeVPkAQq2/KZKz/1ZLfz5a0e
 ij9UVxh3JmPX8YO5t5GMR6f9h0SGjT8kmti6xzgPUQoBW4WQ1q
 /RjFgVbd+O2y+exJ2YQQNXgUCgplqwSx2PJuZ7/7rkdxNbXPMs
 HjS+8nxnrTtYkgGKZ4zkxgVFP01sixMBlhowndlDdDQj5+ZSWQ
 hM5Wf3YsSwHXTFL+ukvowFoOh2rGruChUMgGnhs8MlsnwcNzDO
 Mnsib2DHlZMj0A0UQj4K1cQ3U1ft3oxtV2AZEZR3qjt46GDNa4
 RFZHad2mHL3DpRwvTWsjdlJtLWjkk6udhmE+RROTM
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 July 2014, Will Deacon wrote:
> On Fri, Jul 04, 2014 at 02:47:10PM +0100, Thierry Reding wrote:
> > On Fri, Jul 04, 2014 at 01:05:30PM +0200, Joerg Roedel wrote:
> > > On Thu, Jun 26, 2014 at 10:49:41PM +0200, Thierry Reding wrote:
> > > > Add an IOMMU device registry for drivers to register with and implement
> > > > a method for users of the IOMMU API to attach to an IOMMU device. This
> > > > allows to support deferred probing and gives the IOMMU API a convenient
> > > > hook to perform early initialization of a device if necessary.
> > > 
> > > Can you elaborate on why exactly you need this? The IOMMU-API is
> > > designed to hide any details from the user about the available IOMMUs in
> > > the system and which IOMMU handles which device. This looks like it is
> > > going in a completly different direction from that.
> > 
> > I need this primarily to properly serialize device probing order.
> > Without it the IOMMU may be probed later than its clients, in which case
> > the client drivers will assume that there is no IOMMU (iommu_present()
> > for the parent bus fails).
> 
> I can also vouch for needing a solution to this problem. The ARM SMMU (and
> I think others) rely on initcall ordering rather than the driver probing
> model to ensure the IOMMU is probed before any of its masters.

I think it would be best to attach platform devices to IOMMUs from the
of_dma_configure() we just introduced. That still requires handling
IOMMUs special though, and I don't know how we should best deal
with that. It would not be too hard to scan for IOMMUs in DT first
and register them all in a way that we can later look them up
by phandle, but that would break down if we ever get nested IOMMUs.

Another possibility might be to register all devices as we do today,
including IOMMU devices, but return -EPROBE_DEFER from
platform_drv_probe() before we call into the driver's probe function
if the IOMMU has not been set up at that point.

For PCI devices, we need a different way of dealing with the IOMMUs,
some generic PCI code needs to be added to attach the correct IOMMU
to a newly added PCI device based on how the host bridge is configured.

We can probably for now get away with not worrying about any bus type
other than platform, amba or PCI: we don't use any other DMA master
capable bus on ARM, and other architectures can probably rely on
having only a single IOMMU implementation in the system.

	Arnd
