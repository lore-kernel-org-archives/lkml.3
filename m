Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650Ab3BFUvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:51:16 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52569 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758625Ab3BFUvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:51:10 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVYvmRr5oGLfLCPFPV_G_r-fqG9GZaK_wxNW8aO_oyuRA@mail.gmail.com>
References: <CAE9FiQXHG01NjnYNDbC-KEpbcvY-q4pBe97CxTOGS7W4vZQBYQ@mail.gmail.com>
 <1359314629-18651-1-git-send-email-yinghai@kernel.org> <CAErSpo6r_LNEtYB3j5ELb8NdHu0a6_YOVj8S32CmByGFUpSsbg@mail.gmail.com>
 <CAE9FiQXg1YcPPJLCgPbKOKXHk-LRQv4bbBGH9jyuATQa2ANLkg@mail.gmail.com>
 <CAE9FiQX2DbTO0qCzGO4iMTkU_mPM2oZL+R5UoZ5dj=as6MUAsw@mail.gmail.com>
 <CAErSpo7-dULYwWQ=f5CBCxOULKJE9=n6Ha4jkVKd8enspuYjTA@mail.gmail.com>
 <CAE9FiQWvmK7N2z19B9ZiMyc_T6cJdpWoWr3mExpuwUA4ogBc3w@mail.gmail.com>
 <CAErSpo4x-GzGxJOWgwP_DEqNhefDo0V1zTT5GBR30+Q57=E-hg@mail.gmail.com> <CAE9FiQVYvmRr5oGLfLCPFPV_G_r-fqG9GZaK_wxNW8aO_oyuRA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 6 Feb 2013 13:50:49 -0700
Message-ID: <CAErSpo5-6xs+Uz=Yzws23RmrFK=+AQZ2=UT+n0k=462EgazbUA@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] PCI: Iterate pci host bridge instead of pci root bus
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Tony Luck <tony.luck@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 11:59 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, Feb 6, 2013 at 9:54 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> I think you're missing the point.
>>
>> Search the tree for uses of "for_each_pci_dev()."  Almost every
>> occurrence is a bug because that code doesn't work correctly for
>> hot-added devices.  That code gets run for devices that are present at
>> boot, but not for devices hot-added later.
>>
>> You're proposing to add "for_each_pci_host_bridge()."  That will have
>> the exact same problem as for_each_pci_dev() already does.  Code that
>> uses it will work for host bridges present at boot, but not for
>> bridges hot-added later.
>>
>> Why would we want to add an interface when every use of that interface
>> will be a design bug?  I think we should fix the existing users of
>> pci_root_buses by changing their designs so they will work correctly
>> with host bridge hotplug.
>
> I'm a little confused about what you want.
>
> In boot stage using for_each_pci_host_bridge or pci_root_buses is fine.

No, it's not.  Boot-time should work exactly the same way as hot-add
time, unless there's a reason it can't.  There might be corner cases
where we can't do that yet, e.g., the pcibios_resource_survey stuff,
but in general I don't think there's anything that *forces* us to
iterate through host bridges at boot-time.

> For those cases that it should support host-bridge by nature.
> there are two solutions:
> 1. use for_each_pci_host_bridge, and it is hotplug-safe.

I'm trying to tell you that for_each_pci_host_bridge() is NOT
hotplug-safe.  Your series makes it safer than it was, in the sense
that it probably fixes stray pointer references when a host bridge
hotplug happens while somebody's traversing pci_root_buses.  But the
whole point of for_each_pci_host_bridge() is to run some code for
every bridge we know about *right now*.  If a host bridge is added
right after the for_each_pci_host_bridge() loop exits, that code
doesn't get run.  In most cases, that's a bug.  The only exception I
know about is the /sys/.../rescan interface.

> and make sgi_hotplug to use acpi_pci_driver interface.
> and acpi_pci_root_add() will call .add in the acpi_pci_driver.
>
> 2. make them all to be built-in, and  those acpi_pci_driver should be registered
> much early before acpi_pci_root_add is called.
> then we don't need to call for_each_host_bridge for it.
>
> So difference between them:
> 1. still keep the module support, and register acpi_pci_driver later.
> 2. built-in support only, and need to register acpi_pci_driver early.

acpi_pci_driver is going away, so I don't want to add any more uses of
it.  Obviously it's only relevant to x86 and ia64 anyway.

What I'd like is a change where for_each_pci_host_bridge() is used
only inside the PCI core and defined somewhere like drivers/pci/pci.h
so it's not even available outside.

The other uses should be changed so they use
pcibios_root_bridge_prepare() or something similar.  That way, it will
be obvious that the code supports hot-added bridges, and when it gets
copied to other places, we'll be copying a working design instead of a
broken one.

I don't want to have to audit these places and figure out "this is
safe because this arch doesn't support host bridge hotplug" or "this
is safe because this CPU doesn't support XYZ."  That's not a
maintainable solution.  The safety should be apparent from the code
itself, without requiring extra platform-specific knowledge.

Bjorn
