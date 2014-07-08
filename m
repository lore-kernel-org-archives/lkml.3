Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbaGHMB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:01:28 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:20860 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbaGHMB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:01:26 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18pMQ0VF585iPvBxVUl2tzAB9frgxvdVBg=
X-DKIM: OpenDKIM Filter v2.0.1 titan 7955A5A4E98
Date: Tue, 8 Jul 2014 08:01:06 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Pisati <p.pisati@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Joerg Roedel <joro@8bytes.org>,
        Hiroshi.DOYU@nokia.com, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: 3.16rc3 multiplatform, Armada 370 and IOMMU: unbootable kernel
Message-ID: <20140708120106.GS23978@titan.lakedaemon.net>
References: <20140703135146.GA6898@luxor.wired.org>
 <53B5C61D.2060308@free-electrons.com>
 <53B5CA26.7050405@free-electrons.com>
 <1936558.QaAG1bYMuD@avalon>
 <20140705150308.GA28791@arch.cereza>
 <20140705205951.GB3678@kroah.com>
 <20140707105818.GA1101@arch.cereza>
 <20140707183002.GA5947@kroah.com>
 <20140707233758.GA1456@arch.cereza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707233758.GA1456@arch.cereza>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ezequiel,

On Mon, Jul 07, 2014 at 08:37:58PM -0300, Ezequiel Garcia wrote:
> On 07 Jul 11:30 AM, Greg Kroah-Hartman wrote:
> > On Mon, Jul 07, 2014 at 07:58:18AM -0300, Ezequiel Garcia wrote:
> [..]
> > > 
> > > I guess I snipped the thread and lost most of the information about the panic.
> > > Here's the original bug report:
> > > 
> > > http://www.spinics.net/lists/arm-kernel/msg344059.html
> > > 
> > > The problem reported involves enabling OMAP IOMMU driver and not any other IOMMU
> > > driver. Doing some tracing and adding a few prints, we found that
> > > omap_iommu_init() sets a bus notifier for the platform bus type:
> > > 
> > > omap_iommu_init -> bus_set_iommu -> iommu_bus_init:
> > > 
> > > static void iommu_bus_init(struct bus_type *bus, struct iommu_ops *ops)
> > > {
> > >         bus_register_notifier(bus, &iommu_bus_nb);
> > >         bus_for_each_dev(bus, NULL, ops, add_iommu_group);
> > > }
> > > 
> > > But the iommu bus notifier gets called for the 'pci' bus type, which
> > > has the iommu_ops field NULL (since it hasn't been set for iommu).
> > 
> > So this is what needs to be figured out, how is the notifier being
> > called with a PCI device?  Who else called iommu_bus_init() for the PCI
> > bus?
> > 
> 
> Nobody. The only caller of iommu_bus_init() the above OMAP IOMMU.
> 
> However, I found something interesting. Tried to bisect this without much
> luck; I did two bisects and ended up in the same merge commit:
> 
> # good: [0f16aa3c24a216d14d7f0587e1cbd2c1b51a38f3] Merge tag 'samsung-dt-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into next/dt
> # first bad commit: [755a9ba7bf24a45b6dbf8bb15a5a56c8ed12461a] Merge tag 'dt-for-3.16' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc into next
> 
> So, after doing a few diff's between that good and bad and searching for
> "bus_notifier" changes, saw something strange in arch/arm/mach-mvebu/coherency.c.
> 
> It seems bus_register_notifier() is been called for platform and pci devices
> with the *same* notifier block. Haven't looked close enough, but you mentioned
> that could cause trouble?
> 
> This patch fixes the issue here:

Thanks for digging in to this!  Please submit this as patch on it's own
and I'll merge it in.

thx,

Jason.
