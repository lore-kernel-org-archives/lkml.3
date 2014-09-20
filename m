Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbaITOIw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 10:08:52 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:54098 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263AbaITOIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 10:08:50 -0400
Message-ID: <541D8A56.8070609@roeck-us.net>
Date: Sat, 20 Sep 2014 07:08:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jisheng Zhang <jszhang@marvell.com>, wim@iguana.be
CC: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] watchdog: dw_wdt: add restart handler support
References: <1411108199-1280-1-git-send-email-jszhang@marvell.com> <1411108199-1280-3-git-send-email-jszhang@marvell.com> <541CEF86.9070606@roeck-us.net>
In-Reply-To: <541CEF86.9070606@roeck-us.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.541D8A72.0095,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
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

On 09/19/2014 08:07 PM, Guenter Roeck wrote:
> On 09/18/2014 11:29 PM, Jisheng Zhang wrote:
>> The kernel core now provides an API to trigger a system restart.
>> Register with it to support restarting the system via. watchdog.
>>
>> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
>> ---
>>   drivers/watchdog/dw_wdt.c | 27 +++++++++++++++++++++++++++
>>   1 file changed, 27 insertions(+)
>>
>> diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
>> index ad0619d..4ca41e9 100644
>> --- a/drivers/watchdog/dw_wdt.c
>> +++ b/drivers/watchdog/dw_wdt.c
>> @@ -29,9 +29,11 @@
>>   #include <linux/miscdevice.h>
>>   #include <linux/module.h>
>>   #include <linux/moduleparam.h>
>> +#include <linux/notifier.h>
>>   #include <linux/of.h>
>>   #include <linux/pm.h>
>>   #include <linux/platform_device.h>
>> +#include <linux/reboot.h>
>>   #include <linux/spinlock.h>
>>   #include <linux/timer.h>
>>   #include <linux/uaccess.h>
>> @@ -62,6 +64,7 @@ static struct {
>>       unsigned long        next_heartbeat;
>>       struct timer_list    timer;
>>       int            expect_close;
>> +    struct notifier_block    restart_handler;
>>   } dw_wdt;
>>
>>   static inline int dw_wdt_is_enabled(void)
>> @@ -119,6 +122,22 @@ static void dw_wdt_keepalive(void)
>>              WDOG_COUNTER_RESTART_REG_OFFSET);
>>   }
>>
>> +static int dw_wdt_restart_handle(struct notifier_block *this,
>> +                unsigned long mode, void *cmd)
>> +{
>> +    u32 val;
>> +
>> +    writel(0, dw_wdt.regs + WDOG_TIMEOUT_RANGE_REG_OFFSET);
>> +    val = readl(dw_wdt.regs + WDOG_CONTROL_REG_OFFSET);
>> +    if (val & WDOG_CONTROL_REG_WDT_EN_MASK)
>> +        writel(WDOG_COUNTER_RESTART_KICK_VALUE, dw_wdt.regs +
>> +            WDOG_COUNTER_RESTART_REG_OFFSET);
>> +    else
>> +        writel(WDOG_CONTROL_REG_WDT_EN_MASK,
>> +               dw_wdt.regs + WDOG_CONTROL_REG_OFFSET);
>
> Don't you have to write WDOG_COUNTER_RESTART_KICK_VALUE into
> WDOG_COUNTER_RESTART_REG_OFFSET in the else case as well ?
>

According to the datasheet, it should be sufficient to
- Write 0 into WDOG_TIMEOUT_RANGE_REG_OFFSET to select the minimum timeout period
- Write 0x1 into WDOG_CONTROL_REG_OFFSET to enable the watchdog and select reset
   as desired action. This can be unconditional.

Writing into the restart register should not be necessary.

Thanks,
Guenter

