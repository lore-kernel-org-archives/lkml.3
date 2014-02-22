Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaBVKVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 05:21:30 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:51173 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbaBVKV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 05:21:26 -0500
Message-ID: <53087A0F.6010302@linaro.org>
Date: Sat, 22 Feb 2014 18:21:03 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sudeep Holla <Sudeep.Holla@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lan Tianyu <tianyu.lan@intel.com>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Joe Perches <joe@perches.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>
Subject: Re: [PATCH v5 3/5] ACPI / processor: Introduce map_gic_id() to get
 apic id from MADT or _MAT method
References: <1392740638-2479-1-git-send-email-hanjun.guo@linaro.org> <1392740638-2479-4-git-send-email-hanjun.guo@linaro.org> <5304C0C4.3080601@arm.com> <53057DA9.3010307@linaro.org> <5307487F.6000308@arm.com>
In-Reply-To: <5307487F.6000308@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-2-21 20:37, Sudeep Holla wrote:
> Hi Hanjun,
> 
> (Adding MarcZ for his views on GIC)
> 
> On 20/02/14 03:59, Hanjun Guo wrote:
>> Hi Sudeep,
>>
>> Thanks for your comments, please refer to the replies below. :)
>>
>> On 2014年02月19日 22:33, Sudeep Holla wrote:
>>> Hi Hanjun,
>>>
>>> On 18/02/14 16:23, Hanjun Guo wrote:
>>>> Get apic id from MADT or _MAT method is not implemented on arm/arm64,
>>>> and ACPI 5.0 introduces GIC Structure for it, so this patch introduces
>>>> map_gic_id() to get apic id followed the ACPI 5.0 spec.
>>>>
>>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>>>> ---
>>>>   drivers/acpi/processor_core.c |   26 ++++++++++++++++++++++++++
>>>>   1 file changed, 26 insertions(+)
>>>>
>>>> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
>>>> index 4dcf776..d316d9b 100644
>>>> --- a/drivers/acpi/processor_core.c
>>>> +++ b/drivers/acpi/processor_core.c
>>>> @@ -71,6 +71,27 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
>>>>   	return 0;
>>>>   }
>>>>   
>>>> +static int map_gic_id(struct acpi_subtable_header *entry,
>>>> +		int device_declaration, u32 acpi_id, int *apic_id)
>>>> +{
>>>> +	struct acpi_madt_generic_interrupt *gic =
>>>> +		(struct acpi_madt_generic_interrupt *)entry;
>>>> +
>>>> +	if (!(gic->flags & ACPI_MADT_ENABLED))
>>>> +		return -ENODEV;
>>>> +
>>>> +	/* In the GIC interrupt model, logical processors are
>>>> +	 * required to have a Processor Device object in the DSDT,
>>>> +	 * so we should check device_declaration here
>>>> +	 */
>>>> +	if (device_declaration && (gic->uid == acpi_id)) {
>>>> +		*apic_id = gic->gic_id;
>>> I have mentioned this earlier, it's not clear yet to me how does this work ?
>>> It needs more clarity in the form of comment here at-least as the ACPIv5.0 is
>>> also not so clear or explicit on how to handle this.
>>
>> Yes, I noticed your comments and had a reply for that, after a
>> long consideration for this, I would withdraw my previous comments
>> before, please refer to the comments below.
>>
>>>
>>> Here you are expecting gic->uid = acpi_id which is fine, while acpi_map_cpuid
>>> matches apic_id with cpu_physical_id(which must be MPIDR in ARM{32,64}). The
>>> latter imposes restriction that gic->gic_id has to be MPIDR. Does that mean we
>>> are imposing restriction on GIC ID to be MPIDR ? If so please document it here
>>> and please explain the reason behind that choice.
>>
>> On x86 and IA64, APIC/SAPIC ID is the hardware id of the logical
>> processor, and UID is just a unique ID to identify the processor in DSDT, it
>> can be any value, and even can be strings defined in ASL if I remember
>> that correctly.
>>
> OK, but that's not the case on ARM{32,64}. My main concern here is if we don't
> make this definitions clear enough, the vendors might produce ACPI tables with
> whatever suits them and we may end up supporting them. Since we are starting
> with clean slate, we can avoid getting into such situations. I will be to be
> more elaborate this time.

I agree.

> 
> The GIC ID is referred as the local GIC’s hardware ID in ACPIv5.0.
> IIUC, since GICC is per-cpu entry, it has to GIC CPU interface ID.
> 
> Now how does it differ from MPIDR ? e.g. ARM TC2(multi cluster system)
> 	GIC ID		MPIDR			Comment
> 	0		0x000			CA15_0
> 	1		0x001			CA15_1
> 	2		0x100			CA7_0
> 	3		0x101			CA7_1
> 	4		0x102			CA7_2

Yes, obvious different. I know GIC ID can matche the bit index of the associated processor
in the distributor's GICD_ITARGETSR register, and it a clear statement in GICv1/GICv2, my
question is that is this consistent in GICv3/v4 too? this will have some impact on the
code implementation.

> 
>> The processor driver also follows that guidance now, and GIC structure 
>> in MADT
>> actually represents a processor (GICC) in the system, so I would let
>> gic->gic_id as MPIDR(processor hardware ID) for now to avoid confusions
>> and keep consistency with current ACPI driver.
>>
> 
> Yes that's my worry "... so I would let gic->gic_id as MPIDR(processor hardware
> ID)" as it contradicts the definition.
> 
> 1. Yes today GIC CPU ID is enumerated in the code and we don't need it, but
>    that doesn't mean the GICC contain whatever(of vendor choice). IMO it should
>    be CPU interface ID as per the definition.
> 
> 2. It's better you post this patch as part of ARM64 port for easier
>    understanding on how this gets used as its ARM specific anyway.
>    That gives better/complete picture at least for review purposes.

It make sense to me, since Rafael had dropped this patch, I will resend
it in ARM64 ACPI core patche set.

> 
>> UID can be any value and it depends on implementation, so it can be MPIDR
>> also, it will not conflict with GIC ID and can works fine in acpi processor
>> driver now.
>>
> 
> Agreed UID can be anything, but your initial ARM64 APCI patches were assuming it
> to be MPIDR. Since MPIDR is not specified anywhere else in the ACPI tables and
> it is required for some boot methods like PSCI and may be others, I am for
> mandating _UID in processor object to be MPIDR. If you agree please make it
> explicit in the comments.
> 
>>>
>>> I would expect _UID to be MPIDR rather than GIC ID but you may have some reasons
>>> for this choice.
>>
>> I think they both can be MPIDR for now, is this ok to you?
>>
> 
> Yes for _UID and no for GIC ID, they need to represent the hardware. We can see
> how to manage in this in ACPI. Initially I went by the name "cpu_physical_id"
> in acpi_map_cpuid but it looks like it's cpuid->apicid mapping on x86. So that
> should not be problem.

Yes, from the ACPI side, it is ok. but we still need the mappings from logical
processor id to MPIDR value for SMP initialization, just as cpu_logical_map()
in ARM64 did, so I will address your comments and figure out a better solution.

> 
>> we can update the code when the new ACPI spec is coming out if there
>> is a clear explanation for GIC ID and UID in GIC structures, does this make
>> sense to you?
> 
> Yes, that's for next version of ACPI but we don't know that yet. IIUC you are
> trying to implement ACPI port for ARM64 based on ACPIv5.0 through these patches
> right ? Hence I pushing you to be more explicit through comments as ACPIv5.0 is
> not clear enough.

I agree. I will resend this patch as part of ARM64 ACPI core patch set (it is still
need some time though), please help me to review the code and let's discuss it at
that time, is that make sense to you?

Thanks
Hanjun

