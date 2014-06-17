Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967497AbaFQWEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:04:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54798 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965961AbaFQVwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:52:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 090/212] ACPI: Revert "ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c"
Date: Tue, 17 Jun 2014 14:43:04 -0700
Message-Id: <1403041506-13646-91-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit e2a7c3d7812369daae56f069eab2e8f3e548d231 upstream.

The commit 1e2d9cd and 7d7ee95 remove ACPI Proc Battery
directory and breaks some old userspace tools. This patch
is to revert 7d7ee95.

Fixes: 7d7ee958867a (ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c)
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/Kconfig  |  17 ++++++++
 drivers/acpi/Makefile |   1 +
 drivers/acpi/cm_sbs.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 123 insertions(+)
 create mode 100644 drivers/acpi/cm_sbs.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 436111b..13e1c8a 100644
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
diff --git a/drivers/acpi/cm_sbs.c b/drivers/acpi/cm_sbs.c
new file mode 100644
index 0000000..6c9ee68
--- /dev/null
+++ b/drivers/acpi/cm_sbs.c
@@ -0,0 +1,105 @@
+/*
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
-- 
1.9.1

