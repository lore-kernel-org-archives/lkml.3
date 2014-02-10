Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788AbaBJHJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 02:09:40 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:59323 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaBJHJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 02:09:37 -0500
Message-ID: <52F87B1D.7090401@linaro.org>
Date: Mon, 10 Feb 2014 15:09:17 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Lan Tianyu <lantianyu1986@gmail.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>,
        linaro-acpi <linaro-acpi@lists.linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>
Subject: Re: [PATCH v2 2/3] ACPI / processor_core: Rework _PDC related stuff
 to make it more arch-independent
References: <1391865018-3446-1-git-send-email-hanjun.guo@linaro.org> <1391865018-3446-3-git-send-email-hanjun.guo@linaro.org> <CAOLK0pxxF+3e3gzgfSYuz+R8+n6hnB9rrCpzxdGNJPyHQ4xS5w@mail.gmail.com>
In-Reply-To: <CAOLK0pxxF+3e3gzgfSYuz+R8+n6hnB9rrCpzxdGNJPyHQ4xS5w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tianyu,

On 2014年02月10日 10:21, Lan Tianyu wrote:
> 2014-02-08 21:10 GMT+08:00 Hanjun Guo <hanjun.guo@linaro.org>:
>> _PDC related stuff in processor_core.c is little bit X86/IA64 dependent,
>> rework the code to make it more arch-independent, no functional change
>> in this patch.
>>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
>> ---
>>   arch/ia64/include/asm/acpi.h  |    5 +----
>>   arch/ia64/kernel/acpi.c       |   17 +++++++++++++++++
>>   arch/x86/include/asm/acpi.h   |   19 +------------------
>>   arch/x86/kernel/acpi/cstate.c |   31 +++++++++++++++++++++++++++++++
>>   drivers/acpi/processor_core.c |   19 +------------------
>>   5 files changed, 51 insertions(+), 40 deletions(-)
>>
>> diff --git a/arch/ia64/include/asm/acpi.h b/arch/ia64/include/asm/acpi.h
>> index d651102..d2b8b9d 100644
>> --- a/arch/ia64/include/asm/acpi.h
>> +++ b/arch/ia64/include/asm/acpi.h
>> @@ -152,10 +152,7 @@ extern int __initdata nid_to_pxm_map[MAX_NUMNODES];
>>   #endif
>>
>>   static inline bool arch_has_acpi_pdc(void) { return true; }
>> -static inline void arch_acpi_set_pdc_bits(u32 *buf)
>> -{
>> -       buf[2] |= ACPI_PDC_EST_CAPABILITY_SMP;
>> -}
>> +extern void arch_acpi_set_pdc_bits(u32 *buf);
>>
>>   #define acpi_unlazy_tlb(x)
>>
>> diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
>> index 07d209c..d71f64a 100644
>> --- a/arch/ia64/kernel/acpi.c
>> +++ b/arch/ia64/kernel/acpi.c
>> @@ -1014,3 +1014,20 @@ EXPORT_SYMBOL(acpi_unregister_ioapic);
>>    * TBD when when IA64 starts to support suspend...
>>    */
>>   int acpi_suspend_lowlevel(void) { return 0; }
>> +
>> +void arch_acpi_set_pdc_bits(u32 *buf)
>> +{
>> +       /* Enable coordination with firmware's _TSD info */
>> +       buf[2] |= ACPI_PDC_SMP_T_SWCOORD;
> Hi Hanjun:
>              You can write like this.
>              buf[2] |= ACPI_PDC_SMP_T_SWCOORD | ACPI_PDC_EST_CAPABILITY_SMP;

Thanks for the suggestion, will update it.

>
>> +       if (boot_option_idle_override == IDLE_NOMWAIT) {
>> +               /*
>> +                * If mwait is disabled for CPU C-states, the C2C3_FFH access
>> +                * mode will be disabled in the parameter of _PDC object.
>> +                * Of course C1_FFH access mode will also be disabled.
>> +                */
>> +               buf[2] &= ~(ACPI_PDC_C_C2C3_FFH | ACPI_PDC_C_C1_FFH);
>> +
>> +       }
>> +
>> +       buf[2] |= ACPI_PDC_EST_CAPABILITY_SMP;
>> +}
>> diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
>> index c8c1e70..e9f71bc 100644
>> --- a/arch/x86/include/asm/acpi.h
>> +++ b/arch/x86/include/asm/acpi.h
>> @@ -147,24 +147,7 @@ static inline bool arch_has_acpi_pdc(void)
>>                  c->x86_vendor == X86_VENDOR_CENTAUR);
>>   }
>>
>> -static inline void arch_acpi_set_pdc_bits(u32 *buf)
>> -{
>> -       struct cpuinfo_x86 *c = &cpu_data(0);
>> -
>> -       buf[2] |= ACPI_PDC_C_CAPABILITY_SMP;
>> -
>> -       if (cpu_has(c, X86_FEATURE_EST))
>> -               buf[2] |= ACPI_PDC_EST_CAPABILITY_SWSMP;
>> -
>> -       if (cpu_has(c, X86_FEATURE_ACPI))
>> -               buf[2] |= ACPI_PDC_T_FFH;
>> -
>> -       /*
>> -        * If mwait/monitor is unsupported, C2/C3_FFH will be disabled
>> -        */
>> -       if (!cpu_has(c, X86_FEATURE_MWAIT))
>> -               buf[2] &= ~(ACPI_PDC_C_C2C3_FFH);
>> -}
>> +extern void arch_acpi_set_pdc_bits(u32 *buf);
>>
>>   #else /* !CONFIG_ACPI */
>>
>> diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
>> index e69182f..aa9aed9 100644
>> --- a/arch/x86/kernel/acpi/cstate.c
>> +++ b/arch/x86/kernel/acpi/cstate.c
>> @@ -16,6 +16,37 @@
>>   #include <asm/mwait.h>
>>   #include <asm/special_insns.h>
>>
>> +void arch_acpi_set_pdc_bits(u32 *buf)
>> +{
>> +       struct cpuinfo_x86 *c = &cpu_data(0);
>> +
>> +       /* Enable coordination with firmware's _TSD info */
>> +       buf[2] |= ACPI_PDC_SMP_T_SWCOORD;
>> +       if (boot_option_idle_override == IDLE_NOMWAIT) {
>> +               /*
>> +                * If mwait is disabled for CPU C-states, the C2C3_FFH access
>> +                * mode will be disabled in the parameter of _PDC object.
>> +                * Of course C1_FFH access mode will also be disabled.
>> +                */
>> +               buf[2] &= ~(ACPI_PDC_C_C2C3_FFH | ACPI_PDC_C_C1_FFH);
>> +
>> +       }
>> +
>> +       buf[2] |= ACPI_PDC_C_CAPABILITY_SMP;
> This is not right. ACPI_PDC_C_CAPABILITY_SMP contians ACPI_PDC_C_C1_FFH and
> ACPI_PDC_C_C2C3_FFH. boot_option_idle_override is meaningless here.
>
> You should keep original order and put the check at last.

Good catch! I will update this patch, thanks for your review :)

Best regards
Hanjun
