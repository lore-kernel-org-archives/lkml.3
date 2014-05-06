Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934033AbaEFGGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 02:06:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:53252 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbaEFGGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 02:06:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,994,1389772800"; 
   d="scan'208";a="534134956"
Message-ID: <53687C1E.2020001@intel.com>
Date: Tue, 06 May 2014 14:07:26 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Levente Kurusa <levex@linux.com>, Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux ATA/IDE <linux-ide@vger.kernel.org>,
        Joe Thomas <Joe.Thomas@dothill.com>
Subject: Re: [PATCH] ahci: unregister acpi notify handler when a ZPODD is
 unbound
References: <1398873887-23920-1-git-send-email-levex@linux.com> <536853F5.7040107@intel.com> <53687AE9.4010604@linux.com>
In-Reply-To: <53687AE9.4010604@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 02:02 PM, Levente Kurusa wrote:
> Hi,
> 
> On 05/06/2014 05:16 AM, Aaron Lu wrote:
>> On 05/01/2014 12:04 AM, Levente Kurusa wrote:
>>> When a ZPODD device is unbound via sysfs, the acpi notify handler
>>> is not removed. This causes panics as observed in Bug #74601. The
>>
>> Ah...too bad, I forgot to consider this situation, thanks for tracking
>> this.
>>
>>> panic only happens when the wake happens from outside the kernel
>>> (i.e. inserting media or pressing a button). Implement a new
>>> ahci_remove_one function which causes zpodd_exit to be called for all
>>> ZPODD devices on the unbound PCI device.
>>>
>>> Signed-off-by: Levente Kurusa <levex@linux.com>
>>> ---
>>>
>>> Hi,
>>>
>>> I am not sure if the loop below is correct. Maybe there is a better
>>> solution to loop through all the devices which might use ZPODD?
>>
>> I didn't find a proper place either. For hotplug, we did the zpodd_exit
>> at ata_scsi_handle_link_detach. But for host controller pci device
>> removal, we used scsi_remove_host in ata_port_detach and there is no
>> place to add the zpodd_exit for a to-be-removed scsi device...
>>
>> Looks like we can only iterate the ata devices and call zpodd_exit
>> explicitly for them if they are zpodd devices. Instead of adding a new
>> remove callback, what about just embed that into the ata_port_detach
>> like the following example?
> 
> Yes, this makes more sense as this doesn't tinker with exports and such...
> However this will throw unused variable compiler warnings if we add the
> required #ifdefs... Maybe a new function? ata_zpodd_detach_port?

I think we can omit the #ifdefs as the loop is not called frequently and
thus doesn't cost much. We already have stubs for zpodd_dev_enabled and
zpodd_exit.

Thanks,
Aaron

> 
>>
>>
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> index 943cc8b83e59..43652da6fea6 100644
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>> @@ -6314,6 +6314,8 @@ int ata_host_activate(struct ata_host *host, int irq,
>>  static void ata_port_detach(struct ata_port *ap)
>>  {
>>  	unsigned long flags;
>> +	struct ata_link *link;
>> +	struct ata_device *dev;
>>  
>>  	if (!ap->ops->error_handler)
>>  		goto skip_eh;
>> @@ -6333,6 +6335,13 @@ static void ata_port_detach(struct ata_port *ap)
>>  	cancel_delayed_work_sync(&ap->hotplug_task);
>>  
>>   skip_eh:
>> +	/* clean up zpodd related stuffs on port removal */
>> +	ata_for_each_link(link, ap, HOST_FIRST) {
>> +		ata_for_each_dev(dev, link, ALL) {
>> +			if (zpodd_dev_enabled(dev))
>> +				zpodd_exit(dev);
>> +		}
>> +	}
>>  	if (ap->pmp_link) {
>>  		int i;
>>  		for (i = 0; i < SATA_PMP_MAX_PORTS; i++)
> 

