Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab3GYBTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 21:19:38 -0400
Received: from smtp.citrix.com ([66.165.176.89]:19942 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801Ab3GYBTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 21:19:34 -0400
X-IronPort-AV: E=Sophos;i="4.89,738,1367971200"; 
   d="scan'208";a="39145508"
From: Ben Guthro <Ben.Guthro@citrix.com>
To: "Zheng, Lv" <lv.zheng@intel.com>
CC: "Moore, Robert" <robert.moore@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <jbeulich@suse.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [PATCH v3 1/3] acpi: Call acpi_os_prepare_sleep hook in reduced
 hardware sleep path
Thread-Topic: [PATCH v3 1/3] acpi: Call acpi_os_prepare_sleep hook in
 reduced hardware sleep path
Thread-Index: AQHOcnZaynMmjqnGME+NOEIvSWZ+pJlRNlAAgAAXToCAIn1ogIAAGvwAgABYu4D//74uAIAAWDSAgACuBQCAAAUjgA==
Date: Thu, 25 Jul 2013 01:19:31 +0000
Message-ID: <0B4C846C-B333-492B-9DC4-8B7E07054B0F@citrix.com>
References: <1372255575-29567-1-git-send-email-benjamin.guthro@citrix.com>
 <1372255575-29567-2-git-send-email-benjamin.guthro@citrix.com>
 <1AE640813FDE7649BE1B193DEA596E880241B363@SHSMSX101.ccr.corp.intel.com>
 <51D2BCB7.5040105@citrix.com>
 <1AE640813FDE7649BE1B193DEA596E88024352D2@SHSMSX101.ccr.corp.intel.com>
 <51EFC1FE.5000609@citrix.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E36FEA87FF@ORSMSX103.amr.corp.intel.com>
 <51EFD536.8070209@citrix.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E36FEA884D@ORSMSX103.amr.corp.intel.com>
 <1AE640813FDE7649BE1B193DEA596E88024356C3@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88024356C3@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.154.239]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F8D270A50514074DA73BD1C2AA675EB7@citrix.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 24, 2013, at 9:01 PM, "Zheng, Lv" <lv.zheng@intel.com>
 wrote:

>> From: Moore, Robert
>> Sent: Wednesday, July 24, 2013 10:39 PM
>> 
>> I haven't found a high-level description of "acpi_os_prepare_sleep", perhaps I
>> missed it.
> 
> If we take a look at the declaration of this new OSL API, its name is acpi_os_prepare_sleep, but originally it only hacks two registers' values.
> It is more like a Xen only hacking logic rather than an OSL API from ACPICA's perspective.

The feature was introduced by Intel, for tboot, not Xen.
As pointed out by Konrad - If you implemented tboot on another OS, like Solaris, etc - this would be necessary.

> So the API declaration is just looking ugly to ACPICA, this has prevented this OSL API from being back ported to ACPICA for long time.
> If ACPICA merged this codes, then it could be very hard for ACPICA to do any future enhancement to modify the logic in the acpi_hw_legacy_sleep/acpi_hw_extended_sleep.
> Thus this is not clean for ACPICA, it will introduce unwanted software entropy to ACPICA.
> 
> This patchset enhances the OSL API, but doesn't make it cleaner, and just add a new parameter, it is a hack on top of the original hack.

The original hack, as you call it is abstracted away in other parts of ACPICA, in all of the acpi_os_* code, if I read it correctly.
I'm not sure what makes this any different.

> IMO, from ACPICA's perspective, the OSL API should be designed to be re-used by any other OSPMs and might have more meaningful function declaration to ACPICA.
> OSPM codes like Xen can implement this OSL API.  The Xen only hacking logic should be put inside the OSL API implementation.
> 

Again - not just for Xen.

> Hers is just a suggestion and I don't know if this can work for Xen:
> 
> status = acpi_os_prepare_sleep(u8 sleep_state);
> if (ACPI_SKIP(status))
> ...
> 
> And export:
> 1. acpi_gbl_sleep_type_a/acpi_gbl_sleep_type_b
> 2. acpi_gbl_reduced_hardware
> 3. acpi_hw_get_bit_register_info
> to be used by acpi_os_prepare_sleep.
> At least you can just copy the logic in the acpi_hw_legacy_sleep/acpi_hw_extended_sleep to the acpi_os_prepare_sleep.
> That kind of complexity is Xen's complexity, you shouldn't move this complexity to ACPICA just because you want Xen side codes to be simpler.
> If Xen and tboot already have knowledge about above what will actually happen to the "sleep_state", we don't need to export them.

I'm sorry, I don't follow you here.

I moved no complexity into ACPICA in order to make Xen simpler.
In fact, I am arguing for the simpler interface, and smaller change in ACPICA.
It merely needs to also happen in the new reduced hardware sleep path, as it is broken for existing systems...and indeed would also be broken for the tboot path.




> 
> This way might be better for both parties.
> 
> Thanks and best regards
> -Lv
> 
> 
>> 
>> Can someone point me to the overall description of this change and why it is
>> being considered?
>> 
>> Thanks,
>> Bob
>> 
>> 
>>> -----Original Message-----
>>> From: Ben Guthro [mailto:Benjamin.Guthro@citrix.com]
>>> Sent: Wednesday, July 24, 2013 6:23 AM
>>> To: Moore, Robert
>>> Cc: Zheng, Lv; Konrad Rzeszutek Wilk; Jan Beulich; Rafael J . Wysocki;
>>> linux-kernel@vger.kernel.org; linux-acpi@vger.kernel.org; xen-
>>> devel@lists.xen.org
>>> Subject: Re: [PATCH v3 1/3] acpi: Call acpi_os_prepare_sleep hook in
>>> reduced hardware sleep path
>>> 
>>> On 07/24/2013 09:18 AM, Moore, Robert wrote:
>>>> I have not looked closely at this, but we typically do things like
>>>> this
>>> in ACPICA so that they only need to be implemented once to support all
>>> of the various acpica-hosted operating systems - linux, solaris,
>>> hp-ux, apple, freebsd, etc. -- even if they could be implemented
>>> "cleaner" in some way on any given host.
>>> 
>>> Even when the resulting "simplification" results in reduced functionality?
>>> 
>>> Maybe I am misunderstanding the suggestion...but it sounded like it
>>> was basically to mimic the traditional behavior, and mask out the
>>> reduced hardware capabilities on these system types.
>>> 
>>> It seems to me that if the system supports the reduced hardware ACPI
>>> sleep, you would want to make use of it...
>>> 
>>> 
>>> 
>>>> 
>>>> 
>>>> 
>>>>> -----Original Message-----
>>>>> From: Ben Guthro [mailto:Benjamin.Guthro@citrix.com]
>>>>> Sent: Wednesday, July 24, 2013 5:01 AM
>>>>> To: Zheng, Lv
>>>>> Cc: Konrad Rzeszutek Wilk; Jan Beulich; Rafael J . Wysocki; linux-
>>>>> kernel@vger.kernel.org; linux-acpi@vger.kernel.org; xen-
>>>>> devel@lists.xen.org; Moore, Robert
>>>>> Subject: Re: [PATCH v3 1/3] acpi: Call acpi_os_prepare_sleep hook
>>>>> in reduced hardware sleep path
>>>>> 
>>>>> 
>>>>> 
>>>>> On 07/24/2013 02:24 AM, Zheng, Lv wrote:
>>>>>> Hi,
>>>>>> 
>>>>>> Sorry for the delayed response.
>>>>>> 
>>>>>>> From: Ben Guthro [mailto:Benjamin.Guthro@citrix.com]
>>>>>>> Sent: Tuesday, July 02, 2013 7:43 PM
>>>>>>> 
>>>>>>> 
>>>>>>> On 07/02/2013 02:19 AM, Zheng, Lv wrote:
>>>>>>>> Thanks for your efforts!
>>>>>>>> 
>>>>>>>> I wonder if it is possible to remove the argument - "u8 extended"
>>>>>>>> and convert
>>>>>>> "pm1a_control, pm1b_control" into some u8 values that are
>>>>>>> equivalent to "acpi_gbl_sleep_type_a, acpi_gbl_sleep_type_b" in
>>>>>>> the legacy sleep
>>>>> path.
>>>>>>>> It can also simplify Xen codes.
>>>>>>> 
>>>>>>> Thanks for your time to review this.
>>>>>>> 
>>>>>>> I'm not sure that this simplifies things. I think that, in fact,
>>>>>>> it would make them quite a bit more complicated, but perhaps I
>>>>> misunderstand.
>>>>>>> 
>>>>>>> Is it not preferred to use the reduced hardware sleep, over the
>>>>>>> old
>>>>> method?
>>>>>>> While these register definitions may be equivalent below, doing
>>>>>>> the translation in linux, only to translate them back again at a
>>>>>>> lower
>>>>> layer seems unnecessary.
>>>>>>> 
>>>>>> 
>>>>>> Yes, it would require tboot layer to be able to be aware of how
>>>>>> such
>>>>> fields locate in the PM registers.
>>>>>> So I think you can pass the register address of the field and the
>>>>>> field
>>>>> name/value pair to the tboot, this could simplify things, no lower
>>>>> layer effort will be needed.
>>>>>> Please don't worry about the case that a register field could be
>>>>>> split
>>>>> into PM1a and PM1b, it could be a hardware design issue.
>>>>>> IMO, one field should always be in one register, either PM1a or PM1b.
>>>>>> Or there could be hardware issues cannot be addressed by the
>>>>>> ACPICA
>>>>> architecture (something like natural atomicity).
>>>>>> But maybe I'm wrong.
>>>>> 
>>>>> Again, I don't think this simplifies things, but complicates them
>>>>> unnecessarily. Converting the reduced hardware sleep to the legacy
>>>>> sleep seems like it would be an unnecessary layer of translation.
>>>>> 
>>>>> The interface now simply passes the information from ACPICA down to
>>>>> the lower layers (xen, tboot) - and then lets them worry about the
>>>>> reduced hardware implementation.
>>>>> 
>>>>> FWIW, xen has shipped with this implemetation, and enterprise
>>>>> kernels using the traditional xen kernel (like Suse) are making use of it.
>>>>> 
>>>>> It may benefit tboot, in this case, but not Xen.
>>>>> 
>>>>> I personally see it as an undesirable complication.
>>>>> 
>>>>> Best regards,
>>>>> Ben
>>>>> 
>>>>>> 
>>>>>> Thanks and best regards
>>>>>> -Lv
>>>>>> 
>>>>>>> The hypervisor knows how to deal with both the reduced hardware
>>>>>>> sleep as well as the legacy sleep path - it merely need to
>>>>>>> distinguish these two paths, when performing the hypercall.
>>>>>>> 
>>>>>>> Since there are two paths through the higher level ACPICA code -
>>>>>>> that in hwsleep.c, and hwesleep.c - there needs to be some
>>>>>>> distinction between the two paths, when calling through to the
>>>>>>> lower level
>>>>>>> acpi_os_prepare_sleep() call.
>>>>>>> 
>>>>>>> An alternate method would be to create another interface named
>>>>>>> acpi_os_prepare_esleep() which would do the equivalent of this
>>>>>>> patch series, with an "extended" parameter hidden from upper
>>>>>>> level
>>>>> interfaces.
>>>>>>> 
>>>>>>> This, however, would also add another function to
>>>>>>> include/acpi/acpiosxf.h - which, I thought was undesirable, in
>>>>>>> the impression that I got from Bob Moore, and Rafael Wysocki
>>>>>>> (though, please correct me on this point, if I have
>>>>>>> misunderstood)
>>>>>>> 
>>>>>>> Best Regards
>>>>>>> 
>>>>>>> Ben
>>>>>>> 
>>>>>>>> 
>>>>>>>> As in ACPI specification, the bit definitions between the legacy
>>>>>>>> sleep registers
>>>>>>> and the extended sleep registers are equivalent.
>>>>>>>> 
>>>>>>>> The legacy sleep register definition:
>>>>>>>> Table 4-16 PM1 Status Registers Fixed Hardware Feature Status
>>>>>>>> Bits
>>>>>>>> - WAK_STS(bit 15) Table 4-18 PM1 Control Registers Fixed
>>>>>>>> Hardware Feature Control Bits - SLP_TYPx (bit 10-12), SLP_EN
>>>>>>>> (bit 13)
>>>>>>>> 
>>>>>>>> The extended sleep register definition:
>>>>>>>> Table 4-24 Sleep Control Register - SLP_TYPx (3 bits from offset
>>>>>>>> 2), SLP_EN (1
>>>>>>> bit from offset 5), here 10-8 = 2, and 13-8 = 5, this definition
>>>>>>> is equivalent to Table 4-18.
>>>>>>>> Table 4-25 Sleep Status Register - WAK_STS (1 bit 7), 15-8 = 7,
>>>>>>>> this definition is
>>>>>>> equivalent to Table 4-16.
>>>>>>>> 
>>>>>>>> Thanks and best regards
>>>>>>>> -Lv
>>>>>>>> 
>>>>>>>>> -----Original Message-----
>>>>>>>>> From: linux-acpi-owner@vger.kernel.org
>>>>>>>>> [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Ben
>>>>>>>>> Guthro
>>>>>>>>> Sent: Wednesday, June 26, 2013 10:06 PM
>>>>>>>>> To: Konrad Rzeszutek Wilk; Jan Beulich; Rafaell J . Wysocki;
>>>>>>>>> linux-kernel@vger.kernel.org; linux-acpi@vger.kernel.org;
>>>>>>>>> xen-devel@lists.xen.org
>>>>>>>>> Cc: Ben Guthro; Moore, Robert
>>>>>>>>> Subject: [PATCH v3 1/3] acpi: Call acpi_os_prepare_sleep hook
>>>>>>>>> in reduced hardware sleep path
>>>>>>>>> 
>>>>>>>>> In version 3.4 acpi_os_prepare_sleep() got introduced in
>>>>>>>>> parallel with reduced hardware sleep support, and the two
>>>>>>>>> changes didn't get
>>>>>>>>> synchronized: The new code doesn't call the hook function (if
>>>>>>>>> so requested). Fix this, requiring a parameter to be added to
>>>>>>>>> the hook function to distinguish "extended" from "legacy" sleep.
>>>>>>>>> 
>>>>>>>>> Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
>>>>>>>>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>>>>>>>>> Cc: Bob Moore <robert.moore@intel.com>
>>>>>>>>> Cc: Rafaell J. Wysocki <rjw@sisk.pl>
>>>>>>>>> Cc: linux-acpi@vger.kernel.org
>>>>>>>>> ---
>>>>>>>>>  drivers/acpi/acpica/hwesleep.c |    8 ++++++++
>>>>>>>>>  drivers/acpi/acpica/hwsleep.c  |    2 +-
>>>>>>>>>  drivers/acpi/osl.c             |   16 ++++++++--------
>>>>>>>>>  include/linux/acpi.h           |   10 +++++-----
>>>>>>>>>  4 files changed, 22 insertions(+), 14 deletions(-)
>>>>>>>>> 
>>>>>>>>> diff --git a/drivers/acpi/acpica/hwesleep.c
>>>>>>>>> b/drivers/acpi/acpica/hwesleep.c index 5e5f762..6834dd7 100644
>>>>>>>>> --- a/drivers/acpi/acpica/hwesleep.c
>>>>>>>>> +++ b/drivers/acpi/acpica/hwesleep.c
>>>>>>>>> @@ -43,6 +43,7 @@
>>>>>>>>>   */
>>>>>>>>> 
>>>>>>>>>  #include <acpi/acpi.h>
>>>>>>>>> +#include <linux/acpi.h>
>>>>>>>>>  #include "accommon.h"
>>>>>>>>> 
>>>>>>>>>  #define _COMPONENT          ACPI_HARDWARE
>>>>>>>>> @@ -128,6 +129,13 @@ acpi_status acpi_hw_extended_sleep(u8
>>>>>>>>> sleep_state)
>>>>>>>>> 
>>>>>>>>>  	ACPI_FLUSH_CPU_CACHE();
>>>>>>>>> 
>>>>>>>>> +	status = acpi_os_prepare_sleep(sleep_state,
>>>>> acpi_gbl_sleep_type_a,
>>>>>>>>> +				       acpi_gbl_sleep_type_b, true);
>>>>>>>>> +	if (ACPI_SKIP(status))
>>>>>>>>> +		return_ACPI_STATUS(AE_OK);
>>>>>>>>> +	if (ACPI_FAILURE(status))
>>>>>>>>> +		return_ACPI_STATUS(status);
>>>>>>>>> +
>>>>>>>>>  	/*
>>>>>>>>>  	 * Set the SLP_TYP and SLP_EN bits.
>>>>>>>>>  	 *
>>>>>>>>> diff --git a/drivers/acpi/acpica/hwsleep.c
>>>>>>>>> b/drivers/acpi/acpica/hwsleep.c index e3828cc..a93c299 100644
>>>>>>>>> --- a/drivers/acpi/acpica/hwsleep.c
>>>>>>>>> +++ b/drivers/acpi/acpica/hwsleep.c
>>>>>>>>> @@ -153,7 +153,7 @@ acpi_status acpi_hw_legacy_sleep(u8
>>> sleep_state)
>>>>>>>>>  	ACPI_FLUSH_CPU_CACHE();
>>>>>>>>> 
>>>>>>>>>  	status = acpi_os_prepare_sleep(sleep_state, pm1a_control,
>>>>>>>>> -				       pm1b_control);
>>>>>>>>> +				       pm1b_control, false);
>>>>>>>>>  	if (ACPI_SKIP(status))
>>>>>>>>>  		return_ACPI_STATUS(AE_OK);
>>>>>>>>>  	if (ACPI_FAILURE(status))
>>>>>>>>> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c index
>>>>>>>>> e721863..3fc2801 100644
>>>>>>>>> --- a/drivers/acpi/osl.c
>>>>>>>>> +++ b/drivers/acpi/osl.c
>>>>>>>>> @@ -77,8 +77,8 @@ EXPORT_SYMBOL(acpi_in_debugger);
>>>>>>>>>  extern char line_buf[80];
>>>>>>>>>  #endif				/*ENABLE_DEBUGGER */
>>>>>>>>> 
>>>>>>>>> -static int (*__acpi_os_prepare_sleep)(u8 sleep_state, u32
>>> pm1a_ctrl,
>>>>>>>>> -				      u32 pm1b_ctrl);
>>>>>>>>> +static int (*__acpi_os_prepare_sleep)(u8 sleep_state, u32
>>>>>>>>> +val_a,
>>>>>>>>> +u32
>>>>>>> val_b,
>>>>>>>>> +				      u8 extended);
>>>>>>>>> 
>>>>>>>>>  static acpi_osd_handler acpi_irq_handler;
>>>>>>>>>  static void *acpi_irq_context; @@ -1757,13 +1757,13 @@
>>>>>>>>> acpi_status acpi_os_terminate(void)
>>>>>>>>>  	return AE_OK;
>>>>>>>>>  }
>>>>>>>>> 
>>>>>>>>> -acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32
>>> pm1a_control,
>>>>>>>>> -				  u32 pm1b_control)
>>>>>>>>> +acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 val_a,
>>>>>>>>> +u32
>>>>> val_b,
>>>>>>>>> +				  u8 extended)
>>>>>>>>>  {
>>>>>>>>>  	int rc = 0;
>>>>>>>>>  	if (__acpi_os_prepare_sleep)
>>>>>>>>> -		rc = __acpi_os_prepare_sleep(sleep_state,
>>>>>>>>> -					     pm1a_control, pm1b_control);
>>>>>>>>> +		rc = __acpi_os_prepare_sleep(sleep_state, val_a, val_b,
>>>>>>>>> +					     extended);
>>>>>>>>>  	if (rc < 0)
>>>>>>>>>  		return AE_ERROR;
>>>>>>>>>  	else if (rc > 0)
>>>>>>>>> @@ -1772,8 +1772,8 @@ acpi_status acpi_os_prepare_sleep(u8
>>>>>>>>> sleep_state,
>>>>>>>>> u32 pm1a_control,
>>>>>>>>>  	return AE_OK;
>>>>>>>>>  }
>>>>>>>>> 
>>>>>>>>> -void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
>>>>>>>>> -			       u32 pm1a_ctrl, u32 pm1b_ctrl))
>>>>>>>>> +void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state, u32
>>>>> val_a,
>>>>>>>>> +					   u32 val_b, u8 extended))
>>>>>>>>>  {
>>>>>>>>>  	__acpi_os_prepare_sleep = func;
>>>>>>>>>  }
>>>>>>>>> diff --git a/include/linux/acpi.h b/include/linux/acpi.h index
>>>>>>>>> 17b5b59..de99022 100644
>>>>>>>>> --- a/include/linux/acpi.h
>>>>>>>>> +++ b/include/linux/acpi.h
>>>>>>>>> @@ -477,11 +477,11 @@ static inline bool
>>>>>>>>> acpi_driver_match_device(struct device *dev,
>>>>>>>>>  #endif	/* !CONFIG_ACPI */
>>>>>>>>> 
>>>>>>>>>  #ifdef CONFIG_ACPI
>>>>>>>>> -void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
>>>>>>>>> -			       u32 pm1a_ctrl,  u32 pm1b_ctrl));
>>>>>>>>> +void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state, u32
>>>>> val_a,
>>>>>>>>> +					   u32 val_b, u8 extended));
>>>>>>>>> 
>>>>>>>>> -acpi_status acpi_os_prepare_sleep(u8 sleep_state,
>>>>>>>>> -				  u32 pm1a_control, u32 pm1b_control);
>>>>>>>>> +acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 val_a,
>>>>>>>>> +u32
>>>>> val_b,
>>>>>>>>> +				  u8 extended);
>>>>>>>>>  #ifdef CONFIG_X86
>>>>>>>>>  void arch_reserve_mem_area(acpi_physical_address addr, size_t
>>>>> size);
>>>>>>>>>  #else
>>>>>>>>> @@ -491,7 +491,7 @@ static inline void
>>>>>>>>> arch_reserve_mem_area(acpi_physical_address addr,
>>>>>>>>>  }
>>>>>>>>>  #endif /* CONFIG_X86 */
>>>>>>>>>  #else
>>>>>>>>> -#define acpi_os_set_prepare_sleep(func, pm1a_ctrl, pm1b_ctrl)
>>>>>>>>> do { } while
>>>>>>>>> (0)
>>>>>>>>> +#define acpi_os_set_prepare_sleep(func, val_a, val_b, ext) do
>>>>>>>>> +{ } while (0)
>>>>>>>>>  #endif
>>>>>>>>> 
>>>>>>>>>  #if defined(CONFIG_ACPI) && defined(CONFIG_PM_RUNTIME)
>>>>>>>>> --
>>>>>>>>> 1.7.9.5
>>>>>>>>> 
>>>>>>>>> --
>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>>> linux-
>>> acpi"
>>>>>>>>> in the body of a message to majordomo@vger.kernel.org More
>>>>>>>>> majordomo info at  http://vger.kernel.org/majordomo-info.html

