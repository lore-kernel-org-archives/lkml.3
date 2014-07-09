Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbaGIMpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:45:11 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:32794 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaGIMpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:45:08 -0400
Message-ID: <53BD3950.60000@gmail.com>
Date: Wed, 09 Jul 2014 14:45:04 +0200
From: Pascal Huerst <pascal.huerst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: santosh.shilimkar@ti.com, khilman@deeprootsystems.com,
        linus.walleij@linaro.org, gnurou@gmail.com, linux-omap@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@zonque.org>
Subject: Re: gpio-omap: wakeup mask
References: <53B3F687.5050502@gmail.com> <20140704072752.GC28884@atomide.com> <53BD1683.9030505@gmail.com> <20140709104142.GO28884@atomide.com>
In-Reply-To: <20140709104142.GO28884@atomide.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09.07.2014 12:41, Tony Lindgren wrote:
> * Pascal Huerst <pascal.huerst@gmail.com> [140709 03:18]:
>> Hey Tony, all
>>
>> On 04.07.2014 09:27, Tony Lindgren wrote:
>>> * Pascal Huerst <pascal.huerst@gmail.com> [140702 05:12]:
>>>> Hi everyone,
>>>>
>>>> we have a device with an am335x and are using some gpios on bank0 to
>>>> wake up the device from suspend to ram.
>>>>
>>>> We have some user buttons which are configured in the devicetree as
>>>> gpio-keys and one power-key which should wake up the device:
>>>>
>>>> &buttons {
>>>>         power {
>>>>                 label = "Power";
>>>>                 gpios = <&gpio0 6 1>;
>>>>                 linux,code = <116>;
>>>>                 gpio-key,wakeup;
>>>>         };
>>>>
>>>>         one {
>>>>                 label = "One";
>>>>                 gpios = <&gpio0 11 1>;
>>>>                 linux,code = <2>;
>>>>         };
>>>>
>>>>         : : :
>>>> }
>>>>
>>>> The problem is, that the device wakes up on any trigger on bank 0. No
>>>> matter which button was pressed. "gpio-key,wakeup" seems not to have any
>>>> influence.
>>>>
>>>> Now, if I comment the following lines out in drivers/gpio/gpio-omap.c :
>>>> set_gpio_trigger(...).
>>>>
>>>> 321
>>>> 322 if (likely(!(bank->non_wakeup_gpios & gpio_bit))) {
>>>> 323    _gpio_rmw(base, bank->regs->wkup_en, gpio_bit, trigger != 0);
>>>> 324      bank->context.wake_en =
>>>> 325        readl_relaxed(bank->base + bank->regs->wkup_en);
>>>> 326 }
>>>> 327
>>>>
>>>> Everything works as expected. But I don't really understand why? Is this
>>>> a bug, or does this break something else I have not discovered yet?
>>>
>>> The GPIO wake-up events are working from off-idle for omap3
>>> the last time I checked, so sounds like this is some am335x
>>> related issue.
>>
>> Ok, that sounds reasonable.
>>
>>> What does your bank->context.wake_en mask get set to with this code?
>>
>> by calling 'echo mem > /sys/power/state' followed by a wakeup, I get the
>> following:
>>
>> [   28.992866] bank->context->wake_en = 00080040
>> [   29.020974] PM: noirq resume of devices complete after 22.439 msecs
> 
> I guess that's for gpio bank 0 with no bit 11 as your dts has it
> configured. 

Yes that's right. I forgot to print the context, too. If I do so, it's:

[   31.034972] bank->base = F9E07000 gpio = 6 bank->context->wake_en =
00080040

respectively:

[   31.846992] bank->base = F9E07000 gpio = 11 bank->context->wake_en =
00080040

> If you just comment out the _gpio_rmw part above do
> things work as expected?

Yes. It only wakes up on gpio 6 not on gpio 11 anymore.

> Then if that works as expected, maybe write only some unused bits
> into wkup_en register and see if it still wakes to all events while
> it should not?

If I use the following testcode, everything works as expected:

//WARN(true, "WARN: bank->base = %08X\n", bank->base);

if (likely(!(bank->non_wakeup_gpios & gpio_bit))) {
  //_gpio_rmw(base, bank->regs->wkup_en, gpio_bit, trigger != 0);
  writel(0xABC00000, base + bank->regs->wkup_en);

  bank->context.wake_en = readl_relaxed(bank->base +
    bank->regs->wkup_en);
  printk("bank->base = %08X gpio = %i bank->context->wake_en = %08X\n",
    bank->base, gpio, bank->context.wake_en);
}

This produces the following output:

[   35.319228] PM: Syncing filesystems ... done.
[   35.358702] Freezing user space processes ... (elapsed 0.003 seconds)
done.
[   35.369754] Freezing remaining freezable tasks ... (elapsed 0.002
seconds) done.
[   35.380734] PM: Sending message for entering DeepSleep mode
[   35.515932] bank->base = F9E07000 gpio = 19 bank->context->wake_en =
ABC00000
[   35.529319] PM: suspend of devices complete after 137.218 msecs
[   35.544410] PM: late suspend of devices complete after 8.715 msecs
[   35.562247] omap_hwmod: cpgmac0: _wait_target_disable failed
[   35.569325] PM: noirq suspend of devices complete after 18.289 msecs
[   35.576156] PM: GFX domain entered low power state
[   35.576156] PM: Could not transition all powerdomains to target state
[   35.576156] PM: Wakeup source GPIO0
[   35.576156] PM Wakeup source extra: 00000840
[   35.576329] bank->base = F9E07000 gpio = 6 bank->context->wake_en =
ABC00000
[   35.583710] bank->base = F9E07000 gpio = 11 bank->context->wake_en =
ABC00000
[   35.614846] PM: noirq resume of devices complete after 22.582 msecs
[   35.622009] bank->base = F9E07000 gpio = 6 bank->context->wake_en =
ABC00000
[   35.631798] bank->base = F9E07000 gpio = 11 bank->context->wake_en =
ABC00000
[   35.639511] bank->base = F9E07000 gpio = 19 bank->context->wake_en =
ABC00000
[   35.647116] bank->base = FA04C000 gpio = 9 bank->context->wake_en =
ABC00000
[   35.654547] bank->base = FA04C000 gpio = 12 bank->context->wake_en =
ABC00000
[   35.662015] bank->base = FA04C000 gpio = 13 bank->context->wake_en =
ABC00000
[   35.669526] bank->base = FA04C000 gpio = 14 bank->context->wake_en =
ABC00000
[   35.677039] bank->base = FA04C000 gpio = 15 bank->context->wake_en =
ABC00000
[   35.685035] bank->base = FA1AC000 gpio = 17 bank->context->wake_en =
ABC00000
[   35.692507] bank->base = FA1AC000 gpio = 18 bank->context->wake_en =
ABC00000
[   35.706466] PM: early resume of devices complete after 6.235 msecs
[   35.715010] net eth0: initializing cpsw version 1.12 (0)
[   35.794388] net eth0: phy found : id is : 0x4dd076
[   35.849941] mmc0: error -110 during resume (card was removed?)
[   35.856164] dpm_run_callback(): mmc_bus_resume+0x0/0x74 returns -110
[   35.862828] PM: Device mmc0:0001 failed to resume: error -110
[   35.914573] PM: resume of devices complete after 201.604 msecs
[   35.927336] PM: Sending message for resetting M3 state machine
[   35.934236] Restarting tasks ... done.

> It might be worth comparing the GPIO registers between am37xx and
> am335x for the wkup_en register.

I had a quick look, but did not find anything. May be I will have to
look into that again.

Thanks
Pascal
