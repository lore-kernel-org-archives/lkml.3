Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3KZHAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 02:00:35 -0500
Received: from know-smtprelay-omc-7.server.virginmedia.net ([80.0.253.71]:47088
	"EHLO know-smtprelay-omc-7.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab3KZHAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 02:00:34 -0500
X-Originating-IP: [81.99.114.138]
X-Spam: 0
X-Authority: v=2.1 cv=WIjxXxcR c=1 sm=1 tr=0 a=rTb9Q+mClrhkGV9Ah9iRIA==:117
 a=rTb9Q+mClrhkGV9Ah9iRIA==:17 a=N1CowNylAAAA:8 a=JbI8A4tSZDgA:10
 a=IkcTkHD0fZMA:10 a=xqWC_Br6kY4A:10 a=iy5TeHvd1qQA:10 a=VwQbUJbxAAAA:8
 a=GeVnnJ8tQgyAKUgaFcAA:9 a=AcJFgI6m75myw6CY:21 a=iYLsZvz3uIvVDlIW:21
 a=QEXdDO2ut3YA:10 a=LI9Vle30uBYA:10
Message-ID: <1385449223.4579.23.camel@artifact>
Subject: Re: [PATCH v2 09/10] PCI: Sort pci root bus resources list
From: Steven Newbury <steve@snewbury.org.uk>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Date: Tue, 26 Nov 2013 07:00:23 +0000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Mon, Nov 25, 2013 at 6:28 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > Some x86 systems expose above 4G 64bit mmio in _CRS as non-pref mmio range.
> > [   49.415281] PCI host bridge to bus 0000:00
> > [   49.419921] pci_bus 0000:00: root bus resource [bus 00-1e]
> > [   49.426107] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> > [   49.433041] pci_bus 0000:00: root bus resource [io  0x1000-0x5fff]
> > [   49.440010] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> > [   49.447768] pci_bus 0000:00: root bus resource [mem 0xfed8c000-0xfedfffff]
> > [   49.455532] pci_bus 0000:00: root bus resource [mem 0x90000000-0x9fffbfff]
> > [   49.463259] pci_bus 0000:00: root bus resource [mem 0x380000000000-0x381fffffffff]
> >
> > During assign unassigned 64bit mmio resource, it will go through
> > every non-pref mmio for root bus in pci_bus_alloc_resource().
> > As the loop is with pci_bus_for_each_resource(), and could have chance
> > to use under 4G mmio range instead of above 4G mmio range if the requested
> > range is not big enough, even it could handle above 4G 64bit pref mmio.
> >
> > For root bus, we can order list from high to low in pci_add_resource_offset(),
> > during creating root bus, it will still keep the same order in final bus
> > resource list.
> >         pci_acpi_scan_root
> >                 ==> add_resources
> >                         ==> pci_add_resource_offset: # Add to temp resources
> >                 ==> pci_create_root_bus
> >                         ==> pci_bus_add_resource # add to final bus resources.
> >
> > After that, we can make sure 64bit pref mmio for pci bridges will be allocated
> > higest of mmio non-pref, and in this case it is above 4G instead of under 4G.
> 
> Sorry I'm so slow; I'd like to know what problem this solves, too.
> I'm trying to help people at distros figure out whether they will need
> to backport this change.

This series was originally instigated during my attempt to get a PCI
Radeon 5450 graphics card with a 32-bit PLX bridge working in a
(hot-plugable) docking station on a system which had insufficient free
resources below 4G.  The biggest PCI address space user in my case was
the integrated i965 graphics, which I wanted to also be working for my
use case.  Allowing the IGP to be mapped above 4G freed enough resources
to make my system work, and it's now been running this way for the last
couple of years. (I've been rebasing the series in my local kernel.)

I'm pretty sure there are other cases, particularly where hotplug is
required where maximising free PCI address space <4G is extremely
useful; and it's to my mind a generally a good principle to allocate
resources such that limited resources (large aligned ranges) are
preserved for allocations which *require* them.  Is this really any
different than ZONE_DMA?

