Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422709Ab3LTOZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:25:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:40100 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422667Ab3LTOZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:25:12 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-c2-52b453471669
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org
Subject: [PATCH v12 0/7] cpufreq:boost: CPU Boost mode support
Date: Fri, 20 Dec 2013 15:24:48 +0100
Message-id: <1387549495-809-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t9jQV334C1BBqfuS1psnLGe1eJp0w92
	i76fV5gt1uz/yWTRefYJs8WbR9wWbx5uZrS4vGsOm8Xn3iOMFjPO72OyuN24gs3izOlLrBZP
	HvaxWWz86uHA57F4z0smjzvX9rB5rJv2ltljy9V2Fo++LasYPY7f2M7k8XmTXAB7FJdNSmpO
	Zllqkb5dAlfGqzPyBT8lKvrPZzUw7hXuYuTkkBAwkXj9+A8LhC0mceHeerYuRi4OIYHpjBJn
	nl2FcrqYJO4umcYMUsUmoCfx+e5TJhBbRKCZUeLWcz+QImaBS8wSHUuvghUJC9hJfF8yB6yI
	RUBV4uH1N2BxXgEXiUuT5rBDrFOU6H42gQ3E5hRwk5j76QWYLSTgKnHzw0qWCYy8CxgZVjGK
	phYkFxQnpeca6RUn5haX5qXrJefnbmIEh+oz6R2MqxosDjEKcDAq8fAW6G8OEmJNLCuuzD3E
	KMHBrCTC+9lnS5AQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakFqUUwWSYO
	TqkGRrZL/c1+6f3X/5Q/LpghpHyrqm/FYm7ZMtf0LPHH8Wen6XRnX+/UTBZLfZdT5Z2+IdBx
	26OYi743n/FdPvm3w1Oe77fGtkhWhfufFf5yJh180ffiaYDdpFhr/ql/3qiWxgV+V5p2Xy3O
	wm1Wlln0tcsiwrd2Kv6WEUiacaJmNv/aG7MubbhTrcRSnJFoqMVcVJwIAI9T9XRRAgAA
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
       Exynos 4412 3.13-rc4 Linux
       Intel Core i7-3770 3.13-rc4 Linux

Above patches were posted on top of kernel_pm/bleeding-edge
(SHA1: bd0f3a5d9dce48a917ce1f1047534d79c725149)

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
 drivers/thermal/samsung/exynos_tmu_data.c |   12 +--
 include/linux/cpufreq.h                   |   24 ++++++
 10 files changed, 261 insertions(+), 85 deletions(-)

-- 
1.7.10.4

