Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347Ab3GRTeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:34:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:37085 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759333Ab3GRTeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:34:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,696,1367996400"; 
   d="scan'208";a="372723109"
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: rjw@sisk.pl, arjan@linux.intel.com, len.brown@intel.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [RFC v00 1/1] PowerCap: Documentation
Date: Thu, 18 Jul 2013 12:34:15 -0700
Message-Id: <1374176055-23527-2-git-send-email-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1374176055-23527-1-git-send-email-srinivas.pandruvada@linux.intel.com>
References: <1374176055-23527-1-git-send-email-srinivas.pandruvada@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added power cap framework documentation. This explains the use of power capping framework,
sys-fs and programming interface.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 Documentation/powercap/PowerCappingFramework.txt | 1008 ++++++++++++++++++++++
 1 file changed, 1008 insertions(+)
 create mode 100644 Documentation/powercap/PowerCappingFramework.txt

diff --git a/Documentation/powercap/PowerCappingFramework.txt b/Documentation/powercap/PowerCappingFramework.txt
new file mode 100644
index 0000000..76eb63d
--- /dev/null
+++ b/Documentation/powercap/PowerCappingFramework.txt
@@ -0,0 +1,1008 @@
+Power Capping Framework
+==================================
+
+The Linux Power Capping Framework provides user-space with a common
+API to kernel-mode power-capping drivers.  At the same time,
+it provides the hardware-specific power-capping drivers with
+a uniform API to user-space.
+
+Terminology
+=========================
+The Power Capping framework organizes power capping devices under a tree structure.
+At the root level, each device is under some "controller", which is the enabler
+of technology. For example this can be "RAPL".
+Under each controllers, there are multiple power zones, which can be independently
+monitored and controlled using this technology.
+Each power zone can be organized as a tree with parent, children and siblings.
+Each power zone defines attributes to enable power monitoring and apply
+constraints on power consumption.
+
+For example, using RAPL, one can independently control CPU packages. Each package is
+further divided in to multiple domains for core uncore, dram devices, which can
+be independently controlled. As the technology gets matured, each uncore and core,
+devices will be further divided into multiple domain. Here domains are called "zones"
+in this documentation.
+
+
+Experimental implantation is using two options:
+Option 1: Use simple device model. Since we can't have duplicate file names under
+a class even if there parents are different (Unlike a Linux directory tree), each
+child will be named using their hierarchy in the tree. For example, a RAPL power
+zone such as a CPU package can be called intel-rapl-0, then its children will be
+named as intel-rapl-0:0, intel-rapl-0:1 etc.
+
+Option 2: Each controller is a device and zones and constraints under it are
+created using kobjects. Here exact names of power zones can be used in the sys-fs
+file names.
+
+The two tree's below presents representation using above options.
+In this system RAPL functionality is implemented in a client driver using power-capping
+framework described here. The sys-fs tree below is generated on a server system,
+with two CPU packages. Each package is further divided into "core", and "dram".
+============================
+Option 1
+
+/sys/devices/virtual/power_cap
+└── intel-rapl
+    ├── intel-rapl:0
+    │   ├── constraint_0_name
+    │   ├── constraint_0_power_limit_uw
+    │   ├── constraint_0_time_window_us
+    │   ├── constraint_1_name
+    │   ├── constraint_1_power_limit_uw
+    │   ├── constraint_1_time_window_us
+    │   ├── device -> ../../intel-rapl  [recursive, not followed]
+    │   ├── energy_uj
+    │   ├── intel-rapl:0:0
+    │   │   ├── constraint_0_name
+    │   │   ├── constraint_0_power_limit_uw
+    │   │   ├── constraint_0_time_window_us
+    │   │   ├── device -> ../../intel-rapl:0  [recursive, not followed]
+    │   │   ├── energy_uj
+    │   │   ├── max_energy_range_uj
+    │   │   ├── name
+    │   │   ├── power
+    │   │   │   ├── async
+    │   │   │   ├── autosuspend_delay_ms
+    │   │   │   ├── control
+    │   │   │   ├── runtime_active_kids
+    │   │   │   ├── runtime_active_time
+    │   │   │   ├── runtime_enabled
+    │   │   │   ├── runtime_status
+    │   │   │   ├── runtime_suspended_time
+    │   │   │   └── runtime_usage
+    │   │   ├── subsystem -> ../../../../../../class/power_cap
+    │   │   │   ├── intel-rapl -> ../../devices/virtual/power_cap/intel-rapl  [recursive, not followed]
+    │   │   │   ├── intel-rapl:0 -> ../../devices/virtual/power_cap/intel-rapl/intel-rapl:0  [recursive, not followed]
+    │   │   │   ├── intel-rapl:0:0 -> ../../devices/virtual/power_cap/intel-rapl/intel-rapl:0/intel-rapl:0:0  [recursive, not followed]
+    │   │   │   ├── intel-rapl:0:1 -> ../../devices/virtual/power_cap/intel-rapl/intel-rapl:0/intel-rapl:0:1
+    │   │   │   │   ├── constraint_0_name
+    │   │   │   │   ├── constraint_0_power_limit_uw
+    │   │   │   │   ├── constraint_0_time_window_us
+    │   │   │   │   ├── device -> ../../intel-rapl:0  [recursive, not followed]
+    │   │   │   │   ├── energy_uj
+    │   │   │   │   ├── max_energy_range_uj
+    │   │   │   │   ├── name
+    │   │   │   │   ├── power
+    │   │   │   │   │   ├── async
+    │   │   │   │   │   ├── autosuspend_delay_ms
+    │   │   │   │   │   ├── control
+    │   │   │   │   │   ├── runtime_active_kids
+    │   │   │   │   │   ├── runtime_active_time
+    │   │   │   │   │   ├── runtime_enabled
+    │   │   │   │   │   ├── runtime_status
+    │   │   │   │   │   ├── runtime_suspended_time
+    │   │   │   │   │   └── runtime_usage
+    │   │   │   │   ├── subsystem -> ../../../../../../class/power_cap  [recursive, not followed]
+    │   │   │   │   └── uevent
+    │   │   │   ├── intel-rapl:1 -> ../../devices/virtual/power_cap/intel-rapl/intel-rapl:1
+    │   │   │   │   ├── constraint_0_name
+    │   │   │   │   ├── constraint_0_power_limit_uw
+    │   │   │   │   ├── constraint_0_time_window_us
+    │   │   │   │   ├── constraint_1_name
+    │   │   │   │   ├── constraint_1_power_limit_uw
+    │   │   │   │   ├── constraint_1_time_window_us
+    │   │   │   │   ├── device -> ../../intel-rapl  [recursive, not followed]
+    │   │   │   │   ├── energy_uj
+    │   │   │   │   ├── intel-rapl:1:0
+    │   │   │   │   │   ├── constraint_0_name
+    │   │   │   │   │   ├── constraint_0_power_limit_uw
+    │   │   │   │   │   ├── constraint_0_time_window_us
+    │   │   │   │   │   ├── device -> ../../intel-rapl:1  [recursive, not followed]
+    │   │   │   │   │   ├── energy_uj
+    │   │   │   │   │   ├── max_energy_range_uj
+    │   │   │   │   │   ├── name
+    │   │   │   │   │   ├── power
+    │   │   │   │   │   │   ├── async
+    │   │   │   │   │   │   ├── autosuspend_delay_ms
+    │   │   │   │   │   │   ├── control
+    │   │   │   │   │   │   ├── runtime_active_kids
+    │   │   │   │   │   │   ├── runtime_active_time
+    │   │   │   │   │   │   ├── runtime_enabled
+    │   │   │   │   │   │   ├── runtime_status
+    │   │   │   │   │   │   ├── runtime_suspended_time
+    │   │   │   │   │   │   └── runtime_usage
+    │   │   │   │   │   ├── subsystem -> ../../../../../../class/power_cap  [recursive, not followed]
+    │   │   │   │   │   └── uevent
+    │   │   │   │   ├── intel-rapl:1:1
+    │   │   │   │   │   ├── constraint_0_name
+    │   │   │   │   │   ├── constraint_0_power_limit_uw
+    │   │   │   │   │   ├── constraint_0_time_window_us
+    │   │   │   │   │   ├── device -> ../../intel-rapl:1  [recursive, not followed]
+    │   │   │   │   │   ├── energy_uj
+    │   │   │   │   │   ├── max_energy_range_uj
+    │   │   │   │   │   ├── name
+    │   │   │   │   │   ├── power
+    │   │   │   │   │   │   ├── async
+    │   │   │   │   │   │   ├── autosuspend_delay_ms
+    │   │   │   │   │   │   ├── control
+    │   │   │   │   │   │   ├── runtime_active_kids
+    │   │   │   │   │   │   ├── runtime_active_time
+    │   │   │   │   │   │   ├── runtime_enabled
+    │   │   │   │   │   │   ├── runtime_status
+    │   │   │   │   │   │   ├── runtime_suspended_time
+    │   │   │   │   │   │   └── runtime_usage
+    │   │   │   │   │   ├── subsystem -> ../../../../../../class/power_cap  [recursive, not followed]
+    │   │   │   │   │   └── uevent
+    │   │   │   │   ├── max_energy_range_uj
+    │   │   │   │   ├── max_power_range_uw
+    │   │   │   │   ├── name
+    │   │   │   │   ├── power
+    │   │   │   │   │   ├── async
+    │   │   │   │   │   ├── autosuspend_delay_ms
+    │   │   │   │   │   ├── control
+    │   │   │   │   │   ├── runtime_active_kids
+    │   │   │   │   │   ├── runtime_active_time
+    │   │   │   │   │   ├── runtime_enabled
+    │   │   │   │   │   ├── runtime_status
+    │   │   │   │   │   ├── runtime_suspended_time
+    │   │   │   │   │   └── runtime_usage
+    │   │   │   │   ├── subsystem -> ../../../../../class/power_cap  [recursive, not followed]
+    │   │   │   │   └── uevent
+    │   │   │   ├── intel-rapl:1:0 -> ../../devices/virtual/power_cap/intel-rapl/intel-rapl:1/intel-rapl:1:0  [recursive, not followed]
+    │   │   │   └── intel-rapl:1:1 -> ../../devices/virtual/power_cap/intel-rapl/intel-rapl:1/intel-rapl:1:1  [recursive, not followed]
+    │   │   └── uevent
+    │   ├── intel-rapl:0:1
+    │   │   ├── constraint_0_name
+    │   │   ├── constraint_0_power_limit_uw
+    │   │   ├── constraint_0_time_window_us
+    │   │   ├── device -> ../../intel-rapl:0  [recursive, not followed]
+    │   │   ├── energy_uj
+    │   │   ├── max_energy_range_uj
+    │   │   ├── name
+    │   │   ├── power
+    │   │   │   ├── async
+    │   │   │   ├── autosuspend_delay_ms
+    │   │   │   ├── control
+    │   │   │   ├── runtime_active_kids
+    │   │   │   ├── runtime_active_time
+    │   │   │   ├── runtime_enabled
+    │   │   │   ├── runtime_status
+    │   │   │   ├── runtime_suspended_time
+    │   │   │   └── runtime_usage
+    │   │   ├── subsystem -> ../../../../../../class/power_cap  [recursive, not followed]
+    │   │   └── uevent
+    │   ├── max_energy_range_uj
+    │   ├── max_power_range_uw
+    │   ├── name
+    │   ├── power
+    │   │   ├── async
+    │   │   ├── autosuspend_delay_ms
+    │   │   ├── control
+    │   │   ├── runtime_active_kids
+    │   │   ├── runtime_active_time
+    │   │   ├── runtime_enabled
+    │   │   ├── runtime_status
+    │   │   ├── runtime_suspended_time
+    │   │   └── runtime_usage
+    │   ├── subsystem -> ../../../../../class/power_cap  [recursive, not followed]
+    │   └── uevent
+    ├── intel-rapl:1
+    │   ├── constraint_0_name
+    │   ├── constraint_0_power_limit_uw
+    │   ├── constraint_0_time_window_us
+    │   ├── constraint_1_name
+    │   ├── constraint_1_power_limit_uw
+    │   ├── constraint_1_time_window_us
+    │   ├── device -> ../../intel-rapl  [recursive, not followed]
+    │   ├── energy_uj
+    │   ├── intel-rapl:1:0
+    │   │   ├── constraint_0_name
+    │   │   ├── constraint_0_power_limit_uw
+    │   │   ├── constraint_0_time_window_us
+    │   │   ├── device -> ../../intel-rapl:1  [recursive, not followed]
+    │   │   ├── energy_uj
+    │   │   ├── max_energy_range_uj
+    │   │   ├── name
+    │   │   ├── power
+    │   │   │   ├── async
+    │   │   │   ├── autosuspend_delay_ms
+    │   │   │   ├── control
+    │   │   │   ├── runtime_active_kids
+    │   │   │   ├── runtime_active_time
+    │   │   │   ├── runtime_enabled
+    │   │   │   ├── runtime_status
+    │   │   │   ├── runtime_suspended_time
+    │   │   │   └── runtime_usage
+    │   │   ├── subsystem -> ../../../../../../class/power_cap  [recursive, not followed]
+    │   │   └── uevent
+    │   ├── intel-rapl:1:1
+    │   │   ├── constraint_0_name
+    │   │   ├── constraint_0_power_limit_uw
+    │   │   ├── constraint_0_time_window_us
+    │   │   ├── device -> ../../intel-rapl:1  [recursive, not followed]
+    │   │   ├── energy_uj
+    │   │   ├── max_energy_range_uj
+    │   │   ├── name
+    │   │   ├── power
+    │   │   │   ├── async
+    │   │   │   ├── autosuspend_delay_ms
+    │   │   │   ├── control
+    │   │   │   ├── runtime_active_kids
+    │   │   │   ├── runtime_active_time
+    │   │   │   ├── runtime_enabled
+    │   │   │   ├── runtime_status
+    │   │   │   ├── runtime_suspended_time
+    │   │   │   └── runtime_usage
+    │   │   ├── subsystem -> ../../../../../../class/power_cap  [recursive, not followed]
+    │   │   └── uevent
+    │   ├── max_energy_range_uj
+    │   ├── max_power_range_uw
+    │   ├── name
+    │   ├── power
+    │   │   ├── async
+    │   │   ├── autosuspend_delay_ms
+    │   │   ├── control
+    │   │   ├── runtime_active_kids
+    │   │   ├── runtime_active_time
+    │   │   ├── runtime_enabled
+    │   │   ├── runtime_status
+    │   │   ├── runtime_suspended_time
+    │   │   └── runtime_usage
+    │   ├── subsystem -> ../../../../../class/power_cap  [recursive, not followed]
+    │   └── uevent
+    ├── power
+    │   ├── async
+    │   ├── autosuspend_delay_ms
+    │   ├── control
+    │   ├── runtime_active_kids
+    │   ├── runtime_active_time
+    │   ├── runtime_enabled
+    │   ├── runtime_status
+    │   ├── runtime_suspended_time
+    │   └── runtime_usage
+    ├── subsystem -> ../../../../class/power_cap  [recursive, not followed]
+    └── uevent
+
+=============================
+Option 2
+
+/sys/devices/virtual/power_cap
+└── intel-rapl
+    ├── package-0
+    │   ├── constraint-0
+    │   │   ├── name
+    │   │   ├── power_limit_uw
+    │   │   └── time_window_us
+    │   ├── constraint-1
+    │   │   ├── name
+    │   │   ├── power_limit_uw
+    │   │   └── time_window_us
+    │   ├── core
+    │   │   ├── constraint-0
+    │   │   │   ├── name
+    │   │   │   ├── power_limit_uw
+    │   │   │   └── time_window_us
+    │   │   ├── energy_uj
+    │   │   └── max_energy_range_uj
+    │   ├── dram
+    │   │   ├── constraint-0
+    │   │   │   ├── name
+    │   │   │   ├── power_limit_uw
+    │   │   │   └── time_window_us
+    │   │   ├── energy_uj
+    │   │   └── max_energy_range_uj
+    │   ├── energy_uj
+    │   ├── max_energy_range_uj
+    │   └── max_power_range_uw
+    ├── package-1
+    │   ├── constraint-0
+    │   │   ├── name
+    │   │   ├── power_limit_uw
+    │   │   └── time_window_us
+    │   ├── constraint-1
+    │   │   ├── name
+    │   │   ├── power_limit_uw
+    │   │   └── time_window_us
+    │   ├── core
+    │   │   ├── constraint-0
+    │   │   │   ├── name
+    │   │   │   ├── power_limit_uw
+    │   │   │   └── time_window_us
+    │   │   ├── energy_uj
+    │   │   └── max_energy_range_uj
+    │   ├── dram
+    │   │   ├── constraint-0
+    │   │   │   ├── name
+    │   │   │   ├── power_limit_uw
+    │   │   │   └── time_window_us
+    │   │   ├── energy_uj
+    │   │   └── max_energy_range_uj
+    │   ├── energy_uj
+    │   ├── max_energy_range_uj
+    │   └── max_power_range_uw
+    ├── power
+    │   ├── async
+    │   ├── autosuspend_delay_ms
+    │   ├── control
+    │   ├── runtime_active_kids
+    │   ├── runtime_active_time
+    │   ├── runtime_enabled
+    │   ├── runtime_status
+    │   ├── runtime_suspended_time
+    │   └── runtime_usage
+    ├── subsystem -> ../../../../class/power_cap
+    │   └── intel-rapl -> ../../devices/virtual/power_cap/intel-rapl  [recursive, not followed]
+    └── uevent
+
+18 directories, 48 files
+
+
+=================================
+
+Power Zone Attributes
+=================================
+Monitoring attributes
+----------------------
+
+energy_uj (rw): Current energy counter in micro-joules. Write to energy counter
+resets the counter to zero. If the counter can not be reset, then this attribute
+is read-only.
+
+max_energy_range_uj (r): Range of the above energy counter in micro-joules.
+
+power_uw (rw): Current power counter in micro-watts. Write to this counter
+resets the counter to zero. If the counter can not be reset, then this attribute
+is read-only.
+max_power_range_uw (r): Range of the above energy counter in micro-watts.
+
+It is possible that some domains can have both power and energy counters and
+ranges, but at least one is mandatory.
+
+Constraints
+----------------
+power_limit_uw (rw): Power limit in micro-watts, which should be applicable for
+the time window specified by "time_window_us".
+time_window_us (rw): Time window in micro seconds.
+name (ro): An optional name of the constraint
+
+Power Cap Client Driver Interface
+==================================
+
+Interface API
+----------------------------------
+powercap_allocate_controller - Allocates a controller
+
+Synopsis:
+
+void * powercap_allocate_controller (const char * controller_name);
+
+Arguments:
+
+controller_name
+	The Name of this controller, which will be shown
+			in the Sys-Fs Interface.
+
+
+Description:
+
+Used to create a controller with the power capping class. Here controller
+can represent a type of technology, which can control a range of power zones.
+For example a controller can be RAPL (Running Average Power Limit)
+Intel® 64 and IA-32 Processor Architectures. The name can be any string
+which must be unique, otherwise this function returns NULL.
+On successful allocation, this API returns a pointer to the
+controller instance.
+
+
+Name:
+
+powercap_deallocate_controller - Deallocates a controller
+
+Synopsis:
+
+void powercap_deallocate_controller (void * instance);
+
+Arguments:
+
+instance
+	A pointer to the valid controller instance.
+
+
+Description:
+
+Used to deallocate a controller with the power capping class. This
+takes only one argument, which is the pointer to the instance returned
+by a call to powercap_allocate_controller.
+When a controller is deallocated, all zones and associated constraints
+are freed.
+
+
+Name:
+
+powercap_zone_register - Register a power zone
+
+Synopsis:
+
+struct powercap_zone_device * powercap_zone_register (void * controller,
+                                                      const char * name,
+                                                      const struct powercap_zone_ops * ops,
+                                                      struct powercap_zone_device * parent);
+
+Arguments:
+
+controller
+	A controller instance under which this zone operates.
+
+name
+	A name for this zone, this will appear in Sys-Fs I/F under
+		a controller or a parent zone name.
+
+ops
+	Pointer to zone operation callback structure.
+
+parent
+	A pointer to the parent power zone instance if any or NULL
+
+
+Description:
+
+Used to register a power zone for a controller. Zones are organized in
+a tree like structure in Sys-Fs under a controller. A power zone name
+may not be unique, if they are in different level of hierarchy similar to
+a file system directory tree.
+A power zone must a register a pointer to a structure representing zone
+callbacks.
+A power zone can have a some other power zone as a parent or it can be
+NULL to appear as a direct descendant of a controller.
+
+
+Name:
+
+powercap_zone_unregister - Unregister a zone device
+
+Synopsis:
+
+int powercap_zone_unregister (void * controller,
+                              struct powercap_zone_device * pcd_dev);
+
+Arguments:
+
+controller
+	A pointer to the valid instance of a controller.
+
+pcd_dev
+	A pointer to the valid zone instance for a controller
+
+
+Description:
+
+Used to unregister a zone device for a controller. Once a zone is
+unregistered then all its children and associated constraints are freed.
+
+
+Name:
+
+powercap_zone_add_constraint - Register a constraint
+
+Synopsis:
+
+struct powercap_zone_constraint * powercap_zone_add_constraint (struct powercap_zone_device * pcd_dev,
+                                                                struct powercap_zone_constraint_ops * ops);
+
+Arguments:
+
+pcd_dev
+	A pointer to the valid zone instance
+
+ops
+	A pointer to the structure defining constraint callbacks
+
+
+Description:
+
+Used to unregister a register a constraint. Multiple constraints can be
+registered to a zone. Each constraint define some power limits and a time
+window over which this constraint is applicable. Time window and power limit
+should be with in limits specified in the corresponding max/min limits.
+On successful registration, it returns a pointer an instance of a constraint.
+
+
+Name:
+
+powercap_zone_remove_constraint - Unregister a constraint
+
+Synopsis:
+
+int powercap_zone_remove_constraint (struct powercap_zone_device * pcd_dev,
+                                     struct powercap_zone_constraint * pconst);
+
+Arguments:
+
+pcd_dev
+	A pointer to the valid zone instance
+
+pconst
+	A valid constraint instance
+
+
+Description:
+
+Used to unregister a constraint from a zone.
+
+
+struct powercap_zone_constraint_ops - Define constraint callbacks
+
+struct powercap_zone_constraint_ops {
+	int (* set_power_limit_uw) (struct powercap_zone_constraint *, unsigned long);
+	int (* get_power_limit_uw) (struct powercap_zone_constraint *, unsigned long *);
+	int (* set_time_window_us) (struct powercap_zone_constraint *, unsigned long);
+	int (* get_time_window_us) (struct powercap_zone_constraint *, unsigned long *);
+	int (* get_max_power_uw) (struct powercap_zone_constraint *, unsigned long *);
+	int (* get_min_power_uw) (struct powercap_zone_constraint *, unsigned long *);
+	int (* get_max_time_window_us) (struct powercap_zone_constraint *, unsigned long *);
+	int (* get_min_time_window_us) (struct powercap_zone_constraint *, unsigned long *);
+};
+
+Members:
+
+set_power_limit_uw
+	Set power limit in micro-watts.
+
+get_power_limit_uw
+	Get power limit in micro-watts.
+
+set_time_window_us
+	Set time window in micro-seconds.
+
+get_time_window_us
+	Get time window in micro-seconds.
+
+get_max_power_uw
+	Get max power allowed in micro-watts.
+
+get_min_power_uw
+	Get min power allowed in micro-watts.
+
+get_max_time_window_us
+	Get max time window allowed in micro-seconds.
+
+get_min_time_window_us
+	Get min time window allowed in micro-seconds.
+
+
+
+Description:
+
+This structure is used to define the constraint callbacks for the client
+drivers. The following callbacks are mandatory and can't be NULL:
+set_power_limit_uw
+get_power_limit_uw
+set_time_window_us
+get_time_window_us
+
+
+struct powercap_zone_constraint - Defines instance of a constraint
+
+struct powercap_zone_constraint {
+	int id;
+	struct kobject kobj;
+	struct completion kobj_unregister;
+	struct powercap_zone_device * pcd_dev;
+	struct powercap_zone_constraint_ops * ops;
+	struct list_head node;
+};
+
+Members:
+
+id
+	Instance Id of this constraint.
+
+kobj
+	Kobject instance.
+
+kobj_unregister
+	Used for block on this completion variable
+
+pcd_dev
+	Pointer to the power zone for this constraint.
+
+ops
+	Pointer to the constraint callbacks.
+
+node
+	Link to other constraints for this power zone.
+
+
+
+Description:
+
+This defines a constraint instance. The fields of this structure are
+private, and should not be used by client drivers.
+
+
+struct powercap_zone_ops - Define power zone callbacks
+
+struct powercap_zone_ops {
+	int (* get_max_energy_range_uj) (struct powercap_zone_device *, unsigned long *);
+	int (* get_energy_uj) (struct powercap_zone_device *, unsigned long *);
+	int (* reset_energy_uj) (struct powercap_zone_device *);
+	int (* get_max_power_range_uw) (struct powercap_zone_device *, unsigned long *);
+	int (* get_power_uw) (struct powercap_zone_device *, unsigned long *);
+	int (* reset_power_uw) (struct powercap_zone_device *);
+};
+
+Members:
+
+get_max_energy_range_uj
+	Get maximum range of energy counter in
+				micro-joules.
+
+get_energy_uj
+	Get current energy counter in micro-joules.
+
+reset_energy_uj
+	Reset micro-joules energy counter.
+
+get_max_power_range_uw
+	Get maximum range of power counter in
+				micro-watts.
+
+get_power_uw
+	Get current power counter in micro-watts.
+
+reset_power_uw
+	Reset micro-watts power counter.
+
+
+
+Description:
+
+This structure defines zone callbacks to be implemented by client drivers.
+Client drives can define both energy and power related callbacks. But at
+the least one type (either power or energy) is mandatory.
+
+
+struct powercap_zone_device - Defines instance of a power cap zone
+
+struct powercap_zone_device {
+	char name[POWERCAP_ZONE_NAME_LENGTH];
+	const struct powercap_zone_ops * ops;
+	struct kobject kobj;
+	void * node;
+	struct completion kobj_unregister;
+	struct mutex lock;
+	struct idr idr;
+	struct list_head constraint_list;
+};
+
+Members:
+
+name[POWERCAP_ZONE_NAME_LENGTH]
+	Power zone name.
+
+ops
+	Pointer to the zone operation structure.
+
+kobj
+	Instance of a kobj.
+
+node
+	Node pointer to insert to a tree data structure.
+
+kobj_unregister
+	Used for block on this completion variable.
+
+lock
+	Mutex to protect zone related operations.
+
+idr
+	Instance to an idr entry.
+
+constraint_list
+	Link to the next power zone for this controller.
+
+
+
+Description:
+
+This defines a power zone instance. The fields of this structure are
+private, and should not be used by client drivers.
+
+
+struct powercap_zone_constraint_ops - Define constraint callbacks
+
+struct powercap_zone_constraint_ops {
+	int (* set_power_limit_uw) (struct powercap_zone_constraint *, unsigned long);
+	int (* get_power_limit_uw) (struct powercap_zone_constraint *, unsigned long *);
+	int (* set_time_window_us) (struct powercap_zone_constraint *, unsigned long);
+	int (* get_time_window_us) (struct powercap_zone_constraint *, unsigned long *);
+	int (* get_max_power_uw) (struct powercap_zone_constraint *, unsigned long *);
+	int (* get_min_power_uw) (struct powercap_zone_constraint *, unsigned long *);
+	int (* get_max_time_window_us) (struct powercap_zone_constraint *, unsigned long *);
+	int (* get_min_time_window_us) (struct powercap_zone_constraint *, unsigned long *);
+	char *(* get_name) (struct powercap_zone_constraint *);
+	void (* cleanup) (struct powercap_zone_constraint *);
+};
+
+Members:
+
+set_power_limit_uw
+	Set power limit in micro-watts.
+
+get_power_limit_uw
+	Get power limit in micro-watts.
+
+set_time_window_us
+	Set time window in micro-seconds.
+
+get_time_window_us
+	Get time window in micro-seconds.
+
+get_max_power_uw
+	Get max power allowed in micro-watts.
+
+get_min_power_uw
+	Get min power allowed in micro-watts.
+
+get_max_time_window_us
+	Get max time window allowed in micro-seconds.
+
+get_min_time_window_us
+	Get min time window allowed in micro-seconds.
+
+get_name
+	Get the name of constraint
+
+cleanup
+	Do any clean up before the constraint is freed
+This structure is used to define the constraint callbacks for the client
+drivers. The following callbacks are mandatory and can't be NULL:
+ set_power_limit_uw
+ get_power_limit_uw
+ set_time_window_us
+ get_time_window_us
+
+
+
+
+
+struct powercap_zone_constraint - Defines instance of a constraint
+
+struct powercap_zone_constraint {
+	int id;
+	struct kobject kobj;
+	struct completion kobj_unregister;
+	struct powercap_zone_device * pcd_dev;
+	struct powercap_zone_constraint_ops * ops;
+	void * drv_data;
+	struct list_head node;
+};
+
+Members:
+
+id
+	Instance Id of this constraint.
+
+kobj
+	Kobject instance.
+
+kobj_unregister
+	Used for block on this completion variable
+
+pcd_dev
+	Pointer to the power zone for this constraint.
+
+ops
+	Pointer to the constraint callbacks.
+
+drv_data
+	Driver private data
+
+node
+	Link to other constraints for this power zone.
+
+
+
+Description:
+
+This defines a constraint instance. The fields of this structure are
+private, and should not be used by client drivers.
+
+
+struct powercap_zone_ops - Define power zone callbacks
+
+struct powercap_zone_ops {
+	int (* get_max_energy_range_uj) (struct powercap_zone_device *, unsigned long *);
+	int (* get_energy_uj) (struct powercap_zone_device *, unsigned long *);
+	int (* reset_energy_uj) (struct powercap_zone_device *);
+	int (* get_max_power_range_uw) (struct powercap_zone_device *, unsigned long *);
+	int (* get_power_uw) (struct powercap_zone_device *, unsigned long *);
+	int (* reset_power_uw) (struct powercap_zone_device *);
+	void (* cleanup) (struct powercap_zone_device *);
+};
+
+Members:
+
+get_max_energy_range_uj
+	Get maximum range of energy counter in
+				micro-joules.
+
+get_energy_uj
+	Get current energy counter in micro-joules.
+
+reset_energy_uj
+	Reset micro-joules energy counter.
+
+get_max_power_range_uw
+	Get maximum range of power counter in
+				micro-watts.
+
+get_power_uw
+	Get current power counter in micro-watts.
+
+reset_power_uw
+	Reset micro-watts power counter.
+
+cleanup
+	Do any clean up before the zone is freed
+
+
+
+Description:
+
+This structure defines zone callbacks to be implemented by client drivers.
+Client drives can define both energy and power related callbacks. But at
+the least one type (either power or energy) is mandatory.
+
+
+struct powercap_zone_device - Defines instance of a power cap zone
+
+struct powercap_zone_device {
+	char name[POWERCAP_ZONE_NAME_LENGTH];
+	void * controller_inst;
+	const struct powercap_zone_ops * ops;
+	struct kobject kobj;
+	void * node;
+	struct completion kobj_unregister;
+	struct mutex lock;
+	struct idr idr;
+	void * drv_data;
+	struct list_head constraint_list;
+};
+
+Members:
+
+name[POWERCAP_ZONE_NAME_LENGTH]
+	Power zone name.
+
+controller_inst
+	Controller instance for this zone
+
+ops
+	Pointer to the zone operation structure.
+
+kobj
+	Instance of a kobj.
+
+node
+	Node pointer to insert to a tree data structure.
+
+kobj_unregister
+	Used for block on this completion variable.
+
+lock
+	Mutex to protect zone related operations.
+
+idr
+	Instance to an idr entry.
+
+drv_data
+	Driver private data
+
+constraint_list
+	Link to the next power zone for this controller.
+
+
+
+Description:
+
+This defines a power zone instance. The fields of this structure are
+private, and should not be used by client drivers.
+
+
+Name:
+
+powercap_set_zone_data - Set private data for a zone
+
+Synopsis:
+
+void powercap_set_zone_data (struct powercap_zone_device * pcd_dev,
+                             void * pdata);
+
+Arguments:
+
+pcd_dev
+	A pointer to the valid zone instance.
+
+pdata
+	A pointer to the user private data.
+
+
+Description:
+
+Allows client drivers to associate some private data to zone instance.
+
+
+Name:
+
+powercap_get_zone_data - Get private data for a zone
+
+Synopsis:
+
+void * powercap_get_zone_data (struct powercap_zone_device * pcd_dev);
+
+Arguments:
+
+pcd_dev
+	A pointer to the valid zone instance.
+
+
+Description:
+
+Allows client drivers to get private data associate with a zone,
+using call to powercap_set_zone_data.
+
+
+Name:
+
+powercap_set_constraint_data - Set private data for a constraint
+
+Synopsis:
+
+void powercap_set_constraint_data (struct powercap_zone_constraint * pconst,
+                                   void * pdata);
+
+Arguments:
+
+pconst
+	A pointer to the valid constraint instance.
+
+pdata
+	A pointer to the user private data.
+
+
+Description:
+
+Allows client drivers to associate some private data to constraint instance.
+
+
+Name:
+
+powercap_get_constraint_data - Get private data for a constraint
+
+Synopsis:
+
+void * powercap_get_constraint_data (struct powercap_zone_constraint * pconst);
+
+Arguments:
+
+pconst
+	A pointer to the valid constraint instance.
+
+
+Description:
+
+Allows client drivers to get private data associate with a constraint,
+using call to powercap_set_constraint_data.
+
-- 
1.8.3.1

