Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbaJ1WeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:34:11 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37383 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266AbaJ1WeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:34:01 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/6] rcutorture: Remove obsolete kversion param in kvm.sh
Date: Tue, 28 Oct 2014 15:30:04 -0700
Message-Id: <1414535405-30228-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414535405-30228-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028222929.GA29476@linux.vnet.ibm.com>
 <1414535405-30228-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0025-0000-0000-000000F07241
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

Now that we have removed configs based on kernel version, we can also remove the
kversion parameter in kvm.sh.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 .../selftests/rcutorture/bin/kvm-test-1-run.sh        |  2 +-
 tools/testing/selftests/rcutorture/bin/kvm.sh         | 19 +++++--------------
 2 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index e0f896999d6b..8ca9f21f2efc 100755
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
index e527dc952eb0..368d64ac779e 100755
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
1.8.1.5

