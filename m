Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbbA1UiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:38:19 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:45516 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933651AbbA1UiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:38:11 -0500
From: Javi Merino <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: punit.agrawal@arm.com, broonie@kernel.org,
        Javi Merino <javi.merino@arm.com>
Subject: [PATCH v1 0/7] The power allocator thermal governor
Date: Wed, 28 Jan 2015 17:00:31 +0000
Message-Id: <1422464438-16761-1-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi linux-pm,

The power allocator governor allocates device power to control
temperature.  This requires transforming performance requests into
requested power, which we do with an extended cooling device API
introduced in patch 2 (thermal: extend the cooling device API to
include power information).  Patch 3 (thermal: cpu_cooling: implement
the power cooling device API) extends the cpu cooling device using a
simple power model.

This series depend on the array printing helper v5[0] and the weight
fixes[1].  Rui said that he had applied patch 1 (thermal: let
governors have private data for each thermal zone) but I can't see it
in his tree, so I'm reposting it.

[0] http://mid.gmane.org/1422449335-8289-1-git-send-email-javi.merino%40arm.com
[1] http://thread.gmane.org/gmane.linux.power-management.general/55730

Changes since RFC v6:
  - Addressed Eduardo's review
    + Pass the interval to the static power function as suggested by
      Eduardo
    + Make the cooling device ops return 0 or -E* and put the
      calculation in a parameter, like the rest of the cooling device
      ops
    + Documentation improvements
  - Use thermal_cdev_update() to change cooling device states
  - Add a patch to export the power allocator governor's tzp
    parameters to sysfs

Changes since RFC v5:
  - Addressed Stephen's review of the trace patches.
  - Removed power actors and extended the cooling device interface
    instead.
  - Let platforms override the power allocator governor parameters in
    their thermal zone parameters

Changes since RFC v4:
  - Add more tracing
  - Document some of the limitations of the power allocator governor
  - Export the power_actor API and move power_actor.h to include/linux

Changes since RFC v3:
  - Use tz->passive to poll faster when the first trip point is hit.
  - Don't make a special directory for power_actors
  - Add a DT property for sustainable-power
  - Simplify the static power interface and pass the current thermal
    zone in every power_actor_ops to remove the controversial
    enum power_actor_types
  - Use locks with the actor_list list
  - Use cpufreq_get() to get the frequency of the cpu instead of
    using the notifiers.
  - Remove the prompt for THERMAL_POWER_ACTOR_CPU when configuring
    the kernel

Changes since RFC v2:
  - Changed the PI controller into a PID controller
  - Added static power to the cpu power model
  - tz parameter max_dissipatable_power renamed to sustainable_power
  - Register the cpufreq cooling device as part of the
    power_cpu_actor registration.

Changes since RFC v1:
  - Fixed finding cpufreq cooling devices in cpufreq_frequency_change()
  - Replaced the cooling device interface with a separate power actor
    API
  - Addressed most of Eduardo's comments
  - Incorporated ftrace support for bitmask to trace cpumasks

Cheers,
Javi & Punit

Javi Merino (6):
  thermal: let governors have private data for each thermal zone
  thermal: extend the cooling device API to include power information
  thermal: cpu_cooling: implement the power cooling device API
  thermal: introduce the Power Allocator governor
  thermal: add trace events to the power allocator governor
  thermal: export thermal_zone_parameters to sysfs

Punit Agrawal (1):
  of: thermal: Introduce sustainable power for a thermal zone

 .../devicetree/bindings/thermal/thermal.txt        |   9 +
 Documentation/thermal/cpu-cooling-api.txt          | 156 ++++++-
 Documentation/thermal/power_allocator.txt          | 241 ++++++++++
 Documentation/thermal/sysfs-api.txt                |  52 +++
 drivers/thermal/Kconfig                            |  15 +
 drivers/thermal/Makefile                           |   1 +
 drivers/thermal/cpu_cooling.c                      | 507 ++++++++++++++++++++-
 drivers/thermal/of-thermal.c                       |   4 +
 drivers/thermal/power_allocator.c                  | 496 ++++++++++++++++++++
 drivers/thermal/thermal_core.c                     | 254 ++++++++++-
 drivers/thermal/thermal_core.h                     |   8 +
 include/linux/cpu_cooling.h                        |  39 ++
 include/linux/thermal.h                            |  64 ++-
 include/trace/events/thermal.h                     |  58 +++
 include/trace/events/thermal_power_allocator.h     |  80 ++++
 15 files changed, 1964 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/thermal/power_allocator.txt
 create mode 100644 drivers/thermal/power_allocator.c
 create mode 100644 include/trace/events/thermal_power_allocator.h

-- 
1.9.1

