Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3HBSIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 14:08:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:15984 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754840Ab3HBSIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 14:08:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="380916736"
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [RFC v01 1/3] PowerCap: Documentation
Date: Fri,  2 Aug 2013 11:08:50 -0700
Message-Id: <1375466932-11842-2-git-send-email-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com>
References: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=a
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added power cap framework documentation. This explains the use of power capping framework,
sys-fs and programming interface.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 Documentation/powercap/PowerCappingFramework.txt | 677 +++++++++++++++++++++++
 1 file changed, 677 insertions(+)
 create mode 100644 Documentation/powercap/PowerCappingFramework.txt

diff --git a/Documentation/powercap/PowerCappingFramework.txt b/Documentation/powercap/PowerCappingFramework.txt
new file mode 100644
index 0000000..74a4563
--- /dev/null
+++ b/Documentation/powercap/PowerCappingFramework.txt
@@ -0,0 +1,677 @@
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
+monitored and controlled.
+Each power zone can be organized as a tree with parent, children and siblings.
+Each power zone defines attributes to enable power monitoring and constraints.
+
+Example Sysfs interface tree:
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
+    │   ├── device -> ../../intel-rapl
+    │   ├── energy_uj
+    │   ├── intel-rapl:0:0
+    │   │   ├── constraint_0_name
+    │   │   ├── constraint_0_power_limit_uw
+    │   │   ├── constraint_0_time_window_us
+    │   │   ├── constraint_1_name
+    │   │   ├── constraint_1_power_limit_uw
+    │   │   ├── constraint_1_time_window_us
+    │   │   ├── device -> ../../intel-rapl:0
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
+    │   │   ├── type
+    │   │   └── uevent
+    │   ├── intel-rapl:0:1
+    │   │   ├── constraint_0_name
+    │   │   ├── constraint_0_power_limit_uw
+    │   │   ├── constraint_0_time_window_us
+    │   │   ├── constraint_1_name
+    │   │   ├── constraint_1_power_limit_uw
+    │   │   ├── constraint_1_time_window_us
+    │   │   ├── device -> ../../intel-rapl:0
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
+    │   │   ├── type
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
+    │   ├── subsystem -> ../../../../../class/power_cap
+    │   ├── type
+    │   └── uevent
+    ├── intel-rapl:1
+    │   ├── constraint_0_name
+    │   ├── constraint_0_power_limit_uw
+    │   ├── constraint_0_time_window_us
+    │   ├── constraint_1_name
+    │   ├── constraint_1_power_limit_uw
+    │   ├── constraint_1_time_window_us
+    │   ├── device -> ../../intel-rapl
+    │   ├── energy_uj
+    │   ├── intel-rapl:1:0
+    │   │   ├── constraint_0_name
+    │   │   ├── constraint_0_power_limit_uw
+    │   │   ├── constraint_0_time_window_us
+    │   │   ├── constraint_1_name
+    │   │   ├── constraint_1_power_limit_uw
+    │   │   ├── constraint_1_time_window_us
+    │   │   ├── device -> ../../intel-rapl:1
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
+    │   │   ├── type
+    │   │   └── uevent
+    │   ├── intel-rapl:1:1
+    │   │   ├── constraint_0_name
+    │   │   ├── constraint_0_power_limit_uw
+    │   │   ├── constraint_0_time_window_us
+    │   │   ├── constraint_1_name
+    │   │   ├── constraint_1_power_limit_uw
+    │   │   ├── constraint_1_time_window_us
+    │   │   ├── device -> ../../intel-rapl:1
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
+    │   │   ├── type
+    │   │   └── uevent
+    │   ├── max_energy_range_uj
+    │   ├── max_power_range_uw
+    │   ├── name
+    │   ├── powerintel-rapl:0
+    │   │   ├── async
+    │   │   ├── autosuspend_delay_ms
+    │   │   ├── control
+    │   │   ├── runtime_active_kids
+    │   │   ├── runtime_active_time
+    │   │   ├── runtime_enabled
+    │   │   ├── runtime_status
+    │   │   ├── runtime_suspended_time
+    │   │   └── runtime_usage
+    │   ├── subsystem -> ../../../../../class/power_cap
+    │   ├── type
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
+    ├── subsystem -> ../../../../class/power_cap
+    ├── type
+    └── uevent
+
+
+For example, above powercap sysfs tree represents RAPL(Running Average Power Limit)
+type controls available in the Intel® 64 and IA-32 Processor Architectures. Here
+under controller "intel-rapl" there are two CPU packages (package-0/1), which can
+provide power monitoring and controls (intel-rapl:0 and intel-rapl:1). Each power
+zone has a name.
+For example:
+cat /sys/class/power_cap/intel-rapl/intel-rapl:0/name
+package-0
+ 
+In addition to providing monitoring and control at package level, each package
+is further divided into child power zones (called domains in the RAPL specifications).
+Here zones represent controls for core and dram  parts. These zones can be represented
+as children of package.
+For example:
+cat /sys/class/power_cap/intel-rapl/intel-rapl:0/intel-rapl:0:1/name
+dram
+
+Under RAPL framework there are two constraints, one for
+short term and one for long term, with two different time windows. These can be
+represented as two constraints, with different time windows, power limits and names.
+For example:
+	constraint_0_name
+	constraint_0_power_limit_uw
+	constraint_0_time_window_us
+	constraint_1_name
+	constraint_1_power_limit_uw
+	constraint_1_time_window_us
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
+max_energy_range_uj (ro): Range of the above energy counter in micro-joules.
+
+power_uw (rw): Current power counter in micro-watts. Write to this counter
+resets the counter to zero. If the counter can not be reset, then this attribute
+is read-only.
+max_power_range_uw (ro): Range of the above energy counter in micro-watts.
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
+In addition each node has an attribute "type", which shows, whether is a controller
+or power zone.
+
+Power Cap Client Driver Interface
+==================================
+The API summary:
+
+Call powercap_allocate_controller to define a controller with a name.
+Call powercap_zone_register for each power zone for this controller.
+power zones can have other power zone as a parent or don't have a
+parent.
+During powercap_zone_register defines number of constraints and callbacks.
+
+To Free a power zone call powercap_zone_unregister.
+To free a controller call powercap_deallocate_controller.
+
+Rest of this document is generated by using kernel-doc on
+powercap.h
+
+struct powercap_zone_constraint_ops - Define constraint callbacks
+
+struct powercap_zone_constraint_ops {
+	int (* set_power_limit_uw) (struct powercap_zone_device *, int, u64);
+	int (* get_power_limit_uw) (struct powercap_zone_device *, int, u64 *);
+	int (* set_time_window_us) (struct powercap_zone_device *, int, u64);
+	int (* get_time_window_us) (struct powercap_zone_device *, int, u64 *);
+	int (* get_max_power_uw) (struct powercap_zone_device *, int, u64 *);
+	int (* get_min_power_uw) (struct powercap_zone_device *, int, u64 *);
+	int (* get_max_time_window_us) (struct powercap_zone_device *, int, u64 *);
+	int (* get_min_time_window_us) (struct powercap_zone_device *, int, u64 *);
+	const char *(* get_name) (struct powercap_zone_device *, int);
+	void (* cleanup) (struct powercap_zone_device *, int);
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
+ get_name
+
+
+
+
+
+struct powercap_controller - Defines a powercap controller
+
+struct powercap_controller {
+	char name[POWERCAP_CTRL_NAME_LENGTH + 1];
+	struct device device;
+	struct idr idr;
+	void * root_node;
+	struct mutex node_lock;
+	struct list_head ctrl_inst;
+};
+
+Members:
+
+name[POWERCAP_CTRL_NAME_LENGTH + 1]
+	name of controller
+
+device
+	device for this controller
+
+idr
+	idr to have unique id for its child
+
+root_node
+	Root holding power zones for this controller
+
+node_lock
+	mutex for node
+
+ctrl_inst
+	link to the controller list
+
+
+
+Description:
+
+Defines powercap controller instance
+
+
+struct powercap_zone_ops - Define power zone callbacks
+
+struct powercap_zone_ops {
+	int (* get_max_energy_range_uj) (struct powercap_zone_device *, u64 *);
+	int (* get_energy_uj) (struct powercap_zone_device *, u64 *);
+	int (* reset_energy_uj) (struct powercap_zone_device *);
+	int (* get_max_power_range_uw) (struct powercap_zone_device *, u64 *);
+	int (* get_power_uw) (struct powercap_zone_device *, u64 *);
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
+struct powercap_zone_attr - Defines a per zone attribute group
+
+struct powercap_zone_attr {
+	struct attribute * zone_dev_attrs[POWERCAP_ZONE_MAX_ATTRS];
+	int zone_attr_count;
+	struct attribute * const_dev_attrs[POWERCAP_CONSTRAINTS_MAX_ATTRS];
+	int const_attr_count;
+	struct attribute_group dev_zone_attr_group;
+	struct attribute_group dev_const_attr_group;
+	int attr_grp_cnt;
+	const struct attribute_group * dev_attr_groups[POWERCAP_MAX_ATTR_GROUPS + 1];
+};
+
+Members:
+
+zone_dev_attrs[POWERCAP_ZONE_MAX_ATTRS]
+	Device attribute list for power zone.
+
+zone_attr_count
+	Number of power zone attributes.
+
+const_dev_attrs[POWERCAP_CONSTRAINTS_MAX_ATTRS]
+	Constraint attributes.
+
+const_attr_count
+	Number of constraint related attributes
+
+dev_zone_attr_group
+	Attribute group for power zone attributes
+
+dev_const_attr_group
+	Attribute group for constraints
+
+attr_grp_cnt
+	Number of attribute groups
+
+dev_attr_groups[POWERCAP_MAX_ATTR_GROUPS + 1]
+	Used to assign to dev->group
+
+
+
+Description:
+
+Used to add an attribute group unique to a zone based on registry.
+
+
+struct powercap_zone_device - Defines instance of a power cap zone
+
+struct powercap_zone_device {
+	int id;
+	char * zone_dev_name;
+	char name[POWERCAP_ZONE_NAME_LENGTH + 1];
+	void * controller_inst;
+	const struct powercap_zone_ops * ops;
+	struct device device;
+	struct powercap_zone_attr attrs;
+	void * node;
+	int const_id_cnt;
+	struct mutex lock;
+	struct idr idr;
+	struct idr * par_idr;
+	void * drv_data;
+	struct list_head constraint_list;
+};
+
+Members:
+
+id
+	Unique id
+
+zone_dev_name
+	Zone device sysfs node name
+
+name[POWERCAP_ZONE_NAME_LENGTH + 1]
+	Power zone name.
+
+controller_inst
+	Controller instance for this zone
+
+ops
+	Pointer to the zone operation structure.
+
+device
+	Instance of a device.
+
+attrs
+	Attributes associated with this device
+
+node
+	Node pointer to insert to a tree data structure.
+
+const_id_cnt
+	Constraint id count
+
+lock
+	Mutex to protect zone related operations.
+
+idr
+	Instance to an idr entry for children zones.
+
+par_idr
+	To remove reference from the parent idr
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
+powercap_allocate_controller - Allocates a controller
+
+Synopsis:
+
+struct powercap_controller * powercap_allocate_controller (const char * controller_name);
+
+Arguments:
+
+controller_name
+	The Name of this controller, which will be shown
+			in the sysfs Interface.
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
+void powercap_deallocate_controller (struct powercap_controller * instance);
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
+struct powercap_zone_device * powercap_zone_register (struct powercap_controller * controller,
+                                                      const char * name,
+                                                      struct powercap_zone_device * parent,
+                                                      const struct powercap_zone_ops * ops,
+                                                      int no_constraints,
+                                                      struct powercap_zone_constraint_ops * const_ops);
+
+Arguments:
+
+controller
+	A controller instance under which this zone operates.
+
+name
+	A name for this zone.
+
+parent
+	A pointer to the parent power zone instance if any or NULL
+
+ops
+	Pointer to zone operation callback structure.
+
+no_constraints
+	Number of constraints for this zone
+
+const_ops
+	Pointer to constraint callback structure
+
+
+Description:
+
+Used to register a power zone for a controller. Zones are organized in
+a tree like structure in sysfs under a controller.
+A power zone must a register a pointer to a structure representing zone
+callbacks.
+A power zone can have a some other power zone as a parent or it can be
+NULL to appear as a direct descendant of a controller.
+Each power zone can have number of constraints. Constraints appears
+under zones as attributes with unique id.
+
+
+Name:
+
+powercap_zone_unregister - Unregister a zone device
+
+Synopsis:
+
+int powercap_zone_unregister (struct powercap_controller * controller,
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
-- 
1.8.3.1

