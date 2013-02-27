Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933879Ab3B0Amr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:42:47 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:49392 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933080Ab3B0Amp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:42:45 -0500
Message-ID: <512D565F.1010403@huawei.com>
Date: Wed, 27 Feb 2013 08:42:07 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v8 13/13] PCI, ACPI: remove support of ACPI PCI subdrivers
References: <1361892353-14786-1-git-send-email-jiang.liu@huawei.com> <1361892353-14786-14-git-send-email-jiang.liu@huawei.com> <CAE9FiQV_hv3fD166LuZYhTKGxeKKKCw-Dak+8UYou7tRa-4hYw@mail.gmail.com>
In-Reply-To: <CAE9FiQV_hv3fD166LuZYhTKGxeKKKCw-Dak+8UYou7tRa-4hYw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-2-27 3:07, Yinghai Lu wrote:
> On Tue, Feb 26, 2013 at 7:25 AM, Jiang Liu <liuj97@gmail.com> wrote:
>> From: Myron Stowe <myron.stowe@redhat.com>
>>
>> Both sub-drivers of the "PCI Root Bridge ("pci_bridge")" driver, "acpiphp"
>> and "pci_slot", have been converted to hook directly into the PCI core.
>>
>> With the conversions there are no remaining usages of the 'struct
>> acpi_pci_driver' list based infrastructure.  This patch removes it.
>>
>> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>> Cc: Toshi Kani <toshi.kani@hp.com>
>> Cc: linux-pci@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
> 
> Nice cleanup!
> 
> for 1-13,
> Reviewed-by: Yinghai Lu <yinghai@kernel.org>
HiYinghai,
	Thanks for review!
	Regards!
	Gerry

> 
> Thanks
> 
> Yinghai
> 
>> ---
>>  drivers/acpi/pci_root.c |   48 +----------------------------------------------
>>  include/linux/acpi.h    |    9 ---------
>>  2 files changed, 1 insertion(+), 56 deletions(-)
>>
>> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
>> index 8b5a73b..2ef0c91 100644
>> --- a/drivers/acpi/pci_root.c
>> +++ b/drivers/acpi/pci_root.c
>> @@ -69,44 +69,12 @@ static struct acpi_driver acpi_pci_root_driver = {
>>                 },
>>  };
>>
>> -/* Lock to protect both acpi_pci_roots and acpi_pci_drivers lists */
>> +/* Lock to protect both acpi_pci_roots lists */
>>  static DEFINE_MUTEX(acpi_pci_root_lock);
>>  static LIST_HEAD(acpi_pci_roots);
>> -static LIST_HEAD(acpi_pci_drivers);
>>
>>  static DEFINE_MUTEX(osc_lock);
>>
>> -int acpi_pci_register_driver(struct acpi_pci_driver *driver)
>> -{
>> -       int n = 0;
>> -       struct acpi_pci_root *root;
>> -
>> -       mutex_lock(&acpi_pci_root_lock);
>> -       list_add_tail(&driver->node, &acpi_pci_drivers);
>> -       if (driver->add)
>> -               list_for_each_entry(root, &acpi_pci_roots, node) {
>> -                       driver->add(root);
>> -                       n++;
>> -               }
>> -       mutex_unlock(&acpi_pci_root_lock);
>> -
>> -       return n;
>> -}
>> -EXPORT_SYMBOL(acpi_pci_register_driver);
>> -
>> -void acpi_pci_unregister_driver(struct acpi_pci_driver *driver)
>> -{
>> -       struct acpi_pci_root *root;
>> -
>> -       mutex_lock(&acpi_pci_root_lock);
>> -       list_del(&driver->node);
>> -       if (driver->remove)
>> -               list_for_each_entry(root, &acpi_pci_roots, node)
>> -                       driver->remove(root);
>> -       mutex_unlock(&acpi_pci_root_lock);
>> -}
>> -EXPORT_SYMBOL(acpi_pci_unregister_driver);
>> -
>>  /**
>>   * acpi_is_root_bridge - determine whether an ACPI CA node is a PCI root bridge
>>   * @handle - the ACPI CA node in question.
>> @@ -416,7 +384,6 @@ static int acpi_pci_root_add(struct acpi_device *device)
>>         acpi_status status;
>>         int result;
>>         struct acpi_pci_root *root;
>> -       struct acpi_pci_driver *driver;
>>         u32 flags, base_flags;
>>         bool is_osc_granted = false;
>>
>> @@ -576,12 +543,6 @@ static int acpi_pci_root_add(struct acpi_device *device)
>>                 pci_assign_unassigned_bus_resources(root->bus);
>>         }
>>
>> -       mutex_lock(&acpi_pci_root_lock);
>> -       list_for_each_entry(driver, &acpi_pci_drivers, node)
>> -               if (driver->add)
>> -                       driver->add(root);
>> -       mutex_unlock(&acpi_pci_root_lock);
>> -
>>         /* need to after hot-added ioapic is registered */
>>         if (system_state != SYSTEM_BOOTING)
>>                 pci_enable_bridges(root->bus);
>> @@ -602,16 +563,9 @@ end:
>>  static int acpi_pci_root_remove(struct acpi_device *device, int type)
>>  {
>>         struct acpi_pci_root *root = acpi_driver_data(device);
>> -       struct acpi_pci_driver *driver;
>>
>>         pci_stop_root_bus(root->bus);
>>
>> -       mutex_lock(&acpi_pci_root_lock);
>> -       list_for_each_entry_reverse(driver, &acpi_pci_drivers, node)
>> -               if (driver->remove)
>> -                       driver->remove(root);
>> -       mutex_unlock(&acpi_pci_root_lock);
>> -
>>         device_set_run_wake(root->bus->bridge, false);
>>         pci_acpi_remove_bus_pm_notifier(device);
>>
>> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
>> index 8c1d6f2..eeb5600 100644
>> --- a/include/linux/acpi.h
>> +++ b/include/linux/acpi.h
>> @@ -147,15 +147,6 @@ void acpi_penalize_isa_irq(int irq, int active);
>>
>>  void acpi_pci_irq_disable (struct pci_dev *dev);
>>
>> -struct acpi_pci_driver {
>> -       struct list_head node;
>> -       int (*add)(struct acpi_pci_root *root);
>> -       void (*remove)(struct acpi_pci_root *root);
>> -};
>> -
>> -int acpi_pci_register_driver(struct acpi_pci_driver *driver);
>> -void acpi_pci_unregister_driver(struct acpi_pci_driver *driver);
>> -
>>  extern int ec_read(u8 addr, u8 *val);
>>  extern int ec_write(u8 addr, u8 val);
>>  extern int ec_transaction(u8 command,
>> --
>> 1.7.9.5
>>
> 
> .
> 


