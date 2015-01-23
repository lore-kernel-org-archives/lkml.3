Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbbAWKCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:02:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbbAWKCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:02:08 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "devel\@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>, Jake Oshins <jakeo@microsoft.com>
Subject: Re: [PATCH 2/3] Drivers: hv: vmbus: introduce vmbus_acpi_remove
References: <1421866929-20167-1-git-send-email-vkuznets@redhat.com>
	<1421866929-20167-3-git-send-email-vkuznets@redhat.com>
	<BY2PR0301MB0711E8D8C81EE6EF2DE848EAA0490@BY2PR0301MB0711.namprd03.prod.outlook.com>
Date: Fri, 23 Jan 2015 11:01:59 +0100
In-Reply-To: <BY2PR0301MB0711E8D8C81EE6EF2DE848EAA0490@BY2PR0301MB0711.namprd03.prod.outlook.com>
	(KY Srinivasan's message of "Thu, 22 Jan 2015 19:08:29 +0000")
Message-ID: <878ugthl2g.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KY Srinivasan <kys@microsoft.com> writes:

>> -----Original Message-----
>> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
>> Sent: Wednesday, January 21, 2015 11:02 AM
>> To: KY Srinivasan; devel@linuxdriverproject.org
>> Cc: Haiyang Zhang; linux-kernel@vger.kernel.org; Dexuan Cui
>> Subject: [PATCH 2/3] Drivers: hv: vmbus: introduce vmbus_acpi_remove
>> 
>> In case we do request_resource() in vmbus_acpi_add() we need to tear it
>> down to be able to load the driver again. Otherwise the following crash in
>> oberved when hv_vmbus unload/load sequence is performed on
>> Generation2 instance:
>> 
>> [   38.165701] BUG: unable to handle kernel paging request at ffffffffa00075a0
>> [   38.166315] IP: [<ffffffff8107dc5f>] __request_resource+0x2f/0x50
>> [   38.166315] PGD 1f34067 PUD 1f35063 PMD 3f723067 PTE 0
>> [   38.166315] Oops: 0000 [#1] SMP
>> [   38.166315] Modules linked in: hv_vmbus(+) [last unloaded: hv_vmbus]
>> [   38.166315] CPU: 0 PID: 267 Comm: modprobe Not tainted 3.19.0-
>> rc5_bug923184+ #486
>> [   38.166315] Hardware name: Microsoft Corporation Virtual Machine/Virtual
>> Machine, BIOS Hyper-V UEFI Release v1.0 11/26/2012
>> [   38.166315] task: ffff88003f401cb0 ti: ffff88003f60c000 task.ti:
>> ffff88003f60c000
>> [   38.166315] RIP: 0010:[<ffffffff8107dc5f>]  [<ffffffff8107dc5f>]
>> __request_resource+0x2f/0x50
>> [   38.166315] RSP: 0018:ffff88003f60fb58  EFLAGS: 00010286
>> ...
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  drivers/hv/vmbus_drv.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>> 
>> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c index
>> 4d6b269..b06cb87 100644
>> --- a/drivers/hv/vmbus_drv.c
>> +++ b/drivers/hv/vmbus_drv.c
>> @@ -902,6 +902,15 @@ acpi_walk_err:
>>  	return ret_val;
>>  }
>> 
>> +static int vmbus_acpi_remove(struct acpi_device *device) {
>> +	int ret = 0;
>> +
>> +	if (hyperv_mmio.start && hyperv_mmio.end)
>> +		ret = release_resource(&hyperv_mmio);
>> +	return ret;
>> +}
>> +
>>  static const struct acpi_device_id vmbus_acpi_device_ids[] = {
>>  	{"VMBUS", 0},
>>  	{"VMBus", 0},
>> @@ -914,6 +923,7 @@ static struct acpi_driver vmbus_acpi_driver = {
>>  	.ids = vmbus_acpi_device_ids,
>>  	.ops = {
>>  		.add = vmbus_acpi_add,
>> +		.remove = vmbus_acpi_remove,
>>  	},
>>  };
>
> Vitaly,
>
> Jake has sent the following patch that has fixed retrieving of the mmio resources:
> https://lkml.org/lkml/2015/1/20/876
>
> This patch also deals with the resource cleanup that you have in this
> patch.

Ah, I see, I'm stepping on his toes here :) We can just drop this patch
from this series if Jake's get accepted (and I think it should).

>
> Regards,
>
> K. Y
>> 
>> --
>> 1.9.3

-- 
  Vitaly
