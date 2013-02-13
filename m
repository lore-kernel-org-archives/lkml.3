Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735Ab3BMMx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:53:27 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:37867 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab3BMMxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:53:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Myron Stowe <mstowe@redhat.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] ACPI / PCI: Initialize PCI root drivers after PCI bus enumeration
Date: Wed, 13 Feb 2013 13:59:52 +0100
Message-ID: <1678811.LFvn3m6Wlp@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQXk1VhA2+qAcp8jL=TG28acePyX4SOYALiAQ0bGnLaFOA@mail.gmail.com>
References: <1882094.fnYp8pBVVX@vostro.rjw.lan> <CAE9FiQXk1VhA2+qAcp8jL=TG28acePyX4SOYALiAQ0bGnLaFOA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 12, 2013 05:54:08 PM Yinghai Lu wrote:
> On Tue, Feb 12, 2013 at 4:16 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > After commit 1aeae82 (ACPI / PCI: avoid building pci_slot as module)
> > the pci_slot driver's .add() callback routine, acpi_pci_slot_add(),
> > is executed from within acpi_pci_root_add() before the PCI devices on
> > the bus are enumerated and that triggers the WARN_ON() in
> > kobject_get():
> >
> > WARNING: at /scratch/rafael/work/test/include/linux/kref.h:42 kobject_get+0x33/0x40()
> > Hardware name: PORTEGE R500
> > Modules linked in:
> > Pid: 1, comm: swapper/0 Not tainted 3.8.0-rc7+ #160
> > Call Trace:
> >  [<ffffffff8103d38a>] warn_slowpath_common+0x7a/0xb0
> >  [<ffffffff8103d3d5>] warn_slowpath_null+0x15/0x20
> >  [<ffffffff812f99b3>] kobject_get+0x33/0x40
> >  [<ffffffff81452b82>] get_device+0x12/0x30
> >  [<ffffffff8138df7b>] register_slot+0x243/0x295
> >  [<ffffffff810a7b6d>] ? trace_hardirqs_on+0xd/0x10
> >  [<ffffffff8137b7b9>] acpi_ns_walk_namespace+0x10f/0x24a
> >  [<ffffffff8138dd38>] ? walk_p2p_bridge+0x13b/0x13b
> >  [<ffffffff8138dd38>] ? walk_p2p_bridge+0x13b/0x13b
> >  [<ffffffff8137bdc3>] acpi_walk_namespace+0xe9/0x132
> >  [<ffffffff8138dd38>] ? walk_p2p_bridge+0x13b/0x13b
> >  [<ffffffff8138dcf5>] walk_p2p_bridge+0xf8/0x13b
> >  [<ffffffff8134d606>] ? acpi_os_signal_semaphore+0x76/0x87
> >  [<ffffffff8138dd38>] ? walk_p2p_bridge+0x13b/0x13b
> >  [<ffffffff8137b7b9>] acpi_ns_walk_namespace+0x10f/0x24a
> >  [<ffffffff8138dbfd>] ? do_sta_before_sun+0x2b/0x2b
> >  [<ffffffff8138dbfd>] ? do_sta_before_sun+0x2b/0x2b
> >  [<ffffffff8137bdc3>] acpi_walk_namespace+0xe9/0x132
> >  [<ffffffff81356071>] ? acpi_pci_root_add+0x3e7/0x49a
> >  [<ffffffff8138e07f>] acpi_pci_slot_add+0xb2/0x103
> >  [<ffffffff8138dd38>] ? walk_p2p_bridge+0x13b/0x13b
> >  [<ffffffff81356089>] acpi_pci_root_add+0x3ff/0x49a
> >
> > which means that pci_bus->dev used in register_slot() has not been
> > registered yet at that point.
> >
> > To fix this use the observation that before commit 1aeae82
> > acpi_pci_slot_add() was always run after pci_bus_add_devices()
> > and that happened to the acpiphp's .add() callback routine too.
> > Thus it is safe to reorder acpi_pci_root_add() to make the PCI root
> > drivers' .add() callbacks be run after pci_bus_add_devices(), so do
> > that.
> >
> > This approach was previously proposed by Myron Stowe.
> >
> > References: https://patchwork.kernel.org/patch/1848781/
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >
> > The commit mentioned in the changelog above is in linux-pm.git/linux-next.
> >
> > Thanks,
> > Rafael
> >
> > ---
> >  drivers/acpi/pci_root.c |   13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> >
> > Index: test/drivers/acpi/pci_root.c
> > ===================================================================
> > --- test.orig/drivers/acpi/pci_root.c
> > +++ test/drivers/acpi/pci_root.c
> > @@ -600,17 +600,20 @@ static int acpi_pci_root_add(struct acpi
> >         if (system_state != SYSTEM_BOOTING)
> >                 pci_assign_unassigned_bus_resources(root->bus);
> >
> > +       /* need to after hot-added ioapic is registered */
> > +       if (system_state != SYSTEM_BOOTING)
> > +               pci_enable_bridges(root->bus);
> > +
> > +       pci_bus_add_devices(root->bus);
> > +
> >         mutex_lock(&acpi_pci_root_lock);
> > +
> >         list_for_each_entry(driver, &acpi_pci_drivers, node)
> >                 if (driver->add)
> >                         driver->add(root);
> > -       mutex_unlock(&acpi_pci_root_lock);
> >
> > -       /* need to after hot-added ioapic is registered */
> > -       if (system_state != SYSTEM_BOOTING)
> > -               pci_enable_bridges(root->bus);
> > +       mutex_unlock(&acpi_pci_root_lock);
> >
> > -       pci_bus_add_devices(root->bus);
> >         return 1;
> >
> >  out_del_root:
> >
> 
> No, we don't need this after
> 
> | commit 4f535093cf8f6da8cfda7c36c2c1ecd2e9586ee4
> |     PCI: Put pci_dev in device tree as early as possible
> 
> in pci/next.
> 
> So we can move that Jiang's patch from your tree to Bjorn's tree?

OK, I'm dropping that patch from my tree, then (hopefully, no one has merged
my acpi-cleanup branch yet).

Bjorn, could you pick up https://patchwork.kernel.org/patch/2003771/ please?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
