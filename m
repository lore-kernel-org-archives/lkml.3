Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaLETEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:04:53 -0500
Received: from service87.mimecast.com ([91.220.42.44]:60411 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaLETEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:04:51 -0500
From: "Javi Merino" <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: punit.agrawal@arm.com, broonie@kernel.org,
        Javi Merino <javi.merino@arm.com>
Subject: [RFC PATCH v6 0/9] The power allocator thermal governor
Date: Fri,  5 Dec 2014 19:04:11 +0000
Message-Id: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
X-OriginalArrivalTime: 05 Dec 2014 19:04:48.0924 (UTC) FILETIME=[575C45C0:01D010BE]
X-MC-Unique: 114120519044901701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id sB5J4xwZ013824

Hi linux-pm,

The power allocator governor allocates device power to control
temperature.  This requires transforming performance requests into
requested power, which we do with an extended cooling device API
introduced in patch 5 (thermal: extend the cooling device API to
include power information).  Patch 6 (thermal: cpu_cooling: implement
the power cooling device API) extends the cpu cooling device using a
simple power model.  The division of power between the cooling devices
ensures that power is allocated where it is needed the most, based on
the current workload.

Patches 1-3 adds array printing helpers to ftrace, which we then use
in patch 8.

Changes since v5:
  - Addressed Stephen's review of the trace patches.
  - Removed power actors and extended the cooling device interface
    instead.
  - Let platforms override the power allocator governor parameters in
    their thermal zone parameters

Changes since v4:
  - Add more tracing
  - Document some of the limitations of the power allocator governor
  - Export the power_actor API and move power_actor.h to include/linux

Changes since v3:
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

Changes since v2:
  - Changed the PI controller into a PID controller
  - Added static power to the cpu power model
  - tz parameter max_dissipatable_power renamed to sustainable_power
  - Register the cpufreq cooling device as part of the
    power_cpu_actor registration.

Changes since v1:
  - Fixed finding cpufreq cooling devices in cpufreq_frequency_change()
  - Replaced the cooling device interface with a separate power actor
    API
  - Addressed most of Eduardo's comments
  - Incorporated ftrace support for bitmask to trace cpumasks

Todo:
  - Expose thermal zone parameters in sysfs
  - Expose new governor parameters in device tree
  - Expose cooling device weights in device tree

Cheers,
Javi & Punit

Dave Martin (1):
  tracing: Add array printing helpers

Javi Merino (7):
  tools lib traceevent: Generalize numeric argument
  tools lib traceevent: Add support for __print_u{8,16,32,64}_array()
  thermal: let governors have private data for each thermal zone
  thermal: extend the cooling device API to include power information
  thermal: cpu_cooling: implement the power cooling device API
  thermal: introduce the Power Allocator governor
  thermal: add trace events to the power allocator governor

Punit Agrawal (1):
  of: thermal: Introduce sustainable power for a thermal zone

 .../devicetree/bindings/thermal/thermal.txt        |   4 +
 Documentation/thermal/cpu-cooling-api.txt          | 144 +++++-
 Documentation/thermal/power_allocator.txt          | 223 +++++++++
 drivers/thermal/Kconfig                            |  15 +
 drivers/thermal/Makefile                           |   1 +
 drivers/thermal/cpu_cooling.c                      | 455 +++++++++++++++++-
 drivers/thermal/of-thermal.c                       |   4 +
 drivers/thermal/power_allocator.c                  | 528 +++++++++++++++++++++
 drivers/thermal/thermal_core.c                     | 128 ++++-
 drivers/thermal/thermal_core.h                     |   8 +
 include/linux/cpu_cooling.h                        |  49 +-
 include/linux/ftrace_event.h                       |   9 +
 include/linux/thermal.h                            |  61 ++-
 include/trace/events/thermal_power_allocator.h     | 138 ++++++
 include/trace/ftrace.h                             |  17 +
 kernel/trace/trace_output.c                        |  51 ++
 tools/lib/traceevent/event-parse.c                 |  88 +++-
 tools/lib/traceevent/event-parse.h                 |   8 +-
 18 files changed, 1886 insertions(+), 45 deletions(-)
 create mode 100644 Documentation/thermal/power_allocator.txt
 create mode 100644 drivers/thermal/power_allocator.c
 create mode 100644 include/trace/events/thermal_power_allocator.h

-- 
1.9.1


