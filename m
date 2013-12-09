Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab3LIKEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:04:24 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:14921 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab3LIKET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:04:19 -0500
X-AuditID: cbfee61a-b7f796d000004313-20-52a595a1d408
Date: Mon, 09 Dec 2013 11:04:01 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Eduardo Valentin <eduardo.valentin@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH RESEND v10 0/7] cpufreq:boost: CPU Boost mode support
Message-id: <20131209110401.329351e9@amdc2363>
In-reply-to: <529F384A.8040409@ti.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1385986761-17934-1-git-send-email-l.majewski@samsung.com>
 <20131204075921.3b9e86fa@amdc2363> <529F384A.8040409@ti.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t9jQd2FU5cGGVzZoG2xccZ6VounTT/Y
	Lfp+XmG2WLP/J5NF59knzBZvHnFbXN41h83ic+8RRosZ5/cxWdxuXMFmceb0JVaLJw/72Cw2
	fvVw4PVYvOclk8eda3vYPNZNe8vsseVqO4tH35ZVjB7Hb2xn8vi8SS6APYrLJiU1J7MstUjf
	LoErY/KfJywF25Ur5q/+xdjAOEu6i5GTQ0LARGLSyR/MELaYxIV769m6GLk4hASmM0rsnnGF
	EcL5xSjR0rSMFaSKRUBV4veXaYwgNpuAnsTnu0+ZQGwRAW2JuT2nmEEamAX+MUsc27WKHSQh
	LOAp0fyohwXE5gVq+D/nOFgDp4CaxNyN7awQGw4ySlx984oNJMEvICnR/g/mJjuJc582sEM0
	C0r8mHwPbBCzgJbE5m1NrBC2vMTmNW+ZJzAKzkJSNgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGuoV
	J+YWl+al6yXn525iBMfTM6kdjCsbLA4xCnAwKvHwrmBdGiTEmlhWXJl7iFGCg1lJhPdRL1CI
	NyWxsiq1KD++qDQntfgQozQHi5I474FW60AhgfTEktTs1NSC1CKYLBMHp1QDI4/utJ+6v6q2
	W9es7jT8Xct2leGtR4fll58RioI3eYI7OH7l1tpOmKc4d+6S4zNWtTy/o6l4rPuGT9apGvGL
	c0qmyHiw35hRPeeTkc99nnzlV8zMugtrFcWDH1TP+XkjoOKMcFTzXEabeZMf7ZO7E7fqR5yn
	qr93+xxBgWThrxqNV3O7EldKKLEUZyQaajEXFScCAMrVUVWjAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

> On 04-12-2013 02:59, Lukasz Majewski wrote:
> > Hi Rafael,
> > 
> >> This patch series introduces support for CPU overclocking technique
> >> called Boost.
> >>
> >> It is a follow up of a LAB governor proposal. Boost is a LAB
> >> component:
> >> http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq
> >>
> >> Boost unifies hardware based solution (e.g. Intel Nehalem) with
> >> software oriented one (like the one done at Exynos).
> >> For this reason cpufreq/freq_table code has been reorganized to
> >> include common code.
> >>
> >> Important design decisions:
> >> - Boost related code is compiled-in unconditionally to cpufreq core
> >> and disabled by default. The cpufreq_driver is responsibile for
> >> setting boost_supported flag and providing set_boost callback(if HW
> >> support is needed). For software managed boost, special Kconfig
> >> flag - CONFIG_CPU_FREQ_BOOST_SW has been defined. It will be
> >> selected only when a target platform has thermal framework
> >> properly configured.
> >>
> >> - struct cpufreq_driver has been extended with boost related
> >> fields: -- boost_supported - when driver supports boosting
> >>         -- boost_enabled - boost state
> >>         -- set_boost - callback to function, which is necessary to
> >>            enable/disable boost
> >>
> >> - Boost sysfs attribute (/sys/devices/system/cpu/cpufreq/boost) is
> >> visible _only_ when cpufreq driver supports Boost.
> >>
> >> - No special spin_lock for Boost was created. The one from cpufreq
> >> core was reused.
> >>
> >> - The Boost code doesn't rely on any policy. When boost state is
> >> changed, then the policy list is iterated and proper adjustements
> >> are done.
> >>
> >> - To improve safety level, the thermal framework is also extended
> >> to disable software boosting, when thermal trip point is reached.
> >> After cooling down the boost can be enabled again. This emulates
> >> behaviour similar to HW managed boost (like x86)
> >>
> >> Tested at HW:
> >>        Exynos 4412 3.13-rc2 Linux
> >>        Intel Core i7-3770 3.13-rc2 Linux
> >>
> >> Above patches were posted on top of kernel_pm/bleeding-edge
> >> (SHA1: 9483a9f69d5c8f83f1723361bf8340ddfb6475b4)
> >>
> > 
> > Rafael, could you pull patches from 1 to 6 of this series? Those are
> > related to cpufreq core and has already been accepted by Viresh at a
> > late August this year.
> > This would facilitate my further cpufreq work.
> > 
> > And about the last patch - related to thermal. It seems that more
> > discussion NOT related to cpufreq will be ongoing. 
> > 
> > I would prefer to add it as a separate patch to thermal subtree.
> 
> I agree with Lukasz here. The part that touches the thermal driver is
> minimal and the discussion is a simple matter of concept and
> optimization of data structures.

Rafael, what is your opinion here?

Shall I prepare another resend (without thermal patch) or would you
accept the cpufreq part of this patch set (1 to 6) as is?

> 
> > 
> > 
> > 
> >>
> >> Lukasz Majewski (7):
> >>   cpufreq: Add boost frequency support in core
> >>   cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to work with
> >> common boost solution
> >>   cpufreq:boost:Kconfig: Provide support for software managed BOOST
> >>   cpufreq:exynos:Extend Exynos cpufreq driver to support boost
> >>     framework
> >>   Documentation:cpufreq:boost: Update BOOST documentation
> >>   cpufreq:exynos4x12: Change L0 driver data to CPUFREQ_BOOST_FREQ
> >>   thermal:exynos:boost: Automatic enable/disable of BOOST feature
> >> (at Exynos4412)
> >>
> >>  Documentation/cpu-freq/boost.txt          |   26 +++----
> >>  drivers/cpufreq/Kconfig                   |    4 +
> >>  drivers/cpufreq/Kconfig.arm               |   15 ++++
> >>  drivers/cpufreq/acpi-cpufreq.c            |   86
> >> +++++++-------------- drivers/cpufreq/cpufreq.c                 |
> >> 118 ++++++++++++++++++++++++++++-
> >> drivers/cpufreq/exynos-cpufreq.c          |    3 +
> >> drivers/cpufreq/exynos4x12-cpufreq.c      |    2 +-
> >> drivers/cpufreq/freq_table.c              |   56 ++++++++++++--
> >> drivers/thermal/samsung/exynos_tmu_data.c |   47 ++++++++++++
> >> include/linux/cpufreq.h                   |   24 ++++++ 10 files
> >> changed, 302 insertions(+), 79 deletions(-)
> >>
> > 
> > 
> > 
> 
> 


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
