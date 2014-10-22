Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484AbaJVIDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:03:09 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:45948 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbaJVIDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:03:02 -0400
Message-ID: <544764B1.9020303@gmail.com>
Date: Wed, 22 Oct 2014 10:02:57 +0200
From: =?UTF-8?B?UGhpbGlwcGUgUsOpdG9ybmF6?= <philippe.retornaz@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
CC: linux-pm@vger.kernel.org, Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v2 01/47] kernel: Add support for poweroff handler call
 chain
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net> <1413864783-3271-2-git-send-email-linux@roeck-us.net> <54460140.50805@gmail.com> <54465FBA.8070007@roeck-us.net>
In-Reply-To: <54465FBA.8070007@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 21/10/2014 15:29, Guenter Roeck a écrit :
> On 10/20/2014 11:46 PM, Philippe Rétornaz wrote:
>> Hello
>>
>> [...]
>>> - Use raw notifiers protected by spinlocks instead of atomic notifiers
>> [...]
>>
>>> +/**
>>> + *    do_kernel_power_off - Execute kernel poweroff handler call chain
>>> + *
>>> + *    Calls functions registered with register_power_off_handler.
>>> + *
>>> + *    Expected to be called from machine_power_off as last step of
>>> + *    the poweroff sequence.
>>> + *
>>> + *    Powers off the system immediately if a poweroff handler function
>>> + *    has been registered. Otherwise does nothing.
>>> + */
>>> +void do_kernel_power_off(void)
>>> +{
>>> +    spin_lock(&power_off_handler_lock);
>>> +    raw_notifier_call_chain(&power_off_handler_list, 0, NULL);
>>> +    spin_unlock(&power_off_handler_lock);
>>> +}
>>
>> I don't get it. You are still in atomic context inside the poweroff
>> callback
>> since you lock it with a spinlock.
[...]
>>
>> Why not using the blocking_notifier_* family ?
>> It will lock with a read-write semaphore under which you can sleep.
>>
>> For instance, twl4030_power_off will sleep, since it is doing I2C access.
>> So you cannot call it in atomic context.
>>
>
> Learning something new all the time. I assumed that spin_lock (unlike
> spin_lock_irqsafe) would not run in atomic context.
>
> I did not want to use a sleeping lock because I am not sure if that
> works for all architectures; some disable (local) interrupts before
> calling the function (eg arm and arm64), and I don't want to change
> that semantics.

You're right and it even disable all others CPUs (if any).
I don't understand why it needs to disable local interrupts since the
code path to pm_power_off is simply doing:

syscall -> migrate to reboot cpu -> disable local interrupt -> disable 
others cpu -> pm_power_off().

I don't understand why we cannot re-enable interrupts right before 
pm_power_off().
And it looks like that all pm_power_off callbacks which can sleep are 
broken.
I still wonder how i2c communication can works without local interrupts 
... it looks
like somebody is re-enabling them (or the code was never run)

> I have another idea how to get there without changing the lock situation
> while executing the call chain - just set a flag indicating that it is
> running and execute it without lock. Would that work ?

I don't think inventing a new locking mechanism is a good solution.
We need first to know for sure if we can sleep or not in pm_power_off.
If yes then we need to re-enable local interrupts and we can use a mutex.
If not then the atomic notifier is fine and a lots of drivers are wrong.

Thanks,

Philippe
