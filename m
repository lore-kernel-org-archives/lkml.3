Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbaKJOuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:50:03 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:35140 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbaKJOuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:50:00 -0500
Message-ID: <5460D091.3000509@roeck-us.net>
Date: Mon, 10 Nov 2014 06:49:53 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH v5 18/48] mfd: twl4030-power: Register with kernel power-off
 handler
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net> <1415292213-28652-19-git-send-email-linux@roeck-us.net> <20141110084600.GA2582@amd> <5460C70D.1000206@roeck-us.net>
In-Reply-To: <5460C70D.1000206@roeck-us.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.5460D098.012C,ss=2,re=0.001,recu=0.000,reip=0.000,cl=2,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
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

On 11/10/2014 06:09 AM, Guenter Roeck wrote:
> On 11/10/2014 12:46 AM, Pavel Machek wrote:
>> Hi!
>>
>>> @@ -611,7 +611,7 @@ twl4030_power_configure_resources(const struct twl4030_power_data *pdata)
>>>    * After a successful execution, TWL shuts down the power to the SoC
>>>    * and all peripherals connected to it.
>>>    */
>>> -void twl4030_power_off(void)
>>> +static void twl4030_power_off(struct power_off_handler_block *this)
>>>   {
>>>       int err;
>>>
>>> @@ -621,6 +621,11 @@ void twl4030_power_off(void)
>>>           pr_err("TWL4030 Unable to power off\n");
>>>   }
>>>
>>> +static struct power_off_handler_block twl4030_power_off_hb = {
>>> +    .handler = twl4030_power_off,
>>> +    .priority = POWER_OFF_PRIORITY_LOW,
>>> +};
>>> +
>>>   static bool twl4030_power_use_poweroff(const struct twl4030_power_data *pdata,
>>>                       struct device_node *node)
>>>   {
>>> @@ -839,7 +844,9 @@ static int twl4030_power_probe(struct platform_device *pdev)
>>>       }
>>>
>>>       /* Board has to be wired properly to use this feature */
>>> -    if (twl4030_power_use_poweroff(pdata, node) && !pm_power_off) {
>>> +    if (twl4030_power_use_poweroff(pdata, node)) {
>>> +        int ret;
>>> +
>>>           /* Default for SEQ_OFFSYNC is set, lets ensure this */
>>>           err = twl_i2c_read_u8(TWL_MODULE_PM_MASTER, &val,
>>>                         TWL4030_PM_MASTER_CFG_P123_TRANSITION);
>>> @@ -856,7 +863,11 @@ static int twl4030_power_probe(struct platform_device *pdev)
>>>               }
>>>           }
>>>
>>> -        pm_power_off = twl4030_power_off;
>>> +        ret = devm_register_power_off_handler(&pdev->dev,
>>> +                              &twl4030_power_off_hb);
>>> +        if (ret)
>>> +            dev_warn(&pdev->dev,
>>> +                 "Failed to register power-off handler\n");
>>>       }
>>>
>>
>> Could we get rid of the "struct power_off_handler_block" and guarantee
>> that register_power_off never fails (or print message from the
>> register_power_off...)? That way, your patch would be an cleanup.
>>
>> You could then add priorities if they turn out to be really
>> neccessary, later...
>
> Priorities are necessary. We had _that_ discussion before.
> Priorities solve the problem where multiple handlers are installed,
> either conditionally or unconditionally. If I take priorities away,
> a substantial part of the patch set's value gets lost, and I might
> as well drop it.
>
I have an idea: Instead of dropping the priority, drop
power_off_handler_block and add two parameters to register_power_off_handler
and devm_register_power_off_handler instead: the priority and a context.
At the same time, declare that those two functions must be called
with the memory subsystem initialized (register_power_off_handler_simple
must be used otherwise).

With this change, the registration functions can still fail due to memory
allocation errors, but we can get rid of the data structure and simplify
the calling code while retaining functionality. I'll explore that for v7.

Guenter

