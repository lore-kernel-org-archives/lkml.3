Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaI2IUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:20:47 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:52356 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaI2IUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:20:45 -0400
MIME-Version: 1.0
In-Reply-To: <1411023787-11458-1-git-send-email-tianyu.lan@intel.com>
References: <1411023787-11458-1-git-send-email-tianyu.lan@intel.com>
Date: Mon, 29 Sep 2014 01:20:44 -0700
Message-ID: <CAKohpokht4=7XCftPYa5PqpPMN-O-5b_RjJ3BgHnxjYV4VzyTg@mail.gmail.com>
Subject: Re: [PATCH 1/1] Cpufreq: Keep cpufreq sysfs nodes across S2RAM/S2DISK
 when using intel_pstate driver.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for being late on this. Was away for a week for Linaro Connect followed
by a week of vacations :(

On 18 September 2014 00:03, Lan Tianyu <tianyu.lan@intel.com> wrote:
> Cpufreq core introduces cpufreq_suspended flag to let cpufreq sysfs nodes
> across S2RAM/S2DISK. But the flag is only set in the cpufreq_suspend()
> for cpufreq drivers which have target or target_index callback. This
> skips intel_pstate driver. This patch is to set the flag before checking
> target or target_index callback.

Oh yes, this looks to be the right thing to do..

> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  drivers/cpufreq/cpufreq.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index d9fdedd..eb9bb78 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1656,6 +1656,8 @@ void cpufreq_suspend(void)
>         if (!cpufreq_driver)
>                 return;
>
> +       cpufreq_suspended = true;
> +
>         if (!has_target())
>                 return;
>
> @@ -1670,8 +1672,6 @@ void cpufreq_suspend(void)
>                         pr_err("%s: Failed to suspend driver: %p\n", __func__,
>                                 policy);
>         }
> -
> -       cpufreq_suspended = true;

But this change is buggy.. Because you are updating 'cpufreq_suspended'
before actually stopping the governor, any calls to __cpufreq_governor()
will be converted to NO-operations because of this in __cpufreq_governor():

/* Don't start any governor operations if we are entering suspend */
if (cpufreq_suspended)
    return 0;

And so the governor's will never stop :(

So you need to keep the above line where it was :)
