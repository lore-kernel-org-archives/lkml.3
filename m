Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaHIVLQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 17:11:16 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49858 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaHIVLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 17:11:12 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53E68E6C.300@roeck-us.net>
Date: Sat, 09 Aug 2014 14:11:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?windows-1252?Q?Heiko_St=FCbner?= <heiko@sntech.de>
CC: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/7] arm: Support restart through restart handler call
 chain
References: <1407203338-12915-1-git-send-email-linux@roeck-us.net> <1407203338-12915-4-git-send-email-linux@roeck-us.net> <2985231.leR3BbmHFl@diego>
In-Reply-To: <2985231.leR3BbmHFl@diego>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2014 01:01 PM, Heiko Stübner wrote:
> Hi Guenter,
>
> Am Montag, 4. August 2014, 18:48:54 schrieb Guenter Roeck:
>> The kernel core now supports a restart handler call chain for system
>> restart functions.
>>
>> With this change, the arm_pm_restart callback is now optional, so check
>> if it is set before calling it. Only call the kernel restart handler
>> if arm_pm_restart is not set.
>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
>> Acked-by: Heiko Stuebner <heiko@sntech.de>
>> ---
>> v6: No change.
>> v5: Renamed restart function to do_kernel_restart
>> v4: No change.
>> v3: Use wrapper function to execute notifier call chain.
>> v2: Only call notifier call chain if arm_pm_restart is not set.
>>      Do not include linux/watchdog.h.
>>
>>   arch/arm/kernel/process.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
>> index 81ef686..84ca0d5 100644
>> --- a/arch/arm/kernel/process.c
>> +++ b/arch/arm/kernel/process.c
>> @@ -230,7 +230,10 @@ void machine_restart(char *cmd)
>>   	local_irq_disable();
>>   	smp_send_stop();
>>
>> -	arm_pm_restart(reboot_mode, cmd);
>> +	if (arm_pm_restart)
>> +		arm_pm_restart(reboot_mode, cmd);
>> +	else
>> +		do_kernel_restart(cmd);
>>
>>   	/* Give a grace period for failure to restart of 1s */
>>   	mdelay(1000);
>
> shouldn't you also get rid of
>
> 	void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd) = null_restart;
>
Yes. Looks like I'll need another revision.

Even worse, the current upstream code is somewhat broken and doesn't really
like the following instructions.
	drivers/watchdog/moxart_wdt.c:  arm_pm_restart = NULL;
	drivers/watchdog/sunxi_wdt.c:   arm_pm_restart = NULL;

Fortunately that code is only executed if those drivers are built as modules
and unloaded.

Guenter

> like a previous attempt at unifying the restart handling [0] did.
>
> Because when testing the current series on my Rockchip boards, there was
> always an arm_pm_restart defined ... namely the null_restart mentioned above.
> So do_kernel_restart is never reached until I disable the null_restart.
>
>
> Heiko
>
>
> [0] http://permalink.gmane.org/gmane.linux.ports.arm.kernel/277042
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

