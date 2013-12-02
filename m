Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab3LBMTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:19:36 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:37404 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706Ab3LBMTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:19:33 -0500
X-AuditID: cbfee61a-b7f316d000007e34-9d-529c7ad3005d
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH RESEND v10 0/7] cpufreq:boost: CPU Boost mode support
Date: Mon, 02 Dec 2013 13:19:14 +0100
Message-id: <1385986761-17934-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t9jQd0rVXOCDNoXcVlsnLGe1eJp0w92
	i76fV5gt1uz/yWTRefYJs8WbR9wWbx5uZrS4vGsOm8Xn3iOMFjPO72OyuN24gs3izOlLrBZP
	HvaxWWz86uHA57F4z0smjzvX9rB5rJv2ltljy9V2Fo++LasYPY7f2M7k8XmTXAB7FJdNSmpO
	Zllqkb5dAldG+8Ut7AWtkhXtX6azNjAeF+5i5OSQEDCRaPt2iRHCFpO4cG89WxcjF4eQwHRG
	iS9vLjODJIQEupgkeiebgdhsAnoSn+8+ZQIpEhFYwijxumkBK4jDLLCRWWLnzLdsIFXCAq4S
	W1+dA+tmEVCVmDNjBZjNK+AmMX/+NlaIdfIST+/3gdVzAsXnfnrBBrHNVeLmh5UsExh5FzAy
	rGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDtdnUjsYVzZYHGIU4GBU4uG9KDwnSIg1say4
	MvcQowQHs5II78tEoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZ
	Jg5OqQZGhr3zvs1+Ep6rM6Nb9+DlMMcFfus0ZQ8/2nV826mU01HvYu48bukOK9HoEf7+LmlD
	7DSJObyeWfMkdkZfzuG5E7PrrcuMT//CuZWq9uWUJN3XebNdVeTjycB1cjdvrBBqeVBRXKNX
	uvJ/nGe+vcR2Sf2nGpPevbVba5a1N3/Sxn578wPvuaddVmIpzkg01GIuKk4EAOUIlTdTAgAA
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
  software boosting, when thermal trip point is reached. After cooling down
  the boost can be enabled again. This emulates behaviour similar to HW
  managed boost (like x86)

Tested at HW:
       Exynos 4412 3.13-rc2 Linux
       Intel Core i7-3770 3.13-rc2 Linux

Above patches were posted on top of kernel_pm/bleeding-edge
(SHA1: 9483a9f69d5c8f83f1723361bf8340ddfb6475b4)


Lukasz Majewski (7):
  cpufreq: Add boost frequency support in core
  cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to work with common
    boost solution
  cpufreq:boost:Kconfig: Provide support for software managed BOOST
  cpufreq:exynos:Extend Exynos cpufreq driver to support boost
    framework
  Documentation:cpufreq:boost: Update BOOST documentation
  cpufreq:exynos4x12: Change L0 driver data to CPUFREQ_BOOST_FREQ
  thermal:exynos:boost: Automatic enable/disable of BOOST feature (at
    Exynos4412)

 Documentation/cpu-freq/boost.txt          |   26 +++----
 drivers/cpufreq/Kconfig                   |    4 +
 drivers/cpufreq/Kconfig.arm               |   15 ++++
 drivers/cpufreq/acpi-cpufreq.c            |   86 +++++++--------------
 drivers/cpufreq/cpufreq.c                 |  118 ++++++++++++++++++++++++++++-
 drivers/cpufreq/exynos-cpufreq.c          |    3 +
 drivers/cpufreq/exynos4x12-cpufreq.c      |    2 +-
 drivers/cpufreq/freq_table.c              |   56 ++++++++++++--
 drivers/thermal/samsung/exynos_tmu_data.c |   47 ++++++++++++
 include/linux/cpufreq.h                   |   24 ++++++
 10 files changed, 302 insertions(+), 79 deletions(-)

-- 
1.7.10.4

