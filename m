Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3FFHIh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:08:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30086 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab3FFHIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:08:35 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-f8-51b03571a3a0
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocky" <rjw@sisk.pl>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 0/5] cpufreq:boost: CPU Boost mode support
Date: Thu, 06 Jun 2013 09:07:47 +0200
Message-id: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t9jQd1C0w2BBndeC1v8ebuc1eJp0w92
	i3mfZS06zz5htnjziNvizcPNjBaXd81hs/jce4TR4nbjCjaL/oW9TBYdR74xW2z86uHA43Hn
	2h42j3XT3jJ79G1ZxejxaHELo8fnTXIBrFFcNimpOZllqUX6dglcGauntLIVLBWsmDb/F3sD
	40/eLkZODgkBE4mzp1uZIGwxiQv31rN1MXJxCAlMZ5Rou/GBFSQhJNDFJLF2gS6IzSagJ/H5
	7lOwBhEBX4meZYfAbGaBk8wSd48FgtjCAlYSJxZ+ZOxi5OBgEVCVaD2WCxLmFXCVeH3nA9Qu
	eYmn9/vYJjByL2BkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHE7PpHYwrmywOMQowMGo
	xMMrEbA+UIg1say4MvcQowQHs5IIb6zIhkAh3pTEyqrUovz4otKc1OJDjNIcLErivAdarQOF
	BNITS1KzU1MLUotgskwcnFINjJMXCO1hbs3c4hN+xCjO73leDde7BwvZ+Jfw66yKi5dsvX7Q
	7qjgN82bgjevxQSzX19/gUvaJGj6sX1r1+6Lr9QXfXdzkllB9/Xdqot1Fua9SdBYKKhhbBNU
	fVjbpmnv42MVuUaTLgdFWT5Q3Ww/8R6HvX+CactXg0N5FxbuX1N8Ndhq10rvTUosxRmJhlrM
	RcWJAAWVZRMjAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces support for CPU overclocking technique 
called Boost. 

It is a follow up of a LAB governor proposal. Boost is a LAB component:
http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq

Boost unifies hardware based solution (e.g. Intel Nehalem) with
software oriented one (like the one done at Exynos).
For this reason cpufreq/freq_table code has been reorganized to exclude
common code.

Important design decisions:

- Boost related code is compiled-in unconditionally. I wanted to avoid
situation when a lot of #ifdef CONFIG_CPU_FREQ_BOOST are scattered at
cpufreq code (especially cpufreq.c large file)

- Only one cpufreq_boost instance is created at cpufreq driver file. 

- Boost can manage overclocking when many policies are istalled in
the system (this is a preparation for b.L)

- Boost sysfs attributies are seen only when cpufreq driver supports them.
They will not show up until either CONFIG_CPU_FREQ_BOOST or device tree
cpufreq "boost_mode" attribute is defined.

- No special spin_lock for Boost was created. The one from cpufreq was
reused.

- Low level boost trigger function (*low_level_boost function callback) is
necessary to "glue" together acpi-cpufreq boost with software based one.



Tested at: HW: Exynos 4412 3.10 linux
	   Compile tested x86_64 defconfig (acpi) - help with HW test 
		needed

Lukasz Majewski (5):
  cpufreq: Define cpufreq_set_drv_attr_files() to add per CPU sysfs
    attributes
  cpufreq:boost: Add support for software based CPU frequency boost
  cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to work with common
    boost solution
  cpufreq:exynos:Extend exynos cpufreq driver to support boost
  cpufreq:boost:Kconfig: Enable boost support at Kconfig

 drivers/cpufreq/Kconfig          |    7 ++
 drivers/cpufreq/acpi-cpufreq.c   |   64 ++++++--------
 drivers/cpufreq/cpufreq.c        |  175 ++++++++++++++++++++++++++++++++++++--
 drivers/cpufreq/exynos-cpufreq.c |   48 +++++++++++
 drivers/cpufreq/freq_table.c     |   87 ++++++++++++++++++-
 include/linux/cpufreq.h          |   35 +++++++-
 6 files changed, 369 insertions(+), 47 deletions(-)

-- 
1.7.10.4

