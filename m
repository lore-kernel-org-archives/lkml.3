Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab3HRVBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 17:01:49 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:64839 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab3HRVBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 17:01:48 -0400
Message-ID: <52115262.70402@gmail.com>
Date: Mon, 19 Aug 2013 01:01:54 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
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

On 08/17/2013 09:08 PM, Arnd Bergmann wrote:
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

While bringing up timer and irq, I had no luck without that mapping,
but I didn't try without later on. There is no driver requiring it,
as I either only use mainline drivers that never knew about A1500
before, or I have written it on my own (dw-apb-ictl).

I don't think it is required and will try to remove it, now that I
know I have set up core stuff correctly and it boots.

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

Ok.

> Note that we should really change the common code to do both the of_clk_init()
> and the l2x0_of_init() automatically, but that needs to be done with some care,
> in order to not break any of the existing platforms. Would you be able to do
> one of the two? We can then get the next person that wants to add a platform
> to do the last one ;-)

Scary but that reduces armada-1500.c to MACH descriptor and DT
compatible only ;) I don't expect any weird hacks required for
it anyway.

Sebastian

