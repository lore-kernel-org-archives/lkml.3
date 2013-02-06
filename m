Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab3BFRpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:45:40 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:38519 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab3BFRph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:45:37 -0500
MIME-Version: 1.0
In-Reply-To: <20130206065340.416a708b@redhat.com>
References: <CAE9FiQXHG01NjnYNDbC-KEpbcvY-q4pBe97CxTOGS7W4vZQBYQ@mail.gmail.com>
 <1359314629-18651-1-git-send-email-yinghai@kernel.org> <CAErSpo6r_LNEtYB3j5ELb8NdHu0a6_YOVj8S32CmByGFUpSsbg@mail.gmail.com>
 <CAE9FiQXg1YcPPJLCgPbKOKXHk-LRQv4bbBGH9jyuATQa2ANLkg@mail.gmail.com>
 <CAE9FiQX2DbTO0qCzGO4iMTkU_mPM2oZL+R5UoZ5dj=as6MUAsw@mail.gmail.com>
 <CAErSpo7-dULYwWQ=f5CBCxOULKJE9=n6Ha4jkVKd8enspuYjTA@mail.gmail.com>
 <CAE9FiQWvmK7N2z19B9ZiMyc_T6cJdpWoWr3mExpuwUA4ogBc3w@mail.gmail.com> <20130206065340.416a708b@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 6 Feb 2013 10:45:16 -0700
Message-ID: <CAErSpo4jtrp4ashHsfZP580_qdCXBEqmdd=SBfQrgQTV4uM4EA@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] PCI: Iterate pci host bridge instead of pci root bus
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        Tony Luck <tony.luck@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 1:53 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em Tue, 5 Feb 2013 16:47:10 -0800
> Yinghai Lu <yinghai@kernel.org> escreveu:
>
>> On Tue, Feb 5, 2013 at 4:19 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> >
>> > Maybe.  I'd rather not introduce for_each_pci_host_bridge() at all, if
>> > we can avoid it.  Every place it's used is a place we have to audit to
>> > make sure it's safe.  I think your audit above is correct and
>> > complete, but it relies on way too much architecture knowledge.  It's
>> > better if we can deduce correctness without knowing which arches
>> > support hotplug and which CPUs support EDAC.
>> >
>> > As soon as for_each_pci_host_bridge() is in the tree, those uses can
>> > be copied to even more places.  It's a macro, so it's usable by any
>> > module, even out-of-tree ones that we'll never see and can't fix.  So
>> > we won't really have a good way to deprecate and remove it.
>>
>> Now we only have two references in modules.
>>
>> drivers/edac/i7core_edac.c:     for_each_pci_host_bridge(host_bridge) {
>> drivers/pci/hotplug/sgi_hotplug.c:      for_each_pci_host_bridge(host_bridge) {
>>
>> for the sgi_hotplug.c, it should be same problem that have for acpiphp
>> and pciehp.
>> need to make it support pci host bridge hotplug anyway.
>>
>> for edac, we need to check Mauro about their plan.
>
> The i7core_pci_lastbus() code at i7core_edac is there to make it work
> with some Nehalem/Nehalem-EP machines that hide the memory controller's
> PCI ID by using an artificially low last bus.

I don't really understand how this helps.  An example would probably
make it clearer.

i7core_edac.c has some very creative use of PCI infrastructure.
Normally a driver has a pci_device_id table that identifies the
vendor/device IDs of the devices it cares about, and the driver's
.probe() method is called for every matching device.

But i7core_edac only has two entries in its id_table.  When we find a
device that matches one of those two entries, we call i7core_probe(),
which then gropes around for all the *other* devices related to that
original one.  This is a bit messy.

I'd like it a lot better if the device IDs in
pci_dev_descr_i7core_nehalem[], pci_dev_descr_lynnfield[], etc., were
just in the pci_device_id table directly.  Then i7core_probe() would
be called directly for every device you care about, and you could sort
them out there.  That should work without any need for
pci_get_device(), i7core_pci_lastbus(), etc.

Bjorn
