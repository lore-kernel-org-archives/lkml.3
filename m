Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaBXUt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 15:49:59 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:32042 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaBXUt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 15:49:57 -0500
X-IronPort-AV: E=Sophos;i="4.97,536,1389744000"; 
   d="scan'208";a="103675990"
Date: Mon, 24 Feb 2014 20:49:49 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Julien Grall <julien.grall@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <xen-devel@lists.xenproject.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm/xen: Don't use xen DMA ops when the device is
 protected by an IOMMU
In-Reply-To: <20140224151636.GA13489@kroah.com>
Message-ID: <alpine.DEB.2.02.1402242036490.31489@kaball.uk.xensource.com>
References: <1392913301-25524-1-git-send-email-julien.grall@linaro.org> <1392914159.32657.18.camel@kazak.uk.xensource.com> <alpine.DEB.2.02.1402241214570.4471@kaball.uk.xensource.com> <20140224151636.GA13489@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, gregkh@linuxfoundation.org wrote:
> On Mon, Feb 24, 2014 at 12:19:11PM +0000, Stefano Stabellini wrote:
> > CC'ing Greg.
> > 
> > On Thu, 20 Feb 2014, Ian Campbell wrote:
> > > On Thu, 2014-02-20 at 16:21 +0000, Julien Grall wrote:
> > > > Only Xen is able to know if a device can safely avoid to use xen-swiotlb.
> > > > This patch introduce a new property "protected-devices" for the hypervisor
> > > > node which list device which the IOMMU are been correctly programmed by Xen.
> > > > 
> > > > During Linux boot, Xen specific code will create an hash table which
> > > > contains all these devices. The hash table will be used in need_xen_dma_ops
> > > > to check if the Xen DMA ops needs to be used for the current device.
> > > 
> > > Is it out of the question to find a field within struct device itself to
> > > store this e.g. in struct device_dma_parameters perhaps and avoid the
> > > need for a hashtable lookup.
> > > 
> > > device->iommu_group might be another option, if we can create our own
> > > group?
> > 
> > I agree that a field in struct device would be ideal.
> > Greg, get_maintainer.pl points at you as main maintainer of device.h, do
> > you have an opinion on this?
> 
> I need a whole lot more context here please.  With a patch would be even
> better so that I know exactly what you are referring to...

The Xen hypervisor tells Linux which devices are protected by an SMMU,
preprogrammed by Xen, so that Linux can avoid the swiotlb and bounce
buffers for DMA requests involving them.
The information is present on device tree and parsed at boot time by
Linux.

Julien is proposing to store the list of "safe" devices on an hash table
in the Xen specific code (in arch/arm/xen/enlighten.c, see
http://marc.info/?l=linux-kernel&m=139291370526082&w=2).
Whenever Linux is about to do DMA, we would check in the hashtable to
figure out whether we need to go through the swiotlb or we can simply
use the native dma_ops.

Ian and I were thinking that it would be much easier and faster to have
a "xen_safe_device" parameter in struct device and just check for that.
It doesn't actually need to be in struct device, it could simply be a
flag in struct device_dma_parameters as Ian was suggesting.

Julien, could you please come up with a simple patch to demonstrate the
concept?
