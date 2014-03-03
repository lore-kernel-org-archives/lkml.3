Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaCCQRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:17:39 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34156 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbaCCQRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:17:37 -0500
MIME-Version: 1.0
In-Reply-To: <1393856266.2193.18.camel@rzhang1-mobl4>
References: <1393405874-3266-1-git-send-email-rui.zhang@intel.com>
 <1393405874-3266-9-git-send-email-rui.zhang@intel.com> <1393856266.2193.18.camel@rzhang1-mobl4>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 3 Mar 2014 09:17:16 -0700
Message-ID: <CAErSpo79kE86azt-3GXE+E2AniCU1vzmQtvG66YN1wau5ams=g@mail.gmail.com>
Subject: Re: [RFC PATCH 8/8] PNPACPI: create both PNP and Platform device
 nodes for PNP0C01/PNP0C02
To: Zhang Rui <rui.zhang@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 7:17 AM, Zhang Rui <rui.zhang@intel.com> wrote:
> Hi, Bjorn,
>
> do you have comments for this particular patch?

Nope, I'm not paying attention to this area any more.

> On Wed, 2014-02-26 at 17:11 +0800, Zhang Rui wrote:
>> ACPI devices with id "PNP0C01/PNP0C02" means that we need to
>> protect their resources from being allocated by others.
>>
>> Currently, this is done in drivers/pnp/system.c.
>>
>> But the problem is that, there are some devices with extra ids besides
>> PNP0C01/PNP0C02, and for these devices,
>> 1) PNP0C01/PNP0C02 suggest that resource reservation is still needed.
>> 2) the other ids suggest that we should enumerate them to platform bus
>>
>> To reserve resources for those devices, we should either use the current code
>> by exporting the device to PNP bus, or introduce resource reservation support
>> in platform bus/ACPI.
>>
>> This patch follows the first way by enumerating an ACPI device to platform bus
>> AND pnp bus at the same time.
>> Its PNP device node will be probed by drivers/pnp/system.c and do
>> everything as we do today.
>> Its platform device node will also be created so that a platform bus
>> driver can be probed.
>>
>> The advantage is that, it brings little change to the current code,
>> the patch itself looks safe and clear.
>> The disadvantage is that
>> 1) we create two physical device nodes for the same ACPI node,
>>    this is against our effort that has been doing recently.
>> 2) we still depend on PNP bus to do this (resouce reservation) for us,
>>    which is still a problem we need to fix sooner or later.
>>
>> An alternative proposal is to remove the depedency of PNP bus and
>> do resource management in ACPI for all PNP0C01/PNP0C02 devices instead,
>> no matter what bus they are enumerated to.
>> To do this, we need to
>> 1) introduce a fs_initcall() in ACPI, to reserve all PNP0C01/PNP0C02 resources
>> in ACPI, something like we did via drivers/acpi/motherboard.c before
>> (but the code needs to follow drivers/pnp/quirks.c and system.c strictly).
>> This initcall will be run after PCI claiming BARs and before PCI assigning
>> resources for uninitialized devices.
>> 2) skip drivers/pnp/quirks.c and drivers/pnp/system.c for ACPI
>>    enumerted PNP devices, by checking pnp_device->protocal.
>> 3) remove PNP0C01/PNP0C02 from PNPACPI white list.
>>
>> By doing this, we can remove the depedency of PNP bus, but this requires
>> a lot of code duplication(need to copy quirks.c and system.c logic into ACPI),
>> which does not look good neither.
>>
>> Any comments will be appreciated.
>>
>> Signed-off-by: Zhang Rui <rui.zhang@intel.com>
>> ---
>>  drivers/pnp/pnpacpi/core.c |   20 ++++++++++++++++----
>>  1 file changed, 16 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
>> index 739fa24..5b13600 100644
>> --- a/drivers/pnp/pnpacpi/core.c
>> +++ b/drivers/pnp/pnpacpi/core.c
>> @@ -173,9 +173,6 @@ static const struct acpi_device_id acpi_pnp_device_ids[]= {
>>       {"FUJ02bf"},
>>       {"FUJ02B1"},
>>       {"FUJ02E3"},
>> -     /* system */
>> -     {"PNP0c02"}, /* General ID for reserving resources */
>> -     {"PNP0c01"}, /* memory controller */
>>       /* c6xdigio */
>>          {"PNP0400"}, /* Standard LPT Printer Port */
>>          {"PNP0401"}, /* ECP Printer Port */
>> @@ -677,6 +674,20 @@ static int is_cmos_rtc_device(struct acpi_device *adev)
>>       return !acpi_match_device_ids(adev, ids);
>>  }
>>
>> +/*
>> + * For devices with id "PNP0C01"/"PNP0C02", they will be enumerated
>> + * to PNP bus anyway to do resource reservation.
>> + */
>> +static int is_system_device(struct acpi_device *adev)
>> +{
>> +     struct acpi_device_id ids[] = {
>> +             {"PNP0C02"},
>> +             {"PNP0C01"},
>> +             {""},
>> +     };
>> +     return !acpi_match_device_ids(adev, ids);
>> +}
>> +
>>  static acpi_status __init pnpacpi_add_device_handler(acpi_handle handle,
>>                                                    u32 lvl, void *context,
>>                                                    void **rv)
>> @@ -685,7 +696,8 @@ static acpi_status __init pnpacpi_add_device_handler(acpi_handle handle,
>>
>>       if (acpi_bus_get_device(handle, &device))
>>               return AE_CTRL_DEPTH;
>> -     if (device->handler == &pnpacpi_handler || is_cmos_rtc_device(device))
>> +     if (device->handler == &pnpacpi_handler || is_system_device(device) ||
>> +         is_cmos_rtc_device(device))
>>               pnpacpi_add_device(device);
>>       return AE_OK;
>>  }
>
>
