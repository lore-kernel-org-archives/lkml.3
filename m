Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab3EMLGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 07:06:47 -0400
Received: from smtp.citrix.com ([66.165.176.89]:15461 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab3EMLGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 07:06:46 -0400
X-IronPort-AV: E=Sophos;i="4.87,662,1363132800"; 
   d="scan'208";a="24810966"
Date: Mon, 13 May 2013 12:06:43 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yuval Shaia <yuval.shaia@oracle.com>,
        Feng Jin <joe.jin@oracle.com>, Chien Yen <chien.yen@oracle.com>
Subject: Re: [PATCH] xen: reuse the same pirq allocated when driver load
 first time
In-Reply-To: <20130510185339.GD2562@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1305131136020.4799@kaball.uk.xensource.com>
References: <518A0A50.1020705@oracle.com> <20130510185339.GD2562@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 May 2013, Konrad Rzeszutek Wilk wrote:
> On Wed, May 08, 2013 at 04:18:24PM +0800, Zhenzhong Duan wrote:
> > When driver load and unload in a loop, pirq will exhaust finally.
> > Try to use the same pirq which was already mapped and binded at first time
> 
> So what happens if I unload and reload two drivers in random order?
> 
> > when driver loaded.
> > 
> > Read pirq from msix entry and test if data is XEN_PIRQ_MSI_DATA
> > xen_irq_from_pirq(pirq) < 0 checking is wrong as irq will be freed
> > when driver unload, it's always true in second load.
> 
> If my understanding is right the issue at hand is that the caching
> information about the pirq disappears once the driver has been
> unloaded b/c the event's irq-info is removed (as the driver is
> unloaded and free_irq is called).
> 
> Stefano,
> Is there a specific write to the MSI structure that would cause the
> hypervisor to drop the PIRQ? Or a nice hypercall to "free" an
> PIRQ in usage?

We already have a "free PIRQ" hypercall, it's called
PHYSDEVOP_unmap_pirq and should be called by QEMU.
Linux should disable the MSI bit in the PCI config options of the
device:

pci_disable_msi -> pci_msi_shutdown -> msi_set_enable(0)

That should cause QEMU to issue a xc_physdev_unmap_pirq that actually
unmaps the pirq. If it doesn't, it's a bug :)


> I presume that on the first load the msg.data value is
> ALWAYS != XEN_PIRQ_MSI_DATA right? Is that somethign we can ALWAYS
> depend? Or is there a possibility that it could be that when the
> PCI device is unplugged from one guest and plugged in another?
> 
> Could we use PHYSDEVOP_irq_status_query to figure out if the PIRQ
> has been already allocated? Ah, does not look like it.
> 
> I am a bit worried about depending on just msg.data to tells us
> whether the device had been initialized before.

Data comes from QEMU, I think it is zeroed at init time.
