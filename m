Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3BEXzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 18:55:35 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:37503 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3BEXzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 18:55:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXg1YcPPJLCgPbKOKXHk-LRQv4bbBGH9jyuATQa2ANLkg@mail.gmail.com>
References: <CAE9FiQXHG01NjnYNDbC-KEpbcvY-q4pBe97CxTOGS7W4vZQBYQ@mail.gmail.com>
	<1359314629-18651-1-git-send-email-yinghai@kernel.org>
	<CAErSpo6r_LNEtYB3j5ELb8NdHu0a6_YOVj8S32CmByGFUpSsbg@mail.gmail.com>
	<CAE9FiQXg1YcPPJLCgPbKOKXHk-LRQv4bbBGH9jyuATQa2ANLkg@mail.gmail.com>
Date: Tue, 5 Feb 2013 15:55:30 -0800
X-Google-Sender-Auth: fkTylEpob-71QVV_przKTwQsEA8
Message-ID: <CAE9FiQX2DbTO0qCzGO4iMTkU_mPM2oZL+R5UoZ5dj=as6MUAsw@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] PCI: Iterate pci host bridge instead of pci root bus
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 2, 2013 at 9:05 PM, Yinghai Lu <yinghai@kernel.org> wrote:

>> Your solution is to introduce for_each_pci_host_bridge() as an
>> iterator through the known host bridges.  There are two scenarios
>> where we use something like this:
>>
>> 1) We want to perform an operation on every known host bridge.
>>
>> 2) We want to initialize something for every host bridge.
>>
>> In my opinion, the only instance of scenario 1) is bus_rescan_store(),
>> where we want to rescan all PCI host bridges.
>>
>> In every other case, we're doing some kind of initialization of all
>> the host bridges.  For these cases, for_each_pci_host_bridge() is the
>> wrong solution because it doesn't work for hot-added bridges.  I think
>> these cases should be changed to use pcibios_root_bridge_prepare() or
>> something something else called in the host bridge add path.
>
> Yes, will check if those for_pci_host_bridge could be converted to
> adding calling in pcibios_root_bridge_prepare one by one.

I went through those patches again, here are findings:
1. run-time iteration includes at least 3 occurrence are addressed.
a. in pci-sysfs::bus_rescan_store
b. powerpc pci_64.c::sys_pciconfig_iobase system call
c. probe.c::pci_create_root_bus/pci_find_bus

2. edac: i7core_edac.c::i7core_pci_lastbus()
this one is not support host bridge hotplug, and in i7core_probe it will
bail-out if probed before overall.
To make edac with i7 to support host-bridge hotadd, will change the structure of
that i7core_probe.
But I'm not worried about that yet, because Nehalem-EX does not support EDAC,
and assume we will NOT have use case with new -EX intel cpu with
hotplug support to use EDAC.

3. pcibios_resource_survey/pcibios_assign_unassigned_resource in __init path.
it is with x86/frv/microblaze/mn10300.
for x86/acpi, we have per root bus calling in pci_root.c::acpi_pci_root_add().
other three does not support pci_root_bridge hotplug yet.

4. looks like all other changes are __init path, and those arch does not support
pci_root_bridge hotplug yet.

So looks like this patch set is ok now.

Also i updated
	git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-pci-for-each-host-bridge

with new ordering of patches.

BTW, I would address unifying pcibios_reserource_survey between
x86/frv/microblaze/mn10300 later.

Thanks

Yinghai
