Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3FGLvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 07:51:40 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:50065 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3FGLvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 07:51:38 -0400
Message-ID: <51B1C944.3070509@gmail.com>
Date: Fri, 07 Jun 2013 13:51:32 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        John Stultz <john.stultz@linaro.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: Re: [PATCH v3 4/6] ARM: kirkwood: move device tree nodes to DT irqchip
 and clocksource
References: <1370536034-23956-1-git-send-email-sebastian.hesselbarth@gmail.com> <1370536034-23956-5-git-send-email-sebastian.hesselbarth@gmail.com> <20130607103007.415575c8@skate>
In-Reply-To: <20130607103007.415575c8@skate>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/13 10:30, Thomas Petazzoni wrote:
> On Thu,  6 Jun 2013 18:27:12 +0200, Sebastian Hesselbarth wrote:
>
>> -		wdt@20300 {
>> +		wdt: watchdog-timer@20300 {
>>   			compatible = "marvell,orion-wdt";
>>   			reg = <0x20300 0x28>;
>> +			interrupt-parent = <&bridge_intc>;
>> +			interrupts = <3>;
>>   			clocks = <&gate_clk 7>;
>>   			status = "okay";
>>   		};
>
> The watchdog driver is mapping the same registers as the timer driver
> (0x20300) and is poking into the same TIMER_CTRL register that controls
> both the timers and the watchdog.

Thomas,

I didn't comment on the base address above: with issue (b) solved the
actual reg property of wdt should be <0x20320 0x8> while timer's reg
property is <0x20300 0x20>.

I had a closer look at orion-wdt. Actually, I don't want to poke into it
too much, but DT irqchip introduces that chained irq handler for bridge
registers. While clocksource allows us to have separate drivers for DT
and non-DT, current watchdog does not.

This introduces some issues to take care of when dealing with kernels
where you have both non-DT and DT compiled in.

(a) non-DT timer and DT/non-DT watchdog poke BRIDGE_CAUSE

Convert non-DT irq to install chained irq and remove it from non-DT
timer and DT/non-DT watchdog.

(b) non-DT timer, DT timer, and DT/non-DT watchdog poke TIMER_CTRL

Have non-DT timer and DT timer export an orion_timer_ctrl_clrset()
function that spin_locks access to TIMER_CTRL register. Make non-DT
timer, DT timer, and DT/non-DT watchdog use that exported function.

One thing we need to workaround here: You cannot have the same function
name exported from both non-DT and DT timer. For a temporary "fix" this
function could sit in arch/arm/plat-orion/temporary.c until we get rid
of non-DT completely. Maybe we also want some place there to
subsequently split-off code from common.c when we switch to other APIs
for DT kernels (Reset API).

(c) common plat-orion reset and watchdog poke RSTOUTn_MASK

Leave it.

*OR* (d) implement a DT-only version of watchdog

 From what I can see from current orion wdt I prefer forking the whole
driver and remove of_device_id from the old one. Or just have non-DT
and DT callbacks where required. That will safe us from messing with
non-DT core drivers just for getting orion wdt to behave on DT kernels.

And just for the record, we fork off new drivers for DT all the time
but watchdog already sits in drivers/ while the rest moves from arch/arm
to drivers/.

Sebastian

