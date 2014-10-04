Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaJDREz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 13:04:55 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:49035 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaJDREx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 13:04:53 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] rcutorture: Remove obsolete kversion param in kvm.sh
Date: Sat,  4 Oct 2014 13:04:15 -0400
Message-Id: <1412442255-3685-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have removed configs based on kernel version, we can also remove the
kversion parameter in kvm.sh.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 .../selftests/rcutorture/bin/kvm-test-1-run.sh        |  2 +-
 tools/testing/selftests/rcutorture/bin/kvm.sh         | 19 +++++--------------
 2 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index e0f8969..8ca9f21 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -45,7 +45,7 @@ trap 'rm -rf $T' 0
 touch $T
 
 . $KVM/bin/functions.sh
-. $KVPATH/ver_functions.sh
+. $CONFIGFRAG/ver_functions.sh
 
 config_template=${1}
 config_dir=`echo $config_template | sed -e 's,/[^/]*$,,'`
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index e527dc9..368d64a 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -47,7 +47,6 @@ resdir=""
 configs=""
 cpus=0
 ds=`date +%Y.%m.%d-%H:%M:%S`
-kversion=""
 
 . functions.sh
 
@@ -64,7 +63,6 @@ usage () {
 	echo "       --duration minutes"
 	echo "       --interactive"
 	echo "       --kmake-arg kernel-make-arguments"
-	echo "       --kversion vN.NN"
 	echo "       --mac nn:nn:nn:nn:nn:nn"
 	echo "       --no-initrd"
 	echo "       --qemu-args qemu-system-..."
@@ -128,11 +126,6 @@ do
 		TORTURE_KMAKE_ARG="$2"
 		shift
 		;;
-	--kversion)
-		checkarg --kversion "(kernel version)" $# "$2" '^v[0-9.]*$' '^error'
-		kversion=$2
-		shift
-		;;
 	--mac)
 		checkarg --mac "(MAC address)" $# "$2" '^\([0-9a-fA-F]\{2\}:\)\{5\}[0-9a-fA-F]\{2\}$' error
 		TORTURE_QEMU_MAC=$2
@@ -170,11 +163,10 @@ do
 done
 
 CONFIGFRAG=${KVM}/configs/${TORTURE_SUITE}; export CONFIGFRAG
-KVPATH=${CONFIGFRAG}/$kversion; export KVPATH
 
 if test -z "$configs"
 then
-	configs="`cat $CONFIGFRAG/$kversion/CFLIST`"
+	configs="`cat $CONFIGFRAG/CFLIST`"
 fi
 
 if test -z "$resdir"
@@ -186,10 +178,10 @@ fi
 touch $T/cfgcpu
 for CF in $configs
 do
-	if test -f "$CONFIGFRAG/$kversion/$CF"
+	if test -f "$CONFIGFRAG/$CF"
 	then
-		cpu_count=`configNR_CPUS.sh $CONFIGFRAG/$kversion/$CF`
-		cpu_count=`configfrag_boot_cpus "$TORTURE_BOOTARGS" "$CONFIGFRAG/$kversion/$CF" "$cpu_count"`
+		cpu_count=`configNR_CPUS.sh $CONFIGFRAG/$CF`
+		cpu_count=`configfrag_boot_cpus "$TORTURE_BOOTARGS" "$CONFIGFRAG/$CF" "$cpu_count"`
 		echo $CF $cpu_count >> $T/cfgcpu
 	else
 		echo "The --configs file $CF does not exist, terminating."
@@ -252,7 +244,6 @@ END {
 cat << ___EOF___ > $T/script
 CONFIGFRAG="$CONFIGFRAG"; export CONFIGFRAG
 KVM="$KVM"; export KVM
-KVPATH="$KVPATH"; export KVPATH
 PATH="$PATH"; export PATH
 TORTURE_BOOT_IMAGE="$TORTURE_BOOT_IMAGE"; export TORTURE_BOOT_IMAGE
 TORTURE_BUILDONLY="$TORTURE_BUILDONLY"; export TORTURE_BUILDONLY
@@ -285,7 +276,7 @@ then
 fi
 ___EOF___
 awk < $T/cfgcpu.pack \
-	-v CONFIGDIR="$CONFIGFRAG/$kversion/" \
+	-v CONFIGDIR="$CONFIGFRAG/" \
 	-v KVM="$KVM" \
 	-v ncpus=$cpus \
 	-v rd=$resdir/$ds/ \
-- 
1.9.1

