Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbaBQWUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:20:18 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35209 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbaBQWNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:20 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 46/55] rcutorture: Remove RCU dependencies from ver_functions.sh API
Date: Mon, 17 Feb 2014 14:12:50 -0800
Message-Id: <1392675179-11560-46-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F3855
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The current set of functions in ver_functions.sh have APIs that are
specific to RCU.  This commit therefore makes an RCU-independent function
that outputs version-specific boot arguments.  This has the benefit that
a test-type-independent call in kvm-test-1-rcu.sh can now handle any type
of test, given a test-type-specific set of files in a configs directory.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 .../selftests/rcutorture/bin/kvm-test-1-rcu.sh     |  8 ++-----
 .../rcutorture/configs/v0.0/ver_functions.sh       | 22 +++++++++----------
 .../rcutorture/configs/v3.3/ver_functions.sh       | 25 ++++++++++++----------
 .../rcutorture/configs/v3.5/ver_functions.sh       | 23 ++++++++++++++------
 .../selftests/rcutorture/configs/ver_functions.sh  | 21 +++++++++++++-----
 5 files changed, 59 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
index 30cfbc8f3a0b..7986b3e7f318 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
@@ -148,12 +148,8 @@ qemu_append="`identify_qemu_append "$QEMU"`"
 
 # Pull in Kconfig-fragment boot parameters
 boot_args="`configfrag_boot_params "$boot_args" "$config_template"`"
-# Generate CPU-hotplug boot parameters
-boot_args="`rcutorture_param_onoff "$boot_args" $builddir/.config`"
-# Generate rcu_barrier() boot parameter
-boot_args="`rcutorture_param_n_barrier_cbs "$boot_args"`"
-# Pull in standard rcutorture boot arguments
-boot_args="$boot_args rcutorture.stat_interval=15 rcutorture.shutdown_secs=$seconds rcutorture.rcutorture_runnable=1 rcutorture.test_no_idle_hz=1 rcutorture.verbose=1"
+# Generate kernel-version-specific boot parameters
+boot_args="`per_version_boot_params "$boot_args" $builddir/.config $seconds`"
 
 echo $QEMU $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
 if test -n "$RCU_BUILDONLY"
diff --git a/tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh
index e8052539af54..5ace37a89780 100644
--- a/tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh
+++ b/tools/testing/selftests/rcutorture/configs/v0.0/ver_functions.sh
@@ -20,16 +20,14 @@
 #
 # Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
 
-# rcutorture_param_n_barrier_cbs bootparam-string
-#
-# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
-rcutorture_param_n_barrier_cbs () {
-	echo $1
-}
-
-# rcutorture_param_onoff bootparam-string config-file
-#
-# Adds onoff rcutorture module parameters to kernels having it.
-rcutorture_param_onoff () {
-	echo $1
+# per_version_boot_params bootparam-string config-file seconds
+#
+# Adds per-version torture-module parameters to kernels supporting them.
+# Which old kernels do not.
+per_version_boot_params () {
+	echo	rcutorture.stat_interval=15 \
+		rcutorture.shutdown_secs=$3 \
+		rcutorture.rcutorture_runnable=1 \
+		rcutorture.test_no_idle_hz=1 \
+		rcutorture.verbose=1
 }
diff --git a/tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh
index c37432f3572c..bae55692ce6e 100644
--- a/tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh
+++ b/tools/testing/selftests/rcutorture/configs/v3.3/ver_functions.sh
@@ -20,22 +20,25 @@
 #
 # Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
 
-# rcutorture_param_n_barrier_cbs bootparam-string
-#
-# Adds n_barrier_cbs rcutorture module parameter to kernels having it.
-rcutorture_param_n_barrier_cbs () {
-	echo $1
-}
-
 # rcutorture_param_onoff bootparam-string config-file
 #
 # Adds onoff rcutorture module parameters to kernels having it.
 rcutorture_param_onoff () {
 	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
 	then
-		echo CPU-hotplug kernel, adding rcutorture onoff.
-		echo $1 rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
-	else
-		echo $1
+		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
+		echo rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
 	fi
 }
+
+# per_version_boot_params bootparam-string config-file seconds
+#
+# Adds per-version torture-module parameters to kernels supporting them.
+per_version_boot_params () {
+	echo $1 `rcutorture_param_onoff "$1" "$2"` \
+		rcutorture.stat_interval=15 \
+		rcutorture.shutdown_secs=$3 \
+		rcutorture.rcutorture_runnable=1 \
+		rcutorture.test_no_idle_hz=1 \
+		rcutorture.verbose=1
+}
diff --git a/tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh
index 6a5f13aab44d..8977d8d31b19 100644
--- a/tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh
+++ b/tools/testing/selftests/rcutorture/configs/v3.5/ver_functions.sh
@@ -26,9 +26,9 @@
 rcutorture_param_n_barrier_cbs () {
 	if echo $1 | grep -q "rcutorture\.n_barrier_cbs"
 	then
-		echo $1
+		:
 	else
-		echo $1 rcutorture.n_barrier_cbs=4
+		echo rcutorture.n_barrier_cbs=4
 	fi
 }
 
@@ -38,9 +38,20 @@ rcutorture_param_n_barrier_cbs () {
 rcutorture_param_onoff () {
 	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
 	then
-		echo CPU-hotplug kernel, adding rcutorture onoff.
-		echo $1 rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
-	else
-		echo $1
+		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
+		echo rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
 	fi
 }
+
+# per_version_boot_params bootparam-string config-file seconds
+#
+# Adds per-version torture-module parameters to kernels supporting them.
+per_version_boot_params () {
+	echo $1 `rcutorture_param_onoff "$1" "$2"` \
+		`rcutorture_param_n_barrier_cbs "$1"` \
+		rcutorture.stat_interval=15 \
+		rcutorture.shutdown_secs=$3 \
+		rcutorture.rcutorture_runnable=1 \
+		rcutorture.test_no_idle_hz=1 \
+		rcutorture.verbose=1
+}
diff --git a/tools/testing/selftests/rcutorture/configs/ver_functions.sh b/tools/testing/selftests/rcutorture/configs/ver_functions.sh
index 5e40eadea777..8977d8d31b19 100644
--- a/tools/testing/selftests/rcutorture/configs/ver_functions.sh
+++ b/tools/testing/selftests/rcutorture/configs/ver_functions.sh
@@ -26,9 +26,9 @@
 rcutorture_param_n_barrier_cbs () {
 	if echo $1 | grep -q "rcutorture\.n_barrier_cbs"
 	then
-		echo $1
+		:
 	else
-		echo $1 rcutorture.n_barrier_cbs=4
+		echo rcutorture.n_barrier_cbs=4
 	fi
 }
 
@@ -39,8 +39,19 @@ rcutorture_param_onoff () {
 	if ! bootparam_hotplug_cpu "$1" && configfrag_hotplug_cpu "$2"
 	then
 		echo CPU-hotplug kernel, adding rcutorture onoff. 1>&2
-		echo $1 rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
-	else
-		echo $1
+		echo rcutorture.onoff_interval=3 rcutorture.onoff_holdoff=30
 	fi
 }
+
+# per_version_boot_params bootparam-string config-file seconds
+#
+# Adds per-version torture-module parameters to kernels supporting them.
+per_version_boot_params () {
+	echo $1 `rcutorture_param_onoff "$1" "$2"` \
+		`rcutorture_param_n_barrier_cbs "$1"` \
+		rcutorture.stat_interval=15 \
+		rcutorture.shutdown_secs=$3 \
+		rcutorture.rcutorture_runnable=1 \
+		rcutorture.test_no_idle_hz=1 \
+		rcutorture.verbose=1
+}
-- 
1.8.1.5

