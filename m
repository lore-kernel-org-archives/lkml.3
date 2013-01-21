Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab3AUByU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 20:54:20 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:60871 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab3AUByP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 20:54:15 -0500
MIME-Version: 1.0
In-Reply-To: <2123353.z1dtQmXUNo@vostro.rjw.lan>
References: <1358495602-22867-1-git-send-email-yinghai@kernel.org>
	<1358495602-22867-7-git-send-email-yinghai@kernel.org>
	<2123353.z1dtQmXUNo@vostro.rjw.lan>
Date: Sun, 20 Jan 2013 17:54:14 -0800
X-Google-Sender-Auth: yuhccHu4junSLE6SXMZqNGcLmeA
Message-ID: <CAE9FiQVxwm43bkpRYEkSy5sL-FAkE49NE5nFQvXKWPSfoY+oEw@mail.gmail.com>
Subject: Re: [PATCH v9 06/11] PCI, ACPI, acpiphp: Rename alloc_acpiphp_hp_work()
 to alloc_acpi_hp_work
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

On Sun, Jan 20, 2013 at 2:38 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, January 17, 2013 11:53:17 PM Yinghai Lu wrote:
>> Will need to use it for pci root bridge hotplug support, rename
>> *acpiphp* to *acpi* and move to osc.c.
>> Also make kacpi_hotplug_wq static after that.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: Len Brown <lenb@kernel.org>
>> Cc: linux-acpi@vger.kernel.org
>> ---
>>  drivers/acpi/osl.c                 |   24 +++++++++++++++++++--
>>  drivers/pci/hotplug/acpiphp_glue.c |   42 ++++++------------------------------
>>  include/acpi/acpiosxf.h            |    9 +++++++-
>>  3 files changed, 36 insertions(+), 39 deletions(-)
>>
>> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
>> index 3ff2678..afcce46 100644
>> --- a/drivers/acpi/osl.c
>> +++ b/drivers/acpi/osl.c
>> @@ -84,8 +84,7 @@ static acpi_osd_handler acpi_irq_handler;
>>  static void *acpi_irq_context;
>>  static struct workqueue_struct *kacpid_wq;
>>  static struct workqueue_struct *kacpi_notify_wq;
>> -struct workqueue_struct *kacpi_hotplug_wq;
>> -EXPORT_SYMBOL(kacpi_hotplug_wq);
>> +static struct workqueue_struct *kacpi_hotplug_wq;
>>
>>  /*
>>   * This list of permanent mappings is for memory that may be accessed from
>> @@ -1778,3 +1777,24 @@ void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
>>  {
>>       __acpi_os_prepare_sleep = func;
>>  }
>> +
>> +void alloc_acpi_hp_work(acpi_handle handle, u32 type, void *context,
>> +                     void (*func)(struct work_struct *work))
>> +{
>> +     struct acpi_hp_work *hp_work;
>> +     int ret;
>> +
>> +     hp_work = kmalloc(sizeof(*hp_work), GFP_KERNEL);
>> +     if (!hp_work)
>> +             return;
>> +
>> +     hp_work->handle = handle;
>> +     hp_work->type = type;
>> +     hp_work->context = context;
>> +
>> +     INIT_WORK(&hp_work->work, func);
>> +     ret = queue_work(kacpi_hotplug_wq, &hp_work->work);
>> +     if (!ret)
>> +             kfree(hp_work);
>> +}
>> +EXPORT_SYMBOL(alloc_acpi_hp_work);
>
> That should be EXPORT_SYMBOL_GPL().

Ok.

Chose that because kacpi_hotplug_wq does not have _GPL.

>
...
>> diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
>> index 4315274..adab63c 100644
>> --- a/include/acpi/acpiosxf.h
>> +++ b/include/acpi/acpiosxf.h
>> @@ -193,7 +193,14 @@ void acpi_os_fixed_event_count(u32 fixed_event_number);
>>  /*
>>   * Threads and Scheduling
>>   */
>> -extern struct workqueue_struct *kacpi_hotplug_wq;
>
> include/acpi/acpiosxf.h is related to ACPICA, so while removing kacpi_hotplug_wq
> from it should be OK, please put the rest into acpi_bus.h, preferably next to the
> definition of acpi_eject_event.
>

Ok.

Thanks
