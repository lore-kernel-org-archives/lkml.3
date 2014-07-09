Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbaGIKQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:16:42 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:60143 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbaGIKQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:16:40 -0400
Message-ID: <53BD1683.9030505@gmail.com>
Date: Wed, 09 Jul 2014 12:16:35 +0200
From: Pascal Huerst <pascal.huerst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: santosh.shilimkar@ti.com, khilman@deeprootsystems.com,
        linus.walleij@linaro.org, gnurou@gmail.com, linux-omap@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@zonque.org>
Subject: Re: gpio-omap: wakeup mask
References: <53B3F687.5050502@gmail.com> <20140704072752.GC28884@atomide.com>
In-Reply-To: <20140704072752.GC28884@atomide.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Tony, all

On 04.07.2014 09:27, Tony Lindgren wrote:
> * Pascal Huerst <pascal.huerst@gmail.com> [140702 05:12]:
>> Hi everyone,
>>
>> we have a device with an am335x and are using some gpios on bank0 to
>> wake up the device from suspend to ram.
>>
>> We have some user buttons which are configured in the devicetree as
>> gpio-keys and one power-key which should wake up the device:
>>
>> &buttons {
>>         power {
>>                 label = "Power";
>>                 gpios = <&gpio0 6 1>;
>>                 linux,code = <116>;
>>                 gpio-key,wakeup;
>>         };
>>
>>         one {
>>                 label = "One";
>>                 gpios = <&gpio0 11 1>;
>>                 linux,code = <2>;
>>         };
>>
>>         : : :
>> }
>>
>> The problem is, that the device wakes up on any trigger on bank 0. No
>> matter which button was pressed. "gpio-key,wakeup" seems not to have any
>> influence.
>>
>> Now, if I comment the following lines out in drivers/gpio/gpio-omap.c :
>> set_gpio_trigger(...).
>>
>> 321
>> 322 if (likely(!(bank->non_wakeup_gpios & gpio_bit))) {
>> 323    _gpio_rmw(base, bank->regs->wkup_en, gpio_bit, trigger != 0);
>> 324      bank->context.wake_en =
>> 325        readl_relaxed(bank->base + bank->regs->wkup_en);
>> 326 }
>> 327
>>
>> Everything works as expected. But I don't really understand why? Is this
>> a bug, or does this break something else I have not discovered yet?
> 
> The GPIO wake-up events are working from off-idle for omap3
> the last time I checked, so sounds like this is some am335x
> related issue.

Ok, that sounds reasonable.

> What does your bank->context.wake_en mask get set to with this code?

by calling 'echo mem > /sys/power/state' followed by a wakeup, I get the
following:

[   28.738416] PM: Syncing filesystems ... done.
[   28.779153] Freezing user space processes ... (elapsed 0.003 seconds)
done.
[   28.790236] Freezing remaining freezable tasks ... (elapsed 0.002
seconds) done.
[   28.801386] PM: Sending message for entering DeepSleep mode
[   28.935412] bank->context->wake_en = 00080840
[   28.945935] PM: suspend of devices complete after 133.156 msecs
[   28.961008] PM: late suspend of devices complete after 8.834 msecs
[   28.978874] omap_hwmod: cpgmac0: _wait_target_disable failed
[   28.985940] PM: noirq suspend of devices complete after 18.324 msecs
[   28.992697] PM: GFX domain entered low power state
[   28.992697] PM: Could not transition all powerdomains to target state
[   28.992697] PM: Wakeup source GPIO0
[   28.992866] bank->context->wake_en = 00080040
[   29.020974] PM: noirq resume of devices complete after 22.439 msecs
[   29.028257] bank->context->wake_en = 00080040
[   29.032840] bank->context->wake_en = 00080840
[   29.039207] bank->context->wake_en = 00080840
[   29.043961] bank->context->wake_en = 0000F200
[   29.048534] bank->context->wake_en = 0000F200
[   29.053093] bank->context->wake_en = 0000F200
[   29.057704] bank->context->wake_en = 0000F200
[   29.062266] bank->context->wake_en = 0000F200
[   29.066992] bank->context->wake_en = 00060000
[   29.071554] bank->context->wake_en = 00060000
[   29.082499] PM: early resume of devices complete after 6.136 msecs
[   29.091048] net eth0: initializing cpsw version 1.12 (0)
[   29.173888] net eth0: phy found : id is : 0x4dd076
[   29.229388] mmc0: error -110 during resume (card was removed?)
[   29.235609] dpm_run_callback(): mmc_bus_resume+0x0/0x74 returns -110
[   29.242272] PM: Device mmc0:0001 failed to resume: error -110
[   29.293992] PM: resume of devices complete after 204.891 msecs
[   29.306801] PM: Sending message for resetting M3 state machine
[   29.313693] Restarting tasks ... done.

Thanks
Pascal
