Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbaH1TNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 15:13:33 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43242 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbaH1TMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 15:12:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/11] rcutorture: Specify MAXSMP=y for TREE01
Date: Thu, 28 Aug 2014 12:12:18 -0700
Message-Id: <1409253143-31466-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409253143-31466-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828191203.GA26955@linux.vnet.ibm.com>
 <1409253143-31466-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082819-1542-0000-0000-0000045FBF7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Setting CONFIG_MAXSMP=y causes cpumasks to be moved offstack, which
introduces the possibility of NULL cpumask_var_t pointers.  This commit
therefore enables CONFIG_MAXSMP=y in TREE01 to increase test coverage.
However, because CONFIG_MAXSMP=y implies 8192 CPUs, we need to use
the maxcpus= boot parameter to limit the number of CPUs to something
reasonable, which in turn requires updating the scripts to handle this.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/functions.sh  | 20 ++++++++++++++++++++
 .../selftests/rcutorture/bin/kvm-test-1-run.sh       |  1 +
 tools/testing/selftests/rcutorture/bin/kvm.sh        |  4 +++-
 .../testing/selftests/rcutorture/configs/rcu/TREE01  |  4 +---
 .../selftests/rcutorture/configs/rcu/TREE01.boot     |  2 +-
 5 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/functions.sh b/tools/testing/selftests/rcutorture/bin/functions.sh
index d01b865bb100..b325470c01b3 100644
--- a/tools/testing/selftests/rcutorture/bin/functions.sh
+++ b/tools/testing/selftests/rcutorture/bin/functions.sh
@@ -64,6 +64,26 @@ configfrag_boot_params () {
 	fi
 }
 
+# configfrag_boot_cpus bootparam-string config-fragment-file config-cpus
+#
+# Decreases number of CPUs based on any maxcpus= boot parameters specified.
+configfrag_boot_cpus () {
+	local bootargs="`configfrag_boot_params "$1" "$2"`"
+	local maxcpus
+	if echo "${bootargs}" | grep -q 'maxcpus=[0-9]'
+	then
+		maxcpus="`echo "${bootargs}" | sed -e 's/^.*maxcpus=\([0-9]*\).*$/\1/'`"
+		if test "$3" -gt "$maxcpus"
+		then
+			echo $maxcpus
+		else
+			echo $3
+		fi
+	else
+		echo $3
+	fi
+}
+
 # configfrag_hotplug_cpu config-fragment-file
 #
 # Returns 1 if the config fragment specifies hotplug CPU.
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index 6d2f5fa48484..487308fabf76 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -140,6 +140,7 @@ fi
 # Generate -smp qemu argument.
 qemu_args="-nographic $qemu_args"
 cpu_count=`configNR_CPUS.sh $config_template`
+cpu_count=`configfrag_boot_cpus "$boot_args" "$config_template" "$cpu_count"`
 vcpus=`identify_qemu_vcpus`
 if test $cpu_count -gt $vcpus
 then
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 36534f9938ca..e527dc952eb0 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -188,7 +188,9 @@ for CF in $configs
 do
 	if test -f "$CONFIGFRAG/$kversion/$CF"
 	then
-		echo $CF `configNR_CPUS.sh $CONFIGFRAG/$kversion/$CF` >> $T/cfgcpu
+		cpu_count=`configNR_CPUS.sh $CONFIGFRAG/$kversion/$CF`
+		cpu_count=`configfrag_boot_cpus "$TORTURE_BOOTARGS" "$CONFIGFRAG/$kversion/$CF" "$cpu_count"`
+		echo $CF $cpu_count >> $T/cfgcpu
 	else
 		echo "The --configs file $CF does not exist, terminating."
 		exit 1
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE01 b/tools/testing/selftests/rcutorture/configs/rcu/TREE01
index 063b7079c621..38e3895759dd 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE01
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE01
@@ -1,5 +1,4 @@
 CONFIG_SMP=y
-CONFIG_NR_CPUS=8
 CONFIG_PREEMPT_NONE=n
 CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=y
@@ -10,8 +9,7 @@ CONFIG_NO_HZ_FULL=n
 CONFIG_RCU_FAST_NO_HZ=y
 CONFIG_RCU_TRACE=y
 CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_FANOUT=8
-CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_MAXSMP=y
 CONFIG_RCU_NOCB_CPU=y
 CONFIG_RCU_NOCB_CPU_ZERO=y
 CONFIG_DEBUG_LOCK_ALLOC=n
diff --git a/tools/testing/selftests/rcutorture/configs/rcu/TREE01.boot b/tools/testing/selftests/rcutorture/configs/rcu/TREE01.boot
index 0fc8a3428938..adc3abc82fb8 100644
--- a/tools/testing/selftests/rcutorture/configs/rcu/TREE01.boot
+++ b/tools/testing/selftests/rcutorture/configs/rcu/TREE01.boot
@@ -1 +1 @@
-rcutorture.torture_type=rcu_bh
+rcutorture.torture_type=rcu_bh maxcpus=8
-- 
1.8.1.5

