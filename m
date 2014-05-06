Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934193AbaEFHbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 03:31:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:41209 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbaEFHbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 03:31:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,995,1389772800"; 
   d="scan'208";a="535312983"
Message-ID: <5368900F.6050504@intel.com>
Date: Tue, 06 May 2014 15:32:31 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Levente Kurusa <levex@linux.com>, Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux ATA/IDE <linux-ide@vger.kernel.org>,
        Joe Thomas <Joe.Thomas@dothill.com>
Subject: Re: [PATCH] ahci: unregister acpi notify handler when a ZPODD is
 unbound
References: <1398873887-23920-1-git-send-email-levex@linux.com> <536853F5.7040107@intel.com> <53687AE9.4010604@linux.com> <53687C1E.2020001@intel.com> <53688BBF.5090406@linux.com>
In-Reply-To: <53688BBF.5090406@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 03:14 PM, Levente Kurusa wrote:
> Hi,
> 
> On 05/06/2014 08:07 AM, Aaron Lu wrote:
>> On 05/06/2014 02:02 PM, Levente Kurusa wrote:
>>> Hi,
>>>
>>> On 05/06/2014 05:16 AM, Aaron Lu wrote:
>>>> On 05/01/2014 12:04 AM, Levente Kurusa wrote:
>>>>> When a ZPODD device is unbound via sysfs, the acpi notify handler
>>>>> is not removed. This causes panics as observed in Bug #74601. The
>>>>
>>>> Ah...too bad, I forgot to consider this situation, thanks for tracking
>>>> this.
>>>>
>>>>> panic only happens when the wake happens from outside the kernel
>>>>> (i.e. inserting media or pressing a button). Implement a new
>>>>> ahci_remove_one function which causes zpodd_exit to be called for all
>>>>> ZPODD devices on the unbound PCI device.
>>>>>
>>>>> Signed-off-by: Levente Kurusa <levex@linux.com>
>>>>> ---
>>>>>
>>>>> Hi,
>>>>>
>>>>> I am not sure if the loop below is correct. Maybe there is a better
>>>>> solution to loop through all the devices which might use ZPODD?
>>>>
>>>> I didn't find a proper place either. For hotplug, we did the zpodd_exit
>>>> at ata_scsi_handle_link_detach. But for host controller pci device
>>>> removal, we used scsi_remove_host in ata_port_detach and there is no
>>>> place to add the zpodd_exit for a to-be-removed scsi device...
>>>>
>>>> Looks like we can only iterate the ata devices and call zpodd_exit
>>>> explicitly for them if they are zpodd devices. Instead of adding a new
>>>> remove callback, what about just embed that into the ata_port_detach
>>>> like the following example?
>>>
>>> Yes, this makes more sense as this doesn't tinker with exports and such...
>>> However this will throw unused variable compiler warnings if we add the
>>> required #ifdefs... Maybe a new function? ata_zpodd_detach_port?
>>
>> I think we can omit the #ifdefs as the loop is not called frequently and
>> thus doesn't cost much. We already have stubs for zpodd_dev_enabled and
>> zpodd_exit.
>>
> 
> Ah, I see. Shall I send V2? Any tags I should add for you?

Yes please. Also, this seems to be stable candidate.
You can add my reviewed-by tag, thanks.
