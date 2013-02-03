Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab3BCFFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 00:05:55 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:41326 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab3BCFFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 00:05:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo6r_LNEtYB3j5ELb8NdHu0a6_YOVj8S32CmByGFUpSsbg@mail.gmail.com>
References: <CAE9FiQXHG01NjnYNDbC-KEpbcvY-q4pBe97CxTOGS7W4vZQBYQ@mail.gmail.com>
	<1359314629-18651-1-git-send-email-yinghai@kernel.org>
	<CAErSpo6r_LNEtYB3j5ELb8NdHu0a6_YOVj8S32CmByGFUpSsbg@mail.gmail.com>
Date: Sat, 2 Feb 2013 21:05:53 -0800
X-Google-Sender-Auth: yOAdIXZmvU2rzqE7uVkE09PZwVY
Message-ID: <CAE9FiQXg1YcPPJLCgPbKOKXHk-LRQv4bbBGH9jyuATQa2ANLkg@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] PCI: Iterate pci host bridge instead of pci root bus
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Trim down CC list, otherwise lkml will drop it, Thanks for David
Miller to bring attention to me ]

On Sat, Feb 2, 2013 at 1:50 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Sun, Jan 27, 2013 at 12:23 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> Now we have pci_root_buses list, and there is lots of iteration with
>> list_of_each of it, that is not safe after we add pci root bus hotplug
>> support after booting stage.
>>
>> Add pci_get_next_host_bridge and use bus_find_device in driver core to
>> iterate host bridge and the same time get root bus.
>>
>> We replace searching root bus with searching host_bridge,
>> as host_bridge->bus is the root bus.
>> After those replacing, we even could kill pci_root_buses list.
>
> These are the problems I think you're fixing:
>
> 1) pci_find_next_bus() is not safe because even though it holds
> pci_bus_sem while walking the pci_root_buses list, it doesn't hold a
> reference on the bus it returns.  The bus could be removed while the
> caller is using it.
>
> 2) "list_for_each_entry(bus, &pci_root_buses, node)" is not safe
> because hotplug might modify the pci_root_buses list.  Replacing that
> with for_each_pci_host_bridge() solves that problem by using
> bus_find_device(), which is built on klists, which are designed for
> that problem.
>
> 3) pci_find_next_bus() claims to iterate through all known PCI buses,
> but in fact only iterates through root buses.
>
> So far, so good.  Those are problems we need to fix.
>
> Your solution is to introduce for_each_pci_host_bridge() as an
> iterator through the known host bridges.  There are two scenarios
> where we use something like this:
>
> 1) We want to perform an operation on every known host bridge.
>
> 2) We want to initialize something for every host bridge.
>
> In my opinion, the only instance of scenario 1) is bus_rescan_store(),
> where we want to rescan all PCI host bridges.
>
> In every other case, we're doing some kind of initialization of all
> the host bridges.  For these cases, for_each_pci_host_bridge() is the
> wrong solution because it doesn't work for hot-added bridges.  I think
> these cases should be changed to use pcibios_root_bridge_prepare() or
> something something else called in the host bridge add path.

Yes, will check if those for_pci_host_bridge could be converted to
adding calling in pcibios_root_bridge_prepare one by one.

Thanks

Yinghai
