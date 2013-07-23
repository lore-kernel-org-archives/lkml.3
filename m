Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab3GWIKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:10:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:58873 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab3GWIKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:10:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,725,1367996400"; 
   d="scan'208";a="374543771"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Corey Minyard <minyard@acm.org>,
        Zhao Yakui <yakui.zhao@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: [PATCH 12/13] Testing: Add module load/unload test suite
Date: Tue, 23 Jul 2013 16:10:36 +0800
Message-Id: <b4ea2d9d566206e14e33ddceeb39a2fa3fa541e1.1374566394.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1374566394.git.lv.zheng@intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com> <cover.1374566394.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains two test scripts for module load/unload race testing.

Follow the following steps to use this test suite:
1. Run several instances invoking endless_cat.sh to access the sysfs files
   that exported by the module.
2. Run endless_mod.sh to load/unload the module frequently to see if races
   will happen.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 tools/testing/module-unloading/endless_cat.sh |   32 ++++++++++
 tools/testing/module-unloading/endless_mod.sh |   81 +++++++++++++++++++++++++
 2 files changed, 113 insertions(+)
 create mode 100755 tools/testing/module-unloading/endless_cat.sh
 create mode 100755 tools/testing/module-unloading/endless_mod.sh

diff --git a/tools/testing/module-unloading/endless_cat.sh b/tools/testing/module-unloading/endless_cat.sh
new file mode 100755
index 0000000..72e035c
--- /dev/null
+++ b/tools/testing/module-unloading/endless_cat.sh
@@ -0,0 +1,32 @@
+#!/bin/sh
+
+fatal() {
+	echo $1
+	exit 1
+}
+
+usage() {
+	echo "Usage: `basename $0` <file>"
+	echo "Where:"
+	echo " file: file to cat"
+}
+
+fatal_usage() {
+	usage
+	exit 1
+}
+
+if [ "x$1" = "x" ]; then
+	echo "Missing <file> paraemter."
+	fatal_usage
+fi
+if [ ! -f $1 ]; then
+	echo "$1 is not an accessible file."
+	fatal_usage
+fi
+
+while :
+do
+	cat $1
+	echo "-----------------------------------"
+done
diff --git a/tools/testing/module-unloading/endless_mod.sh b/tools/testing/module-unloading/endless_mod.sh
new file mode 100755
index 0000000..359b0c0
--- /dev/null
+++ b/tools/testing/module-unloading/endless_mod.sh
@@ -0,0 +1,81 @@
+#!/bin/sh
+
+fatal() {
+	echo $1
+	exit 1
+}
+
+usage() {
+	echo "Usage: `basename $0` [-t second] <module>"
+	echo "Where:"
+	echo " second: seconds to sleep between module actions"
+	echo " module: name of module to test"
+}
+
+fatal_usage() {
+	usage
+	exit 1
+}
+
+SLEEPSEC=10
+
+while getopts "t:" opt
+do
+	case $opt in
+	t) SLEEPSEC=$OPTARG;;
+	?) echo "Invalid argument $opt"
+	   fatal_usage;;
+	esac
+done
+shift $(($OPTIND - 1))
+
+if [ "x$1" = "x" ]; then
+	echo "Missing <module> paraemter."
+	fatal_usage
+fi
+
+find_module() {
+	curr_modules=`lsmod | cut -d " " -f1`
+
+	for m in $curr_modules; do
+		if [ "x$m" = "x$1" ]; then
+			return 0
+		fi
+	done
+	return 1
+}
+
+remove_module() {
+	while :
+	do
+		find_module $1
+		if [ $? -eq 0 ]; then
+			rmmod $1
+			echo "Removing $1 ..."
+		else
+			break
+		fi
+	done
+}
+
+insert_module() {
+	while :
+	do
+		find_module $1
+		if [ ! $? -eq 0 ]; then
+			modprobe $1
+			echo "Inserting $1 ..."
+		else
+			break
+		fi
+	done
+}
+
+while :
+do
+	echo "-----------------------------------"
+	insert_module $1
+	sleep $SLEEPSEC
+	remove_module $1
+	sleep $SLEEPSEC
+done
-- 
1.7.10

