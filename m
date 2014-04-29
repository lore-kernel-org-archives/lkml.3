Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbaD2A0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:26:14 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48564 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933062AbaD2AZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:49 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 24/45] torture: Choose bzImage location based on architecture
Date: Mon, 28 Apr 2014 17:25:12 -0700
Message-Id: <1398731133-18925-24-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-1542-0000-0000-00000169D315
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently, the scripts hard-code arch/x86/boot/bzImage, which does not
work well for other architectures.  This commit therefore provides a
identify_boot_image function that selects the correct bzImage location
relative to the top of the Linux source tree.  This commit also adds a
--bootimage argument that allows selecting some other file, for example,
"vmlinux".

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/functions.sh | 21 +++++++++++++++++++++
 .../selftests/rcutorture/bin/kvm-test-1-run.sh      | 11 +++++------
 tools/testing/selftests/rcutorture/bin/kvm.sh       |  8 ++++++++
 3 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/functions.sh b/tools/testing/selftests/rcutorture/bin/functions.sh
index 6b2adb29b073..efa95867e1cc 100644
--- a/tools/testing/selftests/rcutorture/bin/functions.sh
+++ b/tools/testing/selftests/rcutorture/bin/functions.sh
@@ -76,6 +76,27 @@ configfrag_hotplug_cpu () {
 	grep -q '^CONFIG_HOTPLUG_CPU=y$' "$1"
 }
 
+# identify_boot_image qemu-cmd
+#
+# Returns the relative path to the kernel build image.  This will be
+# arch/<arch>/boot/bzImage unless overridden with the TORTURE_BOOT_IMAGE
+# environment variable.
+identify_boot_image () {
+	if test -n "$TORTURE_BOOT_IMAGE"
+	then
+		echo $TORTURE_BOOT_IMAGE
+	else
+		case "$1" in
+		qemu-system-x86_64|qemu-system-i386)
+			echo arch/x86/boot/bzImage
+			;;
+		qemu-system-ppc64)
+			echo arch/powerpc/boot/bzImage
+			;;
+		esac
+	fi
+}
+
 # identify_qemu builddir
 #
 # Returns our best guess as to which qemu command is appropriate for
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index 7848227aa4c1..7a95f86cc85a 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -94,9 +94,11 @@ fi
 # CONFIG_YENTA=n
 if kvm-build.sh $config_template $builddir $T
 then
+	QEMU="`identify_qemu $builddir/vmlinux`"
+	BOOT_IMAGE="`identify_boot_image $QEMU`"
 	cp $builddir/Make*.out $resdir
 	cp $builddir/.config $resdir
-	cp $builddir/arch/x86/boot/bzImage $resdir
+	cp $builddir/$BOOT_IMAGE $resdir
 	parse-build.sh $resdir/Make.out $title
 	if test -f $builddir.wait
 	then
@@ -124,9 +126,6 @@ cd $KVM
 kstarttime=`awk 'BEGIN { print systime() }' < /dev/null`
 echo ' ---' `date`: Starting kernel
 
-# Determine the appropriate flavor of qemu command.
-QEMU="`identify_qemu $builddir/vmlinux`"
-
 # Generate -smp qemu argument.
 qemu_args="-nographic $qemu_args"
 cpu_count=`configNR_CPUS.sh $config_template`
@@ -151,13 +150,13 @@ boot_args="`configfrag_boot_params "$boot_args" "$config_template"`"
 # Generate kernel-version-specific boot parameters
 boot_args="`per_version_boot_params "$boot_args" $builddir/.config $seconds`"
 
-echo $QEMU $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
+echo $QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
 if test -n "$TORTURE_BUILDONLY"
 then
 	echo Build-only run specified, boot/test omitted.
 	exit 0
 fi
-$QEMU $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append "$qemu_append $boot_args"; echo $? > $resdir/qemu-retval &
+$QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append "$qemu_append $boot_args"; echo $? > $resdir/qemu-retval &
 qemu_pid=$!
 commandcompleted=0
 echo Monitoring qemu job at pid $qemu_pid
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 9b838c372698..4eed2a4f42c7 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -39,6 +39,7 @@ dryrun=""
 KVM="`pwd`/tools/testing/selftests/rcutorture"; export KVM
 PATH=${KVM}/bin:$PATH; export PATH
 TORTURE_DEFCONFIG=defconfig
+TORTURE_BOOT_IMAGE=""
 TORTURE_INITRD="$KVM/initrd"; export TORTURE_INITRD
 TORTURE_KMAKE_ARG=""
 TORTURE_SUITE=rcu
@@ -53,6 +54,7 @@ kversion=""
 usage () {
 	echo "Usage: $scriptname optional arguments:"
 	echo "       --bootargs kernel-boot-arguments"
+	echo "       --bootimage relative-path-to-kernel-boot-image"
 	echo "       --buildonly"
 	echo "       --configs \"config-file list\""
 	echo "       --cpus N"
@@ -80,6 +82,11 @@ do
 		TORTURE_BOOTARGS="$2"
 		shift
 		;;
+	--bootimage)
+		checkarg --bootimage "(relative path to kernel boot image)" "$#" "$2" '[a-zA-Z0-9][a-zA-Z0-9_]*' '^--'
+		TORTURE_BOOT_IMAGE="$2"
+		shift
+		;;
 	--buildonly)
 		TORTURE_BUILDONLY=1
 		;;
@@ -245,6 +252,7 @@ CONFIGFRAG="$CONFIGFRAG"; export CONFIGFRAG
 KVM="$KVM"; export KVM
 KVPATH="$KVPATH"; export KVPATH
 PATH="$PATH"; export PATH
+TORTURE_BOOT_IMAGE="$TORTURE_BOOT_IMAGE"; export TORTURE_BOOT_IMAGE
 TORTURE_BUILDONLY="$TORTURE_BUILDONLY"; export TORTURE_BUILDONLY
 TORTURE_DEFCONFIG="$TORTURE_DEFCONFIG"; export TORTURE_DEFCONFIG
 TORTURE_INITRD="$TORTURE_INITRD"; export TORTURE_INITRD
-- 
1.8.1.5

