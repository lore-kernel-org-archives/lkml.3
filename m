Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab3KZSFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:05:14 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44655 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757440Ab3KZSFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:05:10 -0500
MIME-Version: 1.0
In-Reply-To: <1385449223.4579.23.camel@artifact>
References: <1385449223.4579.23.camel@artifact>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 26 Nov 2013 11:04:48 -0700
Message-ID: <CAErSpo67325sLNsa8v=OepiuJs3NT7ZeAr1KtxQ-EFu1GPcFcA@mail.gmail.com>
Subject: Re: [PATCH v2 09/10] PCI: Sort pci root bus resources list
To: Steven Newbury <steve@snewbury.org.uk>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 12:00 AM, Steven Newbury <steve@snewbury.org.uk> wrote:
>
>> On Mon, Nov 25, 2013 at 6:28 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > Some x86 systems expose above 4G 64bit mmio in _CRS as non-pref mmio range.
>> > [   49.415281] PCI host bridge to bus 0000:00
>> > [   49.419921] pci_bus 0000:00: root bus resource [bus 00-1e]
>> > [   49.426107] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
>> > [   49.433041] pci_bus 0000:00: root bus resource [io  0x1000-0x5fff]
>> > [   49.440010] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
>> > [   49.447768] pci_bus 0000:00: root bus resource [mem 0xfed8c000-0xfedfffff]
>> > [   49.455532] pci_bus 0000:00: root bus resource [mem 0x90000000-0x9fffbfff]
>> > [   49.463259] pci_bus 0000:00: root bus resource [mem 0x380000000000-0x381fffffffff]
>> >
>> > During assign unassigned 64bit mmio resource, it will go through
>> > every non-pref mmio for root bus in pci_bus_alloc_resource().
>> > As the loop is with pci_bus_for_each_resource(), and could have chance
>> > to use under 4G mmio range instead of above 4G mmio range if the requested
>> > range is not big enough, even it could handle above 4G 64bit pref mmio.
>> >
>> > For root bus, we can order list from high to low in pci_add_resource_offset(),
>> > during creating root bus, it will still keep the same order in final bus
>> > resource list.
>> >         pci_acpi_scan_root
>> >                 ==> add_resources
>> >                         ==> pci_add_resource_offset: # Add to temp resources
>> >                 ==> pci_create_root_bus
>> >                         ==> pci_bus_add_resource # add to final bus resources.
>> >
>> > After that, we can make sure 64bit pref mmio for pci bridges will be allocated
>> > higest of mmio non-pref, and in this case it is above 4G instead of under 4G.
>>
>> Sorry I'm so slow; I'd like to know what problem this solves, too.
>> I'm trying to help people at distros figure out whether they will need
>> to backport this change.
>
> This series was originally instigated during my attempt to get a PCI
> Radeon 5450 graphics card with a 32-bit PLX bridge working in a
> (hot-plugable) docking station on a system which had insufficient free
> resources below 4G.  The biggest PCI address space user in my case was
> the integrated i965 graphics, which I wanted to also be working for my
> use case.  Allowing the IGP to be mapped above 4G freed enough resources
> to make my system work, and it's now been running this way for the last
> couple of years. (I've been rebasing the series in my local kernel.)

Do you have a URL handy for that discussion?
https://bugzilla.kernel.org/show_bug.cgi?id=10461 looks like a similar
issue.  If you could open a similar bugzilla for your specific problem
and attach before and after dmesg logs, that would help me understand
the problem.

> I'm pretty sure there are other cases, particularly where hotplug is
> required where maximising free PCI address space <4G is extremely
> useful; and it's to my mind a generally a good principle to allocate
> resources such that limited resources (large aligned ranges) are
> preserved for allocations which *require* them.  Is this really any
> different than ZONE_DMA?

It *sounds* great, I agree.  It's obvious that allocating from the top
down instead of from bottom up helps preserve large aligned ranges.
But when we've tried it, we've tripped over issues.  So we do have to
be a little careful, even with "obviously good" allocation changes.

Bjorn
