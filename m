Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaBQWOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:14:39 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35263 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbaBQWNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:22 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 47/55] rcutorture: Rename kvm-test-1-rcu.sh
Date: Mon, 17 Feb 2014 14:12:51 -0800
Message-Id: <1392675179-11560-47-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F386B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The kvm-test-1-rcu.sh is not specific to RCU, so this commit renames it
to kvm-test-1-run.sh.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 .../selftests/rcutorture/bin/kvm-test-1-rcu.sh     | 203 ---------------------
 .../selftests/rcutorture/bin/kvm-test-1-run.sh     | 203 +++++++++++++++++++++
 tools/testing/selftests/rcutorture/bin/kvm.sh      |   2 +-
 3 files changed, 204 insertions(+), 204 deletions(-)
 delete mode 100755 tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
deleted file mode 100755
index 7986b3e7f318..000000000000
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
+++ /dev/null
@@ -1,203 +0,0 @@
-#!/bin/bash
-#
-# Run a kvm-based test of the specified tree on the specified configs.
-# Fully automated run and error checking, no graphics console.
-#
-# Execute this in the source tree.  Do not run it as a background task
-# because qemu does not seem to like that much.
-#
-# Usage: sh kvm-test-1-rcu.sh config builddir resdir minutes qemu-args boot_args
-#
-# qemu-args defaults to "" -- you will want "-nographic" if running headless.
-# boot_args defaults to	"root=/dev/sda noapic selinux=0 console=ttyS0"
-#			"initcall_debug debug rcutorture.stat_interval=15"
-#			"rcutorture.shutdown_secs=$((minutes * 60))"
-#			"rcutorture.rcutorture_runnable=1"
-#
-# Anything you specify for either qemu-args or boot_args is appended to
-# the default values.  The "-smp" value is deduced from the contents of
-# the config fragment.
-#
-# More sophisticated argument parsing is clearly needed.
-#
-# This program is free software; you can redistribute it and/or modify
-# it under the terms of the GNU General Public License as published by
-# the Free Software Foundation; either version 2 of the License, or
-# (at your option) any later version.
-#
-# This program is distributed in the hope that it will be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, you can access it online at
-# http://www.gnu.org/licenses/gpl-2.0.html.
-#
-# Copyright (C) IBM Corporation, 2011
-#
-# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
-
-grace=120
-
-T=/tmp/kvm-test-1-rcu.sh.$$
-trap 'rm -rf $T' 0
-
-. $KVM/bin/functions.sh
-. $KVPATH/ver_functions.sh
-
-config_template=${1}
-config_dir=`echo $config_template | sed -e 's,/[^/]*$,,'`
-title=`echo $config_template | sed -e 's/^.*\///'`
-builddir=${2}
-if test -z "$builddir" -o ! -d "$builddir" -o ! -w "$builddir"
-then
-	echo "kvm-test-1-rcu.sh :$builddir: Not a writable directory, cannot build into it"
-	exit 1
-fi
-resdir=${3}
-if test -z "$resdir" -o ! -d "$resdir" -o ! -w "$resdir"
-then
-	echo "kvm-test-1-rcu.sh :$resdir: Not a writable directory, cannot store results into it"
-	exit 1
-fi
-cp $config_template $resdir/ConfigFragment
-echo ' ---' `date`: Starting build
-echo ' ---' Kconfig fragment at: $config_template >> $resdir/log
-if test -r "$config_dir/CFcommon"
-then
-	cat < $config_dir/CFcommon >> $T
-fi
-# Optimizations below this point
-# CONFIG_USB=n
-# CONFIG_SECURITY=n
-# CONFIG_NFS_FS=n
-# CONFIG_SOUND=n
-# CONFIG_INPUT_JOYSTICK=n
-# CONFIG_INPUT_TABLET=n
-# CONFIG_INPUT_TOUCHSCREEN=n
-# CONFIG_INPUT_MISC=n
-# CONFIG_INPUT_MOUSE=n
-# # CONFIG_NET=n # disables console access, so accept the slower build.
-# CONFIG_SCSI=n
-# CONFIG_ATA=n
-# CONFIG_FAT_FS=n
-# CONFIG_MSDOS_FS=n
-# CONFIG_VFAT_FS=n
-# CONFIG_ISO9660_FS=n
-# CONFIG_QUOTA=n
-# CONFIG_HID=n
-# CONFIG_CRYPTO=n
-# CONFIG_PCCARD=n
-# CONFIG_PCMCIA=n
-# CONFIG_CARDBUS=n
-# CONFIG_YENTA=n
-if kvm-build.sh $config_template $builddir $T
-then
-	cp $builddir/Make*.out $resdir
-	cp $builddir/.config $resdir
-	cp $builddir/arch/x86/boot/bzImage $resdir
-	parse-build.sh $resdir/Make.out $title
-	if test -f $builddir.wait
-	then
-		mv $builddir.wait $builddir.ready
-	fi
-else
-	cp $builddir/Make*.out $resdir
-	echo Build failed, not running KVM, see $resdir.
-	if test -f $builddir.wait
-	then
-		mv $builddir.wait $builddir.ready
-	fi
-	exit 1
-fi
-while test -f $builddir.ready
-do
-	sleep 1
-done
-minutes=$4
-seconds=$(($minutes * 60))
-qemu_args=$5
-boot_args=$6
-
-cd $KVM
-kstarttime=`awk 'BEGIN { print systime() }' < /dev/null`
-echo ' ---' `date`: Starting kernel
-
-# Determine the appropriate flavor of qemu command.
-QEMU="`identify_qemu $builddir/vmlinux`"
-
-# Generate -smp qemu argument.
-qemu_args="-nographic $qemu_args"
-cpu_count=`configNR_CPUS.sh $config_template`
-vcpus=`identify_qemu_vcpus`
-if test $cpu_count -gt $vcpus
-then
-	echo CPU count limited from $cpu_count to $vcpus
-	touch $resdir/Warnings
-	echo CPU count limited from $cpu_count to $vcpus >> $resdir/Warnings
-	cpu_count=$vcpus
-fi
-qemu_args="`specify_qemu_cpus "$QEMU" "$qemu_args" "$cpu_count"`"
-
-# Generate architecture-specific and interaction-specific qemu arguments
-qemu_args="$qemu_args `identify_qemu_args "$QEMU" "$builddir/console.log"`"
-
-# Generate qemu -append arguments
-qemu_append="`identify_qemu_append "$QEMU"`"
-
-# Pull in Kconfig-fragment boot parameters
-boot_args="`configfrag_boot_params "$boot_args" "$config_template"`"
-# Generate kernel-version-specific boot parameters
-boot_args="`per_version_boot_params "$boot_args" $builddir/.config $seconds`"
-
-echo $QEMU $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
-if test -n "$RCU_BUILDONLY"
-then
-	echo Build-only run specified, boot/test omitted.
-	exit 0
-fi
-$QEMU $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append "$qemu_append $boot_args" &
-qemu_pid=$!
-commandcompleted=0
-echo Monitoring qemu job at pid $qemu_pid
-for ((i=0;i<$seconds;i++))
-do
-	if kill -0 $qemu_pid > /dev/null 2>&1
-	then
-		sleep 1
-	else
-		commandcompleted=1
-		kruntime=`awk 'BEGIN { print systime() - '"$kstarttime"' }' < /dev/null`
-		if test $kruntime -lt $seconds
-		then
-			echo Completed in $kruntime vs. $seconds >> $resdir/Warnings 2>&1
-		else
-			echo ' ---' `date`: Kernel done
-		fi
-		break
-	fi
-done
-if test $commandcompleted -eq 0
-then
-	echo Grace period for qemu job at pid $qemu_pid
-	for ((i=0;i<=$grace;i++))
-	do
-		if kill -0 $qemu_pid > /dev/null 2>&1
-		then
-			sleep 1
-		else
-			break
-		fi
-		if test $i -eq $grace
-		then
-			kruntime=`awk 'BEGIN { print systime() - '"$kstarttime"' }'`
-			echo "!!! Hang at $kruntime vs. $seconds seconds" >> $resdir/Warnings 2>&1
-			kill -KILL $qemu_pid
-		fi
-	done
-fi
-
-cp $builddir/console.log $resdir
-parse-rcutorture.sh $resdir/console.log $title
-parse-console.sh $resdir/console.log $title
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
new file mode 100755
index 000000000000..015d35bc43cb
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -0,0 +1,203 @@
+#!/bin/bash
+#
+# Run a kvm-based test of the specified tree on the specified configs.
+# Fully automated run and error checking, no graphics console.
+#
+# Execute this in the source tree.  Do not run it as a background task
+# because qemu does not seem to like that much.
+#
+# Usage: sh kvm-test-1-run.sh config builddir resdir minutes qemu-args boot_args
+#
+# qemu-args defaults to "-nographic", along with arguments specifying the
+#			number of CPUs and other options generated from
+#			the underlying CPU architecture.
+# boot_args defaults to value returned by the per_version_boot_params
+#			shell function.
+#
+# Anything you specify for either qemu-args or boot_args is appended to
+# the default values.  The "-smp" value is deduced from the contents of
+# the config fragment.
+#
+# More sophisticated argument parsing is clearly needed.
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
+# along with this program; if not, you can access it online at
+# http://www.gnu.org/licenses/gpl-2.0.html.
+#
+# Copyright (C) IBM Corporation, 2011
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+grace=120
+
+T=/tmp/kvm-test-1-run.sh.$$
+trap 'rm -rf $T' 0
+
+. $KVM/bin/functions.sh
+. $KVPATH/ver_functions.sh
+
+config_template=${1}
+config_dir=`echo $config_template | sed -e 's,/[^/]*$,,'`
+title=`echo $config_template | sed -e 's/^.*\///'`
+builddir=${2}
+if test -z "$builddir" -o ! -d "$builddir" -o ! -w "$builddir"
+then
+	echo "kvm-test-1-run.sh :$builddir: Not a writable directory, cannot build into it"
+	exit 1
+fi
+resdir=${3}
+if test -z "$resdir" -o ! -d "$resdir" -o ! -w "$resdir"
+then
+	echo "kvm-test-1-run.sh :$resdir: Not a writable directory, cannot store results into it"
+	exit 1
+fi
+cp $config_template $resdir/ConfigFragment
+echo ' ---' `date`: Starting build
+echo ' ---' Kconfig fragment at: $config_template >> $resdir/log
+if test -r "$config_dir/CFcommon"
+then
+	cat < $config_dir/CFcommon >> $T
+fi
+# Optimizations below this point
+# CONFIG_USB=n
+# CONFIG_SECURITY=n
+# CONFIG_NFS_FS=n
+# CONFIG_SOUND=n
+# CONFIG_INPUT_JOYSTICK=n
+# CONFIG_INPUT_TABLET=n
+# CONFIG_INPUT_TOUCHSCREEN=n
+# CONFIG_INPUT_MISC=n
+# CONFIG_INPUT_MOUSE=n
+# # CONFIG_NET=n # disables console access, so accept the slower build.
+# CONFIG_SCSI=n
+# CONFIG_ATA=n
+# CONFIG_FAT_FS=n
+# CONFIG_MSDOS_FS=n
+# CONFIG_VFAT_FS=n
+# CONFIG_ISO9660_FS=n
+# CONFIG_QUOTA=n
+# CONFIG_HID=n
+# CONFIG_CRYPTO=n
+# CONFIG_PCCARD=n
+# CONFIG_PCMCIA=n
+# CONFIG_CARDBUS=n
+# CONFIG_YENTA=n
+if kvm-build.sh $config_template $builddir $T
+then
+	cp $builddir/Make*.out $resdir
+	cp $builddir/.config $resdir
+	cp $builddir/arch/x86/boot/bzImage $resdir
+	parse-build.sh $resdir/Make.out $title
+	if test -f $builddir.wait
+	then
+		mv $builddir.wait $builddir.ready
+	fi
+else
+	cp $builddir/Make*.out $resdir
+	echo Build failed, not running KVM, see $resdir.
+	if test -f $builddir.wait
+	then
+		mv $builddir.wait $builddir.ready
+	fi
+	exit 1
+fi
+while test -f $builddir.ready
+do
+	sleep 1
+done
+minutes=$4
+seconds=$(($minutes * 60))
+qemu_args=$5
+boot_args=$6
+
+cd $KVM
+kstarttime=`awk 'BEGIN { print systime() }' < /dev/null`
+echo ' ---' `date`: Starting kernel
+
+# Determine the appropriate flavor of qemu command.
+QEMU="`identify_qemu $builddir/vmlinux`"
+
+# Generate -smp qemu argument.
+qemu_args="-nographic $qemu_args"
+cpu_count=`configNR_CPUS.sh $config_template`
+vcpus=`identify_qemu_vcpus`
+if test $cpu_count -gt $vcpus
+then
+	echo CPU count limited from $cpu_count to $vcpus
+	touch $resdir/Warnings
+	echo CPU count limited from $cpu_count to $vcpus >> $resdir/Warnings
+	cpu_count=$vcpus
+fi
+qemu_args="`specify_qemu_cpus "$QEMU" "$qemu_args" "$cpu_count"`"
+
+# Generate architecture-specific and interaction-specific qemu arguments
+qemu_args="$qemu_args `identify_qemu_args "$QEMU" "$builddir/console.log"`"
+
+# Generate qemu -append arguments
+qemu_append="`identify_qemu_append "$QEMU"`"
+
+# Pull in Kconfig-fragment boot parameters
+boot_args="`configfrag_boot_params "$boot_args" "$config_template"`"
+# Generate kernel-version-specific boot parameters
+boot_args="`per_version_boot_params "$boot_args" $builddir/.config $seconds`"
+
+echo $QEMU $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
+if test -n "$RCU_BUILDONLY"
+then
+	echo Build-only run specified, boot/test omitted.
+	exit 0
+fi
+$QEMU $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append "$qemu_append $boot_args" &
+qemu_pid=$!
+commandcompleted=0
+echo Monitoring qemu job at pid $qemu_pid
+for ((i=0;i<$seconds;i++))
+do
+	if kill -0 $qemu_pid > /dev/null 2>&1
+	then
+		sleep 1
+	else
+		commandcompleted=1
+		kruntime=`awk 'BEGIN { print systime() - '"$kstarttime"' }' < /dev/null`
+		if test $kruntime -lt $seconds
+		then
+			echo Completed in $kruntime vs. $seconds >> $resdir/Warnings 2>&1
+		else
+			echo ' ---' `date`: Kernel done
+		fi
+		break
+	fi
+done
+if test $commandcompleted -eq 0
+then
+	echo Grace period for qemu job at pid $qemu_pid
+	for ((i=0;i<=$grace;i++))
+	do
+		if kill -0 $qemu_pid > /dev/null 2>&1
+		then
+			sleep 1
+		else
+			break
+		fi
+		if test $i -eq $grace
+		then
+			kruntime=`awk 'BEGIN { print systime() - '"$kstarttime"' }'`
+			echo "!!! Hang at $kruntime vs. $seconds seconds" >> $resdir/Warnings 2>&1
+			kill -KILL $qemu_pid
+		fi
+	done
+fi
+
+cp $builddir/console.log $resdir
+parse-rcutorture.sh $resdir/console.log $title
+parse-console.sh $resdir/console.log $title
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 242b52d11cf9..767097e2a293 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -307,7 +307,7 @@ function dump(first, pastlast)
 		print "touch " builddir ".wait";
 		print "mkdir " builddir " > /dev/null 2>&1 || :";
 		print "mkdir " rd cfr[jn] " || :";
-		print "kvm-test-1-rcu.sh " CONFIGDIR cf[j], builddir, rd cfr[jn], dur " \"" RCU_QEMU_ARG "\" \"" RCU_BOOTARGS "\" > " builddir ".out 2>&1 &"
+		print "kvm-test-1-run.sh " CONFIGDIR cf[j], builddir, rd cfr[jn], dur " \"" RCU_QEMU_ARG "\" \"" RCU_BOOTARGS "\" > " builddir ".out 2>&1 &"
 		print "echo ", cfr[jn], cpusr[jn] ovf ": Waiting for build to complete. `date`"
 		print "while test -f " builddir ".wait"
 		print "do"
-- 
1.8.1.5

