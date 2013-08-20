Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab3HTMdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:33:10 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51387 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab3HTMdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:33:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] cpufreq: Fixes for 3.12
Date: Tue, 20 Aug 2013 14:43:42 +0200
Message-ID: <4207583.84U9qMI9uv@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <cover.1376979090.git.viresh.kumar@linaro.org>
References: <cover.1376979090.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 20, 2013 12:08:21 PM Viresh Kumar wrote:
> Hi Rafael,
> 
> You recently did this:
> 
> commit 878f6e074e9a7784a6e351512eace4ccb3542eef
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Sun Aug 18 15:35:59 2013 +0200
> 
>     Revert "cpufreq: Use cpufreq_policy_list for iterating over policies"
>     
>     Revert commit eb60852 (cpufreq: Use cpufreq_policy_list for iterating
>     over policies), because it breaks system suspend/resume on multiple
>     machines.
>     
>     It either causes resume to block indefinitely or causes the BUG_ON()
>     in lock_policy_rwsem_##mode() to trigger on sysfs accesses to cpufreq
>     attributes.
>     
> ------x------------x---------------
> 
> This patchset gets the reverted patch back along with few supporting patches.
> Cause of the initial problem you observed was this:
> 
> - At suspend all CPUs are removed leaving boot cpu. At this time policies aren't
>   freed and also aren't removed from cpufreq_policy_list. And per-cpu variable
>   cpufreq_cpu_data is marked as NULL.
> - At resume CPUs other than boot cpu called __cpufreq_add_dev(). The tricky
>   change that was introduced by my patch was: We iterate over list of policies
>   instead of CPUs, where we used to get policy structure associated with
>   CPUs using per-cpu variable. Which used to be NULL for first CPU of a policy
>   that turned up. For the first cpu we don't want to call
>   cpufreq_add_policy_cpu() but want __cpufreq_add_add() to continue.
> 
>   When we called cpufreq_add_policy_cpu() it tried to stop the governor (which
>   was already stopped) and hence errors leading into unstable state.
> 
> This patchset fixes these issues and is tested with suspend-resume over my
> thinkpad with ubuntu. Apart from minor cleanups it removes policy from
> cpufreq_policy_list in case of suspend/resume as well and hence we will never
> call cpufreq_add_policy_cpu() for first cpu of a policy.

Well, this looks good, but do we really need it in 3.12?  It doesn't look
like 3.12 will be missing these changes a lot?

Rafael

