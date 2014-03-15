Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbaCOR1R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 13:27:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:37573 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543AbaCOR1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 13:27:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,661,1389772800"; 
   d="scan'208";a="473179590"
Message-ID: <53248D6D.1010405@intel.com>
Date: Sat, 15 Mar 2014 13:27:09 -0400
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Stefan Lippers-Hollmann <s.L-H@gmx.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.14-rc: /proc/acpi/battery gone?
References: <20140314211456.GA23213@amd.pavel.ucw.cz> <CAKb7Uvh1TaNLmi0YVBPmCD571ZU_sM1DpbYUSA8xQZnS5xUbCA@mail.gmail.com> <1677000.FsvVVRjEvo@vostro.rjw.lan> <201403150217.50526.s.L-H@gmx.de> <532471EC.1070107@intel.com> <20140315160545.GA6689@amd.pavel.ucw.cz>
In-Reply-To: <20140315160545.GA6689@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2014 12:05 PM, Pavel Machek wrote:
> Hi!
>
>>>>> They have attempted to use the sysfs api, but apparently that
>>>>> integration was done with an older version of that API. There's also
>>>>> some attempt to get it to work with upower, but I couldn't figure out
>>>>> how to make that work either on my (up-to-date gentoo) box. (TBH I
>>>>> didn't spend more than an hour or two on it, so it may not be
>>>>> impossible.)
>>>>
>>>> Tianyu, can you please have a look at this?
>>>
>>> Disclaimer, I've never used wmbattery so far.
>>>
>>> The current upstream version (2.42, released in early december 2013)
>>> of wmbattery[1] no longer reads from /proc/acpi/ at all. Apparently
>>> it changed to using upower by default, with non-default fall-backs for
>>> reading from sysfs.
>>>
>>> The only change required for building upower with wmbattery 2.42
>>> appears to be a new build-dependency on libupower-glib-dev (at least
>>> on Debian, built from the upower source package). Given that this
>>> version is present in Debian testing and unstable, I'd assume that it's
>>> supposed to work using upower, although I haven't confirmed that myself.
>>>
>>> Judging from the Gentoo ebuild, you probably just have to add
>>> "sys-power/upower" to the RDEPEND variable and make sure to build
>>> wmbattery 2.42; this is untested.
>>>
>>
>> Hi Stefan:
>> 	I just glance wmbattery code. I find the code in the acpi.c is
>> already using the new sysfs battery interfaces, right?
>>
>> ...
>>
>> #define SYSFS_PATH "/sys/class/power_supply"
>>
>> ...
>> char *acpi_labels[] = {
>> 	"uevent",
>> 	"status",
>> 	"BAT",
>> 	"AC",
>> 	"POWER_SUPPLY_CAPACITY=",
>> 	"POWER_SUPPLY_??????_FULL_DESIGN=", /* CHARGE or ENERGY */
>> 	"POWER_SUPPLY_PRESENT=",
>> 	"POWER_SUPPLY_??????_NOW=",
>> 	"POWER_SUPPLY_CURRENT_NOW=",
>> 	"POWER_SUPPLY_STATUS=",
>> #if ACPI_THERMAL
>> 	"thermal_zone",
>> #endif
>> 	"POWER_SUPPLY_ONLINE=",
>> 	"POWER_SUPPLY_??????_FULL=",
>> 	NULL
>> };
>
> New kernel should work with old userspace... and clearly it does not.
>
> Do you have test patch for a revert?
>
> 									Pavel

Please try this patch.

commit 6cb7ea8975bf8ffafd893204f55eddd1aebd8ff6
Author: Lan Tianyu <tianyu.lan@intel.com>
Date:   Sat Mar 15 12:20:15 2014 -0400

     Revert "ACPI / Battery: Remove battery's proc directory" and "ACPI: 
Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c"

     The commit 1e2d9cd and 7d7ee95 remove ACPI Proc Battery
     directory and breaks some old userspace tools. This patch
     is to revert them.

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index f60f11d..c9231b1 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -43,6 +43,23 @@ config ACPI_SLEEP
  	depends on SUSPEND || HIBERNATION
  	default y

+config ACPI_PROCFS_POWER
+	bool "Deprecated power /proc/acpi directories"
+	depends on PROC_FS
+	help
+	  For backwards compatibility, this option allows
+          deprecated power /proc/acpi/ directories to exist, even when
+          they have been replaced by functions in /sys.
+          The deprecated directories (and their replacements) include:
+	  /proc/acpi/battery/* (/sys/class/power_supply/*)
+	  /proc/acpi/ac_adapter/* (sys/class/power_supply/*)
+	  This option has no effect on /proc/acpi/ directories
+	  and functions, which do not yet exist in /sys
+	  This option, together with the proc directories, will be
+	  deleted in 2.6.39.
+
+	  Say N to delete power /proc/acpi/ directories that have moved to /sys/
+
  config ACPI_EC_DEBUGFS
  	tristate "EC read/write access through /sys/kernel/debug/ec"
  	default n
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 0331f91..bce34af 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -47,6 +47,7 @@ acpi-y				+= sysfs.o
  acpi-$(CONFIG_X86)		+= acpi_cmos_rtc.o
  acpi-$(CONFIG_DEBUG_FS)		+= debugfs.o
  acpi-$(CONFIG_ACPI_NUMA)	+= numa.o
+acpi-$(CONFIG_ACPI_PROCFS_POWER) += cm_sbs.o
  ifdef CONFIG_ACPI_VIDEO
  acpi-y				+= video_detect.o
  endif
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 797a693..22c8696 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -36,6 +36,12 @@
  #include <linux/suspend.h>
  #include <asm/unaligned.h>

+#ifdef CONFIG_ACPI_PROCFS_POWER
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <asm/uaccess.h>
+#endif
+
  #include <linux/acpi.h>
  #include <linux/power_supply.h>

@@ -66,6 +72,19 @@ static unsigned int cache_time = 1000;
  module_param(cache_time, uint, 0644);
  MODULE_PARM_DESC(cache_time, "cache time in milliseconds");

+#ifdef CONFIG_ACPI_PROCFS_POWER
+extern struct proc_dir_entry *acpi_lock_battery_dir(void);
+extern void *acpi_unlock_battery_dir(struct proc_dir_entry 
*acpi_battery_dir);
+
+enum acpi_battery_files {
+	info_tag = 0,
+	state_tag,
+	alarm_tag,
+	ACPI_BATTERY_NUMFILES,
+};
+
+#endif
+
  static const struct acpi_device_id battery_device_ids[] = {
  	{"PNP0C0A", 0},
  	{"", 0},
@@ -301,6 +320,14 @@ static enum power_supply_property 
energy_battery_props[] = {
  	POWER_SUPPLY_PROP_SERIAL_NUMBER,
  };

+#ifdef CONFIG_ACPI_PROCFS_POWER
+inline char *acpi_battery_units(struct acpi_battery *battery)
+{
+	return (battery->power_unit == ACPI_BATTERY_POWER_UNIT_MA) ?
+		"mA" : "mW";
+}
+#endif
+
  /* 
--------------------------------------------------------------------------
                                 Battery Management
 
-------------------------------------------------------------------------- 
*/
@@ -719,6 +746,279 @@ static void acpi_battery_refresh(struct 
acpi_battery *battery)
  }

  /* 
--------------------------------------------------------------------------
+                              FS Interface (/proc)
+ 
-------------------------------------------------------------------------- 
*/
+
+#ifdef CONFIG_ACPI_PROCFS_POWER
+static struct proc_dir_entry *acpi_battery_dir;
+
+static int acpi_battery_print_info(struct seq_file *seq, int result)
+{
+	struct acpi_battery *battery = seq->private;
+
+	if (result)
+		goto end;
+
+	seq_printf(seq, "present:                 %s\n",
+		   acpi_battery_present(battery) ? "yes" : "no");
+	if (!acpi_battery_present(battery))
+		goto end;
+	if (battery->design_capacity == ACPI_BATTERY_VALUE_UNKNOWN)
+		seq_printf(seq, "design capacity:         unknown\n");
+	else
+		seq_printf(seq, "design capacity:         %d %sh\n",
+			   battery->design_capacity,
+			   acpi_battery_units(battery));
+
+	if (battery->full_charge_capacity == ACPI_BATTERY_VALUE_UNKNOWN)
+		seq_printf(seq, "last full capacity:      unknown\n");
+	else
+		seq_printf(seq, "last full capacity:      %d %sh\n",
+			   battery->full_charge_capacity,
+			   acpi_battery_units(battery));
+
+	seq_printf(seq, "battery technology:      %srechargeable\n",
+		   (!battery->technology)?"non-":"");
+
+	if (battery->design_voltage == ACPI_BATTERY_VALUE_UNKNOWN)
+		seq_printf(seq, "design voltage:          unknown\n");
+	else
+		seq_printf(seq, "design voltage:          %d mV\n",
+			   battery->design_voltage);
+	seq_printf(seq, "design capacity warning: %d %sh\n",
+		   battery->design_capacity_warning,
+		   acpi_battery_units(battery));
+	seq_printf(seq, "design capacity low:     %d %sh\n",
+		   battery->design_capacity_low,
+		   acpi_battery_units(battery));
+	seq_printf(seq, "cycle count:		  %i\n", battery->cycle_count);
+	seq_printf(seq, "capacity granularity 1:  %d %sh\n",
+		   battery->capacity_granularity_1,
+		   acpi_battery_units(battery));
+	seq_printf(seq, "capacity granularity 2:  %d %sh\n",
+		   battery->capacity_granularity_2,
+		   acpi_battery_units(battery));
+	seq_printf(seq, "model number:            %s\n", battery->model_number);
+	seq_printf(seq, "serial number:           %s\n", battery->serial_number);
+	seq_printf(seq, "battery type:            %s\n", battery->type);
+	seq_printf(seq, "OEM info:                %s\n", battery->oem_info);
+      end:
+	if (result)
+		seq_printf(seq, "ERROR: Unable to read battery info\n");
+	return result;
+}
+
+static int acpi_battery_print_state(struct seq_file *seq, int result)
+{
+	struct acpi_battery *battery = seq->private;
+
+	if (result)
+		goto end;
+
+	seq_printf(seq, "present:                 %s\n",
+		   acpi_battery_present(battery) ? "yes" : "no");
+	if (!acpi_battery_present(battery))
+		goto end;
+
+	seq_printf(seq, "capacity state:          %s\n",
+			(battery->state & 0x04) ? "critical" : "ok");
+	if ((battery->state & 0x01) && (battery->state & 0x02))
+		seq_printf(seq,
+			   "charging state:          charging/discharging\n");
+	else if (battery->state & 0x01)
+		seq_printf(seq, "charging state:          discharging\n");
+	else if (battery->state & 0x02)
+		seq_printf(seq, "charging state:          charging\n");
+	else
+		seq_printf(seq, "charging state:          charged\n");
+
+	if (battery->rate_now == ACPI_BATTERY_VALUE_UNKNOWN)
+		seq_printf(seq, "present rate:            unknown\n");
+	else
+		seq_printf(seq, "present rate:            %d %s\n",
+			   battery->rate_now, acpi_battery_units(battery));
+
+	if (battery->capacity_now == ACPI_BATTERY_VALUE_UNKNOWN)
+		seq_printf(seq, "remaining capacity:      unknown\n");
+	else
+		seq_printf(seq, "remaining capacity:      %d %sh\n",
+			   battery->capacity_now, acpi_battery_units(battery));
+	if (battery->voltage_now == ACPI_BATTERY_VALUE_UNKNOWN)
+		seq_printf(seq, "present voltage:         unknown\n");
+	else
+		seq_printf(seq, "present voltage:         %d mV\n",
+			   battery->voltage_now);
+      end:
+	if (result)
+		seq_printf(seq, "ERROR: Unable to read battery state\n");
+
+	return result;
+}
+
+static int acpi_battery_print_alarm(struct seq_file *seq, int result)
+{
+	struct acpi_battery *battery = seq->private;
+
+	if (result)
+		goto end;
+
+	if (!acpi_battery_present(battery)) {
+		seq_printf(seq, "present:                 no\n");
+		goto end;
+	}
+	seq_printf(seq, "alarm:                   ");
+	if (!battery->alarm)
+		seq_printf(seq, "unsupported\n");
+	else
+		seq_printf(seq, "%u %sh\n", battery->alarm,
+				acpi_battery_units(battery));
+      end:
+	if (result)
+		seq_printf(seq, "ERROR: Unable to read battery alarm\n");
+	return result;
+}
+
+static ssize_t acpi_battery_write_alarm(struct file *file,
+					const char __user * buffer,
+					size_t count, loff_t * ppos)
+{
+	int result = 0;
+	char alarm_string[12] = { '\0' };
+	struct seq_file *m = file->private_data;
+	struct acpi_battery *battery = m->private;
+
+	if (!battery || (count > sizeof(alarm_string) - 1))
+		return -EINVAL;
+	if (!acpi_battery_present(battery)) {
+		result = -ENODEV;
+		goto end;
+	}
+	if (copy_from_user(alarm_string, buffer, count)) {
+		result = -EFAULT;
+		goto end;
+	}
+	alarm_string[count] = '\0';
+	battery->alarm = simple_strtol(alarm_string, NULL, 0);
+	result = acpi_battery_set_alarm(battery);
+      end:
+	if (!result)
+		return count;
+	return result;
+}
+
+typedef int(*print_func)(struct seq_file *seq, int result);
+
+static print_func acpi_print_funcs[ACPI_BATTERY_NUMFILES] = {
+	acpi_battery_print_info,
+	acpi_battery_print_state,
+	acpi_battery_print_alarm,
+};
+
+static int acpi_battery_read(int fid, struct seq_file *seq)
+{
+	struct acpi_battery *battery = seq->private;
+	int result = acpi_battery_update(battery);
+	return acpi_print_funcs[fid](seq, result);
+}
+
+#define DECLARE_FILE_FUNCTIONS(_name) \
+static int acpi_battery_read_##_name(struct seq_file *seq, void *offset) \
+{ \
+	return acpi_battery_read(_name##_tag, seq); \
+} \
+static int acpi_battery_##_name##_open_fs(struct inode *inode, struct 
file *file) \
+{ \
+	return single_open(file, acpi_battery_read_##_name, PDE_DATA(inode)); \
+}
+
+DECLARE_FILE_FUNCTIONS(info);
+DECLARE_FILE_FUNCTIONS(state);
+DECLARE_FILE_FUNCTIONS(alarm);
+
+#undef DECLARE_FILE_FUNCTIONS
+
+#define FILE_DESCRIPTION_RO(_name) \
+	{ \
+	.name = __stringify(_name), \
+	.mode = S_IRUGO, \
+	.ops = { \
+		.open = acpi_battery_##_name##_open_fs, \
+		.read = seq_read, \
+		.llseek = seq_lseek, \
+		.release = single_release, \
+		.owner = THIS_MODULE, \
+		}, \
+	}
+
+#define FILE_DESCRIPTION_RW(_name) \
+	{ \
+	.name = __stringify(_name), \
+	.mode = S_IFREG | S_IRUGO | S_IWUSR, \
+	.ops = { \
+		.open = acpi_battery_##_name##_open_fs, \
+		.read = seq_read, \
+		.llseek = seq_lseek, \
+		.write = acpi_battery_write_##_name, \
+		.release = single_release, \
+		.owner = THIS_MODULE, \
+		}, \
+	}
+
+static const struct battery_file {
+	struct file_operations ops;
+	umode_t mode;
+	const char *name;
+} acpi_battery_file[] = {
+	FILE_DESCRIPTION_RO(info),
+	FILE_DESCRIPTION_RO(state),
+	FILE_DESCRIPTION_RW(alarm),
+};
+
+#undef FILE_DESCRIPTION_RO
+#undef FILE_DESCRIPTION_RW
+
+static int acpi_battery_add_fs(struct acpi_device *device)
+{
+	struct proc_dir_entry *entry = NULL;
+	int i;
+
+	printk(KERN_WARNING PREFIX "Deprecated procfs I/F for battery is loaded,"
+			" please retry with CONFIG_ACPI_PROCFS_POWER cleared\n");
+	if (!acpi_device_dir(device)) {
+		acpi_device_dir(device) = proc_mkdir(acpi_device_bid(device),
+						     acpi_battery_dir);
+		if (!acpi_device_dir(device))
+			return -ENODEV;
+	}
+
+	for (i = 0; i < ACPI_BATTERY_NUMFILES; ++i) {
+		entry = proc_create_data(acpi_battery_file[i].name,
+					 acpi_battery_file[i].mode,
+					 acpi_device_dir(device),
+					 &acpi_battery_file[i].ops,
+					 acpi_driver_data(device));
+		if (!entry)
+			return -ENODEV;
+	}
+	return 0;
+}
+
+static void acpi_battery_remove_fs(struct acpi_device *device)
+{
+	int i;
+	if (!acpi_device_dir(device))
+		return;
+	for (i = 0; i < ACPI_BATTERY_NUMFILES; ++i)
+		remove_proc_entry(acpi_battery_file[i].name,
+				  acpi_device_dir(device));
+
+	remove_proc_entry(acpi_device_bid(device), acpi_battery_dir);
+	acpi_device_dir(device) = NULL;
+}
+
+#endif
+
+/* 
--------------------------------------------------------------------------
                                   Driver Interface
 
-------------------------------------------------------------------------- 
*/

@@ -791,6 +1091,15 @@ static int acpi_battery_add(struct acpi_device 
*device)
  	result = acpi_battery_update(battery);
  	if (result)
  		goto fail;
+#ifdef CONFIG_ACPI_PROCFS_POWER
+	result = acpi_battery_add_fs(device);
+#endif
+	if (result) {
+#ifdef CONFIG_ACPI_PROCFS_POWER
+		acpi_battery_remove_fs(device);
+#endif
+		goto fail;
+	}

  	printk(KERN_INFO PREFIX "%s Slot [%s] (battery %s)\n",
  		ACPI_BATTERY_DEVICE_NAME, acpi_device_bid(device),
@@ -817,6 +1126,9 @@ static int acpi_battery_remove(struct acpi_device 
*device)
  		return -EINVAL;
  	battery = acpi_driver_data(device);
  	unregister_pm_notifier(&battery->pm_nb);
+#ifdef CONFIG_ACPI_PROCFS_POWER
+	acpi_battery_remove_fs(device);
+#endif
  	sysfs_remove_battery(battery);
  	mutex_destroy(&battery->lock);
  	mutex_destroy(&battery->sysfs_lock);
@@ -864,10 +1176,21 @@ static void __init acpi_battery_init_async(void 
*unused, async_cookie_t cookie)
  {
  	if (acpi_disabled)
  		return;
-
  	if (dmi_check_system(bat_dmi_table))
  		battery_bix_broken_package = 1;
-	acpi_bus_register_driver(&acpi_battery_driver);
+
+#ifdef CONFIG_ACPI_PROCFS_POWER
+	acpi_battery_dir = acpi_lock_battery_dir();
+	if (!acpi_battery_dir)
+		return;
+#endif
+	if (acpi_bus_register_driver(&acpi_battery_driver) < 0) {
+#ifdef CONFIG_ACPI_PROCFS_POWER
+		acpi_unlock_battery_dir(acpi_battery_dir);
+#endif
+		return;
+	}
+	return;
  }

  static int __init acpi_battery_init(void)
@@ -879,6 +1202,9 @@ static int __init acpi_battery_init(void)
  static void __exit acpi_battery_exit(void)
  {
  	acpi_bus_unregister_driver(&acpi_battery_driver);
+#ifdef CONFIG_ACPI_PROCFS_POWER
+	acpi_unlock_battery_dir(acpi_battery_dir);
+#endif
  }

  module_init(acpi_battery_init);
diff --git a/drivers/acpi/cm_sbs.c b/drivers/acpi/cm_sbs.c
new file mode 100644
index 0000000..6c9ee68
--- /dev/null
+++ b/drivers/acpi/cm_sbs.c
@@ -0,0 +1,105 @@
+/*
+ * 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or (at
+ *  your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/acpi.h>
+#include <linux/types.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <acpi/acpi_bus.h>
+#include <acpi/acpi_drivers.h>
+
+#define PREFIX "ACPI: "
+
+ACPI_MODULE_NAME("cm_sbs");
+#define ACPI_AC_CLASS		"ac_adapter"
+#define ACPI_BATTERY_CLASS	"battery"
+#define _COMPONENT		ACPI_SBS_COMPONENT
+static struct proc_dir_entry *acpi_ac_dir;
+static struct proc_dir_entry *acpi_battery_dir;
+
+static DEFINE_MUTEX(cm_sbs_mutex);
+
+static int lock_ac_dir_cnt;
+static int lock_battery_dir_cnt;
+
+struct proc_dir_entry *acpi_lock_ac_dir(void)
+{
+	mutex_lock(&cm_sbs_mutex);
+	if (!acpi_ac_dir)
+		acpi_ac_dir = proc_mkdir(ACPI_AC_CLASS, acpi_root_dir);
+	if (acpi_ac_dir) {
+		lock_ac_dir_cnt++;
+	} else {
+		printk(KERN_ERR PREFIX
+				  "Cannot create %s\n", ACPI_AC_CLASS);
+	}
+	mutex_unlock(&cm_sbs_mutex);
+	return acpi_ac_dir;
+}
+EXPORT_SYMBOL(acpi_lock_ac_dir);
+
+void acpi_unlock_ac_dir(struct proc_dir_entry *acpi_ac_dir_param)
+{
+	mutex_lock(&cm_sbs_mutex);
+	if (acpi_ac_dir_param)
+		lock_ac_dir_cnt--;
+	if (lock_ac_dir_cnt == 0 && acpi_ac_dir_param && acpi_ac_dir) {
+		remove_proc_entry(ACPI_AC_CLASS, acpi_root_dir);
+		acpi_ac_dir = NULL;
+	}
+	mutex_unlock(&cm_sbs_mutex);
+}
+EXPORT_SYMBOL(acpi_unlock_ac_dir);
+
+struct proc_dir_entry *acpi_lock_battery_dir(void)
+{
+	mutex_lock(&cm_sbs_mutex);
+	if (!acpi_battery_dir) {
+		acpi_battery_dir =
+		    proc_mkdir(ACPI_BATTERY_CLASS, acpi_root_dir);
+	}
+	if (acpi_battery_dir) {
+		lock_battery_dir_cnt++;
+	} else {
+		printk(KERN_ERR PREFIX
+				  "Cannot create %s\n", ACPI_BATTERY_CLASS);
+	}
+	mutex_unlock(&cm_sbs_mutex);
+	return acpi_battery_dir;
+}
+EXPORT_SYMBOL(acpi_lock_battery_dir);
+
+void acpi_unlock_battery_dir(struct proc_dir_entry *acpi_battery_dir_param)
+{
+	mutex_lock(&cm_sbs_mutex);
+	if (acpi_battery_dir_param)
+		lock_battery_dir_cnt--;
+	if (lock_battery_dir_cnt == 0 && acpi_battery_dir_param
+	    && acpi_battery_dir) {
+		remove_proc_entry(ACPI_BATTERY_CLASS, acpi_root_dir);
+		acpi_battery_dir = NULL;
+	}
+	mutex_unlock(&cm_sbs_mutex);
+	return;
+}
+EXPORT_SYMBOL(acpi_unlock_battery_dir);

>

