Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaCEISG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 03:18:06 -0500
Received: from service87.mimecast.com ([91.220.42.44]:59858 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaCEISD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 03:18:03 -0500
Date: Wed, 5 Mar 2014 08:18:00 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 0/7] [RFC] Support for creating generic host_bridge
 from device tree
Message-ID: <20140305081800.GD1692@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Tanmay Inamdar <tinamdar@apm.com>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Arnd Bergmann <arnd@arndb.de>
References: <1393948204-11555-1-git-send-email-Liviu.Dudau@arm.com>
 <CACoXjcmmbVsmvy46NhjFoBg8mRO=APiY3dZZY=ra-Ceib9Sr4A@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACoXjcmmbVsmvy46NhjFoBg8mRO=APiY3dZZY=ra-Ceib9Sr4A@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 05 Mar 2014 08:18:01.0315 (UTC) FILETIME=[6C9FD330:01CF384B]
X-MC-Unique: 114030508180112301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 01:53:55AM +0000, Tanmay Inamdar wrote:
> Hello,
> 
> Thanks for the patch set.
> 
> On Tue, Mar 4, 2014 at 7:49 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > This is v5 of my attempt to add support for a generic pci_host_bridge controller created
> > from a description passed in the device tree.
> >
> > Changes from v4:
> >   - Export pci_find_host_bridge() to be used by arch code. There is scope for
> >     making the arch/arm64 version of pci_domain_nr the default weak implementation
> >     but that would double the size of this series in order to handle all #define
> >     versions of the pci_domain_nr() function, so I suggest keeping that for a separate
> >     cleanup series.
> >
> > Changes from v3:
> >   - Dynamically allocate bus_range resource in of_create_pci_host_bridge()
> >   - Fix the domain number used when creating child busses.
> >   - Changed domain number allocator to use atomic operations.
> >   - Use ERR_PTR() to propagate the error out of pci_create_root_bus_in_domain()
> >     and of_create_pci_host_bridge().
> >
> > Changes from v2:
> >   - Use range->cpu_addr when calling pci_address_to_pio()
> >   - Introduce pci_register_io_range() helper function in order to register
> >     io ranges ahead of their conversion to PIO values. This is needed as no
> >     information is being stored yet regarding the range mapping, making
> >     pci_address_to_pio() fail. Default weak implementation does nothing,
> >     to cover the default weak implementation of pci_address_to_pio() that
> >     expects direct mapping of physical addresses into PIO values (x86 view).
> >
> > Changes from v1:
> >   - Add patch to fix conversion of IO ranges into IO resources.
> >   - Added a domain_nr member to pci_host_bridge structure, and a new function
> >     to create a root bus in a given domain number. In order to facilitate that
> >     I propose changing the order of initialisation between pci_host_bridge and
> >     it's related bus in pci_create_root_bus() as sort of a rever of 7b5436635800.
> >     This is done in patch 1/4 and 2/4.
> >   - Added a simple allocator of domain numbers in drivers/pci/host-bridge.c. The
> >     code will first try to get a domain id from of_alias_get_id(..., "pci-domain")
> >     and if that fails assign the next unallocated domain id.
> >   - Changed the name of the function that creates the generic host bridge from
> >     pci_host_bridge_of_init to of_create_pci_host_bridge and exported as GPL symbol.
> >
> >
> > v4 thread here: https://lkml.org/lkml/2014/3/3/301
> > v3 thread here: https://lkml.org/lkml/2014/2/28/216
> > v2 thread here: https://lkml.org/lkml/2014/2/27/245
> > v1 thread here: https://lkml.org/lkml/2014/2/3/380
> >
> > Best regards,
> > Liviu
> >
> > Liviu Dudau (7):
> >   pci: Introduce pci_register_io_range() helper function.
> >   pci: OF: Fix the conversion of IO ranges into IO resources.
> >   pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
> >   pci: Introduce a domain number for pci_host_bridge.
> >   pci: Use parent domain number when allocating child busses.
> >   pci: Export find_pci_host_bridge() function.
> >   pci: Add support for creating a generic host_bridge from device tree
> >
> >  drivers/of/address.c       |  39 +++++++++++++
> >  drivers/pci/host-bridge.c  | 142 ++++++++++++++++++++++++++++++++++++++++++++-
> >  drivers/pci/probe.c        |  72 +++++++++++++++--------
> >  include/linux/of_address.h |  14 +----
> >  include/linux/pci.h        |  17 ++++++
> >  5 files changed, 248 insertions(+), 36 deletions(-)
> >
> > --
> > 1.9.0
> >
> 
> This series is working fine on X-Gene with multiple PCIe ports. You
> can add my Tested-by if you want.

Cheers! Any ETA on your updated patches?

I might get the required signatures on the legal approval next week and
then I will publish my host controller driver.

Best regards,
Liviu

> 
> Thanks,
> Tanmay
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

