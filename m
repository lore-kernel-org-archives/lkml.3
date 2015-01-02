Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbbABVJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 16:09:45 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:63541 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbbABVJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 16:09:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [RFC 2/4] PCI: generic: Add support for ARM64 and MSI(x)
Date: Fri, 02 Jan 2015 22:09:33 +0100
Message-ID: <30239600.UAZhntKiNS@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54A6E0DE.6090309@amd.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com> <20150102115533.GA25573@red-moon> <54A6E0DE.6090309@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:a9VTKZD0XZOtUaGJ8HG3qnJZJyz40nc7d74sGRsACSkATvzAyJh
 6cMykMoBW24w/RzULcKvJY3drvQgxsNseTKAkUaESeYYCA50T5L7sbBRfE1RO6Hc7LjPWhh
 SQ3djAa9TSyqZ/1QcnhiJyVufTQ2WZ+Z8wtdqZOg77BiILlBGvlXGC1Oh1dm9+C63RPyLNI
 Pd7J2qi0xEc4inl9YrhTQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 January 2015 12:18:06 Suravee Suthikulanit wrote:
> On 1/2/2015 5:55 AM, Lorenzo Pieralisi wrote:
> > Hi Suravee,
> >
> > On Mon, Dec 29, 2014 at 07:32:44PM +0000, Suravee Suthikulpanit wrote:
> >> >Hi,
> >> >
> >> >I am not sure if this thread is still alive. I'm trying to see what I
> >> >can do to help clean up/convert to make the PCI GHC also works for arm64
> >> >w/ zero or minimal ifdefs.
> >> >
> >> >Please let me know if someone is already working on this. I noticed that
> >> >Lorenzo's patches has already been in 3.19-rc1, and in Bjorn's
> >> >pci/domain branch. Otherwise, I'll try to continue the work based on the
> >> >sample patch from Arnd here.
> > If I am not mistaken, the only bit missing to remove pci_sys_data (and so
> > having a generic host controller driver that works on ARM32/64) is generic
> > MSI management.
> 
> Lorenzo,
> 
> Do you mean to remove pci_sys_data from pci-host-generic.c or removing 
> it completely? I assume the former case.

Something inbetween: We should be able to remove pci_sys_data and
pci_common_init_dev from all drivers in drivers/pci/host/, but keep them
for all drivers in arch/arm/*/pci.c

> So, looking at the current code in the pci-host-generic.c, my 
> understanding is that the:
>      *gen_pci = pci_bus->sysdata->private_data
> will be changed to:
>      *gen_pci = pci_bus->sysdata
> 
> Then, we can simply just call pci_scan_root_bus() directly since we no 
> longer need to declare hw_pci for calling pci_common_init_dev().

Right.

> > I know for certain Marc is working on it, and the solution is WIP,
> > I think we should prevent adding more churn to pci_sys_data, since
> > I managed to remove most of the dependencies (domain, mem_offset).
> 
> Thanks for cleaning up the domain and mem_offset.
> 
> I saw Marc's irq/msi_domain patch series 
> (http://git.kernel.org/cgit/linux/kernel/git/maz/arm-platforms.git/log/?h=irq/msi_domain). 
> 
> 
> My understanding is that deals with associating the newly introduced 
> msi_domain to each device, which replaces the need for pci_bus->msi and 
> hw_pci->msi_ctrl when configure with CONFIG_PCI_MSI_IRQ_DOMAIN (not sure 
> if this would be the plan for all arm32).  For ARM32, if not define 
> CONFIG_PCI_MSI_IRQ_DOMAIN, it would still fall back to using the 
> [pci_sys_data|hw_pci]->msi_ctrl.

For all I can tell, we have two cases on ARM regarding MSI:

- arch/arm/mach-iop13xx/pci.c uses its own
  arch_setup_msi_irq/arch_teardown_msi_irq implementation and does not
  use pci_bus->msi.

- everything else that supports MSI has a modern driver with multiplatform
  support and uses msi_controller. If any platform wants to support GICv2m,
  we have to use CONFIG_PCI_MSI_IRQ_DOMAIN for all of them, and that
  seems like the best way forward.

	Arnd
