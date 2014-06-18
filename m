Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbaFRWdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:33:46 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55700 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaFRWdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:33:44 -0400
Message-ID: <53A213C3.2020207@wwwdotorg.org>
Date: Wed, 18 Jun 2014 16:33:39 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= 
	<stephane.marchesin@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Tomeu Vizoso <tomeu.vizoso@collabora.com>, devicetree@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, myungjoo.ham@samsung.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 1/4] memory: tegra124-emc: Add EMC driver
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com> <1402925713-25426-2-git-send-email-tomeu.vizoso@collabora.com> <539F4D44.3070309@wwwdotorg.org> <53A03186.3040703@collabora.com> <53A069B6.6070902@wwwdotorg.org> <53A1CB23.5090307@collabora.com> <20140618220008.GC26514@mithrandir> <CACP_E+Jr5QyYm92Mc2=WVhKMbk=9Ty1fvJuH+fqOmDnYmdqFRg@mail.gmail.com>
In-Reply-To: <CACP_E+Jr5QyYm92Mc2=WVhKMbk=9Ty1fvJuH+fqOmDnYmdqFRg@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 04:19 PM, Stéphane Marchesin wrote:
> On Wed, Jun 18, 2014 at 3:00 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
>> On Wed, Jun 18, 2014 at 07:23:47PM +0200, Tomeu Vizoso wrote:
>>> On 06/17/2014 06:15 PM, Stephen Warren wrote:
>>>> On 06/17/2014 06:16 AM, Tomeu Vizoso wrote:
>>>>> On 06/16/2014 10:02 PM, Stephen Warren wrote:
>>>>>> On 06/16/2014 07:35 AM, Tomeu Vizoso wrote:
>>>>>>> +#ifdef CONFIG_TEGRA124_EMC
>>>>>>> +int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsigned
>>>>>>> long rate);
>>>>>>> +void tegra124_emc_set_floor(unsigned long freq);
>>>>>>> +void tegra124_emc_set_ceiling(unsigned long freq);
>>>>>>> +#else
>>>>>>> +int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsigned
>>>>>>> long rate)
>>>>>>> +{ return -ENODEV; }
>>>>>>> +void tegra124_emc_set_floor(unsigned long freq)
>>>>>>> +{ return; }
>>>>>>> +void tegra124_emc_set_ceiling(unsigned long freq)
>>>>>>> +{ return; }
>>>>>>> +#endif
>>>>>>
>>>>>> I'll repeat what I said off-list so that we can have the whole
>>>>>> conversation on the list:
>>>>>>
>>>>>> That looks like a custom Tegra-specific API. I think it'd be much better
>>>>>> to integrate this into the common clock framework as a standard clock
>>>>>> constraints API. There are other use-cases for clock constraints besides
>>>>>> EMC scaling (e.g. some in audio on Tegra, and I'm sure many on other
>>>>>> SoCs too).
>>>>>
>>>>> Yes, I wrote a bit in the cover letter about our requirements and how
>>>>> they map to the CCF. Could you please comment on that?
>>>>
>>>> My comments remain the same. I believe this is something that belongs in
>>>> the clock driver, or at the least, some API that takes a struct clock as
>>>> its parameter, so that drivers can use the existing DT clock lookup
>>>> mechanism.
>>>
>>> Ok, let me put this strawman here to see if I have gotten close to what you
>>> have in mind:
>>>
>>> * add per-client accounting (Rabin's patches referenced before)
>>>
>>> * add clk_set_floor, to be used by cpufreq, load stats, etc.
>>>
>>> * add clk_set_ceiling, to be used by battery drivers, thermal, etc.
>>>
>>> * an EMC driver would collect bandwidth and latency requests from consumers
>>> and call clk_set_floor on the EMC clock.
>>>
>>> * the EMC driver would also register for rate change notifications in the
>>> EMC clock and would update the latency allowance registers at that point.
>>
>> Latency allowance registers are part of the MC rather than the EMC. So I
>> think we have two options: a) have a unified driver for MC and EMC or b)
>> provide two parts of the API in two drivers.
>>
>> Or perhaps c), create a generic framework that both MC and EMC can
>> register with (bandwidth for EMC, latency for MC).
> 
> Is there any motivation for keeping MC and EMC separate? In my mind,
> the solution was always to handle those together.

Well, they are documented as being separate HW modules in the TRM.

I know there's an interlock in HW so that when the EMC clock is changed,
the EMC registers can flip atomically to a new configuration.

I'm not aware of any similar HW interlock between MC and EMC registers.
That would imply that very tight co-ordination shouldn't be required.

Do the MC latency allowance registers /really/ need to be *very tightly*
managed whenever the EMC clock is changed, or is it just a matter of it
being a good idea to update EMC clock and MC latency allowance registers
at roughly the same time? Even if there's some co-ordination required,
maybe it can be handled rather like cpufreq notifications; use clock
pre-rate change notifications to set MC up in a way that'll work at both
old/new EMC clocks, and then clock post-rate notifications to the final
MC configuration?
