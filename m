Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab3JKByh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:54:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:24789 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284Ab3JKByJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:54:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1076,1371106800"; 
   d="scan'208";a="373229442"
From: tianyu.lan@intel.com
To: lenb@kernel.org, rjw@sisk.pl
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH 4/5] ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c
Date: Fri, 11 Oct 2013 09:54:10 +0800
Message-Id: <1381456451-22877-4-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1381456451-22877-1-git-send-email-tianyu.lan@intel.com>
References: <1381456451-22877-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

There is no user of cm_sbs.c and CONFIG_ACPI_PROCFS_POWER. So remove
them. Prepare for removing /proc/acpi

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/Kconfig  |  17 --------
 drivers/acpi/Makefile |   1 -
 drivers/acpi/cm_sbs.c | 105 --------------------------------------------------
 3 files changed, 123 deletions(-)
 delete mode 100644 drivers/acpi/cm_sbs.c

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 3278a21..b45671c 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -56,23 +56,6 @@ config ACPI_PROCFS
 
 	  Say N to delete /proc/acpi/ files that have moved to /sys/
 
-config ACPI_PROCFS_POWER
-	bool "Deprecated power /proc/acpi directories"
-	depends on PROC_FS
-	help
-	  For backwards compatibility, this option allows
-          deprecated power /proc/acpi/ directories to exist, even when
-          they have been replaced by functions in /sys.
-          The deprecated directories (and their replacements) include:
-	  /proc/acpi/battery/* (/sys/class/power_supply/*)
-	  /proc/acpi/ac_adapter/* (sys/class/power_supply/*)
-	  This option has no effect on /proc/acpi/ directories
-	  and functions, which do not yet exist in /sys
-	  This option, together with the proc directories, will be
-	  deleted in 2.6.39.
-
-	  Say N to delete power /proc/acpi/ directories that have moved to /sys/
-
 config ACPI_EC_DEBUGFS
 	tristate "EC read/write access through /sys/kernel/debug/ec"
 	default n
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 81dbeb8..1cadbef 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -47,7 +47,6 @@ acpi-y				+= sysfs.o
 acpi-$(CONFIG_X86)		+= acpi_cmos_rtc.o
 acpi-$(CONFIG_DEBUG_FS)		+= debugfs.o
 acpi-$(CONFIG_ACPI_NUMA)	+= numa.o
-acpi-$(CONFIG_ACPI_PROCFS_POWER) += cm_sbs.o
 ifdef CONFIG_ACPI_VIDEO
 acpi-y				+= video_detect.o
 endif
diff --git a/drivers/acpi/cm_sbs.c b/drivers/acpi/cm_sbs.c
deleted file mode 100644
index 6c9ee68..0000000
--- a/drivers/acpi/cm_sbs.c
+++ /dev/null
@@ -1,105 +0,0 @@
-/*
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or (at
- *  your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful, but
- *  WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- *  General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
- *
- * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/acpi.h>
-#include <linux/types.h>
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
-
-#define PREFIX "ACPI: "
-
-ACPI_MODULE_NAME("cm_sbs");
-#define ACPI_AC_CLASS		"ac_adapter"
-#define ACPI_BATTERY_CLASS	"battery"
-#define _COMPONENT		ACPI_SBS_COMPONENT
-static struct proc_dir_entry *acpi_ac_dir;
-static struct proc_dir_entry *acpi_battery_dir;
-
-static DEFINE_MUTEX(cm_sbs_mutex);
-
-static int lock_ac_dir_cnt;
-static int lock_battery_dir_cnt;
-
-struct proc_dir_entry *acpi_lock_ac_dir(void)
-{
-	mutex_lock(&cm_sbs_mutex);
-	if (!acpi_ac_dir)
-		acpi_ac_dir = proc_mkdir(ACPI_AC_CLASS, acpi_root_dir);
-	if (acpi_ac_dir) {
-		lock_ac_dir_cnt++;
-	} else {
-		printk(KERN_ERR PREFIX
-				  "Cannot create %s\n", ACPI_AC_CLASS);
-	}
-	mutex_unlock(&cm_sbs_mutex);
-	return acpi_ac_dir;
-}
-EXPORT_SYMBOL(acpi_lock_ac_dir);
-
-void acpi_unlock_ac_dir(struct proc_dir_entry *acpi_ac_dir_param)
-{
-	mutex_lock(&cm_sbs_mutex);
-	if (acpi_ac_dir_param)
-		lock_ac_dir_cnt--;
-	if (lock_ac_dir_cnt == 0 && acpi_ac_dir_param && acpi_ac_dir) {
-		remove_proc_entry(ACPI_AC_CLASS, acpi_root_dir);
-		acpi_ac_dir = NULL;
-	}
-	mutex_unlock(&cm_sbs_mutex);
-}
-EXPORT_SYMBOL(acpi_unlock_ac_dir);
-
-struct proc_dir_entry *acpi_lock_battery_dir(void)
-{
-	mutex_lock(&cm_sbs_mutex);
-	if (!acpi_battery_dir) {
-		acpi_battery_dir =
-		    proc_mkdir(ACPI_BATTERY_CLASS, acpi_root_dir);
-	}
-	if (acpi_battery_dir) {
-		lock_battery_dir_cnt++;
-	} else {
-		printk(KERN_ERR PREFIX
-				  "Cannot create %s\n", ACPI_BATTERY_CLASS);
-	}
-	mutex_unlock(&cm_sbs_mutex);
-	return acpi_battery_dir;
-}
-EXPORT_SYMBOL(acpi_lock_battery_dir);
-
-void acpi_unlock_battery_dir(struct proc_dir_entry *acpi_battery_dir_param)
-{
-	mutex_lock(&cm_sbs_mutex);
-	if (acpi_battery_dir_param)
-		lock_battery_dir_cnt--;
-	if (lock_battery_dir_cnt == 0 && acpi_battery_dir_param
-	    && acpi_battery_dir) {
-		remove_proc_entry(ACPI_BATTERY_CLASS, acpi_root_dir);
-		acpi_battery_dir = NULL;
-	}
-	mutex_unlock(&cm_sbs_mutex);
-	return;
-}
-EXPORT_SYMBOL(acpi_unlock_battery_dir);
-- 
1.8.2.1

