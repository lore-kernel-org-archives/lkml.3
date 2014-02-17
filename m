Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbaBQWXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:23:15 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35175 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbaBQWNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:18 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/55] rcutorture: Enable concurrent rcutorture runs
Date: Mon, 17 Feb 2014 14:12:11 -0800
Message-Id: <1392675179-11560-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F3817
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcutorture tests run by default range from using one CPU to using
sixteen of them.  Therefore, rcutorture testing could be sped up
significantly simply by running the kernels in parallel.  Building
them in parallel is not all that helpful: "make -j" is usually a
better bet.  So this commit takes a new "--cpus" argument that
specifies how many CPUs rcutorture is permitted to use for its
parallel runs.  The default of zero does sequential runs as before.

The bin-packing is minimal, and will be grossly suboptimal for
some configurations.  However, powers of two work reasonably well.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 .../testing/selftests/rcutorture/bin/functions.sh  |   1 +
 .../selftests/rcutorture/bin/kvm-recheck.sh        |   4 +-
 .../selftests/rcutorture/bin/kvm-test-1-rcu.sh     |   2 +-
 tools/testing/selftests/rcutorture/bin/kvm.sh      | 125 +++++++++++++++++----
 4 files changed, 108 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/functions.sh b/tools/testing/selftests/rcutorture/bin/functions.sh
index 587561d7c035..9b17e810ddc3 100644
--- a/tools/testing/selftests/rcutorture/bin/functions.sh
+++ b/tools/testing/selftests/rcutorture/bin/functions.sh
@@ -96,6 +96,7 @@ identify_qemu () {
 		echo qemu-system-ppc64
 	else
 		echo Cannot figure out what qemu command to use! 1>&2
+		echo file $1 output: $u
 		# Usually this will be one of /usr/bin/qemu-system-*
 		# Use RCU_QEMU_CMD environment variable or appropriate
 		# argument to top-level script.
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
index eb2850935c26..89b5dbac5327 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
@@ -31,9 +31,9 @@ do
 	dirs=`find $rd -name Make.defconfig.out -print | sort | sed -e 's,/[^/]*$,,' | sort -u`
 	for i in $dirs
 	do
-		if test $firsttime
+		if test -n "$firsttime"
 		then
-			firsttime=0
+			firsttime=""
 			resdir=`echo $i | sed -e 's,/$,,' -e 's,/[^/]*$,,'`
 			head -1 $resdir/log
 		fi
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
index a06a0a6ce5ac..1b9555b2b0d7 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
@@ -123,7 +123,7 @@ kstarttime=`awk 'BEGIN { print systime() }' < /dev/null`
 echo ' ---' `date`: Starting kernel
 
 # Determine the appropriate flavor of qemu command.
-QEMU="`identify_qemu $builddir/vmlinux.o`"
+QEMU="`identify_qemu $builddir/vmlinux`"
 
 # Generate -smp qemu argument.
 qemu_args="-nographic $qemu_args"
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index f2113493bbfc..f74f00628afe 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -30,6 +30,10 @@
 scriptname=$0
 args="$*"
 
+T=/tmp/kvm.sh.$$
+trap 'rm -rf $T' 0
+mkdir $T
+
 dur=30
 KVM="`pwd`/tools/testing/selftests/rcutorture"; export KVM
 PATH=${KVM}/bin:$PATH; export PATH
@@ -38,6 +42,7 @@ RCU_INITRD="$KVM/initrd"; export RCU_INITRD
 RCU_KMAKE_ARG=""; export RCU_KMAKE_ARG
 resdir=""
 configs=""
+cpus=0
 ds=`date +%Y.%m.%d-%H:%M:%S`
 kversion=""
 
@@ -49,6 +54,7 @@ usage () {
 	echo "       --builddir absolute-pathname"
 	echo "       --buildonly"
 	echo "       --configs \"config-file list\""
+	echo "       --cpus N"
 	echo "       --datestamp string"
 	echo "       --duration minutes"
 	echo "       --interactive"
@@ -85,6 +91,11 @@ do
 		configs="$2"
 		shift
 		;;
+	--cpus)
+		checkarg --cpus "(number)" "$#" "$2" '^[0-9]*$' '^--'
+		cpus=$2
+		shift
+		;;
 	--datestamp)
 		checkarg --datestamp "(relative pathname)" "$#" "$2" '^[^/]*$' '^--'
 		ds=$2
@@ -168,6 +179,7 @@ else
 	fi
 fi
 mkdir $resdir/$ds
+echo Results directory: $resdir/$ds
 touch $resdir/$ds/log
 echo $scriptname $args
 echo $scriptname $args >> $resdir/$ds/log
@@ -178,33 +190,104 @@ then
 	git status >> $resdir/$ds/testid.txt
 	git rev-parse HEAD >> $resdir/$ds/testid.txt
 fi
-builddir=$KVM/b1
-if ! test -e $builddir
-then
-	mkdir $builddir || :
-fi
 
+touch $T/cfgcpu
 for CF in $configs
 do
-	# Running TREE01 multiple times creates TREE01, TREE01.2, TREE01.3, ...
-	rd=$resdir/$ds/$CF
-	if test -d "${rd}"
+	if test -f "$CONFIGFRAG/$kversion/$CF"
 	then
-		n="`ls -d "${rd}"* | grep '\.[0-9]\+$' |
-			sed -e 's/^.*\.\([0-9]\+\)/\1/' |
-			sort -k1n | tail -1`"
-		if test -z "$n"
-		then
-			rd="${rd}.2"
-		else
-			n="`expr $n + 1`"
-			rd="${rd}.${n}"
-		fi
+		echo $CF `configNR_CPUS.sh $CONFIGFRAG/$kversion/$CF` >> $T/cfgcpu
+	else
+		echo "The --configs file $CF does not exist, terminating."
+		exit 1
 	fi
-	mkdir "${rd}"
-	echo Results directory: $rd
-	kvm-test-1-rcu.sh $CONFIGFRAG/$kversion/$CF $builddir $rd $dur "$RCU_QEMU_ARG" "$RCU_BOOTARGS"
 done
+sort -k2nr $T/cfgcpu > $T/cfgcpu.sort
+
+awk < $T/cfgcpu.sort \
+	-v CONFIGDIR="$CONFIGFRAG/$kversion/" \
+	-v KVM="$KVM" \
+	-v ncpus=$cpus \
+	-v rd=$resdir/$ds/ \
+	-v dur=$dur \
+	-v RCU_QEMU_ARG=$RCU_QEMU_ARG \
+	-v RCU_BOOTARGS=$RCU_BOOTARGS \
+'BEGIN {
+	i = 0;
+}
+
+{
+	cf[i] = $1;
+	cpus[i] = $2;
+	i++;
+}
+
+function dump(first, pastlast)
+{
+	print "echo ----start batch----"
+	jn=1
+	for (j = first; j < pastlast; j++) {
+		builddir=KVM "/b" jn
+		print "echo ", cf[j], cpus[j] ": Starting build."
+		print "rm -f " builddir ".*"
+		print "touch " builddir ".wait"
+		print "mkdir " builddir " || :"
+		if (cfrep[cf[j]] == "") {
+			cfr[j] = cf[j];
+			cfrep[cf[j]] = 1;
+		} else {
+			cfrep[cf[j]]++;
+			cfr[j] = cf[j] "." cfrep[cf[j]];
+		}
+		print "mkdir " rd cfr[j] " || :";
+		print "kvm-test-1-rcu.sh " CONFIGDIR cf[j], builddir, rd cfr[j], dur " \"" RCU_QEMU_ARG "\" \"" RCU_BOOTARGS "\" > " builddir ".out 2>&1 &"
+		print "echo ", cf[j], cpus[j] ": Waiting for build to complete."
+		print "while test -f " builddir ".wait"
+		print "do"
+		print "\tsleep 1"
+		print "done"
+		print "echo ", cf[j], cpus[j] ": Build complete."
+		jn++;
+	}
+	k = first
+	for (j = 1; j < jn; j++) {
+		builddir=KVM "/b" j
+		print "rm -f " builddir ".ready"
+		print "echo ----", cf[k], cpus[k] ": Starting kernel"
+		k++;
+	}
+	print "wait"
+	print "echo ---- All kernel runs complete"
+	k = first
+	for (j = 1; j < jn; j++) {
+		builddir=KVM "/b" j
+		print "echo ----", cf[k], cpus[k] ": Build/run results:"
+		print "cat " builddir ".out"
+		k++;
+	}
+}
+
+END {
+	njobs = i;
+	nc = ncpus;
+	first = 0;
+	for (i = 0; i < njobs; i++) {
+		if (ncpus == 0) {
+			dump(i, i + 1);
+			first = i;
+		} else if (nc < cpus[i] && i != 0) {
+			dump(first, i);
+			first = i;
+			nc = ncpus;
+		}
+		nc -= cpus[i];
+	}
+	if (ncpus != 0)
+		dump(first, i);
+}' > $T/script
+
+sh $T/script
+
 # Tracing: trace_event=rcu:rcu_grace_period,rcu:rcu_future_grace_period,rcu:rcu_grace_period_init,rcu:rcu_nocb_wake,rcu:rcu_preempt_task,rcu:rcu_unlock_preempted_task,rcu:rcu_quiescent_state_report,rcu:rcu_fqs,rcu:rcu_callback,rcu:rcu_kfree_callback,rcu:rcu_batch_start,rcu:rcu_invoke_callback,rcu:rcu_invoke_kfree_callback,rcu:rcu_batch_end,rcu:rcu_torture_read,rcu:rcu_barrier
 
 echo " --- `date` Test summary:"
-- 
1.8.1.5

