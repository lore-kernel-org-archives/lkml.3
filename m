Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbaAFOUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:20:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:12379 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbaAFOUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:20:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,613,1384329600"; 
   d="scan'208";a="460743658"
Message-ID: <52CABBA3.8030107@intel.com>
Date: Mon, 06 Jan 2014 22:20:19 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Leandro Dorileo <l@dorileo.org>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        fcr@adinet.com.uy, "3.8+" <stable@vger.kernel.org>
Subject: Re: [PATCH] ACPI/Battery: Add a _BIX quirk for NEC LZ750/LS
References: <1388648277-23453-1-git-send-email-tianyu.lan@intel.com> <20140103231250.GD13489@core.coreip.homeip.net> <52CAB8A7.1070002@intel.com> <6301126.1BZJn0NGqy@vostro.rjw.lan>
In-Reply-To: <6301126.1BZJn0NGqy@vostro.rjw.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 10:32 PM, Rafael J. Wysocki wrote:
> On Monday, January 06, 2014 10:07:35 PM Lan Tianyu wrote:
>> On 01/04/2014 07:12 AM, Dmitry Torokhov wrote:
>>> On Fri, Jan 03, 2014 at 05:01:11PM -0200, Leandro Dorileo wrote:
>>>> On Thu, Jan 02, 2014 at 03:37:57PM +0800, Lan Tianyu wrote:
>>>>> The aml method _BIX of NEC LZ750/LS returns a broken package which
>>>>> skip the first member "Revision" according ACPI 5.0 spec Table 10-234.
>>>>>
>>>>> This patch is to add a quirk for this machine to skip member "Revision"
>>>>> during parsing _BIX returned package.
>>>>>
>>>>> Reported-and-tested-by: Francisco Castro <fcr@adinet.com.uy>
>>>>> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=67351
>>>>> Cc: 3.8+ <stable@vger.kernel.org>
>>>>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>>>>> ---
>>>>>    drivers/acpi/battery.c |   28 +++++++++++++++++++++++++++-
>>>>>    1 file changed, 27 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
>>>>> index fbf1ace..3d64a87 100644
>>>>> --- a/drivers/acpi/battery.c
>>>>> +++ b/drivers/acpi/battery.c
>>>>> @@ -62,6 +62,7 @@ MODULE_AUTHOR("Alexey Starikovskiy <astarikovskiy@suse.de>");
>>>>>    MODULE_DESCRIPTION("ACPI Battery Driver");
>>>>>    MODULE_LICENSE("GPL");
>>>>>
>>>>> +static int battery_bix_broken_package;
>>>>>    static unsigned int cache_time = 1000;
>>>>>    module_param(cache_time, uint, 0644);
>>>>>    MODULE_PARM_DESC(cache_time, "cache time in milliseconds");
>>>>> @@ -416,7 +417,12 @@ static int acpi_battery_get_info(struct acpi_battery *battery)
>>>>>    		ACPI_EXCEPTION((AE_INFO, status, "Evaluating %s", name));
>>>>>    		return -ENODEV;
>>>>>    	}
>>>>> -	if (test_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags))
>>>>> +
>>>>> +	if (battery_bix_broken_package)
>>>>> +		result = extract_package(battery, buffer.pointer,
>>>>> +				extended_info_offsets + 1,
>>>>> +				ARRAY_SIZE(extended_info_offsets) - 1);
>>>>> +	else if (test_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags))
>>>>>    		result = extract_package(battery, buffer.pointer,
>>>>>    				extended_info_offsets,
>>>>>    				ARRAY_SIZE(extended_info_offsets));
>>>>> @@ -754,6 +760,24 @@ static int battery_notify(struct notifier_block *nb,
>>>>>    	return 0;
>>>>>    }
>>>>>
>>>>> +static int battery_bix_package_quirk(const struct dmi_system_id *id)
>>>>> +{
>>>>> +	battery_bix_broken_package = 1;
>>>>> +	return 0;
>>>>> +}
>>>>> +
>>>>
>>>>
>>>> Do you really need this callback? Why don't you just do:
>>>>
>>>> if (dmi_check_system(bat_dmi_table))
>>>>          battery_bix_broken_package = 1;
>>>>
>>>
>>> Callback would be useful if we were to print the DMI data of the match,
>>> otherwise not so much.
>>>
>>
>> Hi Leandro & Dmitry:
>> 	Thanks for your review. I select to callback mode as it's convenient to
>> add a new quirk for other machines if need. This Just likes what we have
>> done for the other ACPI drivers(E,G ac, processor_idle, video, thermal
>> and so on.).
>
> We can switch to callbacks when we actually need them.  Please keep things
> as simple as reasonably possible.

Ok. I will update it.

>
> Thanks!
>


-- 
Best Regards
Tianyu Lan
