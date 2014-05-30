Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933969AbaE3Q0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:26:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52587 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933500AbaE3Q0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:26:32 -0400
Message-ID: <5388B134.9090307@wwwdotorg.org>
Date: Fri, 30 May 2014 10:26:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Doug Anderson <dianders@chromium.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
Subject: Re: [PATCH V4 3/3] cpufreq: Tegra: implement intermediate frequency
 callbacks
References: <cover.1400662383.git.viresh.kumar@linaro.org>	<dc2702973028425e3ded689a6da227658fb914c4.1400662383.git.viresh.kumar@linaro.org>	<53877103.8070604@wwwdotorg.org> <CAKohponsZOpV74+SLMDLy0oCV-j896wA9--bwbwk4GUL59m1ug@mail.gmail.com>
In-Reply-To: <CAKohponsZOpV74+SLMDLy0oCV-j896wA9--bwbwk4GUL59m1ug@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 07:56 PM, Viresh Kumar wrote:
> On 29 May 2014 23:10, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> This patch breaks Tegra. The reason is below.
...
>>> +disable_pll_x:
>>> +     clk_disable_unprepare(pll_x_clk);
>>
>> ... so this turns off pll_x even though we're running from it.
> 
> Can you describe the role of the enable/disable of this pll_x_clk please?
> Which all clocks depend on it, etc? So that I understand why its important
> to enable it and for which clocks. And also if we need to disable it after
> changing to any freq..

I believe the issue is this:

We can't change the rate of pll_x while it's being used as a source for
something. I'm not 100% sure why. I assume the PLL output simply isn't
stable enough while changing rates; perhaps it can go out-of-range, or
generate glitches.

This means we must switch the CPU clock source to something else (we use
pll_p) while changing the pll_x rate.

Since the CPU is the only thing that uses pll_x, if we switch the CPU to
some other clock source, pll_x will become unused, so it will be
automatically disabled.

Disabling the PLL, and then re-enabling it later when switching the CPU
back to it, presumably takes some extra time (e.g. waiting for PLL lock
when it starts back up), so the code takes an extra reference to the
clock (prepare_enable) before switching the CPU away from it, and drops
that (disable_unprepare) after switching the CPU back to it.

The only case pll_x is disabled is when we use a cpufreq of 216MHz; that
frequency is provided by pll_p itself, so we never switch back to pll_x
in this case, and do want to shut down pll_x to save some power.

Now, in your patch when switching from 216MHz to pll_x, the initial
prepare_enable(pll_x) never happens, then the CPU is switched back to
pll_x which turns it on, then the unpaired disable_unprepare(pll_x)
happens which turns off pll_x even though the CPU is using it as clock
source. Arguably the clock API has a bug in that it shouldn't allow
these unpaired calls to break the reference counting, but that's the way
the API is right now.
