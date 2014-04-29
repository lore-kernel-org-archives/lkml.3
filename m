Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561AbaD2AeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:34:07 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52569 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932982AbaD2AZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:48 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 17/45] torture: Make "--dryrun script" output self-sufficient
Date: Mon, 28 Apr 2014 17:25:05 -0700
Message-Id: <1398731133-18925-17-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-1344-0000-0000-00000134E893
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The scripts produced by kvm.sh's "--dryrun script" argument were intended
for debugging rather than to run, but it is easier to debug if the script
output matches exactly what is run.  This commit therefore makes this
script runnable.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 60 ++++++++++++---------------
 1 file changed, 27 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index ea59e2950f14..8aa62a2dccb5 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -175,30 +175,6 @@ then
 	resdir=$KVM/res
 fi
 
-if test "$dryrun" = ""
-then
-	if ! test -e $resdir
-	then
-		mkdir -p "$resdir" || :
-	fi
-	mkdir $resdir/$ds
-
-	# Be noisy only if running the script.
-	echo Results directory: $resdir/$ds
-	echo $scriptname $args
-
-	touch $resdir/$ds/log
-	echo $scriptname $args >> $resdir/$ds/log
-	echo ${TORTURE_SUITE} > $resdir/$ds/TORTURE_SUITE
-
-	pwd > $resdir/$ds/testid.txt
-	if test -d .git
-	then
-		git status >> $resdir/$ds/testid.txt
-		git rev-parse HEAD >> $resdir/$ds/testid.txt
-	fi
-fi
-
 # Create a file of test-name/#cpus pairs, sorted by decreasing #cpus.
 touch $T/cfgcpu
 for CF in $configs
@@ -267,6 +243,22 @@ END {
 cat << ___EOF___ > $T/script
 TORTURE_SUITE="$TORTURE_SUITE"; export TORTURE_SUITE
 TORTURE_DEFCONFIG="$TORTURE_DEFCONFIG"; export TORTURE_DEFCONFIG
+if ! test -e $resdir
+then
+	mkdir -p "$resdir" || :
+fi
+mkdir $resdir/$ds
+echo Results directory: $resdir/$ds
+echo $scriptname $args
+touch $resdir/$ds/log
+echo $scriptname $args >> $resdir/$ds/log
+echo ${TORTURE_SUITE} > $resdir/$ds/TORTURE_SUITE
+pwd > $resdir/$ds/testid.txt
+if test -d .git
+then
+	git status >> $resdir/$ds/testid.txt
+	git rev-parse HEAD >> $resdir/$ds/testid.txt
+fi
 ___EOF___
 awk < $T/cfgcpu.pack \
 	-v CONFIGDIR="$CONFIGFRAG/$kversion/" \
@@ -366,6 +358,17 @@ END {
 		dump(first, i);
 }' >> $T/script
 
+cat << ___EOF___ >> $T/script
+echo
+echo
+echo " --- `date` Test summary:"
+echo Results directory: $resdir/$ds
+if test -z "$TORTURE_BUILDONLY"
+then
+	kvm-recheck.sh $resdir/$ds
+fi
+___EOF___
+
 if test "$dryrun" = script
 then
 	# Dump out the script, but define the environment variables that
@@ -398,12 +401,3 @@ else
 fi
 
 # Tracing: trace_event=rcu:rcu_grace_period,rcu:rcu_future_grace_period,rcu:rcu_grace_period_init,rcu:rcu_nocb_wake,rcu:rcu_preempt_task,rcu:rcu_unlock_preempted_task,rcu:rcu_quiescent_state_report,rcu:rcu_fqs,rcu:rcu_callback,rcu:rcu_kfree_callback,rcu:rcu_batch_start,rcu:rcu_invoke_callback,rcu:rcu_invoke_kfree_callback,rcu:rcu_batch_end,rcu:rcu_torture_read,rcu:rcu_barrier
-
-echo
-echo
-echo " --- `date` Test summary:"
-echo Results directory: $resdir/$ds
-if test -n "$TORTURE_BUILDONLY"
-then
-	kvm-recheck.sh $resdir/$ds
-fi
-- 
1.8.1.5

