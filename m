Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab3AMPNj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 10:13:39 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:55190 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab3AMPNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 10:13:38 -0500
Message-ID: <50F2CF18.1010301@gmail.com>
Date: Sun, 13 Jan 2013 23:13:28 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 4/6] PCI/acpiphp: update ACPI hotplug slot information
 when PCI hotplug happens
References: <1357663945-16054-1-git-send-email-jiang.liu@huawei.com> <5038693.7d3RCgbghD@vostro.rjw.lan> <50ED9B03.3020606@gmail.com> <2474473.EXPaz4HMXx@vostro.rjw.lan>
In-Reply-To: <2474473.EXPaz4HMXx@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 04:23 AM, Rafael J. Wysocki wrote:
> On Thursday, January 10, 2013 12:29:55 AM Jiang Liu wrote:
>> On 01/09/2013 08:04 AM, Rafael J. Wysocki wrote:
>>> On Wednesday, January 09, 2013 12:52:23 AM Jiang Liu wrote:
>>>> Currently the acpiphp driver fails to update hotplug slot information under
>>>> several conditions, such as:
>>>> 1) The bridge device is removed through /sys/bus/pci/devices/.../remove
>>>> 2) The bridge device is added/removed by PCI hotplug driver other than the
>>>>    acpiphp driver itself. For example, if an IO expansion box with ACPI
>>>>    hotplug slots available is hot-added by the pciehp driver, all ACPI
>>>>    hotplug slots won't be discovered by the acpiphp driver.
>>>>
>>>> So hook the BUS_NOTIFY_ADD_DEVICE/BUS_NOTIFY_DEL_DEVICE events to
>>>> update ACPI hotplug slot information when PCI hotplug event happens.
>>>>
>>>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>>>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>>>> ---
>>>>  drivers/pci/hotplug/acpiphp_glue.c |   62 ++++++++++++++++++++++++++++++++++--
>>>>  1 file changed, 60 insertions(+), 2 deletions(-)
>>>>
>> snip
>>>> +static struct notifier_block acpi_pci_hp_notifier = {
>>>> +	.notifier_call = &acpi_pci_hp_notify_fn,
>>>> +};
>>>> +
>>>>  static struct acpi_pci_driver acpi_pci_hp_driver = {
>>>>  	.add =		add_bridge,
>>>>  	.remove =	remove_bridge,
>>>> @@ -1448,6 +1503,8 @@ int __init acpiphp_glue_init(void)
>>>>  	else
>>>>  		acpi_pci_register_driver(&acpi_pci_hp_driver);
>>>>  
>>>> +	bus_register_notifier(&pci_bus_type, &acpi_pci_hp_notifier);
>>>
>>> Your previous patch adds a PCI bus notifier for a similar thing.  Why are
>>> you adding another one here?
>> Hi Rafael,
>> 	The acpiphp driver could be built as a module, and this bus notifier
>> is used to setup/tear down ACPI based PCI hotplug controllers under a PCI bridge.
>> The previous patch is to add/remove PCI slots. The PCI slot and PCI hotplug
>> controller are related but different objects, so we use two notifiers to support
>> them all.
> 
> I would be much happier if those notifiers were not needed.  At least, I'm not
> sure why they need to be invoked by the driver core during device registration.
> 
> In my opinion it would be much better if they were called only for the devices
> that might need them instead of all PCI devices.
> 
Hi Rafael,
	The whole thing seems a little complex, and I will try my best to explain
about it:)
	Essentially a PCI slot is associated with a PCI bus, and a PCI bus is 
associated with a host bridge or P2P bridge. When hot-adding/hot-removing a PCI bus,
we need to create/destroy PCI slots associated with it. So the pci_slot and acpiphp
drivers need to be notified when hot-adding/hot-removing a PCI bus.
	But there's no common mechanism to get notified when PCI buses are being
hot-added/hot-removed. So my first implementation has introduced a dedicated notifier
chain for PCI bus addition/removal. Later with ongoing changes to the PCI core, 
I found we could rely on the existing bus notification mechanism too, so that becomes
the current implementation.
	I have a proposal to unify the process for boot time and hotplug as below:
1) Change pci_slot and acpiphp as built-in instead of modules.
2) Get rid of acpi_pci_driver for pci_slot and acpiphp driver.
3) Register some forms of callbacks to create/destroy hotplug controllers/slots
   when creating/destroying PCI buses.
3.a) Rely on the bus notification mechanism to invoke callbacks. This solution is
     simple, but with a little overhead
3.b) Introduce a dedicated notifier chain for PCI bus hot-adding/hot-removing.
     This solution could get rid of the overhead, but with more code changes.
3.c) Invoke callbacks from acpi_bus_type->setup/cleanup. This solution could
     only support ACPI based slots, such as pci_slot and acpiphp.
	Any recommendations?
Regards!
Gerry

> Thanks,
> Rafael
> 
> 

