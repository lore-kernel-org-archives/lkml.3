Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759878Ab3BZAlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 19:41:39 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39321 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab3BZAlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 19:41:37 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <512C046E.8050501@jp.fujitsu.com>
Date: Tue, 26 Feb 2013 09:40:14 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [Update 4][PATCH 2/7] ACPI / scan: Introduce common code for
 ACPI-based device hotplug
References: <3260206.bhaAobGhpZ@vostro.rjw.lan> <1478394.ryVNRuTre2@vostro.rjw.lan> <1361815672.12845.71.camel@misato.fc.hp.com> <18666371.hyHAvqrdQ6@vostro.rjw.lan>
In-Reply-To: <18666371.hyHAvqrdQ6@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/02/26 8:39, Rafael J. Wysocki wrote:
> On Monday, February 25, 2013 11:07:52 AM Toshi Kani wrote:
>> On Sat, 2013-02-23 at 22:38 +0000, Rafael J. Wysocki wrote:
>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>
>>> Multiple drivers handling hotplug-capable ACPI device nodes install
>>> notify handlers covering the same types of events in a very similar
>>> way.  Moreover, those handlers are installed in separate namespace
>>> walks, although that really should be done during namespace scans
>>> carried out by acpi_bus_scan().  This leads to substantial code
>>> duplication, unnecessary overhead and behavior that is hard to
>>> follow.
>>>
>>> For this reason, introduce common code in drivers/acpi/scan.c for
>>> handling hotplug-related notification and carrying out device
>>> insertion and eject operations in a generic fashion, such that it
>>> may be used by all of the relevant drivers in the future.  To cover
>>> the existing differences between those drivers introduce struct
>>> acpi_hotplug_profile for representing collections of hotplug
>>> settings associated with different ACPI scan handlers that can be
>>> used by the drivers to make the common code reflect their current
>>> behavior.
>>>
>>> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> ---
>>>
>>> This update causes acpi_bus_device_eject() to only emit KOBJ_OFFLINE uevent if
>>> autoexec is unset for the given scan handler.
>>>
>>> This will require the doc in patch [5/7] to be updated which I'm going to do if
>>> everyone is OK with the $subject patch.
>>>
>>> Thanks,
>>> Rafael
>>   :
>>> +
>>> +static void acpi_scan_bus_device_check(acpi_handle handle, u32 ost_source)
>>> +{
>>> +	struct acpi_device *device = NULL;
>>> +	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
>>> +	int error;
>>> +
>>> +	mutex_lock(&acpi_scan_lock);
>>> +
>>> +	acpi_bus_get_device(handle, &device);
>>> +	if (device) {
>>> +		dev_warn(&device->dev, "Attempt to re-insert\n");
>>> +		goto out;
>>> +	}
>>> +	acpi_evaluate_hotplug_ost(handle, ost_source,
>>> +				  ACPI_OST_SC_INSERT_IN_PROGRESS, NULL);
>>> +	error = acpi_bus_scan(handle);
>>> +	if (error) {
>>> +		acpi_handle_warn(handle, "Namespace scan failure\n");
>>> +		goto out;
>>> +	}
>>> +	error = acpi_bus_get_device(handle, &device);
>>> +	if (error) {
>>> +		acpi_handle_warn(handle, "Missing device node object\n");
>>> +		goto out;
>>> +	}
>>> +	ost_code = ACPI_OST_SC_SUCCESS;
>>> +	if (device->handler && device->handler->hotplug.uevents)
>>> +		kobject_uevent(&device->dev.kobj, KOBJ_ONLINE);
>>

>> I confirmed that the uevent crash issue was solved.  Thinking further, I
>> wonder if we need to emit KOBJ_ONLINE here.  This behavior is asymmetric
>> since we do not emit KOBJ_OFFLINE when autoeject is set.
>
> Well, I put that in there only to be able to make the container driver behave
> in a backwards compatible way (which is to emit KOBJ_ONLINE at this point).
>
> If the container driver doesn't need to emit KOBJ_ONLINE at all, I agree with
> your suggestion.
>
>> The definition of ONLINE/OFFLINE event to an ACPI device object seems also
>> bogus since there is no online/offline operation to the ACPI device object
>> itself.
>> Online/offline operation is only possible to actual device, such as
>> system/cpu/cpu% and system/memory/memory%.
>
> That's correct, but I don't know what the user space expectations are
> currently.

My system expects this event to be notified when hot adding container device.
My container device has cpu and memory. As Toshi said, these devices are
offline when hot adding container device. So in my system, when notifying
container device's KOBJ_ONLINE event, my application runs for onlining these
devices. If this event is not notified to user land, we cannot online these
devices  automatically.

>
>> So, I'd suggest the following changes.
>>   - Remove the "uevents" attribute.  KOBJ_ONLINE/OFFLINE are not used for
>> ACPI device objects.
>>   - Make the !autoeject case as an exception for now, and emit
>> KOBJ_OFFLINE as a way to request off-lining to user.  This uevent is
>> tied with the !autoeject case.  We can then revisit if this use-case
>> needs to be supported going forward.  If so, we may want to consider a
>> different event type.
>
> Well, what about avoiding to expose uevents and autoeject for now and
> exposing enabled only?  Drivers would still be able to set the other flags on
> init on init to enforce the backwards-compatible behavior.
>
> I agree that it would be sufficient to use one additional flag then, to start
> with, but its meaning would be something like "keep backwards compatibility
> with the old container driver", so perhaps "autoeject" is not a good name.
>

> What about "user_eject" (that won't be exposed to user space) instead?  Where,
> if set, it would meand "do not autoeject and emit KOBJ_OFFLINE/ONLINE uevents
> like the old container driver did"?

It's good idea.

Thanks,
Yasuaki Ishimatsu

>
> Rafael
>
>


