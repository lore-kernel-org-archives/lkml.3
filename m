Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab3LDG7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 01:59:33 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:34978 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3LDG7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 01:59:30 -0500
X-AuditID: cbfee61a-b7f796d000004313-03-529ed2d0d0db
Date: Wed, 04 Dec 2013 07:59:21 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lukasz Majewski <l.majewski@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH RESEND v10 0/7] cpufreq:boost: CPU Boost mode support
Message-id: <20131204075921.3b9e86fa@amdc2363>
In-reply-to: <1385986761-17934-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1385986761-17934-1-git-send-email-l.majewski@samsung.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t9jAd2Ll+YFGbQfZbTYOGM9q8XTph/s
	Fn0/rzBbrNn/k8mi8+wTZos3j7gt3jzczGhxedccNovPvUcYLWac38dkcbtxBZvFmdOXWC2e
	POxjs9j41cOBz2PxnpdMHneu7WHzWDftLbPHlqvtLB59W1Yxehy/sZ3J4/MmuQD2KC6blNSc
	zLLUIn27BK6M3+3r2Qu65CoWfZ3D1sA4X7yLkZNDQsBE4uPNS2wQtpjEhXvrgWwuDiGBRYwS
	b9aeZ4ZwfjFKrHx8FijDwcEioCqx4kkuSAObgJ7E57tPmUBsEYFQiaNTv7KD1DMLNLBIND2c
	ygqSEBbwlGh+1MMCYvMCNVz98wdsG6eAu0Tf6yeMEAuaGCU2L94LNolfQFKi/d8PZoiT7CTO
	fdrADtEsKPFj8j2wQcwCWhKbtzWxQtjyEpvXvGWewCg4C0nZLCRls5CULWBkXsUomlqQXFCc
	lJ5rqFecmFtcmpeul5yfu4kRHFfPpHYwrmywOMQowMGoxMObwDkvSIg1say4MvcQowQHs5II
	r00ZUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgsEwenVANjq/GN
	r8r/3zOV7J4kOs1Q+t+mtf84vhT1en05HpL5fVpXzp3vxn+LXWq1i1krVf3z1yyrrlJ1YDqa
	ucL9i/UCeROPrH4nqwn7Xyg7uR9T3nj2Nd+2k7M/Mu1Mudb/9ITnrvgO7sZ9f2c8k3gnF1vi
	z3hj+rv0+9mzGJ7f1U4T/KDmU1Apeu62EktxRqKhFnNRcSIA7D4326cCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

> This patch series introduces support for CPU overclocking technique
> called Boost.
> 
> It is a follow up of a LAB governor proposal. Boost is a LAB
> component:
> http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq
> 
> Boost unifies hardware based solution (e.g. Intel Nehalem) with
> software oriented one (like the one done at Exynos).
> For this reason cpufreq/freq_table code has been reorganized to
> include common code.
> 
> Important design decisions:
> - Boost related code is compiled-in unconditionally to cpufreq core
> and disabled by default. The cpufreq_driver is responsibile for
> setting boost_supported flag and providing set_boost callback(if HW
> support is needed). For software managed boost, special Kconfig flag -
>   CONFIG_CPU_FREQ_BOOST_SW has been defined. It will be selected only
>   when a target platform has thermal framework properly configured.
> 
> - struct cpufreq_driver has been extended with boost related fields:
>         -- boost_supported - when driver supports boosting
>         -- boost_enabled - boost state
>         -- set_boost - callback to function, which is necessary to
>            enable/disable boost
> 
> - Boost sysfs attribute (/sys/devices/system/cpu/cpufreq/boost) is
> visible _only_ when cpufreq driver supports Boost.
> 
> - No special spin_lock for Boost was created. The one from cpufreq
> core was reused.
> 
> - The Boost code doesn't rely on any policy. When boost state is
> changed, then the policy list is iterated and proper adjustements are
> done.
> 
> - To improve safety level, the thermal framework is also extended to
> disable software boosting, when thermal trip point is reached. After
> cooling down the boost can be enabled again. This emulates behaviour
> similar to HW managed boost (like x86)
> 
> Tested at HW:
>        Exynos 4412 3.13-rc2 Linux
>        Intel Core i7-3770 3.13-rc2 Linux
> 
> Above patches were posted on top of kernel_pm/bleeding-edge
> (SHA1: 9483a9f69d5c8f83f1723361bf8340ddfb6475b4)
> 

Rafael, could you pull patches from 1 to 6 of this series? Those are
related to cpufreq core and has already been accepted by Viresh at a
late August this year.
This would facilitate my further cpufreq work.

And about the last patch - related to thermal. It seems that more
discussion NOT related to cpufreq will be ongoing. 

I would prefer to add it as a separate patch to thermal subtree.



> 
> Lukasz Majewski (7):
>   cpufreq: Add boost frequency support in core
>   cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to work with common
>     boost solution
>   cpufreq:boost:Kconfig: Provide support for software managed BOOST
>   cpufreq:exynos:Extend Exynos cpufreq driver to support boost
>     framework
>   Documentation:cpufreq:boost: Update BOOST documentation
>   cpufreq:exynos4x12: Change L0 driver data to CPUFREQ_BOOST_FREQ
>   thermal:exynos:boost: Automatic enable/disable of BOOST feature (at
>     Exynos4412)
> 
>  Documentation/cpu-freq/boost.txt          |   26 +++----
>  drivers/cpufreq/Kconfig                   |    4 +
>  drivers/cpufreq/Kconfig.arm               |   15 ++++
>  drivers/cpufreq/acpi-cpufreq.c            |   86
> +++++++-------------- drivers/cpufreq/cpufreq.c                 |
> 118 ++++++++++++++++++++++++++++-
> drivers/cpufreq/exynos-cpufreq.c          |    3 +
> drivers/cpufreq/exynos4x12-cpufreq.c      |    2 +-
> drivers/cpufreq/freq_table.c              |   56 ++++++++++++--
> drivers/thermal/samsung/exynos_tmu_data.c |   47 ++++++++++++
> include/linux/cpufreq.h                   |   24 ++++++ 10 files
> changed, 302 insertions(+), 79 deletions(-)
> 



-- 
-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
