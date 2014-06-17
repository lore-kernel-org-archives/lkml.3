Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbaFQJPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 05:15:14 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51664 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbaFQJPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 05:15:12 -0400
From: "Javi Merino" <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: punit.agrawal@arm.com, broonie@kernel.org,
        Javi Merino <javi.merino@arm.com>
Subject: [RFC PATCH v4 0/7] The power allocator thermal governor
Date: Tue, 17 Jun 2014 10:14:46 +0100
Message-Id: <1402996493-3578-1-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
X-OriginalArrivalTime: 17 Jun 2014 09:14:59.0846 (UTC) FILETIME=[9D304260:01CF8A0C]
X-MC-Unique: 114061710150816601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s5H9FMxt005744

Hi linux-pm,

The power allocator governor allocates device power to control
temperature.  This requires transforming performance requests into
requested power, which we do with the aid of power models.  Patch 4
(thermal: add a basic cpu power actor) implements a simple power model
for cpus.  The division of power between the actors ensures that power
is allocated where it is needed the most, based on the current
workload.

Patch 1 is a generic documentation of the current thermal framework
and can be merged separately.

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
  - Add more tracing and provide scripts to evaluate the proposal.
  - Tune it to achieve the temperature stability we are aiming for

Cheers,
Javi & Punit

Javi Merino (6):
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
 Documentation/thermal/power_allocator.txt          |  41 ++
 drivers/thermal/Kconfig                            |  21 +
 drivers/thermal/Makefile                           |   5 +
 drivers/thermal/cpu_actor.c                        | 484 +++++++++++++++++++++
 drivers/thermal/of-thermal.c                       |   4 +
 drivers/thermal/power_actor.c                      |  68 +++
 drivers/thermal/power_actor.h                      |  91 ++++
 drivers/thermal/power_allocator.c                  | 477 ++++++++++++++++++++
 drivers/thermal/thermal_core.c                     |  90 +++-
 drivers/thermal/thermal_core.h                     |   8 +
 include/linux/thermal.h                            |  63 ++-
 include/trace/events/thermal_power.h               |  62 +++
 14 files changed, 1588 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/thermal/power_actor.txt
 create mode 100644 Documentation/thermal/power_allocator.txt
 create mode 100644 drivers/thermal/cpu_actor.c
 create mode 100644 drivers/thermal/power_actor.c
 create mode 100644 drivers/thermal/power_actor.h
 create mode 100644 drivers/thermal/power_allocator.c
 create mode 100644 include/trace/events/thermal_power.h

-- 
1.9.1


