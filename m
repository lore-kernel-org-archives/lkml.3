Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbaCDAfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 19:35:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:20537 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301AbaCDAfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 19:35:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,581,1389772800"; 
   d="scan'208";a="466014755"
Message-ID: <53151FB4.60502@intel.com>
Date: Tue, 04 Mar 2014 01:35:00 +0100
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Zhang, Rui" <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "matthew.garrett@nebula.com" <matthew.garrett@nebula.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
Subject: Re: [RFC PATCH 6/8] ACPI: use platform bus as the default bus for
 _HID enumeration
References: <1393405874-3266-1-git-send-email-rui.zhang@intel.com> <22144944.rXupLb1rjo@vostro.rjw.lan> <1393855908.2193.16.camel@rzhang1-mobl4> <1440720.MRPxuLKXmI@vostro.rjw.lan> <744357E9AAD1214791ACBA4B0B909263011E907E@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <744357E9AAD1214791ACBA4B0B909263011E907E@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/4/2014 1:27 AM, Zhang, Rui wrote:
>
>> -----Original Message-----
>> From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
>> Sent: Tuesday, March 04, 2014 7:23 AM
>> To: Zhang, Rui
>> Cc: linux-acpi@vger.kernel.org; linux-kernel@vger.kernel.org;
>> bhelgaas@google.com; matthew.garrett@nebula.com; Wysocki, Rafael J;
>> dmitry.torokhov@gmail.com
>> Subject: Re: [RFC PATCH 6/8] ACPI: use platform bus as the default bus
>> for _HID enumeration
>> Importance: High
>>
>> On Monday, March 03, 2014 10:11:48 PM Zhang Rui wrote:
>>> On Mon, 2014-03-03 at 00:51 +0100, Rafael J. Wysocki wrote:
>>>> On Wednesday, February 26, 2014 05:11:12 PM Zhang Rui wrote:
>>>>> Because of the growing demand for enumerating ACPI devices to
>>>>> platform bus, this patch changes the code to enumerate ACPI
>>>>> devices with _HID/_CID to platform bus by default, unless the
>> device already has a scan handler attached.
>>>>> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>>>>> ---
>>>>>   drivers/acpi/acpi_platform.c |   28 ----------------------------
>>>>>   drivers/acpi/scan.c          |   12 ++++++------
>>>>>   2 files changed, 6 insertions(+), 34 deletions(-)
>>>>>
>>>>> diff --git a/drivers/acpi/acpi_platform.c
>>>>> b/drivers/acpi/acpi_platform.c index dbfe49e..33376a9 100644
>>>>> --- a/drivers/acpi/acpi_platform.c
>>>>> +++ b/drivers/acpi/acpi_platform.c
>>>>> @@ -22,24 +22,6 @@
>>>>>
>>>>>   ACPI_MODULE_NAME("platform");
>>>>>
>>>>> -/*
>>>>> - * The following ACPI IDs are known to be suitable for
>>>>> representing as
>>>>> - * platform devices.
>>>>> - */
>>>>> -static const struct acpi_device_id acpi_platform_device_ids[] =
>> {
>>>>> -
>>>>> -	{ "PNP0D40" },
>>>>> -	{ "ACPI0003" },
>>>>> -	{ "VPC2004" },
>>>>> -	{ "BCM4752" },
>>>>> -
>>>>> -	/* Intel Smart Sound Technology */
>>>>> -	{ "INT33C8" },
>>>>> -	{ "80860F28" },
>>>>> -
>>>>> -	{ }
>>>>> -};
>>>>> -
>>>>>   /**
>>>>>    * acpi_create_platform_device - Create platform device for ACPI
>> device node
>>>>>    * @adev: ACPI device node to create a platform device for.
>>>>> @@ -125,13 +107,3 @@ int acpi_create_platform_device(struct
>> acpi_device *adev,
>>>>>   	kfree(resources);
>>>>>   	return 1;
>>>>>   }
>>>>> -
>>>>> -static struct acpi_scan_handler platform_handler = {
>>>>> -	.ids = acpi_platform_device_ids,
>>>>> -	.attach = acpi_create_platform_device,
>>>>> -};
>>>>> -
>>>>> -void __init acpi_platform_init(void) -{
>>>>> -	acpi_scan_add_handler(&platform_handler);
>>>>> -}
>>>>> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c index
>>>>> 5967338..61af32e 100644
>>>>> --- a/drivers/acpi/scan.c
>>>>> +++ b/drivers/acpi/scan.c
>>>>> @@ -2022,14 +2022,15 @@ static int
>> acpi_scan_attach_handler(struct acpi_device *device)
>>>>>   		handler = acpi_scan_match_handler(hwid->id, &devid);
>>>>>   		if (handler) {
>>>>>   			ret = handler->attach(device, devid);
>>>>> -			if (ret > 0) {
>>>>> +			if (ret > 0)
>>>>>   				device->handler = handler;
>>>>> -				break;
>>>>> -			} else if (ret < 0) {
>>>>> -				break;
>>>>> -			}
>>>>> +			if (ret)
>>>>> +				goto end;
>>>>>   		}
>>>>>   	}
>>>>> +end:
>>>>> +	if (!list_empty(&device->pnp.ids) && !device->handler)
>>>> I'm a bit concerned that this check will create platform devices
>> for
>>>> too many ACPI device objects.
>>> agreed. there are some devices created unexpected by this patch, e.g.
>>> on my test machine, I can see
>>>
>>> /sys/bus/platform/devices/LNXSYSTM:00 (ACPI system bus/root node)
>>> /sys/bus/platform/devices/PNP0000:00  (PIC)
>>> /sys/bus/platform/devices/PNP0100:00  (system timer?)
>>>
>>>>    Shouldn't we require that _HID or at least _CID is present for
>>>> that?
>>>>
>>> I do not think so.
>>> only devices that invoke acpi_add_ids() may have pnp.ids but no
>>> _HID/_CID, right?
>>> I did a check in the code, those devices include:
>> Well, I did that too.
>>
>>> ACPI root node
>>> ACPI video
>>> ACPI bay
>>> ACPI dock
>>> IBM SMBus
>>> ACPI Power resource
>>> ACPI processor
>>> ACPI thermal
>>> ACPI fixed power/sleep button
>>>
>>> IMO, only the ACPI root node, ACPI power resource, possibly ACPI
>>> processor are the ones that we do not want to see in platform bus.
>> No, we don't want any of them.  So pretty much as I said, only if
>> _HID/_CID is present, please?
>>
> Why? We will convert the drivers for most of those devices from ACPI bus to platform bus sooner or later.
> We need to see them in platform bus...

No, we don't.

I'm not sure about IBM SMBus to be honest, but as for the rest:

Why would we want one for the ACPI root?

And for video?  Those things are PCI usually devices anyway and we just 
add "artificial" HIDs for them.

ACPI docks and bays are handled by the dock driver which creates 
platform devices for them already if needed and we don't want duplicates 
there.

ACPI processor has its own scan handler that binds those objects to 
system devices.

Power resources - no need.

Do we need platform devices for ACPI thermal zones?

Yes, we will need them for fixed buttons, but that's a special case anyway.

Thanks,
Rafael

