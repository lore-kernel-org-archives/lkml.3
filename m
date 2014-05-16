Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbaEPKJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:09:04 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:52566 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbaEPKJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:09:02 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1400230695.git.viresh.kumar@linaro.org>
References: <cover.1400230695.git.viresh.kumar@linaro.org>
Date: Fri, 16 May 2014 15:39:00 +0530
Message-ID: <CAJuA9aitMu_=OLT+=6pX=us03HVfrPZ1zCYFXfNg58W+-nzm3g@mail.gmail.com>
Subject: Re: [PATCH V2 0/3] cpufreq: add support for intermediate (stable)
From: Thomas Abraham <ta.omasab@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "rjw@rjwysocki.net" <rjw@rjwysocki.net>, linaro-kernel@lists.linaro.org,
        swarren@nvidia.com,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        pdeschrijver@nvidia.com, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, Doug Anderson <dianders@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>, linux@arm.linux.org.uk,
        arvind.chauhan@arm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 2:33 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Douglas Anderson, recently pointed out an interesting problem due to which
> udelay() was expiring earlier than it should.
>
> While transitioning between frequencies few platforms may temporarily switch to
> a stable frequency, waiting for the main PLL to stabilize.
>
> For example: When we transition between very low frequencies on exynos, like
> between 200MHz and 300MHz, we may temporarily switch to a PLL running at 800MHz.
> No CPUFREQ notification is sent for that. That means there's a period of time
> when we're running at 800MHz but loops_per_jiffy is calibrated at between 200MHz
> and 300MHz. And so udelay behaves badly.

Hi Viresh,

In the given example above, the reworked implementation of cpufreq for
exynos maintains the transition frequency at 800MHz / 4 = 200MHz by
using a clock divider. So the transition frequency is ensured to be
less than or equal to the pre-transition cpu clock frequency.

Thanks,
Thomas.

>
> To get this fixed in a generic way, lets introduce another set of callbacks
> get_intermediate() and target_intermediate(), only for drivers with
> target_index() and CPUFREQ_ASYNC_NOTIFICATION unset.
>
> get_intermediate should return a stable intermediate frequency platform wants to
> switch to, and target_intermediate() should set CPU to to that frequency, before
> jumping to the frequency corresponding to 'index'. Core will take care of
> sending notifications and driver doesn't have to handle them in
> target_intermediate() or target_index().
>
> This patchset also update Tegra to use this new infrastructure.
>
> NOTE: Once set to intermediate frequency, driver isn't expected to fail for the
> following ->target_index() call, if it fails core will issue a WARN().
>
> @Stephen: Can you please test this? I haven't as I didn't had a board. :)
>
> V1-V2: Almost changed completely, V1 was here: https://lkml.org/lkml/2014/5/15/40
>
> Viresh Kumar (3):
>   cpufreq: handle calls to ->target_index() in separate routine
>   cpufreq: add support for intermediate (stable) frequencies
>   cpufreq: Tegra: implement intermediate frequency callbacks
>
>  Documentation/cpu-freq/cpu-drivers.txt | 19 +++++++-
>  drivers/cpufreq/cpufreq.c              | 82 ++++++++++++++++++++++++----------
>  drivers/cpufreq/tegra-cpufreq.c        | 81 ++++++++++++++++-----------------
>  include/linux/cpufreq.h                | 15 +++++++
>  4 files changed, 128 insertions(+), 69 deletions(-)
>
> --
> 2.0.0.rc2
>
>
> _______________________________________________
> linaro-kernel mailing list
> linaro-kernel@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-kernel
