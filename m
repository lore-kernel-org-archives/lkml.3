Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbaEOU6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:58:32 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:60886 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046AbaEOU62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:58:28 -0400
MIME-Version: 1.0
In-Reply-To: <537528B9.9070708@wwwdotorg.org>
References: <25738681139c04272b6d2ebeff244c6d36c893f7.1400133090.git.viresh.kumar@linaro.org>
	<537512E0.7000102@wwwdotorg.org>
	<CAD=FV=X_tVnMBz3yOf6QBYf4+-AK79_sF=asX4mD2mptxhM2CQ@mail.gmail.com>
	<537528B9.9070708@wwwdotorg.org>
Date: Thu, 15 May 2014 13:58:26 -0700
X-Google-Sender-Auth: EP0ux6glS-WUgeEbrMH-JI3Pqbs
Message-ID: <CAD=FV=V4dBRubAKUOUFc=yAWRPNhmSvULg4Pjtx9rD+ou-sMZg@mail.gmail.com>
Subject: Re: [RFC] cpufreq: send notifications for intermediate (stable) frequencies
From: Doug Anderson <dianders@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Stephen Warren <swarren@nvidia.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Thu, May 15, 2014 at 1:51 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/15/2014 02:39 PM, Doug Anderson wrote:
>> Hi,
>>
>> On Thu, May 15, 2014 at 12:17 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> On 05/14/2014 11:56 PM, Viresh Kumar wrote:
>>>> Douglas Anderson, recently pointed out an interesting problem due to which his
>>>> udelay() was expiring earlier than it should:
>>>> https://lkml.org/lkml/2014/5/13/766
>>>>
>>>> While transitioning between frequencies few platforms may temporarily switch to
>>>> a stable frequency, waiting for the main PLL to stabilize.
>>>>
>>>> For example: When we transition between very low frequencies on exynos, like
>>>> between 200MHz and 300MHz, we may temporarily switch to a PLL running at 800MHz.
>>>> No CPUFREQ notification is sent for that. That means there's a period of time
>>>> when we're running at 800MHz but loops_per_jiffy is calibrated at between 200MHz
>>>> and 300MHz. And so udelay behaves badly.
>>>>
>>>> To get this fixed in a generic way, lets introduce another callback safe_freq()
>>>> for the cpufreq drivers.
>>>>
>>>> safe_freq() should return a stable intermediate frequency a platform might want
>>>> to switch to, before jumping to the frequency corresponding to 'index'. Core
>>>> will send the 'PRE' notification for this 'stable' frequency and 'POST' for the
>>>> 'target' frequency. Though if ->target_index() fails, it will handle POST for
>>>> 'stable' frequency only.
>>>>
>>>> Drivers must send 'POST' notification for 'stable' freq and 'PRE' for 'target'
>>>> freq. If they can't switch to target frequency, they don't need to send any
>>>> notification.
>>>
>>> This seems rather complex. Can't either the driver or the cpufreq core
>>> be responsible for all of the notifications? Otherwise, the logic gets
>>> rather complex, and spread between the core and the driver.
>>>
>>> Perhaps the core should make separate calls into the driver to switch to
>>> the temporary frequency and the final frequency, so it can manage all
>>> the notifications. Probably best to use a separate function pointer for
>>> the temporary change so the driver can easily know what it's doing.
>>
>> In the discussion about the exynos cpufreq redesign (atop
>> cpufreq-cpu0), it turns out that they've come up with a pretty
>> reasonable solution that also happens to solve our problem.  They
>> utilize an extra divider to make sure that the temporary PLL gets
>> divided down so that it's low enough.
>>
>> It might mean that going between 300 MHz and 500 MHz that you will
>> transition through 400 MHz, but I'm quite OK with not sending out a
>> notification for that.
>>
>> If something like that could work for tegra, then maybe we can drop
>> this whole thing and it will all just fix itself.  ;)
>
> At least in the case of Tegra20 cpufreq, I don't think that will be
> possible at least without changing the temporary clock source we use
> (pll_p). The PLL that's use temporarily is also the root of all the
> peripheral clocks, and hence can't be changed. We also only characterize
> that PLL at the one specific frequency it was designed to run at.

It's interesting, in the exynos case they didn't change the PLL itself
but found an extra divider that I wasn't actually aware existed.  It
was located after the mux and before the cpu.


> That said, it looks like the CPU clock may support pll_p_out3 and 4 as
> sources in addition to pll_p. I'm not sure if anything else uses those
> divided pll_p outputs. Peter, perhaps you can comment? Also, since pll_p
> itself runs at exactly 216MHz, pll_p_out3 and 4 can never go higher than
> that, so we couldn't use this trick for transitions between two fast
> clock rates. Note that Tegra20 does reparenting for any CPU clock rate
> change, not just when changing to/from certain slow rates. None of the
> other potential CPU clock parents seem any better.

On exynos it won't necessarily transition to a frequency that's
between the start and end.  ...but at least with the trick mentioned
you can be sure that it's never _faster_ than either start or end.
The last I read through the code exynos always transitioned to a temp
PLL, though perhaps certain transitions could be optimized to avoid it
(if you're making a transition that doesn't need to relock).

...example transitions:
1.6 => 800 (temp) => 1.7
600 => 800 (temp) => 800
600 => 400 (temp) => 700
200 => 200 (temp) => 300

-Doug
