Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbaEOUaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:30:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33402 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaEOUaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:30:16 -0400
Message-ID: <53752185.3090608@wwwdotorg.org>
Date: Thu, 15 May 2014 14:20:21 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] clk: tegra: Implement Tegra124 shared/cbus clks
References: <1399990023-30318-1-git-send-email-pdeschrijver@nvidia.com> <1399990023-30318-4-git-send-email-pdeschrijver@nvidia.com> <53725FED.7050303@wwwdotorg.org> <20140514142739.GA8612@ulmo> <20140515105200.GI15168@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20140515105200.GI15168@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 04:52 AM, Peter De Schrijver wrote:
> On Wed, May 14, 2014 at 04:27:40PM +0200, Thierry Reding wrote:
>> * PGP Signed by an unknown key
>>
>> On Tue, May 13, 2014 at 12:09:49PM -0600, Stephen Warren wrote:
>>> On 05/13/2014 08:06 AM, Peter De Schrijver wrote:
>>>> Add shared and cbus clocks to the Tegra124 clock implementation.
>>>
>>>> diff --git a/include/dt-bindings/clock/tegra124-car.h b/include/dt-bindings/clock/tegra124-car.h
>>>
>>>> +#define TEGRA124_CLK_C2BUS 401
>>>> +#define TEGRA124_CLK_C3BUS 402
>>>> +#define TEGRA124_CLK_GR3D_CBUS 403
>>>> +#define TEGRA124_CLK_GR2D_CBUS 404
>>> ...
>>>
>>> I worry about this a bit. IIUC, these clocks don't actually exist in HW,
>>> but are more a way of SW applying policy to the clock that do exist in
>>> HW. As such, I'm not convinced it's a good idea to expose these clock
>>> IDS to DT, since DT is supposed to represent the HW, and not be
>>> influenced by internal SW implementation details.
>>>
>>> Do any DTs actually need to used these new clock IDs? I don't think we
>>> could actually use these value in e.g. tegra124.dtsi's clocks
>>> properties, since these clocks don't exist in HW. Was it your intent to
>>> do that? If not, can't we just define these SW-internal clock IDs in the
>>> header inside the Tegra clock driver, so the values are invisible to DT?
>>
>> I'm beginning to wonder if abusing clocks in this way is really the best
>> solution. From what I understand there are two problems here that are
>> mostly orthogonal though they're implemented using similar techniques.
>>
>> The reason for introducing cbus clocks are still unclear to me. From the
>> cover letter of this patch series it seems like these should be
>> completely hidden from drivers and as such they don't belong in device
>> tree. Also if they are an implementation detail, why are they even
>> implemented as clocks? Perhaps an example use-case would help illustrate
>> the need for this.
> 
> We don't have a PLL per engine, hence we have to use a PLL as parent for
> several module clocks. However you can't change a PLLs rate with
> active clients. So for scaling the PLL clocking eg. VIC or MSENC, you need to
> change their parent to a different PLL, change the original PLL rate and change
> the parent back to the original PLL, all while ensuring you never exceed the
> maximum allowed clock at the current voltage. You also want to take into
> account if a module is clocked so you don't bother handling clocks which are
> disabled. (eg. if only the VIC clock is enabled, there is no point in changing
> the MSENC parent). All this is handled by the 'cbus' clock.

Presumably though we can handle this "cbus" concept entirely inside the
clock driver.

What happens right now is that when a DT node references a clock, the
driver gets a clock and then manipulates it directly. What if the clock
core was reworked a bit such that every single clock was a "cbus" clock.
clk_get() wouldn't return the raw clock object itself, but rather a
"clock client" object, which would forward requests on to the underlying
clk. If there's only 1 clk_get(), there's only 1 client, so all requests
get forwarded automatically. If there are n clk_get_requests(), the
clock object gets to implement the appropriate voting/... algorithm to
mediate the requests.

That way, we don't have to expose any of this logic in the device tree,
or hopefully/mostly even outside the HW clock's implementation.
