Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3KPAk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:40:29 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:58281 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3KPAfw (ORCPT
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
Subject: [PATCH tip/core/rcu 20/28] rcutorture: Add --qemu-args argument to kvm.sh
Date: Fri, 15 Nov 2013 16:35:33 -0800
Message-Id: <1384562141-32446-20-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-6688-0000-0000-0000038DDF3B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commits adds the --qemu-args argument to kvm.sh that is required
to pass boot devices down through to qemu.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 2fb91d4f7996..7d6ca337d1fd 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -49,6 +49,7 @@ usage () {
 	echo "       --interactive"
 	echo "       --kversion vN.NN"
 	echo "       --mac nn:nn:nn:nn:nn:nn"
+	echo "       --qemu-args qemu-system-..."
 	echo "       --qemu-cmd qemu-system-..."
 	echo "       --results absolute-pathname"
 	echo "       --relbuilddir relative-pathname"
@@ -85,7 +86,7 @@ do
 		shift
 		;;
 	--builddir)
-		checkarg --builddir "(absolute pathname)" "$#" "$2" '^/' error
+		checkarg --builddir "(absolute pathname)" "$#" "$2" '^/' '^error'
 		builddir=$2
 		gotbuilddir=1
 		shift
@@ -104,7 +105,7 @@ do
 		shift
 		;;
 	--duration)
-		checkarg --duration "(minutes)" $# "$2" '^[0-9]*$' error
+		checkarg --duration "(minutes)" $# "$2" '^[0-9]*$' '^error'
 		dur=$2
 		shift
 		;;
@@ -112,7 +113,7 @@ do
 		RCU_QEMU_INTERACTIVE=1; export RCU_QEMU_INTERACTIVE
 		;;
 	--kversion)
-		checkarg --kversion "(kernel version)" $# "$2" '^v[0-9.]*$' error
+		checkarg --kversion "(kernel version)" $# "$2" '^v[0-9.]*$' '^error'
 		kversion=$2
 		shift
 		;;
@@ -121,6 +122,11 @@ do
 		RCU_QEMU_MAC=$2; export RCU_QEMU_MAC
 		shift
 		;;
+	--qemu-args)
+		checkarg --qemu-args "-qemu args" $# "$2" '^-' '^error'
+		RCU_QEMU_ARG="$2"
+		shift
+		;;
 	--qemu-cmd)
 		checkarg --qemu-cmd "(qemu-system-...)" $# "$2" 'qemu-system-' '^--'
 		RCU_QEMU_CMD="$2"; export RCU_QEMU_CMD
@@ -134,7 +140,7 @@ do
 		shift
 		;;
 	--results)
-		checkarg --results "(absolute pathname)" "$#" "$2" '^/' error
+		checkarg --results "(absolute pathname)" "$#" "$2" '^/' '^error'
 		resdir=$2
 		shift
 		;;
@@ -189,6 +195,6 @@ do
 	rd=$resdir/$ds/$CF
 	mkdir $rd || :
 	echo Results directory: $rd
-	kvm-test-1-rcu.sh $CONFIGFRAG/$kversion/$CF $builddir $rd $dur "-nographic" "rcutorture.test_no_idle_hz=1 rcutorture.verbose=1 $RCU_BOOTARGS"
+	kvm-test-1-rcu.sh $CONFIGFRAG/$kversion/$CF $builddir $rd $dur "-nographic $RCU_QEMU_ARG" "rcutorture.test_no_idle_hz=1 rcutorture.verbose=1 $RCU_BOOTARGS"
 done
 # Tracing: trace_event=rcu:rcu_nocb_grace_period,rcu:rcu_grace_period,rcu:rcu_grace_period_init,rcu:rcu_quiescent_state_report,rcu:rcu_fqs,rcu:rcu_callback,rcu:rcu_torture_read,rcu:rcu_invoke_callback,rcu:rcu_fqs,rcu:rcu_dyntick,rcu:rcu_unlock_preempted_task
-- 
1.8.1.5

