Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab3GYQd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:33:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41202 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab3GYQd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:33:56 -0400
X-AuditID: cbfee61a-b7f196d000007dfa-83-51f1537230c8
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
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com
Subject: [PATCH v6 0/8] cpufreq:boost: CPU Boost mode support
Date: Thu, 25 Jul 2013 18:33:23 +0200
Message-id: <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jQd2i4I+BBs23DC02zljPavG06Qe7
	xbzPshZ9P68wW6zZ/5PJovPsE2aL3gVX2SzePOK2ePNwM6PF5V1z2Cw+9x5htLjduILNon9h
	L5PFk4d9bBYbv3o48Hss3vOSyePOtT1sHuumvWX26NuyitHj0eIWRo/jN7YzeXzeJBfAHsVl
	k5Kak1mWWqRvl8CVsXDiedaCV5IVX3v62BoYF4l0MXJySAiYSKzY954FwhaTuHBvPVsXIxeH
	kMB0RomtrTtYIJwuJok7f1+BVbEJ6El8vvuUCcQWEZjDKHHnqDtIEbPAA2aJxd+/MHYxcnAI
	C9hKHJ0vDFLDIqAqcfR1DyOIzSvgJnHi0QyobfIST+/3sYHYnEDxuZ9egNlCAq4SNz+sZJnA
	yLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnDQPpPawbiyweIQowAHoxIPr4LTx0Ah
	1sSy4srcQ4wSHMxKIrzmlkAh3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOFBNITS1KzU1ML
	UotgskwcnFINjGsqvJU//Z/WsvlSiMqmpa7vj5RLv8vN+yHpIl4ra1C06uWBR11eomms7dNW
	bFp7Uq7uTMrEPy6HevWmPt0x7evLrReqJB49XVLN39M7seuRsbTiE9vy76of3m5e47dZoVVt
	24JekfA5TmaNDQcfBtxrP1zEK7Mi/vvNuf4W4hzl2+582ibQlKXEUpyRaKjFXFScCABLgeJV
	VgIAAA==
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

- All available policies are now stored in a list.

- The Boost code doesn't rely on any policy. When boost state is changed,
  then the policy list is iterated and proper adjustements are done.

- To improve safety level, the thermal framework is also extended to disable
  software boosting, when thermal trip point is reached. Then it starts 
  monitoring target temperature to evaluate if boost can be enabled 
  again. This emulates behaviour similar to HW managed boost (like x86)

New patches for v6:
cpufreq:exynos4x12: Change L0 driver data to CPUFREQ_BOOST_FREQ

Tested at HW:
       Exynos 4412 3.11-rc1 Linux
       Intel Core i7-3770 3.11-rc1 Linux


Lukasz Majewski (8):
  cpufreq: Store cpufreq policies in a list
  cpufreq: Add boost frequency support in core
  cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to work with common
    boost solution
  thermal:boost: Automatic enable/disable of BOOST feature
  cpufreq:boost:Kconfig: Provide support for software managed BOOST
  cpufreq:exynos:Extend Exynos cpufreq driver to support boost
    framework
  Documentation:cpufreq:boost: Update BOOST documentation
  cpufreq:exynos4x12: Change L0 driver data to CPUFREQ_BOOST_FREQ

 Documentation/cpu-freq/boost.txt     |   26 +++----
 drivers/cpufreq/Kconfig              |    3 +
 drivers/cpufreq/Kconfig.arm          |   16 +++++
 drivers/cpufreq/acpi-cpufreq.c       |   87 ++++++++----------------
 drivers/cpufreq/cpufreq.c            |  124 +++++++++++++++++++++++++++++++++-
 drivers/cpufreq/exynos-cpufreq.c     |    6 ++
 drivers/cpufreq/exynos4x12-cpufreq.c |    2 +-
 drivers/cpufreq/freq_table.c         |   53 +++++++++++++--
 drivers/thermal/thermal_core.c       |   55 +++++++++++++++
 include/linux/cpufreq.h              |   26 +++++++
 include/linux/thermal.h              |    2 +
 11 files changed, 321 insertions(+), 79 deletions(-)

-- 
1.7.10.4

