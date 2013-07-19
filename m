Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412Ab3GSD5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 23:57:30 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:36613 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab3GSD51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 23:57:27 -0400
Message-ID: <51E8B923.5090201@gmail.com>
Date: Thu, 18 Jul 2013 21:57:23 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, john.ronciak@intel.com,
        miles.j.penner@intel.com, bruce.w.allan@intel.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 6/8] PCI: acpiphp: workaround for Thunderbolt on Acer
 Aspire S5
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com> <1372860295-8306-7-git-send-email-mika.westerberg@linux.intel.com> <1444243.g9GbxN3NM0@vostro.rjw.lan>
In-Reply-To: <1444243.g9GbxN3NM0@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2013 03:40 PM, Rafael J. Wysocki wrote:
> On Wednesday, July 03, 2013 05:04:53 PM Mika Westerberg wrote:
>> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>>
>> Correct ACPI PCI hotplug imeplementation should have _RMV method in a
>> PCI slot (device under pci bridge). In Acer Aspire S5 case we have it
>> deeper in hierarchy:
>>
>> Device (RP05)
>> {
>>     // ...
>>     Device (HRUP)
>>     {
>>         // ...
>>         Device (HRDN)
>>         {
>>             // ...
>>             Device (EPUP)
>>             {
>>                 // ...
>>                 Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
>>                 {
>>                     Return (One)
>>                 }
>>             }
>>         }
>>     }
>> }
>>
>> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
>> ---
>>   drivers/pci/hotplug/acpi_pcihp.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
>> index 2a47e82..d92ebfb 100644
>> --- a/drivers/pci/hotplug/acpi_pcihp.c
>> +++ b/drivers/pci/hotplug/acpi_pcihp.c
>> @@ -422,6 +422,19 @@ static int pcihp_is_ejectable(acpi_handle handle)
>>   	status = acpi_evaluate_integer(handle, "_RMV", NULL, &removable);
>>   	if (ACPI_SUCCESS(status) && removable)
>>   		return 1;
>> +
>> +	/*
>> +	 * Workaround for Thunderbolt implementation on Acer Aspire S5.
>> +	 *
>> +	 * Correct ACPI PCI hotplug imeplementation has _RMV method in a PCI
>> +	 * slot (device under pci bridge). In Acer Aspire S5 case we have it
>> +	 * deeper in hierarchy.
>> +	 */
>> +	status = acpi_evaluate_integer(handle, "HRDN.EPUP._RMV", NULL,
>> +			&removable);
>
> Well, calling stuff like this directly from a general function is kind of ugly.
>
> Can we use something like a quirk instead?  A DMI check or something?

Presumably this device functions under Windows so clearly Windows is 
capable of dealing with this case, so we should too.

There are way too many of these silly DMI checks in the kernel - we 
should be way more hesitant to add more of them. They're almost 
guaranteed to be incomplete. I would say they should be avoided whenever 
possible unless there's some reason why a general workaround can't be used.

>
>> +	if (ACPI_SUCCESS(status) && removable)
>> +		return 1;
>> +
>>   	return 0;
>>   }
>
> Rafael
>
>

