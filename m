Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3F1QPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:15:53 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:26092 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab3F1QPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:15:52 -0400
X-IronPort-AV: E=Sophos;i="4.87,958,1363132800"; 
   d="scan'208";a="32494760"
Message-ID: <51CDB6B6.1050704@citrix.com>
Date: Fri, 28 Jun 2013 12:15:50 -0400
From: Ben Guthro <Benjamin.Guthro@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jan Beulich <jbeulich@suse.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <xen-devel@lists.xen.org>, Bob Moore <robert.moore@intel.com>
Subject: Re: [PATCH v5 3/5] acpi: Adjust linux acpi OS functions to new extended
 parameter
References: <1372427184-6197-1-git-send-email-benjamin.guthro@citrix.com> <1372427184-6197-4-git-send-email-benjamin.guthro@citrix.com> <20130628160357.GB13468@phenom.dumpdata.com>
In-Reply-To: <20130628160357.GB13468@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.204.241.11]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/28/2013 12:03 PM, Konrad Rzeszutek Wilk wrote:
> On Fri, Jun 28, 2013 at 09:46:22AM -0400, Ben Guthro wrote:
>> Change the function definitions of acpi_os_prepare_sleep() and
>> acpi_os_set_prepare_sleep() to pass along the new extended sleep
>> parameter.
>>
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>> Signed-off-by: Ben Guthro <benjamin.guthro@citrix.com>
>> Cc: Bob Moore <robert.moore@intel.com>
>> Cc: Rafael J. Wysocki <rjw@sisk.pl>
>> Cc: linux-acpi@vger.kernel.org
>> ---
>>   arch/x86/kernel/tboot.c |    3 ++-
>>   drivers/acpi/osl.c      |   16 ++++++++--------
>>   drivers/xen/acpi.c      |    3 ++-
>>   include/linux/acpi.h    |    6 +++---
>>   include/xen/acpi.h      |    3 ++-
>
> Since they touch the Xen files, please also include
>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>
> thought you should rebase this on top of Rafael's linux-next
> as it won't apply cleanly on top v3.10-rc7.

Actually, it does apply cleanly on top of v3.10-rc7.

However, I'll pull Rafael's linux-next, and rebase on that.

>
>
>>   5 files changed, 17 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
>> index f84fe00..d578c9c 100644
>> --- a/arch/x86/kernel/tboot.c
>> +++ b/arch/x86/kernel/tboot.c
>> @@ -273,7 +273,8 @@ static void tboot_copy_fadt(const struct acpi_table_fadt *fadt)
>>   		offsetof(struct acpi_table_facs, firmware_waking_vector);
>>   }
>>
>> -static int tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
>> +static int tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control,
>> +		       bool extended)
>>   {
>>   	static u32 acpi_shutdown_map[ACPI_S_STATE_COUNT] = {
>>   		/* S0,1,2: */ -1, -1, -1,
>> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
>> index e721863..0251c9b 100644
>> --- a/drivers/acpi/osl.c
>> +++ b/drivers/acpi/osl.c
>> @@ -77,8 +77,8 @@ EXPORT_SYMBOL(acpi_in_debugger);
>>   extern char line_buf[80];
>>   #endif				/*ENABLE_DEBUGGER */
>>
>> -static int (*__acpi_os_prepare_sleep)(u8 sleep_state, u32 pm1a_ctrl,
>> -				      u32 pm1b_ctrl);
>> +static int (*__acpi_os_prepare_sleep)(u8 sleep_state, u32 val_a, u32 val_b,
>> +				      bool extended);
>>
>>   static acpi_osd_handler acpi_irq_handler;
>>   static void *acpi_irq_context;
>> @@ -1757,13 +1757,13 @@ acpi_status acpi_os_terminate(void)
>>   	return AE_OK;
>>   }
>>
>> -acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 pm1a_control,
>> -				  u32 pm1b_control)
>> +acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 val_a, u32 val_b,
>> +				  u8 extended)
>>   {
>>   	int rc = 0;
>>   	if (__acpi_os_prepare_sleep)
>> -		rc = __acpi_os_prepare_sleep(sleep_state,
>> -					     pm1a_control, pm1b_control);
>> +		rc = __acpi_os_prepare_sleep(sleep_state, val_a, val_b,
>> +					     extended);
>>   	if (rc < 0)
>>   		return AE_ERROR;
>>   	else if (rc > 0)
>> @@ -1772,8 +1772,8 @@ acpi_status acpi_os_prepare_sleep(u8 sleep_state, u32 pm1a_control,
>>   	return AE_OK;
>>   }
>>
>> -void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
>> -			       u32 pm1a_ctrl, u32 pm1b_ctrl))
>> +void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state, u32 val_a,
>> +			       u32 val_b, bool extended))
>>   {
>>   	__acpi_os_prepare_sleep = func;
>>   }
>> diff --git a/drivers/xen/acpi.c b/drivers/xen/acpi.c
>> index 119d42a..36d2be1 100644
>> --- a/drivers/xen/acpi.c
>> +++ b/drivers/xen/acpi.c
>> @@ -36,7 +36,8 @@
>>   #include <asm/xen/hypervisor.h>
>>
>>   int xen_acpi_notify_hypervisor_state(u8 sleep_state,
>> -				     u32 pm1a_cnt, u32 pm1b_cnt)
>> +				     u32 pm1a_cnt, u32 pm1b_cnt,
>> +				     bool extended)
>>   {
>>   	struct xen_platform_op op = {
>>   		.cmd = XENPF_enter_acpi_sleep,
>> diff --git a/include/linux/acpi.h b/include/linux/acpi.h
>> index 709a2f2..26f9996 100644
>> --- a/include/linux/acpi.h
>> +++ b/include/linux/acpi.h
>> @@ -477,8 +477,8 @@ static inline bool acpi_driver_match_device(struct device *dev,
>>   #endif	/* !CONFIG_ACPI */
>>
>>   #ifdef CONFIG_ACPI
>> -void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
>> -			       u32 pm1a_ctrl,  u32 pm1b_ctrl));
>> +void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state, u32 val_a,
>> +			       u32 val_b, bool extended));
>>   #ifdef CONFIG_X86
>>   void arch_reserve_mem_area(acpi_physical_address addr, size_t size);
>>   #else
>> @@ -488,7 +488,7 @@ static inline void arch_reserve_mem_area(acpi_physical_address addr,
>>   }
>>   #endif /* CONFIG_X86 */
>>   #else
>> -#define acpi_os_set_prepare_sleep(func, pm1a_ctrl, pm1b_ctrl) do { } while (0)
>> +#define acpi_os_set_prepare_sleep(func, val_a, val_b, ext) do { } while (0)
>>   #endif
>>
>>   #if defined(CONFIG_ACPI) && defined(CONFIG_PM_RUNTIME)
>> diff --git a/include/xen/acpi.h b/include/xen/acpi.h
>> index 68d73d0..9f7e2e6 100644
>> --- a/include/xen/acpi.h
>> +++ b/include/xen/acpi.h
>> @@ -76,7 +76,8 @@ static inline int xen_acpi_get_pxm(acpi_handle h)
>>   }
>>
>>   int xen_acpi_notify_hypervisor_state(u8 sleep_state,
>> -				     u32 pm1a_cnt, u32 pm1b_cnd);
>> +				     u32 pm1a_cnt, u32 pm1b_cnd,
>> +				     bool extended);
>>
>>   static inline void xen_acpi_sleep_register(void)
>>   {
>> --
>> 1.7.9.5
>>
