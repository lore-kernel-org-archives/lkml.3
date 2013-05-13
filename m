Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab3EMOIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:08:13 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24408 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3EMOIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:08:12 -0400
Date: Mon, 13 May 2013 10:07:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yuval Shaia <yuval.shaia@oracle.com>,
        Feng Jin <joe.jin@oracle.com>, Chien Yen <chien.yen@oracle.com>
Subject: Re: [PATCH] xen: reuse the same pirq allocated when driver load
 first time
Message-ID: <20130513140749.GQ6811@phenom.dumpdata.com>
References: <518A0A50.1020705@oracle.com>
 <20130510185339.GD2562@phenom.dumpdata.com>
 <alpine.DEB.2.02.1305131136020.4799@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305131136020.4799@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 12:06:43PM +0100, Stefano Stabellini wrote:
> On Fri, 10 May 2013, Konrad Rzeszutek Wilk wrote:
> > On Wed, May 08, 2013 at 04:18:24PM +0800, Zhenzhong Duan wrote:
> > > When driver load and unload in a loop, pirq will exhaust finally.
> > > Try to use the same pirq which was already mapped and binded at first time
> > 
> > So what happens if I unload and reload two drivers in random order?
> > 
> > > when driver loaded.
> > > 
> > > Read pirq from msix entry and test if data is XEN_PIRQ_MSI_DATA
> > > xen_irq_from_pirq(pirq) < 0 checking is wrong as irq will be freed
> > > when driver unload, it's always true in second load.
> > 
> > If my understanding is right the issue at hand is that the caching
> > information about the pirq disappears once the driver has been
> > unloaded b/c the event's irq-info is removed (as the driver is
> > unloaded and free_irq is called).
> > 
> > Stefano,
> > Is there a specific write to the MSI structure that would cause the
> > hypervisor to drop the PIRQ? Or a nice hypercall to "free" an
> > PIRQ in usage?
> 
> We already have a "free PIRQ" hypercall, it's called
> PHYSDEVOP_unmap_pirq and should be called by QEMU.

Considering that we call function that allocates (PHYSDEVOP_get_free_pirq)
it in the Linux kernel (and not in QEMU), perhaps that should be done in the
Linux kernel as part of xen_destroy_irq()? Or would that confuse QEMU?

It looks like QEMU only does that hypercall (via xc_physdev_unmap_pirq)
unregister_real_device which is only called during pci unplug?

> Linux should disable the MSI bit in the PCI config options of the
> device:
> 
> pci_disable_msi -> pci_msi_shutdown -> msi_set_enable(0)

Zhenzhong, does it do that? Looking at the driver it certainly seems that way.
> 
> That should cause QEMU to issue a xc_physdev_unmap_pirq that actually
> unmaps the pirq. If it doesn't, it's a bug :)

<sigh> It doesn't do that. So two bugs:
 - QEMU doing that
 - Linux kernel doing the hypercall as well.

> 
> 
> > I presume that on the first load the msg.data value is
> > ALWAYS != XEN_PIRQ_MSI_DATA right? Is that somethign we can ALWAYS
> > depend? Or is there a possibility that it could be that when the
> > PCI device is unplugged from one guest and plugged in another?
> > 
> > Could we use PHYSDEVOP_irq_status_query to figure out if the PIRQ
> > has been already allocated? Ah, does not look like it.
> > 
> > I am a bit worried about depending on just msg.data to tells us
> > whether the device had been initialized before.
> 
> Data comes from QEMU, I think it is zeroed at init time.
