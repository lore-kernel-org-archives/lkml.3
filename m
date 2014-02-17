Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaBQWNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:13:14 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:52105 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbaBQWNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:11 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/55] rcutorture: Move common boot flags to kvm-test-1-rcu.sh
Date: Mon, 17 Feb 2014 14:12:07 -0800
Message-Id: <1392675179-11560-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-1542-0000-0000-00000652D9B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently, most boot flags are calculated in kvm-test-1-rcu.sh, except
that rcutorture.test_no_idle_hz and rcutorture.verbose are set up by
kvm.sh.  This commit promotes one-stop shopping by consolidating the
determination of boot flags into kvm-test-1-rcu.sh.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh | 8 ++++----
 tools/testing/selftests/rcutorture/bin/kvm.sh            | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
index 151b23788935..2cb7facbc86d 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
@@ -6,15 +6,15 @@
 # Execute this in the source tree.  Do not run it as a background task
 # because qemu does not seem to like that much.
 #
-# Usage: sh kvm-test-1-rcu.sh config builddir resdir minutes qemu-args bootargs
+# Usage: sh kvm-test-1-rcu.sh config builddir resdir minutes qemu-args boot_args
 #
 # qemu-args defaults to "" -- you will want "-nographic" if running headless.
-# bootargs defaults to	"root=/dev/sda noapic selinux=0 console=ttyS0"
+# boot_args defaults to	"root=/dev/sda noapic selinux=0 console=ttyS0"
 #			"initcall_debug debug rcutorture.stat_interval=15"
 #			"rcutorture.shutdown_secs=$((minutes * 60))"
 #			"rcutorture.rcutorture_runnable=1"
 #
-# Anything you specify for either qemu-args or bootargs is appended to
+# Anything you specify for either qemu-args or boot_args is appended to
 # the default values.  The "-smp" value is deduced from the contents of
 # the config fragment.
 #
@@ -138,7 +138,7 @@ boot_args="`rcutorture_param_onoff "$boot_args" $builddir/.config`"
 # Generate rcu_barrier() boot parameter
 boot_args="`rcutorture_param_n_barrier_cbs "$boot_args"`"
 # Pull in standard rcutorture boot arguments
-boot_args="$boot_args rcutorture.stat_interval=15 rcutorture.shutdown_secs=$seconds rcutorture.rcutorture_runnable=1"
+boot_args="$boot_args rcutorture.stat_interval=15 rcutorture.shutdown_secs=$seconds rcutorture.rcutorture_runnable=1 rcutorture.test_no_idle_hz=1 rcutorture.verbose=1"
 
 echo $QEMU $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
 if test -n "$RCU_BUILDONLY"
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index f60f98415f13..979881baa80f 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -203,7 +203,7 @@ do
 	fi
 	mkdir "${rd}"
 	echo Results directory: $rd
-	kvm-test-1-rcu.sh $CONFIGFRAG/$kversion/$CF $builddir $rd $dur "-nographic $RCU_QEMU_ARG" "rcutorture.test_no_idle_hz=1 rcutorture.verbose=1 $RCU_BOOTARGS"
+	kvm-test-1-rcu.sh $CONFIGFRAG/$kversion/$CF $builddir $rd $dur "-nographic $RCU_QEMU_ARG" "$RCU_BOOTARGS"
 done
 # Tracing: trace_event=rcu:rcu_grace_period,rcu:rcu_future_grace_period,rcu:rcu_grace_period_init,rcu:rcu_nocb_wake,rcu:rcu_preempt_task,rcu:rcu_unlock_preempted_task,rcu:rcu_quiescent_state_report,rcu:rcu_fqs,rcu:rcu_callback,rcu:rcu_kfree_callback,rcu:rcu_batch_start,rcu:rcu_invoke_callback,rcu:rcu_invoke_kfree_callback,rcu:rcu_batch_end,rcu:rcu_torture_read,rcu:rcu_barrier
 
-- 
1.8.1.5

