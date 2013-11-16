Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab3KPAlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:41:08 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:52399 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725Ab3KPAfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:35:52 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH tip/core/rcu 05/28] rcutorture: Add per-Kconfig fragment boot parameters
Date: Fri, 15 Nov 2013 16:35:18 -0800
Message-Id: <1384562141-32446-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-3532-0000-0000-000003112BE7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Some Kconfig fragments require rcutorture module parameters to
do optimal testing, for example, a configuration for SRCU would
need rcutorture.torture_type=srcu.  This commit therefore adds a
per-Kconfig-fragment boot-parameter capability.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rcutorture/bin/functions.sh      | 12 ++++++++++++
 tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/tools/testing/selftests/rcutorture/bin/functions.sh b/tools/testing/selftests/rcutorture/bin/functions.sh
index d4c15f81cd27..8f912419ed7f 100644
--- a/tools/testing/selftests/rcutorture/bin/functions.sh
+++ b/tools/testing/selftests/rcutorture/bin/functions.sh
@@ -28,6 +28,18 @@ bootparam_hotplug_cpu () {
 	echo "$1" | grep -q "rcutorture\.onoff_"
 }
 
+# configfrag_boot_params bootparam-string config-fragment-file
+#
+# Adds boot parameters from the .boot file, if any.
+configfrag_boot_params () {
+	if test -r "$2.boot"
+	then
+		echo $1 `grep -v '^#' "$2.boot" | tr '\012' ' '`
+	else
+		echo $1
+	fi
+}
+
 # configfrag_hotplug_cpu config-fragment-file
 #
 # Returns 1 if the config fragment specifies hotplug CPU.
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
index 0a3f037a8bb3..618aa4d766d3 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
@@ -137,6 +137,8 @@ fi
 boot_args="`rcutorture_param_onoff "$boot_args" $builddir/.config`"
 # Generate rcu_barrier() boot parameter
 boot_args="`rcutorture_param_n_barrier_cbs "$boot_args"`"
+# Pull in Kconfig-fragment boot parameters
+boot_args="`configfrag_boot_params "$boot_args" "$config_template"`"
 
 echo $QEMU -name rcu-test -serial file:$builddir/console.log $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append \"noapic selinux=0 console=ttyS0 initcall_debug debug rcutorture.stat_interval=15 rcutorture.shutdown_secs=$seconds rcutorture.rcutorture_runnable=1 $boot_args\" > $resdir/qemu-cmd
 $QEMU -name rcu-test -serial file:$builddir/console.log $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append "noapic selinux=0 console=ttyS0 initcall_debug debug rcutorture.stat_interval=15 rcutorture.shutdown_secs=$seconds rcutorture.rcutorture_runnable=1 $boot_args" &
-- 
1.8.1.5

