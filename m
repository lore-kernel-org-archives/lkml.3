Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095Ab3HSOwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 10:52:33 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:39182 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab3HSOwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 10:52:32 -0400
Message-ID: <5212312A.20401@gmail.com>
Date: Mon, 19 Aug 2013 16:52:26 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jason Cooper <jason@lakedaemon.net>, Russell King <linux@arm.linux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 5/5] ARM: mvebu: add board init for Armada 1500
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376682098-10580-6-git-send-email-sebastian.hesselbarth@gmail.com> <20130816204831.GX13964@titan.lakedaemon.net> <201308172108.38824.arnd@arndb.de>
In-Reply-To: <201308172108.38824.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/13 21:08, Arnd Bergmann wrote:
> On Friday 16 August 2013, Jason Cooper wrote:
>>> +
>>> +#define ARMADA_1500_REG_BASE_VIRT	0xf6000000
>>> +#define ARMADA_1500_REG_BASE_SIZE	0x03000000
>>> +
>>> +static struct map_desc armada_1500_io_desc[] __initdata = {
>>> +	{
>>> +		.virtual	= ARMADA_1500_REG_BASE_VIRT,
>>> +		.pfn		= __phys_to_pfn(ARMADA_1500_REG_BASE_VIRT),
>>> +		.length		= ARMADA_1500_REG_BASE_SIZE,
>>> +		.type		= MT_DEVICE,
>>> +	},
>>> +};
>
> You should really try to find out what driver uses this. If you have a requirement
> that VIRT == PHYS here, the most likely explanation is that some driver accidentally
> uses readl/writel on the physical address rather than on the result of ioremap.
>
> You can try shrinking the area using bisection until you have found the offending
> driver based on the address.

I just removed the above and it still works. Must have been a placebo
for me to believe it made it working.

>>> +static void __init armada_1500_timer_and_clk_init(void)
>>> +{
>>> +	of_clk_init(NULL);
>>> +	clocksource_of_init();
>>> +}
>>> +
>>> +static void __init armada_1500_dt_init(void)
>>> +{
>>> +	l2x0_of_init(0x70c00000, 0xfeffffff);
>
> New platforms should call this as 'l2x0_of_init(0, 0);' and get the bits from DT.

Is there any work on "get the bits from DT" already? I looked in
arm-soc/for-next and for-next but couldn't find any parsing of
aux_*.

> Note that we should really change the common code to do both the of_clk_init()
> and the l2x0_of_init() automatically, but that needs to be done with some care,
> in order to not break any of the existing platforms. Would you be able to do
> one of the two? We can then get the next person that wants to add a platform
> to do the last one ;-)

Haven't had a look at cache init, but of_clk_init(NULL). Since most
platforms need clocks prior timer, I guess any initcall is too late?
Below init sequence guessing may be wrong, but that is what I read
from init/main.c and arm arch init.

Looking through arch/ there is arc, arm, arm64, and metag using
of_clk_init(NULL).

arch/arc/plat-tb10x and arch/arm64 call it right before
of_platform_populate which is after time_init() and too late for
us, arch/metag calls it within time_init().

On arch/arm of_clk_init(NULL) is heavily spread among mach- subdirs
with exynos, highbank, imx (all sub-machs), mvebu, nspire, rockchip,
sti, and vexpress calling it in .init_time; tegra calls it even
earlier in .init_irq, socfpga in .init_machine. With latest clocksource
driver for Orion, -dove, -orion5x, and -mv78xx0, will also need clocks
prior timer.

If we are going for an arch/arm specific call to of_clk_init(NULL),
we could also call it from time_init(); after asking the tegra guys
about the specific requirement to have them (and the drivers using
it) ready before timers have been initialized.

For the transition period, we should add a static bool to of_clk_init
to WARN_ON double registration attempts.

I could prepare some patches to convert existing arch/arm users to
get some noise on the corresponding mailing lists. Maybe one of the
tegra guys is also reading this and can comment on .init_irq before.

Sebastian
