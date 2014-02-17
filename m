Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaBQWNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:13:21 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:44647 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaBQWNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:12 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/55] rcutorture: Add dryrun capability
Date: Mon, 17 Feb 2014 14:12:13 -0800
Message-Id: <1392675179-11560-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-0928-0000-0000-000006C34EC6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Actual rcutorture tests take considerable time and machine resources,
so it is inconvenient to actually do an rcutorture run when optimizing
the bin-packing algorithm.  This commit therefore adds a --dryrun
argument, which defaults to doing a run, but for which "sched"
says to simply print the run schedule and "script" dumps the script
without running it.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 39 ++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index f74f00628afe..9fab7c8e76f0 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -35,6 +35,7 @@ trap 'rm -rf $T' 0
 mkdir $T
 
 dur=30
+dryrun=""
 KVM="`pwd`/tools/testing/selftests/rcutorture"; export KVM
 PATH=${KVM}/bin:$PATH; export PATH
 builddir="${KVM}/b1"
@@ -56,6 +57,7 @@ usage () {
 	echo "       --configs \"config-file list\""
 	echo "       --cpus N"
 	echo "       --datestamp string"
+	echo "       --dryrun sched|script"
 	echo "       --duration minutes"
 	echo "       --interactive"
 	echo "       --kmake-arg kernel-make-arguments"
@@ -101,6 +103,11 @@ do
 		ds=$2
 		shift
 		;;
+	--dryrun)
+		checkarg --dryrun "sched|script" $# "$2" 'sched\|script' '^--'
+		dryrun=$2
+		shift
+		;;
 	--duration)
 		checkarg --duration "(minutes)" $# "$2" '^[0-9]*$' '^error'
 		dur=$2
@@ -179,9 +186,12 @@ else
 	fi
 fi
 mkdir $resdir/$ds
-echo Results directory: $resdir/$ds
+if test "$dryrun" = ""
+then
+	echo Results directory: $resdir/$ds
+	echo $scriptname $args
+fi
 touch $resdir/$ds/log
-echo $scriptname $args
 echo $scriptname $args >> $resdir/$ds/log
 
 pwd > $resdir/$ds/testid.txt
@@ -231,7 +241,7 @@ function dump(first, pastlast)
 		print "echo ", cf[j], cpus[j] ": Starting build."
 		print "rm -f " builddir ".*"
 		print "touch " builddir ".wait"
-		print "mkdir " builddir " || :"
+		print "mkdir " builddir " > /dev/null 2>&1 || :"
 		if (cfrep[cf[j]] == "") {
 			cfr[j] = cf[j];
 			cfrep[cf[j]] = 1;
@@ -286,7 +296,28 @@ END {
 		dump(first, i);
 }' > $T/script
 
-sh $T/script
+if test "$dryrun" = script
+then
+	echo CONFIGFRAG="$CONFIGFRAG; export CONFIGFRAG"
+	echo KVM="$KVM; export KVM"
+	echo KVPATH="$KVPATH; export KVPATH"
+	echo PATH="$PATH; export PATH"
+	echo RCU_BUILDONLY="$RCU_BUILDONLY; export RCU_BUILDONLY"
+	echo RCU_INITRD="$RCU_INITRD; export RCU_INITRD"
+	echo RCU_KMAKE_ARG="$RCU_KMAKE_ARG; export RCU_KMAKE_ARG"
+	echo RCU_QEMU_CMD="$RCU_QEMU_CMD; export RCU_QEMU_CMD"
+	echo RCU_QEMU_INTERACTIVE="$RCU_QEMU_INTERACTIVE; export RCU_QEMU_INTERACTIVE"
+	echo RCU_QEMU_MAC="$RCU_QEMU_MAC; export RCU_QEMU_MAC"
+	cat $T/script
+	exit 0
+elif test "$dryrun" = sched
+then
+	egrep 'start batch|Starting build\.' $T/script |
+		sed -e 's/:.*$//' -e 's/^echo //'
+	exit 0
+else
+	sh $T/script
+fi
 
 # Tracing: trace_event=rcu:rcu_grace_period,rcu:rcu_future_grace_period,rcu:rcu_grace_period_init,rcu:rcu_nocb_wake,rcu:rcu_preempt_task,rcu:rcu_unlock_preempted_task,rcu:rcu_quiescent_state_report,rcu:rcu_fqs,rcu:rcu_callback,rcu:rcu_kfree_callback,rcu:rcu_batch_start,rcu:rcu_invoke_callback,rcu:rcu_invoke_kfree_callback,rcu:rcu_batch_end,rcu:rcu_torture_read,rcu:rcu_barrier
 
-- 
1.8.1.5

