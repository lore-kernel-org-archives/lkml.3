Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab3KPAgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:36:19 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:59582 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab3KPAfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:35:51 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH tip/core/rcu 04/28] rcutorture: Add per-version default Kconfig fragments and module parameters
Date: Fri, 15 Nov 2013 16:35:17 -0800
Message-Id: <1384562141-32446-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-1542-0000-0000-000003563796
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Different Kconfig parameters apply to different kernel versions, as
do different rcutorture module parameters.  This commit allows the
rcutorture test scripts to adjust for different kernel versions.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 .../testing/selftests/rcutorture/bin/functions.sh  |  7 ++--
 .../selftests/rcutorture/bin/kvm-test-1-rcu.sh     | 12 ++----
 tools/testing/selftests/rcutorture/bin/kvm.sh      | 26 ++++--------
 tools/testing/selftests/rcutorture/configs/CFLIST  | 17 ++++++++
 .../selftests/rcutorture/configs/v0.0/CFLIST       | 14 +++++++
 .../rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP    |  1 -
 .../rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP    |  1 -
 .../rcutorture/configs/v0.0/ver_functions.sh       | 35 ++++++++++++++++
 .../selftests/rcutorture/configs/v3.3/CFLIST       | 14 +++++++
 .../rcutorture/configs/v3.3/ver_functions.sh       | 41 +++++++++++++++++++
 .../selftests/rcutorture/configs/v3.5/CFLIST       | 14 +++++++
 .../rcutorture/configs/v3.5/ver_functions.sh       | 46 ++++++++++++++++++++++
 .../selftests/rcutorture/configs/ver_functions.sh  | 46 ++++++++++++++++++++++
 13 files changed, 242 insertions(+), 32 deletions(-)
 create mode 100644 tools/testing/selftests/rcutorture/configs/CFLIST
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/CFLIST
 create mode 100644 tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/CFLIST
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/CFLIST
 create mode 100644 tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh
 create mode 100644 tools/testing/selftests/rcutorture/configs/ver_functions.sh

diff --git a/tools/testing/selftests/rcutorture/bin/functions.sh b/tools/testing/selftests/rcutorture/bin/functions.sh
index db1c32acdcf6..d4c15f81cd27 100644
--- a/tools/testing/selftests/rcutorture/bin/functions.sh
+++ b/tools/testing/selftests/rcutorture/bin/functions.sh
@@ -32,11 +32,10 @@ bootparam_hotplug_cpu () {
 #
 # Returns 1 if the config fragment specifies hotplug CPU.
 configfrag_hotplug_cpu () {
-	cf=$1
-	if test ! -r $cf
+	if test ! -r "$1"
 	then
-		echo Unreadable config fragment $cf 1>&2
+		echo Unreadable config fragment "$1" 1>&2
 		exit -1
 	fi
-	grep -q '^CONFIG_HOTPLUG_CPU=y$' $cf
+	grep -q '^CONFIG_HOTPLUG_CPU=y$' "$1"
 }
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
index 3b53078c5ff2..0a3f037a8bb3 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
@@ -44,6 +44,7 @@ T=/tmp/kvm-test-1-rcu.sh.$$
 trap 'rm -rf $T' 0
 
 . $KVM/bin/functions.sh
+. $KVPATH/ver_functions.sh
 
 config_template=${1}
 title=`echo $config_template | sed -e 's/^.*\///'`
@@ -133,14 +134,9 @@ else
 fi
 
 # Generate CPU-hotplug boot parameters
-if ! bootparam_hotplug_cpu "$bootargs"
-then
-	if configfrag_hotplug_cpu $builddir/.config
-	then
-		echo Kernel configured for CPU hotplug, adding rcutorture.
-		bootargs="$bootargs rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30"
-	fi
-fi
+boot_args="`rcutorture_param_onoff "$boot_args" $builddir/.config`"
+# Generate rcu_barrier() boot parameter
+boot_args="`rcutorture_param_n_barrier_cbs "$boot_args"`"
 
 echo $QEMU -name rcu-test -serial file:$builddir/console.log $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append \"noapic selinux=0 console=ttyS0 initcall_debug debug rcutorture.stat_interval=15 rcutorture.shutdown_secs=$seconds rcutorture.rcutorture_runnable=1 $boot_args\" > $resdir/qemu-cmd
 $QEMU -name rcu-test -serial file:$builddir/console.log $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append "noapic selinux=0 console=ttyS0 initcall_debug debug rcutorture.stat_interval=15 rcutorture.shutdown_secs=$seconds rcutorture.rcutorture_runnable=1 $boot_args" &
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 7deb7b44d647..92f726b01044 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -33,23 +33,7 @@ dur=30
 KVM=`pwd`/tools/testing/selftests/rcutorture; export KVM
 builddir=${KVM}/b1
 resdir=""
-configs=" sysidleY.2013.06.19a \
-	  sysidleN.2013.06.19a \
-	  P1-S-T-NH-SD-SMP-HP \
-	  P2-2-t-nh-sd-SMP-hp \
-	  P3-3-T-nh-SD-SMP-hp \
-	  P4-A-t-NH-sd-SMP-HP \
-	  P5-U-T-NH-sd-SMP-hp \
-	  P6---t-nh-SD-smp-hp \
-	  N1-S-T-NH-SD-SMP-HP \
-	  N2-2-t-nh-sd-SMP-hp \
-	  N3-3-T-nh-SD-SMP-hp \
-	  N4-A-t-NH-sd-SMP-HP \
-	  N5-U-T-NH-sd-SMP-hp \
-	  PT1-nh \
-	  PT2-NH \
-	  NT1-nh \
-	  NT3-NH"
+configs=""
 ds=`date +%Y.%m.%d-%H:%M:%S`
 kversion=""
 
@@ -156,6 +140,12 @@ echo "resdir=$resdir"
 
 PATH=${KVM}/bin:$PATH; export PATH
 CONFIGFRAG=${KVM}/configs; export CONFIGFRAG
+KVPATH=${CONFIGFRAG}/$kversion; export KVPATH
+
+if test -z "$configs"
+then
+	configs="`cat $CONFIGFRAG/$kversion/CFLIST`"
+fi
 
 if test -z "$resdir"
 then
@@ -181,6 +171,6 @@ do
 	rd=$resdir/$ds/$CF
 	mkdir $rd || :
 	echo Results directory: $rd
-	kvm-test-1-rcu.sh $CONFIGFRAG/$kversion/$CF $builddir $rd $dur "-nographic" "rcutorture.test_no_idle_hz=1 rcutorture.n_barrier_cbs=4 rcutorture.verbose=1"
+	kvm-test-1-rcu.sh $CONFIGFRAG/$kversion/$CF $builddir $rd $dur "-nographic" "rcutorture.test_no_idle_hz=1 rcutorture.verbose=1"
 done
 # Tracing: trace_event=rcu:rcu_nocb_grace_period,rcu:rcu_grace_period,rcu:rcu_grace_period_init,rcu:rcu_quiescent_state_report,rcu:rcu_fqs,rcu:rcu_callback,rcu:rcu_torture_read,rcu:rcu_invoke_callback,rcu:rcu_fqs,rcu:rcu_dyntick,rcu:rcu_unlock_preempted_task
diff --git a/tools/testing/selftests/rcutorture/configs/CFLIST b/tools/testing/selftests/rcutorture/configs/CFLIST
new file mode 100644
index 000000000000..da4cbc668f2a
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/CFLIST
@@ -0,0 +1,17 @@
+sysidleY.2013.06.19a
+sysidleN.2013.06.19a
+P1-S-T-NH-SD-SMP-HP
+P2-2-t-nh-sd-SMP-hp
+P3-3-T-nh-SD-SMP-hp
+P4-A-t-NH-sd-SMP-HP
+P5-U-T-NH-sd-SMP-hp
+P6---t-nh-SD-smp-hp
+N1-S-T-NH-SD-SMP-HP
+N2-2-t-nh-sd-SMP-hp
+N3-3-T-nh-SD-SMP-hp
+N4-A-t-NH-sd-SMP-HP
+N5-U-T-NH-sd-SMP-hp
+PT1-nh
+PT2-NH
+NT1-nh
+NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/CFLIST b/tools/testing/selftests/rcutorture/configs/v0.0/CFLIST
new file mode 100644
index 000000000000..18223947bbcb
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/CFLIST
@@ -0,0 +1,14 @@
+P1-S-T-NH-SD-SMP-HP
+P2-2-t-nh-sd-SMP-hp
+P3-3-T-nh-SD-SMP-hp
+P4-A-t-NH-sd-SMP-HP
+P5-U-T-NH-sd-SMP-hp
+N1-S-T-NH-SD-SMP-HP
+N2-2-t-nh-sd-SMP-hp
+N3-3-T-nh-SD-SMP-hp
+N4-A-t-NH-sd-SMP-HP
+N5-U-T-NH-sd-SMP-hp
+PT1-nh
+PT2-NH
+NT1-nh
+NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP
index d81e11d280aa..d3ef873eb6e7 100644
--- a/tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/N1-S-T-NH-SD-SMP-HP
@@ -1,5 +1,4 @@
 CONFIG_RCU_TRACE=y
-CONFIG_RCU_FAST_NO_HZ=y
 CONFIG_NO_HZ=y
 CONFIG_SMP=y
 CONFIG_RCU_FANOUT=8
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP
index 9647c44cf4b7..f72402d7c13d 100644
--- a/tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/P1-S-T-NH-SD-SMP-HP
@@ -1,7 +1,6 @@
 CONFIG_RCU_TRACE=y
 CONFIG_RCU_CPU_STALL_INFO=y
 CONFIG_NO_HZ=y
-CONFIG_RCU_FAST_NO_HZ=y
 CONFIG_SMP=y
 CONFIG_RCU_FANOUT=8
 CONFIG_NR_CPUS=8
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh
new file mode 100644
index 000000000000..af7d59bf0988
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh
@@ -0,0 +1,35 @@
+#!/bin/bash
+#
+# Kernel-version-dependent shell functions for the rest of the scripts.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+# rcutorture_param_n_barrier_cbs bootparam-string
+#
+# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
+rcutorture_param_n_barrier_cbs () {
+	echo $1
+}
+
+# rcutorture_param_onoff bootparam-string config-file
+#
+# Adds onoff rcutorture module parameters to kernels having it.
+rcutorture_param_onoff () {
+	echo $1
+}
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/CFLIST b/tools/testing/selftests/rcutorture/configs/v3.3/CFLIST
new file mode 100644
index 000000000000..18223947bbcb
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/CFLIST
@@ -0,0 +1,14 @@
+P1-S-T-NH-SD-SMP-HP
+P2-2-t-nh-sd-SMP-hp
+P3-3-T-nh-SD-SMP-hp
+P4-A-t-NH-sd-SMP-HP
+P5-U-T-NH-sd-SMP-hp
+N1-S-T-NH-SD-SMP-HP
+N2-2-t-nh-sd-SMP-hp
+N3-3-T-nh-SD-SMP-hp
+N4-A-t-NH-sd-SMP-HP
+N5-U-T-NH-sd-SMP-hp
+PT1-nh
+PT2-NH
+NT1-nh
+NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh
new file mode 100644
index 000000000000..921fec931114
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh
@@ -0,0 +1,41 @@
+#!/bin/bash
+#
+# Kernel-version-dependent shell functions for the rest of the scripts.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+# rcutorture_param_n_barrier_cbs bootparam-string
+#
+# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
+rcutorture_param_n_barrier_cbs () {
+	echo $1
+}
+
+# rcutorture_param_onoff bootparam-string config-file
+#
+# Adds onoff rcutorture module parameters to kernels having it.
+rcutorture_param_onoff () {
+	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
+	then
+		echo CPU-hotplug kernel, adding rcutorture onoff.
+		echo $1 rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
+	else
+		echo $1
+	fi
+}
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/CFLIST b/tools/testing/selftests/rcutorture/configs/v3.5/CFLIST
new file mode 100644
index 000000000000..18223947bbcb
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/CFLIST
@@ -0,0 +1,14 @@
+P1-S-T-NH-SD-SMP-HP
+P2-2-t-nh-sd-SMP-hp
+P3-3-T-nh-SD-SMP-hp
+P4-A-t-NH-sd-SMP-HP
+P5-U-T-NH-sd-SMP-hp
+N1-S-T-NH-SD-SMP-HP
+N2-2-t-nh-sd-SMP-hp
+N3-3-T-nh-SD-SMP-hp
+N4-A-t-NH-sd-SMP-HP
+N5-U-T-NH-sd-SMP-hp
+PT1-nh
+PT2-NH
+NT1-nh
+NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh
new file mode 100644
index 000000000000..401974455aee
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh
@@ -0,0 +1,46 @@
+#!/bin/bash
+#
+# Kernel-version-dependent shell functions for the rest of the scripts.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+# rcutorture_param_n_barrier_cbs bootparam-string
+#
+# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
+rcutorture_param_n_barrier_cbs () {
+	if echo $1 | grep -q "rcutorture\.n_barrier_cbs"
+	then
+		echo $1
+	else
+		echo $1 rcutorture.n_barrier_cbs=4
+	fi
+}
+
+# rcutorture_param_onoff bootparam-string config-file
+#
+# Adds onoff rcutorture module parameters to kernels having it.
+rcutorture_param_onoff () {
+	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
+	then
+		echo CPU-hotplug kernel, adding rcutorture onoff.
+		echo $1 rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
+	else
+		echo $1
+	fi
+}
diff --git a/tools/testing/selftests/rcutorture/configs/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/ver_functions.sh
new file mode 100644
index 000000000000..f99f23bc3934
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/ver_functions.sh
@@ -0,0 +1,46 @@
+#!/bin/bash
+#
+# Kernel-version-dependent shell functions for the rest of the scripts.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+#
+# Copyright (C) IBM Corporation, 2013
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+# rcutorture_param_n_barrier_cbs bootparam-string
+#
+# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
+rcutorture_param_n_barrier_cbs () {
+	if echo $1 | grep -q "rcutorture\.n_barrier_cbs"
+	then
+		echo $1
+	else
+		echo $1 rcutorture.n_barrier_cbs=4
+	fi
+}
+
+# rcutorture_param_onoff bootparam-string config-file
+#
+# Adds onoff rcutorture module parameters to kernels having it.
+rcutorture_param_onoff () {
+	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
+	then
+		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
+		echo $1 rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
+	else
+		echo $1
+	fi
+}
-- 
1.8.1.5

