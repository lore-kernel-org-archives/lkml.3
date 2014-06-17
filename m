Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778AbaFQQP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:15:57 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51406 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933535AbaFQQPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:15:54 -0400
Message-ID: <53A069B6.6070902@wwwdotorg.org>
Date: Tue, 17 Jun 2014 10:15:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Airlie <airlied@linux.ie>,
        Mike Turquette <mturquette@linaro.org>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH 1/4] memory: tegra124-emc: Add EMC driver
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com> <1402925713-25426-2-git-send-email-tomeu.vizoso@collabora.com> <539F4D44.3070309@wwwdotorg.org> <53A03186.3040703@collabora.com>
In-Reply-To: <53A03186.3040703@collabora.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 06:16 AM, Tomeu Vizoso wrote:
> On 06/16/2014 10:02 PM, Stephen Warren wrote:
>> On 06/16/2014 07:35 AM, Tomeu Vizoso wrote:

>> This binding looks quite anaemic vs.
>> Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-emc.txt; I
>> would expect that this binding needs all the EMC register data from the
>> tegra20-emc binding too. Can the two bindings be identical?
> 
> There's even less stuff needed right now, as all what ultimately the EMC
> driver does is call clk_set_rate on the EMC clock. As the T124 EMC
> driver gains more features, they should get more similar.

IIRC, even changing the EMC clock rate requires modifying the memory
controller's programming (e.g. delays/taps/tuning etc.). That's exactly
what the more complex stuff in the nvidia,tegra20-emc.txt is all about.
I not convinced that a driver that just modifies the clock rate without
adjusting the EMC programming will work reliably.

>>> +#ifdef CONFIG_TEGRA124_EMC
>>> +int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsigned
>>> long rate);
>>> +void tegra124_emc_set_floor(unsigned long freq);
>>> +void tegra124_emc_set_ceiling(unsigned long freq);
>>> +#else
>>> +int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsigned
>>> long rate)
>>> +{ return -ENODEV; }
>>> +void tegra124_emc_set_floor(unsigned long freq)
>>> +{ return; }
>>> +void tegra124_emc_set_ceiling(unsigned long freq)
>>> +{ return; }
>>> +#endif
>>
>> I'll repeat what I said off-list so that we can have the whole
>> conversation on the list:
>>
>> That looks like a custom Tegra-specific API. I think it'd be much better
>> to integrate this into the common clock framework as a standard clock
>> constraints API. There are other use-cases for clock constraints besides
>> EMC scaling (e.g. some in audio on Tegra, and I'm sure many on other
>> SoCs too).
> 
> Yes, I wrote a bit in the cover letter about our requirements and how
> they map to the CCF. Could you please comment on that?

My comments remain the same. I believe this is something that belongs in
the clock driver, or at the least, some API that takes a struct clock as
its parameter, so that drivers can use the existing DT clock lookup
mechanism.
