Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbaDBAcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:32:48 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60642 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897AbaDBAcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:32:45 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <533B5AAA.50707@roeck-us.net>
Date: Tue, 01 Apr 2014 17:32:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: monstr@monstr.eu
CC: Harini Katakam <harinik@xilinx.com>, grant.likely@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        michals@xilinx.com, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] watchdog: Add Cadence WDT driver
References: <1396002720-7105-1-git-send-email-harinik@xilinx.com> <533A0937.9030505@roeck-us.net> <533AA0F7.2080304@monstr.eu>
In-Reply-To: <533AA0F7.2080304@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 04:20 AM, Michal Simek wrote:
> Hi Guenter,
>
>>> +/**
>>> + * struct cdns_wdt - Watchdog device structure
>>> + * @regs: baseaddress of device
>>> + * @rst: reset flag
>>> + * @clk: struct clk * of a clock source
>>> + * @prescaler: for saving prescaler value
>>> + * @ctrl_clksel: counter clock prescaler selection
>>> + * @io_lock: spinlock for IO register access
>>> + * @cdns_wdt_device: watchdog device structure
>>> + * @cdns_wdt_notifier: notifier structure
>>> + *
>>> + * Structure containing parameters specific to cadence watchdog.
>>> + */
>>> +struct cdns_wdt {
>>> +    void __iomem        *regs;
>>> +    u32            rst;
>>> +    struct clk        *clk;
>>> +    u32            prescaler;
>>> +    u32            ctrl_clksel;
>>> +    spinlock_t        io_lock;
>>> +    struct watchdog_device    cdns_wdt_device;
>>> +    struct notifier_block    cdns_wdt_notifier;
>>> +};
>>> +
>>> +/* Write access to Registers */
>>> +static inline void cdns_wdt_writereg(void __iomem *offset, u32 val)
>>> +{
>>> +    writel_relaxed(val, offset);
>>> +}
>>> +
>>
>> Not really sure if this function provides any value.
>
> I can't see any problem to use this helper IO function
> but maybe we could do it a little bit differently.
> Currently implementation is just passing values to writel_relaxed()
>
> What about to do it like this?
>
> static inline void cdns_wdt_writereg(struct cdns_wdt *wdt, u32 offset, u32 val)
> {
>      writel_relaxed(val, wdt->regs + offset);
> }
>
Yes, that would make more sense.

Guenter

> This solution was suggested by Mark here too.
> https://lkml.org/lkml/2014/3/17/234
>
> The reason for having one IO helper function is
> 1. Simper debugging when you add printks to one location and
> you get full list for accesses
> 2. This driver can be also used by BE Linux on Microblaze in PL
> that's why there could be a need to autodetect endianess directly
> on the IP itself. Then using helper function is necessary.
> 3. We have met with secure monitor implementation where all these
> io accesses should be done via smc calls and having
> IO helper function is easier for change.
>
> Thanks,
> Michal
>

