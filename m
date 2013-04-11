Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935226Ab3DKMnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:43:05 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:51204 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3DKMnC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:43:02 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC PATCHv2 arm: initial TI-Nspire support]
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <201304111430.05528.arnd@arndb.de>
Date: Thu, 11 Apr 2013 22:42:51 +1000
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux@arm.linux.org.uk, Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <C576ECFF-EF90-4995-AD28-1CEEE660DBAB@gmail.com>
References: <8E071E2D-4FF3-487E-A53B-B6A7C427E421@gmail.com> <201304111430.05528.arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/04/2013, at 10:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> On Thursday 11 April 2013, Daniel Tang wrote:
>> This is another updated patch for Linux on TI-Nspire support. 
>> 
>> Apologies for previously posting updated patches as replies to the first thread. I'll send updated patches in new threads from now to avoid confusion.
>> 
>> Changes between http://archive.arm.linux.org.uk/lurker/message/20130408.113343.585af217.en.html and v2:
>> * Added new drivers to support the irqchip and timers on older models.
>> * Added new device trees to support the other models.
>> 
>> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
> 
> Nice!
> 
>> arch/arm/Kconfig                            |   2 +
>> arch/arm/Kconfig.debug                      |  16 ++
>> arch/arm/Makefile                           |   1 +
>> arch/arm/boot/dts/Makefile                  |   3 +
>> arch/arm/boot/dts/nspire-classic.dtsi       |  68 ++++++
>> arch/arm/boot/dts/nspire-clp.dts            |  45 ++++
>> arch/arm/boot/dts/nspire-cx.dts             | 115 ++++++++++
>> arch/arm/boot/dts/nspire-tp.dts             |  44 ++++
>> arch/arm/boot/dts/nspire.dtsi               | 159 ++++++++++++++
>> arch/arm/include/debug/nspire.S             |  28 +++
>> arch/arm/mach-nspire/Kconfig                |  15 ++
>> arch/arm/mach-nspire/Makefile               |   2 +
>> arch/arm/mach-nspire/Makefile.boot          |   0
>> arch/arm/mach-nspire/clcd.c                 | 118 +++++++++++
>> arch/arm/mach-nspire/clcd.h                 |  14 ++
>> arch/arm/mach-nspire/mmio.h                 |  15 ++
>> arch/arm/mach-nspire/nspire.c               | 142 +++++++++++++
>> drivers/clocksource/Makefile                |   1 +
>> drivers/clocksource/nspire-classic-timer.c  | 216 +++++++++++++++++++
>> drivers/input/keyboard/Kconfig              |  10 +
>> drivers/input/keyboard/Makefile             |   1 +
>> drivers/input/keyboard/nspire-keypad.c      | 316 ++++++++++++++++++++++++++++
>> drivers/irqchip/Makefile                    |   1 +
>> drivers/irqchip/irq-nspire-classic.c        | 177 ++++++++++++++++
>> include/clocksource/nspire_classic_timer.h  |  16 ++
>> include/linux/platform_data/nspire-keypad.h |  28 +++
>> 26 files changed, 1553 insertions(+)
> 
> Please split this up into a series of patches, one for each subsystem.
> I would also keep the dts files in a separate patch from the platform
> code.

Fair enough. I'll keep that in mind for the next round of patches.

> 
> 
>> +bool timer_init;
>> +
>> +void __init nspire_classic_timer_init(void)
>> +{
>> +	struct device_node *node;
>> +
>> +	if (timer_init)
>> +		return;
>> +
>> +	for_each_compatible_node(node, NULL, DT_COMPAT) {
>> +		nspire_timer_add(node);
>> +	}
>> +
>> +	timer_init = 1;
>> +}
>> +
>> +CLOCKSOURCE_OF_DECLARE(nspire_classic_timer,
>> +		DT_COMPAT, nspire_classic_timer_init)
> 
> Why do you need the logic to prevent it from being initilized
> twice?  Can't you just remove the direct call to nspire_classic_timer_init
> from platform code and rely on of_clk_init() to call it?
> 

Ah, I wasn't aware that of_clk_init() would call the init functions. I thought it was up to clocksource_of_init() to do that.

Originally, I was adding a call to clocksource_of_init() to the platform code but that resulted in the timers being added twice. If of_clk_init() already calls the init functions, that would explain it. 

> Note that the interface has changed in linux-next, you now
> get called separately for each matching device, with the device_node
> as the argument, so you no longer have to search the device tree,
> and can essentially do
> 
> CLOCKSOURCE_OF_DECLARE(nspire_classic_timer, DT_COMPAT, nspire_timer_add);
> 
> Feel free to rebase your patch on top of the clksrc/cleanup branch
> in arm-soc to get the new behavior.

That's perfect. That'll also let me kick the whole timer_init boolean thing.

> 
>> diff --git a/include/linux/platform_data/nspire-keypad.h b/include/linux/platform_data/nspire-keypad.h
>> new file mode 100644
>> index 0000000..03deb64
>> --- /dev/null
>> +++ b/include/linux/platform_data/nspire-keypad.h
> 
> And this file now also isn't needed any more, you can just merge the
> fields of struct nspire_keypad_data into struct nspire_keypad.
> 
> 	Arnd

Thanks again,
tangrs