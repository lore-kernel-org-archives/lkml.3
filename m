Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbaBQWOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:14:44 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35260 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaBQWNW (ORCPT
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
Subject: [PATCH tip/core/rcu 45/55] rcutorture: Create CFcommon file for common Kconfig parameters
Date: Mon, 17 Feb 2014 14:12:49 -0800
Message-Id: <1392675179-11560-45-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F3866
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently, CONFIG_RCU_TORTURE_TEST=y is hardcoded into the
kvm-test-1-rcu.sh script and CONFIG_PRINTK_TIME=y is mentioned in each
and every configs file.  This commit creates a CFcommon file for these
two Kconfig parameters, and modifies kvm-test-1-rcu.sh to copy this new
file into the .config file during the build.  This change will allow
these scripts to operate on torture types other than just rcutorture.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh | 8 +++++---
 tools/testing/selftests/rcutorture/configs/BUSTED        | 1 -
 tools/testing/selftests/rcutorture/configs/CFcommon      | 2 ++
 tools/testing/selftests/rcutorture/configs/SRCU-N        | 1 -
 tools/testing/selftests/rcutorture/configs/SRCU-P        | 1 -
 tools/testing/selftests/rcutorture/configs/TINY01        | 1 -
 tools/testing/selftests/rcutorture/configs/TINY02        | 1 -
 tools/testing/selftests/rcutorture/configs/TREE01        | 1 -
 tools/testing/selftests/rcutorture/configs/TREE02        | 1 -
 tools/testing/selftests/rcutorture/configs/TREE03        | 1 -
 tools/testing/selftests/rcutorture/configs/TREE04        | 1 -
 tools/testing/selftests/rcutorture/configs/TREE05        | 1 -
 tools/testing/selftests/rcutorture/configs/TREE06        | 1 -
 tools/testing/selftests/rcutorture/configs/TREE07        | 1 -
 tools/testing/selftests/rcutorture/configs/TREE08        | 1 -
 tools/testing/selftests/rcutorture/configs/TREE08-T      | 1 -
 tools/testing/selftests/rcutorture/configs/TREE09        | 1 -
 17 files changed, 7 insertions(+), 18 deletions(-)
 create mode 100644 tools/testing/selftests/rcutorture/configs/CFcommon

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
index 41ea7810354f..30cfbc8f3a0b 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
@@ -47,6 +47,7 @@ trap 'rm -rf $T' 0
 . $KVPATH/ver_functions.sh
 
 config_template=${1}
+config_dir=`echo $config_template | sed -e 's,/[^/]*$,,'`
 title=`echo $config_template | sed -e 's/^.*\///'`
 builddir=${2}
 if test -z "$builddir" -o ! -d "$builddir" -o ! -w "$builddir"
@@ -63,9 +64,10 @@ fi
 cp $config_template $resdir/ConfigFragment
 echo ' ---' `date`: Starting build
 echo ' ---' Kconfig fragment at: $config_template >> $resdir/log
-cat << '___EOF___' >> $T
-CONFIG_RCU_TORTURE_TEST=y
-___EOF___
+if test -r "$config_dir/CFcommon"
+then
+	cat < $config_dir/CFcommon >> $T
+fi
 # Optimizations below this point
 # CONFIG_USB=n
 # CONFIG_SECURITY=n
diff --git a/tools/testing/selftests/rcutorture/configs/BUSTED b/tools/testing/selftests/rcutorture/configs/BUSTED
index 46fb6cf30cc2..48d8a245c7fa 100644
--- a/tools/testing/selftests/rcutorture/configs/BUSTED
+++ b/tools/testing/selftests/rcutorture/configs/BUSTED
@@ -5,4 +5,3 @@ CONFIG_HOTPLUG_CPU=y
 CONFIG_PREEMPT_NONE=n
 CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=y
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/CFcommon b/tools/testing/selftests/rcutorture/configs/CFcommon
new file mode 100644
index 000000000000..d2d2a86139db
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/CFcommon
@@ -0,0 +1,2 @@
+CONFIG_RCU_TORTURE_TEST=y
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-N b/tools/testing/selftests/rcutorture/configs/SRCU-N
index b4c6340d920a..9fbb41b9b314 100644
--- a/tools/testing/selftests/rcutorture/configs/SRCU-N
+++ b/tools/testing/selftests/rcutorture/configs/SRCU-N
@@ -5,4 +5,3 @@ CONFIG_HOTPLUG_CPU=y
 CONFIG_PREEMPT_NONE=y
 CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/SRCU-P b/tools/testing/selftests/rcutorture/configs/SRCU-P
index 6650e00c6d91..4b6f272dba27 100644
--- a/tools/testing/selftests/rcutorture/configs/SRCU-P
+++ b/tools/testing/selftests/rcutorture/configs/SRCU-P
@@ -5,4 +5,3 @@ CONFIG_HOTPLUG_CPU=y
 CONFIG_PREEMPT_NONE=n
 CONFIG_PREEMPT_VOLUNTARY=n
 CONFIG_PREEMPT=y
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TINY01 b/tools/testing/selftests/rcutorture/configs/TINY01
index 0c2823f21712..0a63e073a00c 100644
--- a/tools/testing/selftests/rcutorture/configs/TINY01
+++ b/tools/testing/selftests/rcutorture/configs/TINY01
@@ -10,4 +10,3 @@ CONFIG_RCU_TRACE=n
 CONFIG_DEBUG_LOCK_ALLOC=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
 CONFIG_PREEMPT_COUNT=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TINY02 b/tools/testing/selftests/rcutorture/configs/TINY02
index e5072d7528b6..f4feaee40776 100644
--- a/tools/testing/selftests/rcutorture/configs/TINY02
+++ b/tools/testing/selftests/rcutorture/configs/TINY02
@@ -10,4 +10,3 @@ CONFIG_RCU_TRACE=y
 CONFIG_DEBUG_LOCK_ALLOC=y
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
 CONFIG_PREEMPT_COUNT=y
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE01 b/tools/testing/selftests/rcutorture/configs/TREE01
index 141119a00044..9c827ec59a97 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE01
+++ b/tools/testing/selftests/rcutorture/configs/TREE01
@@ -20,4 +20,3 @@ CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE02 b/tools/testing/selftests/rcutorture/configs/TREE02
index 2d4d09608528..bca03f6b3046 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE02
+++ b/tools/testing/selftests/rcutorture/configs/TREE02
@@ -23,4 +23,3 @@ CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=y
 CONFIG_RCU_BOOST=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE03 b/tools/testing/selftests/rcutorture/configs/TREE03
index a47de5be8a04..c1f111c1561b 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE03
+++ b/tools/testing/selftests/rcutorture/configs/TREE03
@@ -20,4 +20,3 @@ CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=y
 CONFIG_RCU_BOOST_PRIO=2
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE04 b/tools/testing/selftests/rcutorture/configs/TREE04
index 8d839b86a1d5..7dbd27ce17a4 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE04
+++ b/tools/testing/selftests/rcutorture/configs/TREE04
@@ -22,4 +22,3 @@ CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=y
 CONFIG_RCU_CPU_STALL_VERBOSE=y
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE05 b/tools/testing/selftests/rcutorture/configs/TREE05
index b5ba72ea25cb..d0f32e574743 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE05
+++ b/tools/testing/selftests/rcutorture/configs/TREE05
@@ -22,4 +22,3 @@ CONFIG_PROVE_RCU_DELAY=y
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE06 b/tools/testing/selftests/rcutorture/configs/TREE06
index 7c95ab48d29f..2e477dfb9c57 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE06
+++ b/tools/testing/selftests/rcutorture/configs/TREE06
@@ -23,4 +23,3 @@ CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE07 b/tools/testing/selftests/rcutorture/configs/TREE07
index 1467404bdec1..042f86ef362a 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE07
+++ b/tools/testing/selftests/rcutorture/configs/TREE07
@@ -21,4 +21,3 @@ CONFIG_PROVE_RCU_DELAY=n
 CONFIG_RCU_CPU_STALL_INFO=y
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE08 b/tools/testing/selftests/rcutorture/configs/TREE08
index 7d097a61ac2a..3438cee1e3c5 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE08
+++ b/tools/testing/selftests/rcutorture/configs/TREE08
@@ -23,4 +23,3 @@ CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE08-T b/tools/testing/selftests/rcutorture/configs/TREE08-T
index 442c4e450ab3..bf4523d3e44c 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE08-T
+++ b/tools/testing/selftests/rcutorture/configs/TREE08-T
@@ -23,4 +23,3 @@ CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE09 b/tools/testing/selftests/rcutorture/configs/TREE09
index 0d1ec0d3dfee..81e4f7c0bf0b 100644
--- a/tools/testing/selftests/rcutorture/configs/TREE09
+++ b/tools/testing/selftests/rcutorture/configs/TREE09
@@ -18,4 +18,3 @@ CONFIG_RCU_CPU_STALL_INFO=n
 CONFIG_RCU_CPU_STALL_VERBOSE=n
 CONFIG_RCU_BOOST=n
 CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
-CONFIG_PRINTK_TIME=y
-- 
1.8.1.5

