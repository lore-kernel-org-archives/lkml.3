Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab3BFVhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:37:07 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:54113 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758539Ab3BFVhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:37:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/22] PCI: Iterate pci host bridge instead of pci root bus
Date: Wed, 06 Feb 2013 22:43:22 +0100
Message-ID: <52330506.F9m0tMYuG1@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQX=uEPjHDi-_VaW88ueH4u9C22gmDiGQewsQ=VN5T4=Gg@mail.gmail.com>
References: <CAE9FiQXHG01NjnYNDbC-KEpbcvY-q4pBe97CxTOGS7W4vZQBYQ@mail.gmail.com> <CAErSpo5-6xs+Uz=Yzws23RmrFK=+AQZ2=UT+n0k=462EgazbUA@mail.gmail.com> <CAE9FiQX=uEPjHDi-_VaW88ueH4u9C22gmDiGQewsQ=VN5T4=Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 06, 2013 01:28:27 PM Yinghai Lu wrote:
> On Wed, Feb 6, 2013 at 12:50 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Wed, Feb 6, 2013 at 11:59 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> >> On Wed, Feb 6, 2013 at 9:54 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >>> I think you're missing the point.
> >>>
> >>> Search the tree for uses of "for_each_pci_dev()."  Almost every
> >>> occurrence is a bug because that code doesn't work correctly for
> >>> hot-added devices.  That code gets run for devices that are present at
> >>> boot, but not for devices hot-added later.
> >>>
> >>> You're proposing to add "for_each_pci_host_bridge()."  That will have
> >>> the exact same problem as for_each_pci_dev() already does.  Code that
> >>> uses it will work for host bridges present at boot, but not for
> >>> bridges hot-added later.
> >>>
> >>> Why would we want to add an interface when every use of that interface
> >>> will be a design bug?  I think we should fix the existing users of
> >>> pci_root_buses by changing their designs so they will work correctly
> >>> with host bridge hotplug.
> >>
> >> I'm a little confused about what you want.
> >>
> >> In boot stage using for_each_pci_host_bridge or pci_root_buses is fine.
> >
> > No, it's not.  Boot-time should work exactly the same way as hot-add
> > time, unless there's a reason it can't.  There might be corner cases
> > where we can't do that yet, e.g., the pcibios_resource_survey stuff,
> > but in general I don't think there's anything that *forces* us to
> > iterate through host bridges at boot-time.
> >
> >> For those cases that it should support host-bridge by nature.
> >> there are two solutions:
> >> 1. use for_each_pci_host_bridge, and it is hotplug-safe.
> >
> > I'm trying to tell you that for_each_pci_host_bridge() is NOT
> > hotplug-safe.  Your series makes it safer than it was, in the sense
> > that it probably fixes stray pointer references when a host bridge
> > hotplug happens while somebody's traversing pci_root_buses.  But the
> > whole point of for_each_pci_host_bridge() is to run some code for
> > every bridge we know about *right now*.  If a host bridge is added
> > right after the for_each_pci_host_bridge() loop exits, that code
> > doesn't get run.  In most cases, that's a bug.  The only exception I
> > know about is the /sys/.../rescan interface.
> >
> >> and make sgi_hotplug to use acpi_pci_driver interface.
> >> and acpi_pci_root_add() will call .add in the acpi_pci_driver.
> >>
> >> 2. make them all to be built-in, and  those acpi_pci_driver should be registered
> >> much early before acpi_pci_root_add is called.
> >> then we don't need to call for_each_host_bridge for it.
> >>
> >> So difference between them:
> >> 1. still keep the module support, and register acpi_pci_driver later.
> >> 2. built-in support only, and need to register acpi_pci_driver early.
> >
> > acpi_pci_driver is going away, so I don't want to add any more uses of
> > it.  Obviously it's only relevant to x86 and ia64 anyway.
> 
> when?
> 
> I have ioapic and iommu hotplug patch set that need to use them.

I suppose it would be a bit simpler if you tried to fix things up before
adding more stuff on top of them, which only makes it more difficult
to clean them up when this additional stuff is applied.

A patchset to remove acpi_pci_driver has been posted already and it is going
to be submitted again after 3.9-rc1.  So this is the time frame.

> > What I'd like is a change where for_each_pci_host_bridge() is used
> > only inside the PCI core and defined somewhere like drivers/pci/pci.h
> > so it's not even available outside.
> >
> > The other uses should be changed so they use
> > pcibios_root_bridge_prepare() or something similar.  That way, it will
> > be obvious that the code supports hot-added bridges, and when it gets
> > copied to other places, we'll be copying a working design instead of a
> > broken one.
> >
> > I don't want to have to audit these places and figure out "this is
> > safe because this arch doesn't support host bridge hotplug" or "this
> > is safe because this CPU doesn't support XYZ."  That's not a
> > maintainable solution.  The safety should be apparent from the code
> > itself, without requiring extra platform-specific knowledge.
> 
> so you still did not answer you want 1 or 2 yet:
> 
> for sgi_hotplug,
> 
> 1. still keep the module support, and register acpi_pci_driver later.
> 2. built-in support only, and need to register acpi_pci_driver early.

Please work with the assumption that acpi_pci_driver is not going to be there
any more.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
