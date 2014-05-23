Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaEWEFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 00:05:30 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:61317 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbaEWEF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 00:05:28 -0400
MIME-Version: 1.0
In-Reply-To: <537E285C.6060608@wwwdotorg.org>
References: <cover.1400662383.git.viresh.kumar@linaro.org>
	<dc2702973028425e3ded689a6da227658fb914c4.1400662383.git.viresh.kumar@linaro.org>
	<537E285C.6060608@wwwdotorg.org>
Date: Fri, 23 May 2014 09:35:28 +0530
Message-ID: <CAKohpomdOEspgfxNR5p=PVLCeSUYcUWZ2cWGGQo0b__ptKiYtw@mail.gmail.com>
Subject: Re: [PATCH V4 3/3] cpufreq: Tegra: implement intermediate frequency callbacks
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 May 2014 22:09, Stephen Warren <swarren@wwwdotorg.org> wrote:
> I think the call to tegra_target_intermediate() is wrong here; shouldn't
> the cpufreq core guarantee that tegra_target_intermediate() has always
> been called before tegra_target(), so there's no need to repeat that
> call here?

That's what Doug requested in the previous version. get_intermediate()
can return zero in case drivers don't want to switch to intermediate
frequency for some target frequency.

Core should rather guarantee that target_index() is always called, if you
want core to guarantee that target_intermediate() is also always called,
then don't ever return zero from get_intermediate.

I did it that way for tegra as both target_intermediate() & target_index()
would have tried to set the same frequency for this particular case,
i.e. when target freq == intermediate frequency.

And both would have sent notification and the last notification wouldn't
have made any sense, both old-freq & new-freq would have been
intermediate freqs.

So, yes I see the feature suggested by Doug quite useful. Like in your
case.

> Also, tegra_target() doesn't seem to follow the rule documented by patch
> 2/3 that states ->target() should restore the orignal frequency on
> error. I'm not even sure if that's possible in general.

I thought I took care of that. Can you please give some example when
we aren't restoring original frequency on failure ?

About the rule, that has to be the expectation from core as there is no
way out that for core to know what happened at end of target_index()..

It can call get_rate() but that would be over engineering it looks ..
