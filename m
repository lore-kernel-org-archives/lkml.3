Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaHTTSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:18:42 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:53236 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaHTTSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:18:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140820185955.GA23566@groeck-UX31A>
References: <1408553745-3536-1-git-send-email-bobby.prani@gmail.com> <20140820185955.GA23566@groeck-UX31A>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 20 Aug 2014 15:18:09 -0400
Message-ID: <CAJhHMCB_3x7479WUkipA+S8i6EwqCWxjzXZSW64Aaa-i-_GR8Q@mail.gmail.com>
Subject: Re: [PATCH] powerpc: booke_wdt: Fix build error as a module
To: Guenter <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>,
        "open list:WATCHDOG DEVICE D..." <linux-watchdog@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 2:59 PM, Guenter <linux@roeck-us.net> wrote:
> On Wed, Aug 20, 2014 at 12:55:44PM -0400, Pranith Kumar wrote:
>> Building booke_wdt fails when trying to build as a module as there is no
>> early_param() in module. Fix by using module_param() instead of early_param().
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>> CC: Guenter Roeck <linux@roeck-us.net>
>> ---
>>  drivers/watchdog/booke_wdt.c | 28 +++++-----------------------
>>  1 file changed, 5 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
>> index 08a7853..65f5e9f 100644
>> --- a/drivers/watchdog/booke_wdt.c
>> +++ b/drivers/watchdog/booke_wdt.c
>> @@ -30,8 +30,6 @@
>>   * occur, and the final time the board will reset.
>>   */
>>
>> -u32 booke_wdt_enabled;
>> -u32 booke_wdt_period = CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT;
>>
>>  #ifdef       CONFIG_PPC_FSL_BOOK3E
>>  #define WDTP(x)              ((((x)&0x3)<<30)|(((x)&0x3c)<<15))
>> @@ -41,27 +39,10 @@ u32 booke_wdt_period = CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT;
>>  #define WDTP_MASK    (TCR_WP_MASK)
>>  #endif
>>
>> -/* Checks wdt=x and wdt_period=xx command-line option */
>> -notrace int __init early_parse_wdt(char *p)
>> -{
>> -     if (p && strncmp(p, "0", 1) != 0)
>> -             booke_wdt_enabled = 1;
>> -
>> -     return 0;
>> -}
>> -early_param("wdt", early_parse_wdt);
>> -
>> -int __init early_parse_wdt_period(char *p)
>> -{
>> -     unsigned long ret;
>> -     if (p) {
>> -             if (!kstrtol(p, 0, &ret))
>> -                     booke_wdt_period = ret;
>> -     }
>> -
>> -     return 0;
>> -}
>> -early_param("wdt_period", early_parse_wdt_period);
>> +static bool booke_wdt_enabled = true;
>
> Any reason for changing the default from false to true ?
> Unless you have a reaslly good reason, I don't think that is a good idea.

I don't see where it was being set to false. It is
uninitialized AFAICT. Does that mean that it is false? (I thought only
static variables got that default).

>
>> +module_param(booke_wdt_enabled, bool, 0444);
>> +static int  booke_wdt_period = CONFIG_BOOKE_WDT_DEFAULT_TIMEOUT;
>> +module_param(booke_wdt_period, int, 0444);
>>
> Also not sure if it adds value to have the module parameters visible
> from user space. Why not use 0 for the permission flags ?
>

I have no objection to your suggestion. But not sure if such paranoia
is warranted :)

-- 
Pranith
