Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab3BFRzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:55:22 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:40891 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab3BFRzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:55:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWvmK7N2z19B9ZiMyc_T6cJdpWoWr3mExpuwUA4ogBc3w@mail.gmail.com>
References: <CAE9FiQXHG01NjnYNDbC-KEpbcvY-q4pBe97CxTOGS7W4vZQBYQ@mail.gmail.com>
 <1359314629-18651-1-git-send-email-yinghai@kernel.org> <CAErSpo6r_LNEtYB3j5ELb8NdHu0a6_YOVj8S32CmByGFUpSsbg@mail.gmail.com>
 <CAE9FiQXg1YcPPJLCgPbKOKXHk-LRQv4bbBGH9jyuATQa2ANLkg@mail.gmail.com>
 <CAE9FiQX2DbTO0qCzGO4iMTkU_mPM2oZL+R5UoZ5dj=as6MUAsw@mail.gmail.com>
 <CAErSpo7-dULYwWQ=f5CBCxOULKJE9=n6Ha4jkVKd8enspuYjTA@mail.gmail.com> <CAE9FiQWvmK7N2z19B9ZiMyc_T6cJdpWoWr3mExpuwUA4ogBc3w@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 6 Feb 2013 10:54:53 -0700
Message-ID: <CAErSpo4x-GzGxJOWgwP_DEqNhefDo0V1zTT5GBR30+Q57=E-hg@mail.gmail.com>
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

On Tue, Feb 5, 2013 at 5:47 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Feb 5, 2013 at 4:19 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>
>> Maybe.  I'd rather not introduce for_each_pci_host_bridge() at all, if
>> we can avoid it.  Every place it's used is a place we have to audit to
>> make sure it's safe.  I think your audit above is correct and
>> complete, but it relies on way too much architecture knowledge.  It's
>> better if we can deduce correctness without knowing which arches
>> support hotplug and which CPUs support EDAC.
>>
>> As soon as for_each_pci_host_bridge() is in the tree, those uses can
>> be copied to even more places.  It's a macro, so it's usable by any
>> module, even out-of-tree ones that we'll never see and can't fix.  So
>> we won't really have a good way to deprecate and remove it.
>
> Now we only have two references in modules.
>
> drivers/edac/i7core_edac.c:     for_each_pci_host_bridge(host_bridge) {
> drivers/pci/hotplug/sgi_hotplug.c:      for_each_pci_host_bridge(host_bridge) {
>
> for the sgi_hotplug.c, it should be same problem that have for acpiphp
> and pciehp.
> need to make it support pci host bridge hotplug anyway.
>
> for edac, we need to check Mauro about their plan.
>
> After those two are addressed, we can drop that EXPORT_SYMBOL_GPL for
> pci_get_next_host_bridge.
>
> We do have pci_get_domain_bus_and_slot() as export symbol.
> So we export pci_get_next_host_bridge should be ok now.
> and it would be better than export root buses list.

I think you're missing the point.

Search the tree for uses of "for_each_pci_dev()."  Almost every
occurrence is a bug because that code doesn't work correctly for
hot-added devices.  That code gets run for devices that are present at
boot, but not for devices hot-added later.

You're proposing to add "for_each_pci_host_bridge()."  That will have
the exact same problem as for_each_pci_dev() already does.  Code that
uses it will work for host bridges present at boot, but not for
bridges hot-added later.

Why would we want to add an interface when every use of that interface
will be a design bug?  I think we should fix the existing users of
pci_root_buses by changing their designs so they will work correctly
with host bridge hotplug.

Bjorn
