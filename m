Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab3KER1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:27:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:59957 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3KER1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:27:11 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-85-52792a6e240e
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
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH v10 0/7] cpufreq:boost: CPU Boost mode support
Date: Tue, 05 Nov 2013 18:26:44 +0100
Message-id: <1383672411-26324-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t9jQd08rcogg70dshYNV0MsNs5Yz2rx
	tOkHu0XfzyvMFmv2/2Sy6Dz7hNnizSNuizcPNzNaXN41h83ic+8RRovbjSvYLM6cvsRq8eRh
	H5vFxq8eDnwei/e8ZPK4c20Pm8e6aW+ZPbZcbWfx6NuyitHj+I3tTB6fN8kFsEdx2aSk5mSW
	pRbp2yVwZdz4soixoFWy4tasPtYGxuPCXYycHBICJhJvV6xmhrDFJC7cW8/WxcjFISQwnVFi
	/6NDrBBOF5PEygn3WECq2AT0JD7ffcoEkhARWMIo8bppAVgVs8BeZolJf9ayglQJC9hJ7Dtw
	GMxmEVCVWHt9PiOIzSvgJvGn+x8bxD55iaf3+8BsTqD43E8vwGwhAVeJmx9Wskxg5F3AyLCK
	UTS1ILmgOCk910ivODG3uDQvXS85P3cTIzhcn0nvYFzVYHGIUYCDUYmHN0G+MkiINbGsuDL3
	EKMEB7OSCO+x/xVBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZ
	ODilGhiX+xTdlVjwNcBrU6DQAbWehToiwqEXZmkwvHp2xteA4/WnDNPaGY2vWP8qxXQ66xoa
	xB38upPtlMTRn9v4dn5MN89zncbTu2VvslXN5sl5Ecm8E26IsLxjSPF7dn9x08p3dlWXb0mX
	xFy33HjooXm1/zHXCYW/z1bGTo6Q17968f7cW1fnvDRXYinOSDTUYi4qTgQAMe/MylMCAAA=
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
       Exynos 4412 3.12-rc7 Linux
       Intel Core i7-3770 3.12-rc7 Linux

Above patches were posted on top of kernel_pm/bleeding-edge
(SHA1: acc3663ce3f9cde3a7da88fb478531c58d5ed399)


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

