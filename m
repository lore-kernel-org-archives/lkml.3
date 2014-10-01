Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbaJAJjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 05:39:44 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:49676 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaJAJjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 05:39:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Date: Wed, 01 Oct 2014 11:38:45 +0200
Message-ID: <3256560.C0cZnIlnAv@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141001084626.GZ841@e106497-lin.cambridge.arm.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com> <2430078.s4snyh5OoF@wuerfel> <20141001084626.GZ841@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:kvhfT1/luyfEgfAKPOxaNMpiIlbMnNKSVYfPT47WApU
 Y9M0nfwch290J5YD5tsHx0n4PCGRsLVbCCBa54+tZPw4msqE5v
 +VvxO49fOuEXr/+Zb7UzgML7ILhBH2rPE1gFrTcLx+cVWnjWpl
 DL4yn1pLdwfXG0P+Lnuz5G5KlqKdkcOX14oauD4PBtOLA7KDSV
 lZXqcBYPThoincVW46T+tndaDRN+gR/e9+GjjMPy2rf2FdcBNz
 t9JTOiCqfYAj6f++u//TRS/9i0Qr+4xmD1C84O1VN8mGQiLAx1
 1pEi12DKSfrCWotBPHpqqdld90t/VufpBjQLK0fqz6SkqDb6Mq
 HjJ8LeIvwRTmw7dHMDq8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 09:46:26 Liviu Dudau wrote:
> On Tue, Sep 30, 2014 at 09:01:14PM +0100, Arnd Bergmann wrote:
> > On Tuesday 30 September 2014 20:54:41 Arnd Bergmann wrote:
> > > On Tuesday 30 September 2014 18:48:21 Liviu Dudau wrote:
> > > > > > > > These are the functions I found that refer to pci_sys_data on arm32:
> > > > > > > > 
> > > > > > > > pcibios_add_bus
> > > > > > > > pcibios_remove_bus
> > > > 
> > > > These are only needed if you want to do per HB processing of the bus
> > > > 
> > > > > > > > pcibios_align_resource
> > > > 
> > > > mvebu is the only user of this function.
> > > > 
> > > > > > > > pci_mmap_page_range
> > > > 
> > > > This is only needed when mapping a PCI resource to userspace. Is that your case here?
> > > > 
> > > > > > > > pci_domain_nr
> > > > > > > > pci_proc_domain
> > > > 
> > > > We have equivalent functionality in the generic patches for those.
> > > > 
> > > 
> > > We clearly don't need those functions for the new drivers, but that's not
> > > the point. The problem is that when you build a kernel that has both
> > > a traditional host bridge driver and a new one in it, you always get those
> > > functions and they get called from the PCI core, with incorrect arguments.
> > 
> > FWIW, the last time we discussed this, I think I had suggested that the
> > functions that are currently architecture specific and have a generic
> > __weak fallback could become function pointers in a per-host structure
> > passed to pci_scan_root_bus, either a new structure or an extended
> > struct pci_ops. Something along these lines:
> 
> Agree to the general idea. But have a look why host drivers need the add_bus ops:
> to add MSI information into the bus!! If we take care of the MSI in the generic
> code there is less of a need for this function at all.


Right, if we can eliminate the need for some or all of the functions above,
we don't have to abstract them any more.

pcibios_remove_bus can just go away entirely, we don't have a single driver
on ARM that implements it. pcibios_add_bus as you say is just used for MSI
at the moment, and we could get rid of it by just moving the msi_chip
reference from pci_bus into pci_host_bridge. 

The arm32 implementations of pci_domain_nr/pci_proc_domain can probably be
removed if we change the arm32 pcibios_init_hw function to call the new
interfaces that set the domain number.

pci_mmap_page_range could either get generalized some more in an attempt
to have a __weak default implementation that works on ARM, or it could
be changed to lose the dependency on pci_sys_data instead. In either
case, the change would involve using the generic pci_host_bridge_window
list.

pcibios_align_resource should probably be per host, and we could move
that into a pointer in pci_host_bridge, something like this:

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index b7c3a5ea1fca..d9cb6c916d54 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -200,11 +200,15 @@ static int pci_revert_fw_address(struct resource *res, struct pci_dev *dev,
 static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
 		int resno, resource_size_t size, resource_size_t align)
 {
+	struct pci_host_bridge *host = find_pci_host_bridge(bus);
+	resource_size_t (*alignf)(void *, const struct resource *,
+				  resource_size_t, resource_size_t),
 	struct resource *res = dev->resource + resno;
 	resource_size_t min;
 	int ret;
 
 	min = (res->flags & IORESOURCE_IO) ? PCIBIOS_MIN_IO : PCIBIOS_MIN_MEM;
+	alignf = host->align_resource ?: pcibios_align_resource;
 
 	/*
 	 * First, try exact prefetching match.  Even if a 64-bit
@@ -215,7 +219,7 @@ static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
 	 */
 	ret = pci_bus_alloc_resource(bus, res, size, align, min,
 				     IORESOURCE_PREFETCH | IORESOURCE_MEM_64,
-				     pcibios_align_resource, dev);
+				     alignf, dev);
 	if (ret == 0)
 		return 0;
 
@@ -227,7 +231,7 @@ static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
 	     (IORESOURCE_PREFETCH | IORESOURCE_MEM_64)) {
 		ret = pci_bus_alloc_resource(bus, res, size, align, min,
 					     IORESOURCE_PREFETCH,
-					     pcibios_align_resource, dev);
+					     alignf, dev);
 		if (ret == 0)
 			return 0;
 	}
@@ -240,7 +244,7 @@ static int __pci_assign_resource(struct pci_bus *bus, struct pci_dev *dev,
 	 */
 	if (res->flags & (IORESOURCE_PREFETCH | IORESOURCE_MEM_64))
 		ret = pci_bus_alloc_resource(bus, res, size, align, min, 0,
-					     pcibios_align_resource, dev);
+					     alignf, dev);
 
 	return ret;
 }


If we decide constantly calling find_pci_host_bridge() is too expensive, we can
be more clever about it.

	Arnd
