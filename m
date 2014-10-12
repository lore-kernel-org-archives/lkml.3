Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaJLTfi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 15:35:38 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:47462 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbaJLTff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 15:35:35 -0400
Message-ID: <543AD7FA.5060706@roeck-us.net>
Date: Sun, 12 Oct 2014 12:35:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 1/2] acpi: Use syscore instead of pm_power_off_prepare
 to prepare for poweroff
References: <1413062057-11657-1-git-send-email-linux@roeck-us.net> <1413062057-11657-2-git-send-email-linux@roeck-us.net> <3090667.ydmQKSGePB@vostro.rjw.lan>
In-Reply-To: <3090667.ydmQKSGePB@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.543AD807.00AE,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2014 12:45 PM, Rafael J. Wysocki wrote:
> On Saturday, October 11, 2014 02:14:16 PM Guenter Roeck wrote:
>> The syscore shutdown callback seems to be perfectly suited to prepare for system
>> poweroff. Use it instead of pm_power_off_prepare.
>
> How much testing did that receive?
>

As I mentioned in patch 0/2, compile tested so far only. Before I start playing
with my servers, I wanted to get some feedback if the idea is worth pursuing
further or if I am missing something essential. _If_ it should be worth pursuing
I'll test it with some real systems (servers + laptops) before resubmitting,
and also add log messages for that testing to ensure that acpi_shutdown
is actually called.

Guenter

>> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
>> Cc: Len Brown <len.brown@intel.com>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>>   drivers/acpi/sleep.c | 21 ++++++++++++++++-----
>>   1 file changed, 16 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
>> index 05a31b5..e03c74d 100644
>> --- a/drivers/acpi/sleep.c
>> +++ b/drivers/acpi/sleep.c
>> @@ -17,6 +17,7 @@
>>   #include <linux/interrupt.h>
>>   #include <linux/suspend.h>
>>   #include <linux/reboot.h>
>> +#include <linux/syscore_ops.h>
>>   #include <linux/acpi.h>
>>   #include <linux/module.h>
>>   #include <asm/io.h>
>> @@ -820,13 +821,23 @@ int acpi_suspend(u32 acpi_state)
>>   	return -EINVAL;
>>   }
>>
>> -static void acpi_power_off_prepare(void)
>> +static void acpi_shutdown(void)
>>   {
>> -	/* Prepare to power off the system */
>> -	acpi_sleep_prepare(ACPI_STATE_S5);
>> -	acpi_disable_all_gpes();
>> +	switch (system_state) {
>> +	case SYSTEM_POWER_OFF:
>> +		/* Prepare to power off the system */
>> +		acpi_sleep_prepare(ACPI_STATE_S5);
>> +		acpi_disable_all_gpes();
>> +		break;
>> +	default:
>> +		break;
>> +	}
>>   }
>>
>> +static struct syscore_ops acpi_syscore_ops = {
>> +	.shutdown = acpi_shutdown,
>> +};
>> +
>>   static void acpi_power_off(void)
>>   {
>>   	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
>> @@ -850,7 +861,7 @@ int __init acpi_sleep_init(void)
>>
>>   	if (acpi_sleep_state_supported(ACPI_STATE_S5)) {
>>   		sleep_states[ACPI_STATE_S5] = 1;
>> -		pm_power_off_prepare = acpi_power_off_prepare;
>> +		register_syscore_ops(&acpi_syscore_ops);
>>   		pm_power_off = acpi_power_off;
>>   	}
>>
>>
>

