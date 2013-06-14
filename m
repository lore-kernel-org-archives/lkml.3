Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab3FNN51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:57:27 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34881 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3FNN5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:57:24 -0400
Message-ID: <51BB213B.7010807@gmail.com>
Date: Fri, 14 Jun 2013 21:57:15 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jiang Liu <jiang.liu@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        stable@vger.kernel.org
Subject: Re: [BUGFIX 2/9] ACPIPHP: fix device destroying order issue when
 handling dock notification
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com> <1371141152-9468-3-git-send-email-jiang.liu@huawei.com> <2448481.HbOiE9Npmq@vostro.rjw.lan> <2301639.HY0nSRLtah@vostro.rjw.lan>
In-Reply-To: <2301639.HY0nSRLtah@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 08:23 PM, Rafael J. Wysocki wrote:
> On Thursday, June 13, 2013 09:59:44 PM Rafael J. Wysocki wrote:
>> On Friday, June 14, 2013 12:32:25 AM Jiang Liu wrote:
>>> Current ACPI glue logic expects that physical devices are destroyed
>>> before destroying companion ACPI devices, otherwise it will break the
>>> ACPI unbind logic and cause following warning messages:
>>> [  185.026073] usb usb5: Oops, 'acpi_handle' corrupt
>>> [  185.035150] pci 0000:1b:00.0: Oops, 'acpi_handle' corrupt
>>> [  185.035515] pci 0000:18:02.0: Oops, 'acpi_handle' corrupt
>>> [  180.013656]  port1: Oops, 'acpi_handle' corrupt
>>> Please refer to https://bugzilla.kernel.org/attachment.cgi?id=104321
>>> for full log message.
>>
>> So my question is, did we have this problem before commit 3b63aaa70e1?
>>
>> If we did, then when did it start?  Or was it present forever?
>>
>>> Above warning messages are caused by following scenario:
>>> 1) acpi_dock_notifier_call() queues a task (T1) onto kacpi_hotplug_wq
>>> 2) kacpi_hotplug_wq handles T1, which invokes acpi_dock_deferred_cb()
>>>    ->dock_notify()-> handle_eject_request()->hotplug_dock_devices()
>>> 3) hotplug_dock_devices() first invokes registered hotplug callbacks to
>>>    destroy physical devices, then destroys all affected ACPI devices.
>>>    Everything seems perfect until now. But the acpiphp dock notification
>>>    handler will queue another task (T2) onto kacpi_hotplug_wq to really
>>>    destroy affected physical devices.
>>
>> Would not the solution be to modify it so that it didn't spawn the other
>> task (T2), but removed the affected physical devices synchronously?
>>
>>> 4) kacpi_hotplug_wq finishes T1, and all affected ACPI devices have
>>>    been destroyed.
>>> 5) kacpi_hotplug_wq handles T2, which destroys all affected physical
>>>    devices.
>>>
>>> So it breaks ACPI glue logic's expection because ACPI devices are destroyed
>>> in step 3 and physical devices are destroyed in step 5.
>>>
>>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>>> Reported-by: Alexander E. Patrakov <patrakov@gmail.com>
>>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>>> Cc: Yinghai Lu <yinghai@kernel.org>
>>> Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>>> Cc: linux-pci@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Cc: stable@vger.kernel.org
>>> ---
>>> Hi Bjorn and Rafael,
>>>      The recursive lock changes haven't been tested yet, need help
>>> from Alexander for testing.
>>
>> Well, let's just say I'm not a fan of recursive locks.  Is that unavoidable
>> here?
> 
> What about the appended patch (on top of [1/9], untested)?
> 
> Rafael
It should have similar effect as patch 2/9, and it will encounter the
same deadlock scenario as 2/9 too.

> 
> 
> ---
>  drivers/pci/hotplug/acpiphp_glue.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
> +++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> @@ -145,9 +145,20 @@ static int post_dock_fixups(struct notif
>  	return NOTIFY_OK;
>  }
>  
> +static void handle_dock_event_func(acpi_handle handle, u32 event, void *context)
> +{
> +	if (event == ACPI_NOTIFY_EJECT_REQUEST) {
> +		struct acpiphp_func *func = context;
> +
> +		if (!acpiphp_disable_slot(func->slot))
> +			acpiphp_eject_slot(func->slot);
> +	} else {
> +		handle_hotplug_event_func(handle, event, context);
> +	}
> +}
>  
>  static const struct acpi_dock_ops acpiphp_dock_ops = {
> -	.handler = handle_hotplug_event_func,
> +	.handler = handle_dock_event_func,
>  };
>  
>  /* Check whether the PCI device is managed by native PCIe hotplug driver */
> 

