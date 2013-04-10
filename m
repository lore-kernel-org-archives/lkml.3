Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965166Ab3DJRHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:07:49 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:61195 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965106Ab3DJRHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:07:46 -0400
MIME-Version: 1.0
In-Reply-To: <51658FCB.3030906@gmail.com>
References: <1361892353-14786-1-git-send-email-jiang.liu@huawei.com>
 <1361892353-14786-11-git-send-email-jiang.liu@huawei.com> <CAErSpo4uyqPRDWKvH_3rtnGzbro1+_SnGH9GBU_-tz1p2a+AMQ@mail.gmail.com>
 <51658FCB.3030906@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 10 Apr 2013 11:07:25 -0600
Message-ID: <CAErSpo7O1L2aRc2aVSqwj2CKwwoC9dbFWgukNj=jCkG-PjYOMA@mail.gmail.com>
Subject: Re: [PATCH v8 10/13] PCI/acpiphp: do not use ACPI PCI subdriver mechanism
To: Jiang Liu <liuj97@gmail.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>, Jiang Liu <jiang.liu@huawei.com>,
        Yinghai Lu <yinghai@kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 10:14 AM, Jiang Liu <liuj97@gmail.com> wrote:
> On 04/10/2013 07:38 AM, Bjorn Helgaas wrote:
>> On Tue, Feb 26, 2013 at 8:25 AM, Jiang Liu <liuj97@gmail.com> wrote:
>>> Previously the acpiphp driver registers itself as an ACPI PCI subdriver,
>>> so it's callbacks will be invoked when creating/destroying PCI root
>>> buses to manage ACPI based PCI hotplug slots. But it doesn't handle
>>> P2P bridge hotplug events, so it will cause strange behavours if there
>>> are hotplug slots associated with a hot-removed P2P bridge.
>>>
>>> So this patch tries to fix this issue by:
>>> 1) Make acpiphp built-in only, not a module.
>>> 2) Directly hook into PCI core to update hotplug slot devices when
>>>    creating/destroying PCI buses through:
>>>         pci_{add|remove}_bus() -> acpi_pci_{add|remove}_bus()
>>> 3) Get rid of ACPI PCI subdriver related code, it's not used any more.
>>>
>>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>>> Cc: Yinghai Lu <yinghai@kernel.org>
>>> Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>>> Cc: Toshi Kani <toshi.kani@hp.com>
>>> Cc: linux-pci@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>> ---
>>>  drivers/pci/hotplug/Kconfig        |    7 +-
>>>  drivers/pci/hotplug/acpiphp.h      |    3 -
>>>  drivers/pci/hotplug/acpiphp_core.c |   23 +--
>>>  drivers/pci/hotplug/acpiphp_glue.c |  282 +++++++-----------------------------
>>>  drivers/pci/pci-acpi.c             |    3 +
>>>  include/linux/pci-acpi.h           |   14 +-
>>>  6 files changed, 67 insertions(+), 265 deletions(-)
>>>
>>> diff --git a/drivers/pci/hotplug/Kconfig b/drivers/pci/hotplug/Kconfig
>>> index 13e9e63..9fcb87f 100644
>>> --- a/drivers/pci/hotplug/Kconfig
>>> +++ b/drivers/pci/hotplug/Kconfig
>>> @@ -52,15 +52,12 @@ config HOTPLUG_PCI_IBM
>>>           When in doubt, say N.
>>>
>>>  config HOTPLUG_PCI_ACPI
>>> -       tristate "ACPI PCI Hotplug driver"
>>> -       depends on (!ACPI_DOCK && ACPI) || (ACPI_DOCK)
>>> +       bool "ACPI PCI Hotplug driver"
>>
> Hi Bjorn,
>         Thanks for review.
>
>> My goal is that a user should never have to specify a kernel boot
>> parameter or edit a modules.conf file, but the user did previously
>> have some way to influence whether we use pciehp or acpiphp.  I know
>> we still have some issues, particularly with acpiphp, so I'm a little
>> concerned that by removing the CONFIG_HOTPLUG_PCI_ACPI=m, we might be
>> removing a way to work around those issues.
>>
>> A distro that previously used CONFIG_HOTPLUG_PCI_ACPI=m will now have
>> to use =y, so modules.conf is no longer applicable.  Can you convince
>> me that the user still has a way to work around issues?  I spent quite
>> a while trying to understand the pciehp/acpiphp dependencies, but it's
>> pretty tangled web.
> I will try my best to explain the relationships between pciehp and acpiphp
> as of v3.9-rc6.
>
> The pciehp driver always have priority over the acpiphp driver.
> That is, the acpiphp driver rejects binding to an ACPI PCI hotplug slot if
> a) The slot's parent is a PCIe port with native hotplug capability
> b) OSPM has taken over PCIe native hotplug control from BIOS.
>         !(root->osc_control_set & OSC_PCI_EXPRESS_NATIVE_HP_CONTROL)
> The above check has no dependency on the loading order of pciehp and acpiphp
> drivers. So converting acpiphp driver to builit-in should be ok.
>
> On the other hand, I remember Yinghai has mentioned that some PCIe ports
> with native hotplug capability doesn't work as expected with the pciehp driver
> and should be managed by the acpiphp driver. Currently we could achieve that
> by using boot param "pcie_ports=compat", but this will disable PCIe port
> drivers altogether. And I also remember that Rafael has mentioned that
> some BIOSes exhibit strange dependency among PCIe OSC controls, so it's
> not feasible to only disable PCIe native hotplug.
>
> For "pciehp_force", it does only affect the way pciehp to detect a hotplug
> slot, it doesn't affect acpiphp at all.
>
> To sum up, converting acpiphp as built-in should not affect the relationship
> between pciehp and acpiphp driver.

My concern is that a user used to be able to remove acpiphp from
modules.conf.  Now removing acpiphp will require a kernel rebuild.
But maybe that won't turn out to be a problem.

> So how about splitting this patch into
> two and adding more comments for the Kconfig change?

Yes, please at least split this into two.  While you're at it, please
also split the first patch into "remove unnecessary is_added guard"
and "cleanup."

Bjorn
