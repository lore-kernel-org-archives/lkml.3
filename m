Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3A2A2a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 19:28:30 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:58058 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab3A2A2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 19:28:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <liuj97@gmail.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [RFC PATCH v5 0/8] introduce PCI bus notifier chain to get rid of the ACPI PCI subdriver interfaces
Date: Tue, 29 Jan 2013 01:34:29 +0100
Message-ID: <1598719.tGLtx5aHMZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo6M-c3diVEUpUESgL=2PenxHYkW1eb=OGBdxxWwkge-Bw@mail.gmail.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com> <CAErSpo6M-c3diVEUpUESgL=2PenxHYkW1eb=OGBdxxWwkge-Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 28, 2013 01:56:33 PM Bjorn Helgaas wrote:
> On Fri, Jan 18, 2013 at 9:07 AM, Jiang Liu <liuj97@gmail.com> wrote:
> > This is an RFC patchset to address review comments in thread at:
> > https://patchwork.kernel.org/patch/1946851/. The patch just pasts
> > compilation. If no objection to the new implementation, I will
> > go on to modify acpiphp driver and conduct tests.
> >
> > The main changes from V4 to V5 includes:
> > 1) introduce a dedicated notifier chain for PCI buses
> > 2) change pci_slot as built-in driver
> > 3) unify the way to create/destroy PCI slots
> > 4) introduce a kernel option to disable PCIe native hotplug
> >
> > TODO:
> > 1) change acpiphp as built-in and unify the way to create/destroy ACPI
> >    based hotplug slots.
> > 2) change other ACPI PCI subdriver in Yinghai's root bridge hotplug series
> >    to use the PCI bus notifier chain.
> > 3) Remove the ACPI PCI subdriver interface eventaully.
> >
> > Jiang Liu (8):
> >   PCI: make PCI device create/destroy logic symmetric
> >   PCI: split registration of PCI bus devices into two stages
> >   PCI: add a blocking notifier chain for PCI bus addition/removal
> >   ACPI, PCI: avoid building pci_slot as module
> >   PCI, ACPI: hook PCI bus notifications to create/destroy PCI slots
> >   pci_slot: replace printk(KERN_xxx) with pr_xxx()
> >   PCI/PCIe: add "pci=nopciehp" to disable PCIe native hotplug
> >   PCI/PCIe: only claim PME from firmware when CONFIG_PCIE_PME is
> >     enabled
> >
> >  Documentation/kernel-parameters.txt |    2 +
> >  drivers/acpi/Kconfig                |    5 +-
> >  drivers/acpi/internal.h             |    5 +
> >  drivers/acpi/pci_root.c             |    8 +-
> >  drivers/acpi/pci_slot.c             |  217 ++++++++++-------------------------
> >  drivers/acpi/scan.c                 |    1 +
> >  drivers/pci/bus.c                   |   26 ++++-
> >  drivers/pci/pci.c                   |    2 +
> >  drivers/pci/pci.h                   |    1 +
> >  drivers/pci/pcie/portdrv_core.c     |    7 +-
> >  drivers/pci/pcie/portdrv_pci.c      |    3 +
> >  drivers/pci/probe.c                 |    7 +-
> >  drivers/pci/remove.c                |   15 +--
> >  include/linux/pci.h                 |   21 ++++
> >  14 files changed, 142 insertions(+), 178 deletions(-)
> 
> I think the problem we're trying to solve is that we don't initialize
> hot-added devices, correctly, e.g., we don't set up AER, we don't
> update acpi/pci_slot stuff, we probably don't set up PME etc.  We also
> have similar issues like IOMMU init on powerpc.
> 
> Notifier chains seem like an unnecessarily complicated way to deal
> with this.  They're great for communicating between modules that stay
> at arm's length from each other.  But that's not the case here --
> everything is PCI and is quite closely coupled.  I think AER, PME,
> slot, etc., should  be initialized directly in pci_device_add() or
> somewhere nearby.

I agree.

> This might sound a bit radical because it implies some fairly
> far-reaching changes.  It means this code can't be a module (the only
> one that can be built as a module today is pciehp, and I think
> everybody agrees that we should make it static as soon as we can
> figure out the acpiphp/pciehp issue).  I think it also means the
> pcieportdrv concept is of dubious value, since all the services should
> be known at build-time and we probably don't need a registration
> interface for them.

It is of dubious value regardless.  It just adds complexity for no gain.
Moreover, these things are in fact not mutually independent.

I've had a lot of headaches trying to work around that when I was working
on PME support and later on _OSC for root bridges.  Let's just take that
stuff away once and for good. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
