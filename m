Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933956Ab3DBWP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:15:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:62899 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933879Ab3DBWP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:15:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,396,1363158000"; 
   d="scan'208";a="279875720"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: =?UTF-8?q?=5BPATCH=200/1=5D=20RAPL=20=28Running=20Average=20Power=20Limit=29=20driver?=
Date: Tue,  2 Apr 2013 15:15:35 -0700
Message-Id: <1364940936-20846-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RAPL(Running Average Power Limit) interface provides platform software
with the ability to monitor, control, and get notifications on SOC
power consumptions. Since its first appearance on Sandy Bridge, more
features have being added to extend its usage. In RAPL, platforms are
divided into domains for fine grained control. These domains include
package, DRAM controller, CPU core (Power Plane 0), graphics uncore
(power plane 1), etc.

The purpose of this driver is to expose RAPL for userspace
consumption. Overall, RAPL fits in the generic thermal layer in
that platform level power capping and monitoring are mainly used for
thermal management and thermal layer provides the abstracted interface
needed to have portable applications.

Specifically, userspace is presented with per domain cooling device
with sysfs links to its kobject. Although RAPL domain provides many
parameters for fine tuning, long term power limit is exposed as the
single knob via cooling device state. Whereas the rest of the
parameters are still accessible via the linked kobject. This simplifies
the interface for both simple and advanced use cases.

DETAILS
=======
1. sysfs layout

As an x86 platform driver, RAPL driver binds with supported CPU ids
during probing phase. Once domains are discovered, kobjets are created
for each domain which are also linked with cooling devices after its
registration with the generic thermal layer.

e.g.package RAPL domain registered as cooling device #15, link "device"
back to its kobject.

/sys/class/thermal/cooling_device15/
├── cur_state
├── device -> ../../../platform/intel_rapl/rapl_domains/package
├── max_state
├── power
├── subsystem -> ../../../../class/thermal
├── type
└── uevent

In driver's private sysfs area, domains kobjects are grouped under a
kset which exposes global data.
/sys/devices/platform/intel_rapl/
├── driver -> ../../../bus/platform/drivers/intel_rapl
├── power
├── rapl_domains
│   ├── package
│   │   └── thermal_cooling
-> ../../../../virtual/thermal/cooling_device15  
│   ├── power_plane_0
│   │   └── thermal_cooling
-> ../../../../virtual/thermal/cooling_device16  
│   └── power_plane_1
│       └── thermal_cooling
-> ../../../../virtual/thermal/cooling_device18  
└── subsystem -> ../../../bus/platform


2. per domain parameters

These are the fine tuning parameters only used by advanced
power/thermal management applications. Refer to Intel SDM ch14 for
details.

root@chromoly:/sys/class/thermal/cooling_device15/device# grep . *
domain_name:package
energy:924228
lock:0
max_power:0
max_window:0
min_power:0
pl1_clamp:1
pl1_enable:1
pl2_clamp:0
pl2_enable:1
power:2276
power_limit1:12000
power_limit2:31250
thermal_spec_power:17000
throttle_time:
time_window1:28000
time_window2:0

3. event notifications

RAPL driver uses eventfd to provide userspace notifications on selected
events. A file node called "event_control" is created for each RAPL
domain. User can write control file descriptor, eventfd descriptor, and
threshold to event_control file. Then, user application can use
poll/select or blocking read to get notifications from the driver.
Multiple events are allowed for each domain but only a single threshold
is accepted.

4. Usage Examples (assume the topology in the sysfs layout above)

- set power limit to package domain (whole SOC package) to 6w
root@chromoly:~# echo 6000
	> /sys/class/thermal/cooling_device15/cur_state  

- set power limit to pp1 domain (graphics) to 4w
root@chromoly:~# echo 4000
	> /sys/class/thermal/cooling_device18/cur_state  

- check the current power usage in mWatts of pp1 domain
root@chromoly:~# cat  /sys/class/thermal/cooling_device18/cur_state 
61

- set event notification when power consumption of graphics unit crosses
  5w.
root@chromoly:~#
  event_fd_listener /sys/class/thermal/cooling_device18/device/power 5000
(event_fd_listener opens control file power and creates an eventfd,
then write efd, cfd, threshold to event_control file of the given
domain)


Caveats:

1. Package power limit events are supported by legacy thermal reporting
mechanism, which uses local APIC thermal vector to generate interrupts
when targeted P-states are not honored by the HW/FW. This is tied to
machine check reporting. Until RAPL is used, this notification is a rare
exception. When RAPL power limit is set artifically low, this
notification could result in unwanted interrupts for each power limit
excursion. Therefore, RAPL driver attempts to turn off the power limit
notification interrupt when user sets a power limit.

2. By Intel Software Developer's Manual, RAPL interface can report
max/min power for certain domains. But in reality HW often reports 0
for max/min power. RAPL driver tackles this problem by using thermal
specification power or current power limit1 when max power information
is not available. The result is that the max_state of a RAPL cooling
device can be based on thermal spec power or power limit 1.

3. Since RAPL is backed by FW. In case of FW failure or plain lack of
support, setting RAPL power limit could result in silent failure. I
don't have a good solution for that.

4. Data polling starts only when the following items are set
	- power limit
	- events


Jacob Pan (1):
  Introduce Intel RAPL cooling device driver

 drivers/platform/x86/Kconfig      |    8 +
 drivers/platform/x86/Makefile     |    1 +
 drivers/platform/x86/intel_rapl.c | 1323 +++++++++++++++++++++++++++++++++++++
 drivers/platform/x86/intel_rapl.h |  249 +++++++
 4 files changed, 1581 insertions(+)
 create mode 100644 drivers/platform/x86/intel_rapl.c
 create mode 100644 drivers/platform/x86/intel_rapl.h

-- 
1.7.9.5

