Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab3KPAiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:38:01 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:57133 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923Ab3KPAgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:36:09 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH tip/core/rcu 08/28] rcutorture: Refactor TREE_RCU test cases
Date: Fri, 15 Nov 2013 16:35:21 -0800
Message-Id: <1384562141-32446-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-9332-0000-0000-0000022BC20B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The TREE_RCU test cases were first put in place many years ago, and have
been incrementally modified rather than being reworked.  This commit
therefore completes a long-overdue reworking of the TREE_RCU test cases.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rcutorture/configs/CFLIST  | 26 +++---
 .../rcutorture/configs/N1-S-T-NH-SD-SMP-HP         | 19 -----
 .../rcutorture/configs/N2-2-t-nh-sd-SMP-hp         | 20 -----
 .../rcutorture/configs/N3-3-T-nh-SD-SMP-hp         | 22 -----
 .../rcutorture/configs/N4-A-t-NH-sd-SMP-HP         | 18 ----
 .../rcutorture/configs/N5-U-T-NH-sd-SMP-hp         | 22 -----
 .../rcutorture/configs/N6---t-nh-SD-smp-hp         | 19 -----
 .../rcutorture/configs/N7-4-T-NH-SD-SMP-HP         | 26 ------
 .../rcutorture/configs/N8-2-T-NH-SD-SMP-HP         | 22 -----
 .../rcutorture/configs/P1-S-T-NH-SD-SMP-HP         | 20 -----
 .../rcutorture/configs/P2-2-t-nh-sd-SMP-hp         | 20 -----
 .../rcutorture/configs/P3-3-T-nh-SD-SMP-hp         | 20 -----
 .../rcutorture/configs/P4-A-t-NH-sd-SMP-HP         | 22 -----
 .../rcutorture/configs/P5-U-T-NH-sd-SMP-hp         | 28 -------
 .../rcutorture/configs/P6---t-nh-SD-smp-hp         | 18 ----
 .../rcutorture/configs/P7-4-T-NH-SD-SMP-HP         | 30 -------
 .../rcutorture/configs/P7-4-T-NH-SD-SMP-HP-all     | 30 -------
 .../rcutorture/configs/P7-4-T-NH-SD-SMP-HP-none    | 30 -------
 .../rcutorture/configs/P7-4-T-NH-SD-SMP-hp         | 30 -------
 tools/testing/selftests/rcutorture/configs/TREE01  | 23 ++++++
 .../selftests/rcutorture/configs/TREE01.boot       |  1 +
 tools/testing/selftests/rcutorture/configs/TREE02  | 26 ++++++
 tools/testing/selftests/rcutorture/configs/TREE03  | 23 ++++++
 tools/testing/selftests/rcutorture/configs/TREE04  | 25 ++++++
 .../selftests/rcutorture/configs/TREE04.boot       |  1 +
 tools/testing/selftests/rcutorture/configs/TREE05  | 25 ++++++
 .../selftests/rcutorture/configs/TREE05.boot       |  1 +
 tools/testing/selftests/rcutorture/configs/TREE06  | 26 ++++++
 tools/testing/selftests/rcutorture/configs/TREE07  | 24 ++++++
 tools/testing/selftests/rcutorture/configs/TREE08  | 26 ++++++
 tools/testing/selftests/rcutorture/configs/TREE09  | 21 +++++
 .../rcutorture/configs/sysidleN.2013.06.19a        | 23 ------
 .../rcutorture/configs/sysidleY.2013.06.19a        | 26 ------
 .../selftests/rcutorture/doc/TREE_RCU-Kconfig.txt  | 95 ++++++++++++++++++++++
 34 files changed, 328 insertions(+), 480 deletions(-)
 delete mode 100644 tools/testing/selftests/rcutorture/configs/N1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/N2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/N3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/N4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/N5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/N6---t-nh-SD-smp-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/N7-4-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/N8-2-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/P1-S-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/P2-2-t-nh-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/P3-3-T-nh-SD-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/P4-A-t-NH-sd-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/P5-U-T-NH-sd-SMP-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/P6---t-nh-SD-smp-hp
 delete mode 100644 tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP
 delete mode 100644 tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-all
 delete mode 100644 tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-none
 delete mode 100644 tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-hp
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE01
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE01.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE02
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE03
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE04
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE04.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE05
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE05.boot
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE06
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE07
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE08
 create mode 100644 tools/testing/selftests/rcutorture/configs/TREE09
 delete mode 100644 tools/testing/selftests/rcutorture/configs/sysidleN.2013.06.19a
 delete mode 100644 tools/testing/selftests/rcutorture/configs/sysidleY.2013.06.19a
 create mode 100644 tools/testing/selftests/rcutorture/doc/TREE_RCU-Kconfig.txt

diff --git a/tools/testing/selftests/rcutorture/configs/CFLIST b/tools/testing/selftests/rcutorture/configs/CFLIST
index da4cbc668f2a..884491b25c19 100644
--- a/tools/testing/selftests/rcutorture/configs/CFLIST
+++ b/tools/testing/selftests/rcutorture/configs/CFLIST
@@ -1,17 +1,13 @@
-sysidleY.2013.06.19a
-sysidleN.2013.06.19a
-P1-S-T-NH-SD-SMP-HP
-P2-2-t-nh-sd-SMP-hp
-P3-3-T-nh-SD-SMP-hp
-P4-A-t-NH-sd-SMP-HP
-P5-U-T-NH-sd-SMP-hp
-P6---t-nh-SD-smp-hp
-N1-S-T-NH-SD-SMP-HP
-N2-2-t-nh-sd-SMP-hp
-N3-3-T-nh-SD-SMP-hp
-N4-A-t-NH-sd-SMP-HP
-N5-U-T-NH-sd-SMP-hp
-PT1-nh
-PT2-NH
+TREE01
+TREE02
+TREE03
+TREE04
+TREE05
+TREE06
+TREE07
+TREE08
+TREE09
+SRCU-N
+SRCU-P
 NT1-nh
 NT3-NH
diff --git a/tools/testing/selftests/rcutorture/configs/N1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/N1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index d81e11d280aa..000000000000
--- a/tools/testing/selftests/rcutorture/configs/N1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,19 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/N2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/N2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 02e418572b1b..000000000000
--- a/tools/testing/selftests/rcutorture/configs/N2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/N3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/N3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b3100f69c8cf..000000000000
--- a/tools/testing/selftests/rcutorture/configs/N3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/N4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/N4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index c56b44530725..000000000000
--- a/tools/testing/selftests/rcutorture/configs/N4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/N5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/N5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index 90d924fea9e9..000000000000
--- a/tools/testing/selftests/rcutorture/configs/N5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/N6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/N6---t-nh-SD-smp-hp
deleted file mode 100644
index 0ccc36d72738..000000000000
--- a/tools/testing/selftests/rcutorture/configs/N6---t-nh-SD-smp-hp
+++ /dev/null
@@ -1,19 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_NR_CPUS=1
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/N7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/N7-4-T-NH-SD-SMP-HP
deleted file mode 100644
index 3f640cf84973..000000000000
--- a/tools/testing/selftests/rcutorture/configs/N7-4-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,26 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=y
-CONFIG_RCU_NOCB_CPU_ZERO=n
-CONFIG_RCU_NOCB_CPU_ALL=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/N8-2-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/N8-2-T-NH-SD-SMP-HP
deleted file mode 100644
index 285da2dd8ac3..000000000000
--- a/tools/testing/selftests/rcutorture/configs/N8-2-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=14
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=y
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=n
-#CHECK#CONFIG_TREE_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/P1-S-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/P1-S-T-NH-SD-SMP-HP
deleted file mode 100644
index 9647c44cf4b7..000000000000
--- a/tools/testing/selftests/rcutorture/configs/P1-S-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/P2-2-t-nh-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/P2-2-t-nh-sd-SMP-hp
deleted file mode 100644
index 0f3b667d2a9f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/P2-2-t-nh-sd-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=4
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/P3-3-T-nh-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/P3-3-T-nh-SD-SMP-hp
deleted file mode 100644
index b035e141bf2a..000000000000
--- a/tools/testing/selftests/rcutorture/configs/P3-3-T-nh-SD-SMP-hp
+++ /dev/null
@@ -1,20 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=n
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/P4-A-t-NH-sd-SMP-HP b/tools/testing/selftests/rcutorture/configs/P4-A-t-NH-sd-SMP-HP
deleted file mode 100644
index 3ccf6a9447f5..000000000000
--- a/tools/testing/selftests/rcutorture/configs/P4-A-t-NH-sd-SMP-HP
+++ /dev/null
@@ -1,22 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/P5-U-T-NH-sd-SMP-hp b/tools/testing/selftests/rcutorture/configs/P5-U-T-NH-sd-SMP-hp
deleted file mode 100644
index ef624ce73d8e..000000000000
--- a/tools/testing/selftests/rcutorture/configs/P5-U-T-NH-sd-SMP-hp
+++ /dev/null
@@ -1,28 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=6
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=y
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_PROVE_RCU_DELAY=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_RT_MUTEXES=y
-CONFIG_RCU_BOOST=y
-CONFIG_RCU_BOOST_PRIO=2
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/P6---t-nh-SD-smp-hp b/tools/testing/selftests/rcutorture/configs/P6---t-nh-SD-smp-hp
deleted file mode 100644
index f4c9175828bf..000000000000
--- a/tools/testing/selftests/rcutorture/configs/P6---t-nh-SD-smp-hp
+++ /dev/null
@@ -1,18 +0,0 @@
-CONFIG_RCU_TRACE=n
-CONFIG_NO_HZ=n
-CONFIG_SMP=n
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP b/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP
deleted file mode 100644
index 77a8c5b75763..000000000000
--- a/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP
+++ /dev/null
@@ -1,30 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=n
-CONFIG_RCU_NOCB_CPU_ZERO=n
-CONFIG_RCU_NOCB_CPU_ALL=y
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_SLUB=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-all b/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-all
deleted file mode 100644
index 0eecebc6e95f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-all
+++ /dev/null
@@ -1,30 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=y
-CONFIG_RCU_NOCB_CPU_ZERO=n
-CONFIG_RCU_NOCB_CPU_ALL=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_SLUB=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-none b/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-none
deleted file mode 100644
index 0eecebc6e95f..000000000000
--- a/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-HP-none
+++ /dev/null
@@ -1,30 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=y
-CONFIG_RCU_NOCB_CPU_ZERO=n
-CONFIG_RCU_NOCB_CPU_ALL=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_SLUB=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-hp b/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-hp
deleted file mode 100644
index 588bc70420cd..000000000000
--- a/tools/testing/selftests/rcutorture/configs/P7-4-T-NH-SD-SMP-hp
+++ /dev/null
@@ -1,30 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=2
-CONFIG_NR_CPUS=16
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=n
-CONFIG_RCU_NOCB_CPU=y
-CONFIG_RCU_NOCB_CPU_NONE=n
-CONFIG_RCU_NOCB_CPU_ZERO=y
-CONFIG_RCU_NOCB_CPU_ALL=n
-CONFIG_SUSPEND=n
-CONFIG_HIBERNATION=n
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_DEBUG_OBJECTS=y
-CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_SLUB=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/TREE01 b/tools/testing/selftests/rcutorture/configs/TREE01
new file mode 100644
index 000000000000..141119a00044
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE01
@@ -0,0 +1,23 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_RCU_TRACE=y
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_FANOUT=8
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_ZERO=y
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_RCU_BOOST=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE01.boot b/tools/testing/selftests/rcutorture/configs/TREE01.boot
new file mode 100644
index 000000000000..0fc8a3428938
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE01.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=rcu_bh
diff --git a/tools/testing/selftests/rcutorture/configs/TREE02 b/tools/testing/selftests/rcutorture/configs/TREE02
new file mode 100644
index 000000000000..2d4d09608528
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE02
@@ -0,0 +1,26 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_FAST_NO_HZ=n 
+CONFIG_RCU_TRACE=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_RCU_FANOUT=3
+CONFIG_RCU_FANOUT_LEAF=3
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_RCU_NOCB_CPU=n
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_PROVE_LOCKING=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=y
+CONFIG_RCU_BOOST=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE03 b/tools/testing/selftests/rcutorture/configs/TREE03
new file mode 100644
index 000000000000..a47de5be8a04
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE03
@@ -0,0 +1,23 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_HZ_PERIODIC=y
+CONFIG_NO_HZ_IDLE=n
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_TRACE=y
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_FANOUT=4
+CONFIG_RCU_FANOUT_LEAF=4
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_RCU_NOCB_CPU=n
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_RCU_BOOST=y
+CONFIG_RCU_BOOST_PRIO=2
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE04 b/tools/testing/selftests/rcutorture/configs/TREE04
new file mode 100644
index 000000000000..8d839b86a1d5
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE04
@@ -0,0 +1,25 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=n
+CONFIG_NO_HZ_FULL=y
+CONFIG_NO_HZ_FULL_ALL=y
+CONFIG_RCU_FAST_NO_HZ=y
+CONFIG_RCU_TRACE=y
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_RCU_FANOUT=2
+CONFIG_RCU_FANOUT_LEAF=2
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_RCU_NOCB_CPU=n
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_RCU_CPU_STALL_VERBOSE=y
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE04.boot b/tools/testing/selftests/rcutorture/configs/TREE04.boot
new file mode 100644
index 000000000000..0fc8a3428938
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE04.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=rcu_bh
diff --git a/tools/testing/selftests/rcutorture/configs/TREE05 b/tools/testing/selftests/rcutorture/configs/TREE05
new file mode 100644
index 000000000000..b5ba72ea25cb
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE05
@@ -0,0 +1,25 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_FAST_NO_HZ=n
+CONFIG_RCU_TRACE=n
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_FANOUT=6
+CONFIG_RCU_FANOUT_LEAF=6
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_NONE=y
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_PROVE_RCU_DELAY=y
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE05.boot b/tools/testing/selftests/rcutorture/configs/TREE05.boot
new file mode 100644
index 000000000000..3b42b8b033cd
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE05.boot
@@ -0,0 +1 @@
+rcutorture.torture_type=sched
diff --git a/tools/testing/selftests/rcutorture/configs/TREE06 b/tools/testing/selftests/rcutorture/configs/TREE06
new file mode 100644
index 000000000000..7c95ab48d29f
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE06
@@ -0,0 +1,26 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=8
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_FAST_NO_HZ=n
+CONFIG_RCU_TRACE=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_RCU_FANOUT=6
+CONFIG_RCU_FANOUT_LEAF=6
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_RCU_NOCB_CPU=n
+CONFIG_DEBUG_LOCK_ALLOC=y
+CONFIG_PROVE_LOCKING=y
+CONFIG_PROVE_RCU=y
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE07 b/tools/testing/selftests/rcutorture/configs/TREE07
new file mode 100644
index 000000000000..1467404bdec1
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE07
@@ -0,0 +1,24 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=16
+CONFIG_PREEMPT_NONE=y
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=n
+#CHECK#CONFIG_TREE_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=n
+CONFIG_NO_HZ_FULL=y
+CONFIG_NO_HZ_FULL_ALL=y
+CONFIG_NO_HZ_FULL_SYSIDLE=y
+CONFIG_RCU_FAST_NO_HZ=n
+CONFIG_RCU_TRACE=y
+CONFIG_HOTPLUG_CPU=y
+CONFIG_RCU_FANOUT=2
+CONFIG_RCU_FANOUT_LEAF=2
+CONFIG_RCU_FANOUT_EXACT=n
+CONFIG_RCU_NOCB_CPU=n
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE08 b/tools/testing/selftests/rcutorture/configs/TREE08
new file mode 100644
index 000000000000..7d097a61ac2a
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE08
@@ -0,0 +1,26 @@
+CONFIG_SMP=y
+CONFIG_NR_CPUS=16
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_FAST_NO_HZ=n
+CONFIG_RCU_TRACE=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_RCU_FANOUT=3
+CONFIG_RCU_FANOUT_EXACT=y
+CONFIG_RCU_FANOUT_LEAF=2
+CONFIG_RCU_NOCB_CPU=y
+CONFIG_RCU_NOCB_CPU_ALL=y
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_RCU_BOOST=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/TREE09 b/tools/testing/selftests/rcutorture/configs/TREE09
new file mode 100644
index 000000000000..0d1ec0d3dfee
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/configs/TREE09
@@ -0,0 +1,21 @@
+CONFIG_SMP=n
+CONFIG_NR_CPUS=1
+CONFIG_PREEMPT_NONE=n
+CONFIG_PREEMPT_VOLUNTARY=n
+CONFIG_PREEMPT=y
+#CHECK#CONFIG_TREE_PREEMPT_RCU=y
+CONFIG_HZ_PERIODIC=n
+CONFIG_NO_HZ_IDLE=y
+CONFIG_NO_HZ_FULL=n
+CONFIG_RCU_TRACE=n
+CONFIG_HOTPLUG_CPU=n
+CONFIG_SUSPEND=n
+CONFIG_HIBERNATION=n
+CONFIG_RCU_NOCB_CPU=n
+CONFIG_DEBUG_LOCK_ALLOC=n
+CONFIG_PROVE_RCU_DELAY=n
+CONFIG_RCU_CPU_STALL_INFO=n
+CONFIG_RCU_CPU_STALL_VERBOSE=n
+CONFIG_RCU_BOOST=n
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=n
+CONFIG_PRINTK_TIME=y
diff --git a/tools/testing/selftests/rcutorture/configs/sysidleN.2013.06.19a b/tools/testing/selftests/rcutorture/configs/sysidleN.2013.06.19a
deleted file mode 100644
index 9dbcde3a517e..000000000000
--- a/tools/testing/selftests/rcutorture/configs/sysidleN.2013.06.19a
+++ /dev/null
@@ -1,23 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ_PERIODIC=n
-CONFIG_NO_HZ_IDLE=n
-CONFIG_NO_HZ_FULL=y
-CONFIG_NO_HZ_FULL_SYSIDLE=n
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
diff --git a/tools/testing/selftests/rcutorture/configs/sysidleY.2013.06.19a b/tools/testing/selftests/rcutorture/configs/sysidleY.2013.06.19a
deleted file mode 100644
index d24dd6148ebf..000000000000
--- a/tools/testing/selftests/rcutorture/configs/sysidleY.2013.06.19a
+++ /dev/null
@@ -1,26 +0,0 @@
-CONFIG_RCU_TRACE=y
-CONFIG_RCU_CPU_STALL_INFO=y
-CONFIG_NO_HZ_PERIODIC=n
-CONFIG_NO_HZ_IDLE=n
-CONFIG_NO_HZ_FULL=y
-CONFIG_NO_HZ_FULL_SYSIDLE=y
-CONFIG_RCU_FAST_NO_HZ=y
-CONFIG_SMP=y
-CONFIG_RCU_FANOUT=8
-CONFIG_NR_CPUS=8
-CONFIG_RCU_FANOUT_EXACT=n
-CONFIG_HOTPLUG_CPU=y
-CONFIG_PREEMPT_NONE=n
-CONFIG_PREEMPT_VOLUNTARY=n
-CONFIG_PREEMPT=y
-#CHECK#CONFIG_TREE_PREEMPT_RCU=y
-CONFIG_RCU_TORTURE_TEST=m
-CONFIG_MODULE_UNLOAD=y
-CONFIG_SYSFS_DEPRECATED_V2=y
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-CONFIG_PRINTK_TIME=y
-
-CONFIG_PROVE_LOCKING=y
-CONFIG_PROVE_RCU=y
-
diff --git a/tools/testing/selftests/rcutorture/doc/TREE_RCU-Kconfig.txt b/tools/testing/selftests/rcutorture/doc/TREE_RCU-Kconfig.txt
new file mode 100644
index 000000000000..adbb76cffb49
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/doc/TREE_RCU-Kconfig.txt
@@ -0,0 +1,95 @@
+This document gives a brief rationale for the TREE_RCU-related test
+cases, a group that includes TREE_PREEMPT_RCU.
+
+
+Kconfig Parameters:
+
+CONFIG_DEBUG_LOCK_ALLOC -- Do three, covering CONFIG_PROVE_LOCKING & not.
+CONFIG_DEBUG_OBJECTS_RCU_HEAD -- Do one.
+CONFIG_HOTPLUG_CPU -- Do half.  (Every second.)
+CONFIG_HZ_PERIODIC -- Do one.
+CONFIG_NO_HZ_IDLE -- Do those not otherwise specified. (Groups of two.)
+CONFIG_NO_HZ_FULL -- Do two, one with CONFIG_NO_HZ_FULL_SYSIDLE.
+CONFIG_NO_HZ_FULL_SYSIDLE -- Do one.
+CONFIG_PREEMPT -- Do half.  (First three and #8.)
+CONFIG_PROVE_LOCKING -- Do all but two, covering CONFIG_PROVE_RCU and not.
+CONFIG_PROVE_RCU -- Do all but one under CONFIG_PROVE_LOCKING.
+CONFIG_PROVE_RCU_DELAY -- Do one.
+CONFIG_RCU_BOOST -- one of TREE_PREEMPT_RCU.
+CONFIG_RCU_BOOST_PRIO -- set to 2 for _BOOST testing.
+CONFIG_RCU_CPU_STALL_INFO -- do one with and without _VERBOSE.
+CONFIG_RCU_CPU_STALL_VERBOSE -- do one with and without _INFO.
+CONFIG_RCU_FANOUT -- Cover hierarchy as currently, but overlap with others.
+CONFIG_RCU_FANOUT_EXACT -- Do one.
+CONFIG_RCU_FANOUT_LEAF -- Do one non-default.
+CONFIG_RCU_FAST_NO_HZ -- Do one, but not with CONFIG_RCU_NOCB_CPU_ALL.
+CONFIG_RCU_NOCB_CPU -- Do three, see below.
+CONFIG_RCU_NOCB_CPU_ALL -- Do one.
+CONFIG_RCU_NOCB_CPU_NONE -- Do one.
+CONFIG_RCU_NOCB_CPU_ZERO -- Do one.
+CONFIG_RCU_TRACE -- Do half.
+CONFIG_SMP -- Need one !SMP for TREE_PREEMPT_RCU.
+RCU-bh: Do one with PREEMPT and one with !PREEMPT.
+RCU-sched: Do one with PREEMPT but not BOOST.
+
+
+Hierarchy:
+
+TREE01.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=8, CONFIG_RCU_FANOUT_EXACT=n.
+TREE02.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=3, CONFIG_RCU_FANOUT_EXACT=n,
+	CONFIG_RCU_FANOUT_LEAF=3.
+TREE03.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=4, CONFIG_RCU_FANOUT_EXACT=n,
+	CONFIG_RCU_FANOUT_LEAF=4.
+TREE04.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=2, CONFIG_RCU_FANOUT_EXACT=n,
+	CONFIG_RCU_FANOUT_LEAF=2.
+TREE05.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=6, CONFIG_RCU_FANOUT_EXACT=n
+	CONFIG_RCU_FANOUT_LEAF=6.
+TREE06.	CONFIG_NR_CPUS=8, CONFIG_RCU_FANOUT=6, CONFIG_RCU_FANOUT_EXACT=y
+	CONFIG_RCU_FANOUT_LEAF=6.
+TREE07.	CONFIG_NR_CPUS=16, CONFIG_RCU_FANOUT=2, CONFIG_RCU_FANOUT_EXACT=n,
+	CONFIG_RCU_FANOUT_LEAF=2.
+TREE08.	CONFIG_NR_CPUS=16, CONFIG_RCU_FANOUT=3, CONFIG_RCU_FANOUT_EXACT=y,
+	CONFIG_RCU_FANOUT_LEAF=2.
+TREE09.	CONFIG_NR_CPUS=1.
+
+
+Kconfig Parameters Ignored:
+
+CONFIG_64BIT
+
+	Used only to check CONFIG_RCU_FANOUT value, inspection suffices.
+
+CONFIG_NO_HZ_FULL_SYSIDLE_SMALL
+
+	Defer until Frederic uses this.
+
+CONFIG_PREEMPT_COUNT
+CONFIG_PREEMPT_RCU
+
+	Redundant with CONFIG_PREEMPT, ignore.
+
+CONFIG_RCU_BOOST_DELAY
+
+	Inspection suffices, ignore.
+
+CONFIG_RCU_CPU_STALL_TIMEOUT
+
+	Inspection suffices, ignore.
+
+CONFIG_RCU_STALL_COMMON
+
+	Implied by TREE_RCU and TREE_PREEMPT_RCU.
+
+CONFIG_RCU_TORTURE_TEST
+CONFIG_RCU_TORTURE_TEST_RUNNABLE
+
+	Always used in KVM testing.
+
+CONFIG_RCU_USER_QS
+
+	Redundant with CONFIG_NO_HZ_FULL.
+
+CONFIG_TREE_PREEMPT_RCU
+CONFIG_TREE_RCU
+
+	These are controlled by CONFIG_PREEMPT.
-- 
1.8.1.5

