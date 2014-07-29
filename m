Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbaG2WOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:14:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51828 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaG2WOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:14:44 -0400
Message-ID: <53D81CD4.5010307@wwwdotorg.org>
Date: Tue, 29 Jul 2014 16:14:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 8/8] clk: tegra: Add EMC clock driver
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com> <1405088313-20048-9-git-send-email-mperttunen@nvidia.com> <53CE97F2.80300@wwwdotorg.org> <53D75FA7.1030300@nvidia.com> <20140729201939.4627.79710@quantum>
In-Reply-To: <20140729201939.4627.79710@quantum>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 02:19 PM, Mike Turquette wrote:
> Quoting Mikko Perttunen (2014-07-29 01:47:35)
>> On 22/07/14 19:57, Stephen Warren wrote:
>>> On 07/11/2014 08:18 AM, Mikko Perttunen wrote:
>>>> +static int emc_debug_rate_set(void *data, u64 rate)
>>>> +{
>>>> +    struct tegra_emc *tegra = data;
>>>> +
>>>> +    return clk_set_rate(tegra->hw.clk, rate);
>>>> +}
>>>> +
>>>> +DEFINE_SIMPLE_ATTRIBUTE(emc_debug_rate_fops, emc_debug_rate_get,
>>>> +                    emc_debug_rate_set, "%lld\n");
>>>
>>> I think the rate can already be obtained through
>>> ...debug/clock/clock_summary. I'm not sure about changing the rate, but
>>> shouldn't that be a feature of the common clock core, not individual
>>> drivers?
>>
>> The core doesn't allow writing to the rate debugfs files, so this is the
>> only way to trigger an EMC clock change for now. I agree that the core
>> might be a better place. I don't know if there are any philosophical
>> objections to that. I'd like to keep this in until a possible core
>> feature addition. Mike, any comments?
>
> Yes, there is a philosophical rejection to exposing rate-change knobs to
> userspace through debugfs. These can and will ship in real products
> (typically Android) with lots of nasty userspace hacks, and also
> represent pretty dangerous things to expose to userspace. I have always
> maintained that such knobs should remain out of tree or, with the advent
> of the custom debugfs entries, should be burden of the clock drivers.

That argument seems a bit inconsistent.

I can see the argument to disallow code that lets user-space fiddle with 
clocks. However, if that argument holds, then surely it must apply to 
either the clock core *or* a clock driver; the end effect of allowing 
the code in either place is that people will be able to implement the 
user-space hacks you want to avoid. Yet, if we allow the code because 
it's a useful debug tool, then surely it should be in the clock core so 
we don't implement it redundantly in each clock driver.

We could always taint the kernel if the feature is used. Admittedly that 
wouldn't stop people using the feature as a hack in Android/product 
kernels, but at least nobody would have to unknowingly debug problems 
due to such manipulation, in the context of an upstream kernel.
