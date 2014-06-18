Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaFRRq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:46:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34329 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaFRRqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:46:54 -0400
Message-ID: <53A1D089.8010605@wwwdotorg.org>
Date: Wed, 18 Jun 2014 11:46:49 -0600
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
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com> <1402925713-25426-2-git-send-email-tomeu.vizoso@collabora.com> <539F4D44.3070309@wwwdotorg.org> <53A03186.3040703@collabora.com> <53A069B6.6070902@wwwdotorg.org> <53A1CB23.5090307@collabora.com>
In-Reply-To: <53A1CB23.5090307@collabora.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 11:23 AM, Tomeu Vizoso wrote:
> On 06/17/2014 06:15 PM, Stephen Warren wrote:
>> On 06/17/2014 06:16 AM, Tomeu Vizoso wrote:
>>> On 06/16/2014 10:02 PM, Stephen Warren wrote:
>>>> On 06/16/2014 07:35 AM, Tomeu Vizoso wrote:
>>>>> +#ifdef CONFIG_TEGRA124_EMC
>>>>> +int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsigned
>>>>> long rate);
>>>>> +void tegra124_emc_set_floor(unsigned long freq);
>>>>> +void tegra124_emc_set_ceiling(unsigned long freq);
>>>>> +#else
>>>>> +int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsigned
>>>>> long rate)
>>>>> +{ return -ENODEV; }
>>>>> +void tegra124_emc_set_floor(unsigned long freq)
>>>>> +{ return; }
>>>>> +void tegra124_emc_set_ceiling(unsigned long freq)
>>>>> +{ return; }
>>>>> +#endif
>>>>
>>>> I'll repeat what I said off-list so that we can have the whole
>>>> conversation on the list:
>>>>
>>>> That looks like a custom Tegra-specific API. I think it'd be much
>>>> better
>>>> to integrate this into the common clock framework as a standard clock
>>>> constraints API. There are other use-cases for clock constraints
>>>> besides
>>>> EMC scaling (e.g. some in audio on Tegra, and I'm sure many on other
>>>> SoCs too).
>>>
>>> Yes, I wrote a bit in the cover letter about our requirements and how
>>> they map to the CCF. Could you please comment on that?
>>
>> My comments remain the same. I believe this is something that belongs in
>> the clock driver, or at the least, some API that takes a struct clock as
>> its parameter, so that drivers can use the existing DT clock lookup
>> mechanism.
> 
> Ok, let me put this strawman here to see if I have gotten close to what
> you have in mind:
> 
> * add per-client accounting (Rabin's patches referenced before)
> 
> * add clk_set_floor, to be used by cpufreq, load stats, etc.
> 
> * add clk_set_ceiling, to be used by battery drivers, thermal, etc.

Yes. I'd expect those to be maintained per-client, and so the clock core
(or whatever higher level code implements clk_set_floor/ceiling)
performs the logic that "blends" together all the different requests
from different clients.

As an aside, for audio usage, I would expect clk_set_rate to be a
per-client (rather than per HW clock) operation too, and to error out if
one client says it wants to set pll_a to the rate needed for
44.1KHz-based audio and a different client wants the rate for
48KHz-based audio.

> * an EMC driver would collect bandwidth and latency requests from
> consumers and call clk_set_floor on the EMC clock.
> 
> * the EMC driver would also register for rate change notifications in
> the EMC clock and would update the latency allowance registers at that
> point.
> 
> How does it sound?

At a high level, yes this sounds about right to me.

