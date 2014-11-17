Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaKQOOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 09:14:24 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:61267 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaKQOOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 09:14:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Liviu Dudau <liviu@dudau.co.uk>, Tony Luck <tony.luck@intel.com>,
        Russell King <linux@arm.linux.org.uk>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Xinwei Hu <huxinwei@huawei.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Suravee.Suthikulpanit@amd.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-ia64@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wuyun <wuyun.wu@huawei.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 00/16] Refine PCI host bridge scan interfaces
Date: Mon, 17 Nov 2014 15:13:16 +0100
Message-ID: <1463511.o4kE8TX3Bd@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416219710-26088-1-git-send-email-wangyijing@huawei.com>
References: <1416219710-26088-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:C87M5QmCMh2uRwQe7i8gTLM0FEmNobqjNvkn6huudo8
 3NDNzHxmad038aTSXeUpfhv+aD/nqsKPeyzqA7ew+2NkwvaX1R
 y6p9d83gD/ie6Q4jq4/wJ369ymt7Sw8DTtr8wsxv+lZx5rZsc7
 GCVwPgaRuVPPkcG0JxjIxx6lzYNgjT/pNL2GQbAfCZ1cFxAI4f
 vukduZbm5gT6dhos9AdkQuvC+mNC3dEYN7AlFwdVBrKEjajGMP
 WvksNRQXj3aqd5ETwa1tVHQeRfZzWDpwZdCQujGrXGIXNMx/ta
 EU26vzEGVScea/8KYDpg9S0N6XfliRzqVyRxbS3cFMvNoOXRfF
 8tLz31Hwwow56lvbBCWg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2014 18:21:34 Yijing Wang wrote:
> This series is based Linux 3.18-rc1 and Lorenzo Pieralisi's
> arm PCI domain cleanup patches, link: 
> https://patchwork.ozlabs.org/patch/407585/
> 
> Current pci scan interfaces like pci_scan_root_bus() and directly
> call pci_create_root_bus()/pci_scan_child_bus() lack flexiblity.
> Some platform infos like PCI domain and msi_chip have to be
> associated to PCI bus by some arch specific function.
> We want to make a generic pci_host_bridge, and make it hold
> the platform infos or hook. Then we could eliminate the lots
> of arch pci_domain_nr, also we could associate some platform 
> ops something like pci_get_msi_chip(struct pci_dev *dev)
> with pci_host_bridge to avoid introduce arch weak functions.
> 
> This RFC version not for all platforms, just applied the new
> scan interface in x86/arm/powerpc/ia64, I will refresh other
> platforms after the core pci scan interfaces are ok.

I think overall this is a good direction to take, in particular
moving more things into struct pci_host_bridge so we can
slim down the architecture specific code.

I don't particularly like the way you use the 'pci_host_info'
to pass callback pointers and some of the generic information.
This duplicates some of the issues we are currently trying
to untangle in the arm32 code to make drivers easier to share
between architectures.

As a general approach, I'd rather see generic helper functions
being exported by the PCI core that a driver may or may not
call. 
The way you split the interface between things that happen
before scanning the buses (pci_create_host_bridge) and
the actual scanning (__pci_create_root_bus, pci_scan_child_bus)
seems very helpful and I think we can expand that concept further:

- The normal pci_create_host_bridge() function can contain
  all of the DT scanning functions (finding bus/mem/io resources, 
  finding the msi-parent), while drivers that don't depend on DT
  for this information can call the same function and fill the
  same things after they have the pci_host_bridge pointer.

- If a driver needs to set up mapping windows, it can do that after
  calling pci_create_host_bridge(). E.g. all the dw_pcie glue drivers
  can call a dw_pcie_setup_windows() function that takes the resources
  out of the pci_host_bridge pointer before the bus is scanned.

- The ACPI code can have a completely different way of creating
  a struct pci_host_bridge, which is also passed into the same
  bus scanning functions, but doesn't have to come from
  pci_create_host_bridge.

- The PowerPC of_scan_bus function can take the same pci_host_bridge
  pointer that comes from pci_create_host_bridge(), but we'd call
  either pci_create_root_bus or of_scan_bus instead of calling
  of_scan_bus through an indirect pointer from pci_create_root_bus.

	Arnd
