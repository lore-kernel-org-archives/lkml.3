Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab3AOGpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 01:45:10 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:52604 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3AOGpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 01:45:04 -0500
MIME-Version: 1.0
In-Reply-To: <2032314.LPbgrOarU3@vostro.rjw.lan>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
	<1357944049-29620-10-git-send-email-yinghai@kernel.org>
	<2032314.LPbgrOarU3@vostro.rjw.lan>
Date: Mon, 14 Jan 2013 22:45:02 -0800
X-Google-Sender-Auth: cBuQ1aFe3Z9OhTmydeXiq5BjWQo
Message-ID: <CAE9FiQUdXWxrM9Mk4rPG4fb5DKEP46Oa84219y8KC+kOaLB67w@mail.gmail.com>
Subject: Re: [PATCH v8 09/22] PCI, ACPI: Add pci_root_hp hot removal
 notification support.
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 3:26 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, January 11, 2013 02:40:36 PM Yinghai Lu wrote:
>> Add missing hot_remove support for root device.
>>
>> How to test it?
>> Find out root bus number to acpi root name mapping from dmesg or /sys
>>
>>   echo "\_SB.PCIB 3" > /sys/kernel/debug/acpi/sci_notify
>> to remove root bus
>>
>> -v2: separate stop and remove, so it will be safe for comingi
>>       acpi_pci_bind_notify() changes.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: Len Brown <lenb@kernel.org>
>> Cc: linux-acpi@vger.kernel.org
>> ---
>>  drivers/acpi/pci_root.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 67 insertions(+)
>>
>> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
>> index 5c1f462c..5ae36d8 100644
>> --- a/drivers/acpi/pci_root.c
>> +++ b/drivers/acpi/pci_root.c
>> @@ -740,6 +740,12 @@ static void add_acpi_root_bridge(acpi_handle handle)
>>       list_add(&bridge->list, &acpi_root_bridge_list);
>>  }
>>
>> +static void remove_acpi_root_bridge(struct acpi_root_bridge *bridge)
>> +{
>> +     list_del(&bridge->list);
>> +     kfree(bridge);
>> +}
>> +
>>  struct acpi_root_hp_work {
>>       struct work_struct work;
>>       acpi_handle handle;
>> @@ -800,6 +806,61 @@ static void handle_root_bridge_insertion(acpi_handle handle)
>>               printk(KERN_ERR "cannot add bridge to acpi list\n");
>>  }
>>
>> +static int acpi_root_evaluate_object(acpi_handle handle, char *cmd, int val)
>> +{
>> +     acpi_status status;
>> +     struct acpi_object_list arg_list;
>> +     union acpi_object arg;
>> +
>> +     arg_list.count = 1;
>> +     arg_list.pointer = &arg;
>> +     arg.type = ACPI_TYPE_INTEGER;
>> +     arg.integer.value = val;
>> +
>> +     status = acpi_evaluate_object(handle, cmd, &arg_list, NULL);
>> +     if (ACPI_FAILURE(status)) {
>> +             pr_warn("%s: %s to %d failed\n",
>> +                              __func__, cmd, val);
>> +             return -1;
>
> Please use a meaningful error code.
>
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static void handle_root_bridge_removal(acpi_handle handle,
>> +              struct acpi_root_bridge *bridge)
>> +{
>> +     u32 flags = 0;
>> +     struct acpi_device *device;
>> +
>> +     if (bridge) {
>> +             flags = bridge->flags;
>> +             remove_acpi_root_bridge(bridge);
>> +     }
>> +
>> +     if (!acpi_bus_get_device(handle, &device)) {
>> +             int ret_val;
>> +
>> +             /* remove pci devices at first */
>> +             ret_val = acpi_bus_trim(device, 0);
>> +             printk(KERN_DEBUG "acpi_bus_trim stop return %x\n", ret_val);
>> +
>> +             /* remove acpi devices */
>> +             ret_val = acpi_bus_trim(device, 1);
>> +             printk(KERN_DEBUG "acpi_bus_trim remove return %x\n", ret_val);
>
> First of all, I don't agree with the way acpi_bus_trim() is used here, as
> I said in the previous message.
>
> Second, this code duplicates the code you're adding on [08/22] almost exactly.
> Please put it into a one separate function instead of duplicating it like this.
>
>> +     }
>> +
>> +     if (flags & ROOT_BRIDGE_HAS_PS3) {
>> +             acpi_status status;
>> +
>> +             status = acpi_evaluate_object(handle, "_PS3", NULL, NULL);
>> +             if (ACPI_FAILURE(status))
>> +                     pr_warn("%s: _PS3 failed\n", __func__);
>
> No, please.  acpi_device_set_power() is for that.
>
>> +     }
>> +     if (flags & ROOT_BRIDGE_HAS_EJ0)
>> +             acpi_root_evaluate_object(handle, "_EJ0", 1);
>
> That seems to duplicate some code from scan.c.

yes, will address in the following patch.
