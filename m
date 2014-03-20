Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbaCTLib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:38:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49216 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaCTLi3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:38:29 -0400
Date: Thu, 20 Mar 2014 11:38:21 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 3/3] arm64: Add architecture support for PCI
Message-ID: <20140320113820.GH6457@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Will Deacon <Will.Deacon@arm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Tanmay Inamdar <tinamdar@apm.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com>
 <8312584.jdZZuHGAjg@wuerfel>
 <20140320094654.GZ6457@e106497-lin.cambridge.arm.com>
 <201403201217.22339.arnd@arndb.de>
MIME-Version: 1.0
In-Reply-To: <201403201217.22339.arnd@arndb.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 20 Mar 2014 11:38:35.0059 (UTC) FILETIME=[ED7DB030:01CF4430]
X-MC-Unique: 114032011382702901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 11:17:22AM +0000, Arnd Bergmann wrote:
> On Thursday 20 March 2014, Liviu Dudau wrote:
> > On Wed, Mar 19, 2014 at 06:37:51PM +0000, Arnd Bergmann wrote:
> > > On Wednesday 19 March 2014 17:21:41 Liviu Dudau wrote:
> > > > 
> > > > My ultimate point is that no matter how long we argue about the shape of the functions that
> > > > I've added into arch/arm64/kernel/pci.c I don't think we can get away without having that
> > > > file, or at least not in the first phase if we want speedy integration into mainline.
> > > 
> > > Let me simplify the discussion here:
> > > 
> > > NAK to adding yet another architecture specific implementation.
> > 
> > So what would be your approach for handling pci_address_to_pio() in a non-arch specific way?
> > 
> > unsigned long __weak pci_address_to_pio(phys_addr_t address)
> > {
> > #ifdef ARCH_HAS_IOSPACE
> >         if (address > IO_SPACE_LIMIT)
> >                 return (unsigned long)-1;
> > 
> >         return (unsigned long) address;
> > #else
> >         struct ioresource *res;
> > 
> >         list_for_each_entry(res, &io_list, list) {
> >                 if (address >= res->start &&
> >                         address < res->start + res->size) {
> >                         return res->start - address;
> >                 }
> >         }
> > 
> >         return (unsigned long)-1;
> > #endif
> > }
> > 
> > 
> > Either that, or you have more magic rabbits than me.
> 
> I don't even understand why you want to create a generic pci_address_to_pio
> implementation, when we don't need that for arm64 at all. Unless I'm
> missing something important, that function is only called in case of
> PCI_PROBE_DEVTREE with pci_of_scan on PowerPC. I don't expect any
> architecture to do the same thing, and the only other architecture that
> needs something like it (sparc) has a different implementation.

Because in my [v7 2/6]* patch for the generic host bridge support I start
using pci_address_to_pio to fix the conversion of PCI ranges to resources.
That requires an arm64 (or more correctly, an arch with memory mapped IO
specific) version of pci_address_to_pio().

Best regards,
Liviu

> 
> The regular (non-DEVTREE) PCI bus scan should just be able to translate
> the BUS I/O addresses into Linux I/O port numbers using io_offset,
> without going through an intermediate step of translating into a CPU
> physical address first, so the entire lookup method won't get used.
> 
> The reason why PowerPC needs it is that they traditionally don't
> use PCI config space access to assign or look at resources, but
> instead rely on the firmware to have set it up in advance and then
> put matching information into DT and the BARs. For Solaris and AIX,
> it's probably easier to use the information from DT, but in Linux,
> we already need to implement the manual bus scan, e.g. to do
> PCI device hotplugging if nothing else.
> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

