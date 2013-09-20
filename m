Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3ITQBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:01:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45208 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3ITQBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:01:32 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-88-523c715a6ebc
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com
Subject: [PATCH RESEND v8 0/7] cpufreq:boost: CPU Boost mode support
Date: Fri, 20 Sep 2013 18:00:57 +0200
Message-id: <1379692864-4954-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t9jAd2oQpsgg8YvmhYbZ6xntXja9IPd
	Yt5nWYu+n1eYLdbs/8lk0Xn2CbPFm0fcFm8ebma0uLxrDpvF594jjBa3G1ewWfQv7GWyePKw
	j81i41cPBz6PxXteMnncubaHzWPdtLfMHn1bVjF6PFrcwuhx/MZ2Jo/Pm+QC2KO4bFJSczLL
	Uov07RK4Mk5dP8JesFCyovHderYGxm/CXYycHBICJhJbV31ih7DFJC7cW8/WxcjFISSwiFFi
	zf7/zBBOF5PEhOkfmECq2AT0JD7ffQpmiwjMYZS4c9QdxGYW2MUscemSLogtLOAicX/zbLCp
	LAKqEif+3mMDsXkFXCWuTpzIArFNXuLp/T6wOKeAm8TcTy/AbCGgmpsfVrJMYORdwMiwilE0
	tSC5oDgpPddIrzgxt7g0L10vOT93EyM4VJ9J72Bc1WBxiFGAg1GJh/dBiE2QEGtiWXFl7iFG
	CQ5mJRHe2gKgEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp2ampBalFMFkmDk6p
	BsYu53+vN68Jb1SzXr362Ps/39esmftX5OOXwru/yoP7/kq/dA/67a5/4qX1xbU7lxy8L3wt
	OF7mw9n56Zf/VtzfoXFuP/OMgJ3fni6b2qhz0rmj1Xru4ZoubrNO1yU/ogp9/eM7T6o+F7G5
	tORO0I6doe3HPa4UHVDTYW1dJspxQefoC42UmISnSizFGYmGWsxFxYkAb5Z6j1ECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces support for CPU overclocking technique
called Boost.

It is a follow up of a LAB governor proposal. Boost is a LAB component:
http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq

Boost unifies hardware based solution (e.g. Intel Nehalem) with
software oriented one (like the one done at Exynos).
For this reason cpufreq/freq_table code has been reorganized to include
common code.

Important design decisions:
- Boost related code is compiled-in unconditionally to cpufreq core and
  disabled by default. The cpufreq_driver is responsibile for setting
  boost_supported flag and providing set_boost callback(if HW support
  is needed). For software managed boost, special Kconfig flag -
  CONFIG_CPU_FREQ_BOOST_SW has been defined. It will be selected only
  when a target platform has thermal framework properly configured.

- struct cpufreq_driver has been extended with boost related fields:
        -- boost_supported - when driver supports boosting
        -- boost_enabled - boost state
        -- set_boost - callback to function, which is necessary to
           enable/disable boost

- Boost sysfs attribute (/sys/devices/system/cpu/cpufreq/boost) is visible
  _only_ when cpufreq driver supports Boost.

- No special spin_lock for Boost was created. The one from cpufreq core
  was reused.

- The Boost code doesn't rely on any policy. When boost state is changed,
  then the policy list is iterated and proper adjustements are done.

- To improve safety level, the thermal framework is also extended to disable
  software boosting, when thermal trip point is reached. Then it starts
  monitoring target temperature to evaluate if boost can be enabled
  again. This emulates behaviour similar to HW managed boost (like x86)

Tested at HW:
       Exynos 4412 (TRATS2) 3.12-rc1 Linux
       Intel Core i7-3770 3.12-rc1 Linux

Above patches were posted on top of linux_pm/linux-next 
SHA1: cf8bc6460f2137412081ba26d18932f20cb856fd

Lukasz Majewski (7):
  cpufreq: Add boost frequency support in core
  cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to work with common
    boost solution
  thermal:boost: Automatic enable/disable of BOOST feature
  cpufreq:boost:Kconfig: Provide support for software managed BOOST
  cpufreq:exynos:Extend Exynos cpufreq driver to support boost
    framework
  Documentation:cpufreq:boost: Update BOOST documentation
  cpufreq:exynos4x12: Change L0 driver data to CPUFREQ_BOOST_FREQ

 Documentation/cpu-freq/boost.txt     |   26 ++++----
 drivers/cpufreq/Kconfig              |    4 ++
 drivers/cpufreq/Kconfig.arm          |   15 +++++
 drivers/cpufreq/acpi-cpufreq.c       |   86 +++++++++----------------
 drivers/cpufreq/cpufreq.c            |  118 +++++++++++++++++++++++++++++++++-
 drivers/cpufreq/exynos-cpufreq.c     |    6 ++
 drivers/cpufreq/exynos4x12-cpufreq.c |    2 +-
 drivers/cpufreq/freq_table.c         |   53 +++++++++++++--
 drivers/thermal/thermal_core.c       |   55 ++++++++++++++++
 include/linux/cpufreq.h              |   25 +++++++
 include/linux/thermal.h              |    2 +
 11 files changed, 313 insertions(+), 79 deletions(-)

-- 
1.7.10.4

