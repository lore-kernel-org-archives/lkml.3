Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab3H0Ipb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:45:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41447 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3H0Ip0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:45:26 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-a3-521c67243422
Date: Tue, 27 Aug 2013 10:45:12 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Subject: Re: [PATCH v8 0/7] cpufreq:boost: CPU Boost mode support
Message-id: <20130827104512.7d04d379@amdc308.digital.local>
In-reply-to: <CAKohpom90VAMYHkp3stbJJ-7H3y3zrVoQ+1q=Vza2Q0JhG8bNw@mail.gmail.com>
References: <CAKohpom90VAMYHkp3stbJJ-7H3y3zrVoQ+1q=Vza2Q0JhG8bNw@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9jAV2VdJkgg7O9fBYbZ6xntXja9IPd
	Yt5nWYu+n1eYLdbs/8lk0Xn2CbNF74KrbBZvHnFbXN41h83ic+8RRovbjSvYLPoX9jJZPHnY
	x2ax8auHA5/H4j0vmTzuXNvD5rFu2ltmj74tqxg9Hi1uYfQ4fmM7k8fnTXIB7FFcNimpOZll
	qUX6dglcGQvudzMX9MtXnFv8gqmBca5EFyMnh4SAicT5Y/1MELaYxIV769m6GLk4hAQWMUo0
	LDvDApIQEmhnkmibbAZiswioSsz7t5sNxGYT0JP4fPcpUDMHh4iAlsTLm6kgvcwCO1kklr2/
	xQhSIyzgKNG3fRaYzStgLbG5fRPYTE6BYInr7X+h5gdIdEz+DWbzC0hKtP/7wQxxkJ3EuU8b
	2CF6BSV+TL4HVsMMtGvztiZWCFteYvOat8wTGAVnISmbhaRsFpKyBYzMqxhFUwuSC4qT0nMN
	9YoTc4tL89L1kvNzNzGCI+qZ1A7GlQ0WhxgFOBiVeHg7mqSDhFgTy4orcw8xSnAwK4nwct0B
	CvGmJFZWpRblxxeV5qQWH2KU5mBREuc90GodKCSQnliSmp2aWpBaBJNl4uCUamDkPPMu5dU9
	93UvOSMyN69m4vn6jp01+8SaqOU3jefZ6Wc6z1E9/Trrof9WiUbeFM/Y+ZcO2UT1vM3rEdm8
	6Q0/p0WYtcHK9qdCs6wUVOWWzGhjy90xpWDR79r2r0FzZHbwPGy9yLPl89QuiwUSgflPd6bY
	qOTryK1UMNi4SFFKl8Nl9Xyr2idKLMUZiYZazEXFiQAPtE4zpAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Aug 2013 11:10:42 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 26 August 2013 21:20, Lukasz Majewski <l.majewski@samsung.com>
> wrote:
> > This patch series introduces support for CPU overclocking technique
> > called Boost.
> >
> > It is a follow up of a LAB governor proposal. Boost is a LAB
> > component:
> > http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq
> >
> > Boost unifies hardware based solution (e.g. Intel Nehalem) with
> > software oriented one (like the one done at Exynos).
> > For this reason cpufreq/freq_table code has been reorganized to
> > include common code.
> >
> > Important design decisions:
> > - Boost related code is compiled-in unconditionally to cpufreq core
> > and disabled by default. The cpufreq_driver is responsibile for
> > setting boost_supported flag and providing set_boost callback(if HW
> > support is needed). For software managed boost, special Kconfig
> > flag - CONFIG_CPU_FREQ_BOOST_SW has been defined. It will be
> > selected only when a target platform has thermal framework properly
> > configured.
> >
> > - struct cpufreq_driver has been extended with boost related fields:
> >         -- boost_supported - when driver supports boosting
> >         -- boost_enabled - boost state
> >         -- set_boost - callback to function, which is necessary to
> >            enable/disable boost
> >
> > - Boost sysfs attribute (/sys/devices/system/cpu/cpufreq/boost) is
> > visible _only_ when cpufreq driver supports Boost.
> >
> > - No special spin_lock for Boost was created. The one from cpufreq
> > core was reused.
> >
> > - The Boost code doesn't rely on any policy. When boost state is
> > changed, then the policy list is iterated and proper adjustements
> > are done.
> >
> > - To improve safety level, the thermal framework is also extended
> > to disable software boosting, when thermal trip point is reached.
> > Then it starts monitoring target temperature to evaluate if boost
> > can be enabled again. This emulates behaviour similar to HW managed
> > boost (like x86)
> >
> > Tested at HW:
> >        Exynos 4412 3.11-rc6 Linux
> >        Intel Core i7-3770 3.11-rc6 Linux
> >
> > Above patches were posted on top of linux_pm/linux-next
> > (SHA1: 68327ee544d74f20bb6179637971912e5e78811c)
> >
> > Lukasz Majewski (7):
> >   cpufreq: Add boost frequency support in core
> >   cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to work with
> > common boost solution
> >   thermal:boost: Automatic enable/disable of BOOST feature
> >   cpufreq:boost:Kconfig: Provide support for software managed BOOST
> >   cpufreq:exynos:Extend Exynos cpufreq driver to support boost
> >     framework
> >   Documentation:cpufreq:boost: Update BOOST documentation
> >   cpufreq:exynos4x12: Change L0 driver data to CPUFREQ_BOOST_FREQ
> >
> >  Documentation/cpu-freq/boost.txt     |   26 ++++----
> >  drivers/cpufreq/Kconfig              |    4 ++
> >  drivers/cpufreq/Kconfig.arm          |   15 +++++
> >  drivers/cpufreq/acpi-cpufreq.c       |   86
> > +++++++++---------------- drivers/cpufreq/cpufreq.c            |
> > 118 +++++++++++++++++++++++++++++++++-
> > drivers/cpufreq/exynos-cpufreq.c     |    6 ++
> > drivers/cpufreq/exynos4x12-cpufreq.c |    2 +-
> > drivers/cpufreq/freq_table.c         |   53 +++++++++++++--
> > drivers/thermal/thermal_core.c       |   55 ++++++++++++++++
> > include/linux/cpufreq.h              |   25 +++++++
> > include/linux/thermal.h              |    2 + 11 files changed, 313
> > insertions(+), 79 deletions(-)
> 
> Sorry for the long delays in getting this patchset in :)
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Thanks Viresh :-).

For my future work it is important, to "stabilize" those patches at
some kernel_pm branch (linux-next or other).

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
