Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaFCKTE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:19:04 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60753 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaFCKTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:19:02 -0400
From: "Javi Merino" <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: punit.agrawal@arm.com, Javi Merino <javi.merino@arm.com>
Subject: [RFC PATCH v3 0/7] The power allocator thermal governor
Date: Tue,  3 Jun 2014 11:18:28 +0100
Message-Id: <1401790715-5630-1-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
X-OriginalArrivalTime: 03 Jun 2014 10:18:55.0867 (UTC) FILETIME=[39DA1CB0:01CF7F15]
X-MC-Unique: 114060311185914101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s53AJ95t004057

Hi linux-pm,

The power allocator governor allocates device power to control
temperature.  This requires transforming performance requests into
requested power, which we do with the aid of power models.  Patch 5
(thermal: add a basic cpu power actor) implements a simple power model
for cpus.  The division of power between the actors ensures that power
is allocated where it is needed the most, based on the current
workload.

Patches 1 and 2 are not proper parts of these series and can be merged
separately.  Patch 1 (tracing: Add __bitmask() macro to trace events
to cpumasks and other bitmasks) is already in for-next[1].  Patch 2
(thermal: document struct thermal_zone_device and thermal_governor)
has already been submitted to linux-pm[2] and is generic.

[1] https://git.kernel.org/cgit/linux/kernel/git/rostedt/linux-trace.git/commit/?h=for-next&id=4449bf927b61b
db4389393c6fea6837214d1ace7
[2] http://article.gmane.org/gmane.linux.power-management.general/46041

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
  - Fix kerneldoc strings
  - Use tz->passive
  - Use cpufreq_get() to get the frequency of the cpu instead of
    using the notifiers.
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

Steven Rostedt (Red Hat) (1):
  tracing: Add __bitmask() macro to trace events to cpumasks and other
    bitmasks

 Documentation/thermal/power_actor.txt     | 164 ++++++++
 Documentation/thermal/power_allocator.txt |  42 +++
 drivers/thermal/Kconfig                   |  23 ++
 drivers/thermal/Makefile                  |   3 +
 drivers/thermal/power_actor/Kconfig       |   9 +
 drivers/thermal/power_actor/Makefile      |   7 +
 drivers/thermal/power_actor/cpu_actor.c   | 606 ++++++++++++++++++++++++++++++
 drivers/thermal/power_actor/power_actor.c |  64 ++++
 drivers/thermal/power_actor/power_actor.h | 105 ++++++
 drivers/thermal/power_allocator.c         | 465 +++++++++++++++++++++++
 drivers/thermal/thermal_core.c            |  90 ++++-
 drivers/thermal/thermal_core.h            |   8 +
 include/linux/ftrace_event.h              |   3 +
 include/linux/thermal.h                   |  62 ++-
 include/linux/trace_seq.h                 |  10 +
 include/trace/events/thermal.h            |  38 ++
 include/trace/events/thermal_governor.h   |  37 ++
 include/trace/ftrace.h                    |  57 ++-
 kernel/trace/trace_output.c               |  41 ++
 19 files changed, 1822 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/thermal/power_actor.txt
 create mode 100644 Documentation/thermal/power_allocator.txt
 create mode 100644 drivers/thermal/power_actor/Kconfig
 create mode 100644 drivers/thermal/power_actor/Makefile
 create mode 100644 drivers/thermal/power_actor/cpu_actor.c
 create mode 100644 drivers/thermal/power_actor/power_actor.c
 create mode 100644 drivers/thermal/power_actor/power_actor.h
 create mode 100644 drivers/thermal/power_allocator.c
 create mode 100644 include/trace/events/thermal.h
 create mode 100644 include/trace/events/thermal_governor.h

-- 
1.9.1


