Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaGJOTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:19:10 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43660 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbaGJOTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:19:06 -0400
From: "Javi Merino" <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: punit.agrawal@arm.com, broonie@kernel.org,
        Javi Merino <javi.merino@arm.com>
Subject: [RFC PATCH v5 00/10] The power allocator thermal governor
Date: Thu, 10 Jul 2014 15:18:38 +0100
Message-Id: <1405001928-12697-1-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
X-OriginalArrivalTime: 10 Jul 2014 14:19:00.0893 (UTC) FILETIME=[E53364D0:01CF9C49]
X-MC-Unique: 114071015190406801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s6AEJJ3j009810

Hi linux-pm,

The power allocator governor allocates device power to control
temperature.  This requires transforming performance requests into
requested power, which we do with the aid of power models.  Patch 7
(thermal: add a basic cpu power actor) implements a simple power model
for cpus.  The division of power between the actors ensures that power
is allocated where it is needed the most, based on the current
workload.

Patches 1-3 adds array printing helpers to ftrace, which we then use
in patch 9.  Patch 4 is a generic documentation of the current thermal
framework and can be merged separately.

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
  - Rethink the use of trip points and make it less intrusive
  - Let platforms override the power allocator governor parameters
  - Provide scripts to evaluate the proposal
  - Let the governor operate on cooling devices as well

Cheers,
Javi & Punit

Dave Martin (1):
  tracing: Add array printing helpers

Javi Merino (8):
  tools lib traceevent: Generalize numeric argument
  tools lib traceevent: Add support for __print_u{8,16,32,64}_array()
  thermal: document struct thermal_zone_device and thermal_governor
  thermal: let governors have private data for each thermal zone
  thermal: introduce the Power Actor API
  thermal: add a basic cpu power actor
  thermal: introduce the Power Allocator governor
  thermal: add trace events to the power allocator governor

Punit Agrawal (1):
  of: thermal: Introduce sustainable power for a thermal zone

 .../devicetree/bindings/thermal/thermal.txt        |   4 +
 Documentation/thermal/power_actor.txt              | 181 ++++++++
 Documentation/thermal/power_allocator.txt          |  61 +++
 drivers/thermal/Kconfig                            |  23 +
 drivers/thermal/Makefile                           |   5 +
 drivers/thermal/cpu_actor.c                        | 501 +++++++++++++++++++++
 drivers/thermal/of-thermal.c                       |   4 +
 drivers/thermal/power_actor.c                      |  70 +++
 drivers/thermal/power_allocator.c                  | 485 ++++++++++++++++++++
 drivers/thermal/thermal_core.c                     |  90 +++-
 drivers/thermal/thermal_core.h                     |   8 +
 include/linux/ftrace_event.h                       |   9 +
 include/linux/power_actor.h                        |  86 ++++
 include/linux/thermal.h                            |  63 ++-
 include/trace/events/thermal_power_allocator.h     | 138 ++++++
 include/trace/ftrace.h                             |  17 +
 kernel/trace/trace_output.c                        |  55 +++
 tools/lib/traceevent/event-parse.c                 |  88 +++-
 tools/lib/traceevent/event-parse.h                 |   8 +-
 19 files changed, 1865 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/thermal/power_actor.txt
 create mode 100644 Documentation/thermal/power_allocator.txt
 create mode 100644 drivers/thermal/cpu_actor.c
 create mode 100644 drivers/thermal/power_actor.c
 create mode 100644 drivers/thermal/power_allocator.c
 create mode 100644 include/linux/power_actor.h
 create mode 100644 include/trace/events/thermal_power_allocator.h

-- 
1.9.1


