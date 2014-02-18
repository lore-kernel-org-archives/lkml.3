Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaBRUdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 15:33:15 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47405 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaBRUdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 15:33:07 -0500
From: Nishanth Menon <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [RFC PATCH 0/6] PM: introduce voltage domain abstraction
Date: Tue, 18 Feb 2014 14:32:17 -0600
Message-ID: <1392755543-28335-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On many SoCs such as OMAP, hardware blocks are isolated into voltage
domains allowing for individual tweaks for optimal power-performance
tradeoffs. Frameworks such as cpufreq, devfreq provide a top level
control of these hardware blocks. Most SoCs have different knobs to
fine tune the voltages. They may supply multiple supplies to various
voltage planes on the same voltage domains.

Regulator framework provides us a with an appropriate representation
of consumer model, however, we lack the abstraction necessary to
isolate the necessary sequencing for a specific voltage domain.

There has been few attempts previously taken such as [3] [4],
this series is a further development of of Mike's series[1] where
cpufreq-cpu0 driver was first targetted with clk notifiers. While I do
understand the concerns Mike has in [2], this could be a base on which
further work may be done.

In a nutshell, this (for cpufreq-cpu0 as an example):
maintains the legacy definitions used by cpufreq/devfreq such as:
&cpu0 {
	cpu0-supply = <&regulator_x>;
};

on other SoCs where this might turn out to be a more detailed
implementation,
&cpu0 {
	cpu0-voltdm = <&voltdm_x>;
};

To enure this is split off from clk framework, I chose
drivers/power/voltdm as the location for the new files, I'd love to
hear opinions and suggestions on the approach.

The series is based on 3.14-rc3 and is available here:
https://github.com/nmenon/linux-2.6-playground/commits/push/voltdm-notifier-rfc

A testing branch for Beagle-XM (OMAP3630 as testbed):
	https://github.com/nmenon/linux-2.6-playground/commits/testing/beagle-xm-voltdm-notifier-rfc
	Log: http://slexy.org/view/s20TgkN7kf

NOTE: TI platforms potentially need further development, however, this
forms the basis of the development.

Mike Turquette (2):
  PM / Voltagedomain: Add generic clk notifier handler for regulator
    based dynamic voltage scaling
  cpufreq: cpufreq-cpu0: use clk rate-change notifiers

Nishanth Menon (4):
  PM / Voltagedomain: introduce voltage domain driver support
  devicetree: bindings: add documentation for voltagedomain
  PM / Voltagedomain: introduce basic voltage domain support for OMAP
  devicetree: bindings: voltagedomain: add bindings for OMAP compatible
    SoCs

 .../bindings/power/voltdm/voltage_domain.txt       |   65 +++
 .../bindings/power/voltdm/voltdm_omap.txt          |   24 +
 drivers/cpufreq/Kconfig                            |    1 +
 drivers/cpufreq/cpufreq-cpu0.c                     |  140 ++----
 drivers/power/Kconfig                              |    1 +
 drivers/power/Makefile                             |    1 +
 drivers/power/voltdm/Kconfig                       |   19 +
 drivers/power/voltdm/Makefile                      |    6 +
 drivers/power/voltdm/core.c                        |  508 ++++++++++++++++++++
 drivers/power/voltdm/voltage_domain_private.h      |   86 ++++
 drivers/power/voltdm/voltdm_omap.c                 |  287 +++++++++++
 include/linux/pm_voltage_domain.h                  |   47 ++
 12 files changed, 1086 insertions(+), 99 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/voltdm/voltage_domain.txt
 create mode 100644 Documentation/devicetree/bindings/power/voltdm/voltdm_omap.txt
 create mode 100644 drivers/power/voltdm/Kconfig
 create mode 100644 drivers/power/voltdm/Makefile
 create mode 100644 drivers/power/voltdm/core.c
 create mode 100644 drivers/power/voltdm/voltage_domain_private.h
 create mode 100644 drivers/power/voltdm/voltdm_omap.c
 create mode 100644 include/linux/pm_voltage_domain.h

[1] https://lkml.org/lkml/2013/7/7/110 (original RFC)
[2] http://marc.info/?l=linux-arm-kernel&m=137947787621572&w=2 (runtime pm should enable regulator)
[3] http://marc.info/?t=136603111700006&r=1&w=2
[4] http://git.omapzoom.org/?p=kernel/omap.git;a=blob;f=arch/arm/mach-omap2/dvfs.c;hb=p-linux-omap-3.4
-- 
1.7.9.5

