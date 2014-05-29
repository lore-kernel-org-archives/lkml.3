Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934236AbaE2Rmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:42:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56820 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932691AbaE2Rmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:42:53 -0400
Message-ID: <53877199.5090009@wwwdotorg.org>
Date: Thu, 29 May 2014 11:42:49 -0600
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
References: <cover.1400662383.git.viresh.kumar@linaro.org>	<dc2702973028425e3ded689a6da227658fb914c4.1400662383.git.viresh.kumar@linaro.org>	<537E285C.6060608@wwwdotorg.org> <CAKohpomdOEspgfxNR5p=PVLCeSUYcUWZ2cWGGQo0b__ptKiYtw@mail.gmail.com>
In-Reply-To: <CAKohpomdOEspgfxNR5p=PVLCeSUYcUWZ2cWGGQo0b__ptKiYtw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 10:05 PM, Viresh Kumar wrote:
> On 22 May 2014 22:09, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> I think the call to tegra_target_intermediate() is wrong here; shouldn't
>> the cpufreq core guarantee that tegra_target_intermediate() has always
>> been called before tegra_target(), so there's no need to repeat that
>> call here?

>> Also, tegra_target() doesn't seem to follow the rule documented by patch
>> 2/3 that states ->target() should restore the orignal frequency on
>> error. I'm not even sure if that's possible in general.
> 
> I thought I took care of that. Can you please give some example when
> we aren't restoring original frequency on failure ?
> 
> About the rule, that has to be the expectation from core as there is no
> way out that for core to know what happened at end of target_index()..
> 
> It can call get_rate() but that would be over engineering it looks ..

E.g. in the following code after the series is applied:

> 	ret = clk_set_rate(pll_x_clk, rate * 1000);
> 	/* Restore to earlier frequency on error, i.e. pll_x */
> 	if (ret)
> 		pr_err("Failed to change pll_x to %lu\n", rate);
> 
> 	ret = clk_set_parent(cpu_clk, pll_x_clk);

If the clk_set_rate() failed, we have no idea what the pll_x rate is; I
don't think the clock API guarantees that zero HW changes have been made
if the function fails. Yet the code switches the CPU clock back to pll_x
without attempting to fix the pll_x rate to be the old rate. Perhaps
there's not much that can be done here though, since if one
clk_set_rate() failed, perhaps the one to fix it will too.

I suspect there are other issues, like switching between pll_p/pllx
might not be restored on error, and the EMC frequency isn't switched
back, etc.
