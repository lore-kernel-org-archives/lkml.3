Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaJ1CKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 22:10:37 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33856 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbaJ1CKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 22:10:35 -0400
Message-ID: <544EFB12.1090901@roeck-us.net>
Date: Mon, 27 Oct 2014 19:10:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 34/47] acpi: Register power-off handler with kernel
 power-off handler
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net> <1414425354-10359-35-git-send-email-linux@roeck-us.net> <5416859.0WlfjKo7zJ@vostro.rjw.lan>
In-Reply-To: <5416859.0WlfjKo7zJ@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.544EFB1B.005B,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
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

On 10/27/2014 05:26 PM, Rafael J. Wysocki wrote:
> On Monday, October 27, 2014 08:55:41 AM Guenter Roeck wrote:
>> Register with kernel power-off handler instead of setting pm_power_off
>> directly. Register with high priority to reflect that the driver explicitly
>> overrides existing power-off handlers.
>
> Well, I'm still rather unconvinced that notifiers are particularly suitable for
> this purpose.
>
> Specifically ->
>

Fine.

>> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
>> Cc: Len Brown <lenb@kernel.org>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> v3:
>> - Replace poweroff in all newly introduced variables and in text
>>    with power_off or power-off as appropriate
>> - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
>> - Replace acpi: with ACPI: in log message
>> v2:
>> - Use define to specify poweroff handler priority
>> - Use pr_warn instead of pr_err
>>
>>   drivers/acpi/sleep.c | 15 +++++++++++++--
>>   1 file changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
>> index 05a31b5..7875b92 100644
>> --- a/drivers/acpi/sleep.c
>> +++ b/drivers/acpi/sleep.c
>> @@ -16,6 +16,8 @@
>>   #include <linux/device.h>
>>   #include <linux/interrupt.h>
>>   #include <linux/suspend.h>
>> +#include <linux/notifier.h>
>> +#include <linux/pm.h>
>>   #include <linux/reboot.h>
>>   #include <linux/acpi.h>
>>   #include <linux/module.h>
>> @@ -827,14 +829,22 @@ static void acpi_power_off_prepare(void)
>>   	acpi_disable_all_gpes();
>>   }
>>
>> -static void acpi_power_off(void)
>> +static int acpi_power_off(struct notifier_block *this,
>> +			  unsigned long unused1, void *unused2)
>>   {
>
> -> Is there any reason why any notifier in the new chain would use the
> second argument for anything meaningful?  And the third argument for
> that matter?
>
>>   	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
>>   	printk(KERN_DEBUG "%s called\n", __func__);
>>   	local_irq_disable();
>>   	acpi_enter_sleep_state(ACPI_STATE_S5);
>> +
>> +	return NOTIFY_DONE;
>
> Also is there any reason for any notifier in the new chain to return anything
> different from NOTIFY_DONE and if so, then what happens when anything else
> is returned?
>

As mentioned earlier, notifiers just come handy. That is all.

Having said that, I don't have a strong opinion either way. If you want me
to implement a priority based callback handler with a single argument,
just let me know and I'll be happy to implement it. It is not worth arguing
about.

Would something like

struct power_off_block {
	void (*power_off_call)(struct power_off_block *);
	struct power_off_block __rcu *next;
	int priority;
};

for the data structure be acceptable ? The power-off handler code would then
be something like

static void acpi_power_off(struct power_off_block *this)
{
}

ie quite similar to the current power-off handler code, with an added argument.
The API would, except for the structure argument, pretty much stay the same.

Thanks,
Guenter

