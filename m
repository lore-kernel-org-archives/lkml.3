Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaBTD7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 22:59:48 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:60224 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaBTD7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 22:59:45 -0500
Message-ID: <53057DA9.3010307@linaro.org>
Date: Thu, 20 Feb 2014 11:59:37 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sudeep Holla <Sudeep.Holla@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lan Tianyu <tianyu.lan@intel.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 3/5] ACPI / processor: Introduce map_gic_id() to get
 apic id from MADT or _MAT method
References: <1392740638-2479-1-git-send-email-hanjun.guo@linaro.org> <1392740638-2479-4-git-send-email-hanjun.guo@linaro.org> <5304C0C4.3080601@arm.com>
In-Reply-To: <5304C0C4.3080601@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sudeep,

Thanks for your comments, please refer to the replies below. :)

On 2014年02月19日 22:33, Sudeep Holla wrote:
> Hi Hanjun,
>
> On 18/02/14 16:23, Hanjun Guo wrote:
>> Get apic id from MADT or _MAT method is not implemented on arm/arm64,
>> and ACPI 5.0 introduces GIC Structure for it, so this patch introduces
>> map_gic_id() to get apic id followed the ACPI 5.0 spec.
>>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>   drivers/acpi/processor_core.c |   26 ++++++++++++++++++++++++++
>>   1 file changed, 26 insertions(+)
>>
>> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
>> index 4dcf776..d316d9b 100644
>> --- a/drivers/acpi/processor_core.c
>> +++ b/drivers/acpi/processor_core.c
>> @@ -71,6 +71,27 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
>>   	return 0;
>>   }
>>   
>> +static int map_gic_id(struct acpi_subtable_header *entry,
>> +		int device_declaration, u32 acpi_id, int *apic_id)
>> +{
>> +	struct acpi_madt_generic_interrupt *gic =
>> +		(struct acpi_madt_generic_interrupt *)entry;
>> +
>> +	if (!(gic->flags & ACPI_MADT_ENABLED))
>> +		return -ENODEV;
>> +
>> +	/* In the GIC interrupt model, logical processors are
>> +	 * required to have a Processor Device object in the DSDT,
>> +	 * so we should check device_declaration here
>> +	 */
>> +	if (device_declaration && (gic->uid == acpi_id)) {
>> +		*apic_id = gic->gic_id;
> I have mentioned this earlier, it's not clear yet to me how does this work ?
> It needs more clarity in the form of comment here at-least as the ACPIv5.0 is
> also not so clear or explicit on how to handle this.

Yes, I noticed your comments and had a reply for that, after a
long consideration for this, I would withdraw my previous comments
before, please refer to the comments below.

>
> Here you are expecting gic->uid = acpi_id which is fine, while acpi_map_cpuid
> matches apic_id with cpu_physical_id(which must be MPIDR in ARM{32,64}). The
> latter imposes restriction that gic->gic_id has to be MPIDR. Does that mean we
> are imposing restriction on GIC ID to be MPIDR ? If so please document it here
> and please explain the reason behind that choice.

On x86 and IA64, APIC/SAPIC ID is the hardware id of the logical
processor, and UID is just a unique ID to identify the processor in DSDT, it
can be any value, and even can be strings defined in ASL if I remember
that correctly.

The processor driver also follows that guidance now, and GIC structure 
in MADT
actually represents a processor (GICC) in the system, so I would let
gic->gic_id as MPIDR(processor hardware ID) for now to avoid confusions
and keep consistency with current ACPI driver.

UID can be any value and it depends on implementation, so it can be MPIDR
also, it will not conflict with GIC ID and can works fine in acpi processor
driver now.

>
> I would expect _UID to be MPIDR rather than GIC ID but you may have some reasons
> for this choice.

I think they both can be MPIDR for now, is this ok to you?

we can update the code when the new ACPI spec is coming out if there
is a clear explanation for GIC ID and UID in GIC structures, does this make
sense to you?

Thanks
Hanjun
