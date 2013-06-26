Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab3FZPDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:03:09 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:58559 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3FZPDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:03:05 -0400
MIME-Version: 1.0
In-Reply-To: <51CB19C602000078000E0D75@nat28.tlf.novell.com>
References: <1372255575-29567-1-git-send-email-benjamin.guthro@citrix.com>
	<1372255575-29567-2-git-send-email-benjamin.guthro@citrix.com>
	<51CB19C602000078000E0D75@nat28.tlf.novell.com>
Date: Wed, 26 Jun 2013 11:03:04 -0400
X-Google-Sender-Auth: zBQB1Q_hQqrJ86mm0MFA0rSBmv0
Message-ID: <CAOvdn6V0TJRF6r_2=CETPsiqawMpKxos+rCn8+aQ+SqU2p1WiQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] acpi: Call acpi_os_prepare_sleep hook in reduced
 hardware sleep path
From: Ben Guthro <benjamin.guthro@citrix.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ben Guthro <benjamin.guthro@citrix.com>,
        Bob Moore <robert.moore@intel.com>, xen-devel@lists.xen.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafaell J . Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 10:41 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>>> On 26.06.13 at 16:06, Ben Guthro <benjamin.guthro@citrix.com> wrote:
>> In version 3.4 acpi_os_prepare_sleep() got introduced in parallel with
>> reduced hardware sleep support, and the two changes didn't get
>> synchronized: The new code doesn't call the hook function (if so
>> requested). Fix this, requiring a parameter to be added to the
>> hook function to distinguish "extended" from "legacy" sleep.
>>
>> Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>
> I think these are intended to reflect the flow of things, so
> should be reversed (also in the other patches).
>
>> --- a/drivers/acpi/acpica/hwesleep.c
>> +++ b/drivers/acpi/acpica/hwesleep.c
>> @@ -43,6 +43,7 @@
>>   */
>>
>>  #include <acpi/acpi.h>
>> +#include <linux/acpi.h>
>
> This also got complaints, so I'd be very surprised if they took it now.

I did see these complaints in the last version.
However, the file drivers/acpi/acpica/hwsleep.c contains this include,
and has since

commit 09f98a825a821f7a3f1b162f9ed023f37213a63b
Author: Tang Liang <liang.tang@oracle.com>
Date:   Fri Dec 9 10:05:54 2011 +0800

So since this is the extended sleep file, vs the standard one - I
don't see why such a restriction would be placed on the former, but
not the latter.

I would look for some guidance here from the ACPI guys, for how to handle this.

>
>>  #include "accommon.h"
>>
>>  #define _COMPONENT          ACPI_HARDWARE
>> @@ -128,6 +129,13 @@ acpi_status acpi_hw_extended_sleep(u8 sleep_state)
>>
>>       ACPI_FLUSH_CPU_CACHE();
>>
>> +     status = acpi_os_prepare_sleep(sleep_state, acpi_gbl_sleep_type_a,
>> +                                    acpi_gbl_sleep_type_b, true);
>
> Without using "bool", using "true" and "false" is wrong (should
> be TRUE and FALSE afaict).

Thanks, I overlooked that.
I'll fix it for the next version.

>
>> --- a/drivers/acpi/acpica/hwsleep.c
>> +++ b/drivers/acpi/acpica/hwsleep.c
>> @@ -153,7 +153,7 @@ acpi_status acpi_hw_legacy_sleep(u8 sleep_state)
>>       ACPI_FLUSH_CPU_CACHE();
>>
>>       status = acpi_os_prepare_sleep(sleep_state, pm1a_control,
>> -                                    pm1b_control);
>> +                                    pm1b_control, false);
>
> Same here.
ack.

>
>>       if (ACPI_SKIP(status))
>>               return_ACPI_STATUS(AE_OK);
>>       if (ACPI_FAILURE(status))
>
> And the split point ought to be here - everything below doesn't
> modify ACPI CA code. Which in particular means that ...

OK.

>
>> --- a/include/linux/acpi.h
>> +++ b/include/linux/acpi.h
>> @@ -477,11 +477,11 @@ static inline bool acpi_driver_match_device(struct device *dev,
>>  #endif       /* !CONFIG_ACPI */
>>
>>  #ifdef CONFIG_ACPI
>> -void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
>> -                            u32 pm1a_ctrl,  u32 pm1b_ctrl));
>> +void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state, u32 val_a,
>> +                                        u32 val_b, u8 extended));
>>
>> -acpi_status acpi_os_prepare_sleep(u8 sleep_state,
>> -                               u32 pm1a_control, u32 pm1b_control);
>> +acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 val_a, u32 val_b,
>> +                               u8 extended);
>
> ... this needs to be moved elsewhere (under include/acpi/), but the
> two incarnations of acpi_os_set_prepare_sleep() should presumably
> remain here.

If my comment above about hwsleep.c holds, would this be necessary?

Thanks for the review.

Ben

>
> Jan
>
>>  #ifdef CONFIG_X86
>>  void arch_reserve_mem_area(acpi_physical_address addr, size_t size);
>>  #else
>> @@ -491,7 +491,7 @@ static inline void arch_reserve_mem_area(acpi_physical_address addr,
>>  }
>>  #endif /* CONFIG_X86 */
>>  #else
>> -#define acpi_os_set_prepare_sleep(func, pm1a_ctrl, pm1b_ctrl) do { } while (0)
>> +#define acpi_os_set_prepare_sleep(func, val_a, val_b, ext) do { } while (0)
>>  #endif
>>
>>  #if defined(CONFIG_ACPI) && defined(CONFIG_PM_RUNTIME)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
