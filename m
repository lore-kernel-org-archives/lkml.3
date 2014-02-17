Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaBQWXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:23:11 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35189 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbaBQWNS (ORCPT
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
Subject: [PATCH tip/core/rcu 12/55] rcutorture: Add comments, especially on bin packing.
Date: Mon, 17 Feb 2014 14:12:16 -0800
Message-Id: <1392675179-11560-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F3806
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 33 +++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 18649b87ea6c..7ef3b245c778 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -188,6 +188,7 @@ fi
 mkdir $resdir/$ds
 if test "$dryrun" = ""
 then
+	# Be noisy only if running the script.
 	echo Results directory: $resdir/$ds
 	echo $scriptname $args
 fi
@@ -201,6 +202,7 @@ then
 	git rev-parse HEAD >> $resdir/$ds/testid.txt
 fi
 
+# Create a file of test-name/#cpus pairs, sorted by decreasing #cpus.
 touch $T/cfgcpu
 for CF in $configs
 do
@@ -214,12 +216,14 @@ do
 done
 sort -k2nr $T/cfgcpu > $T/cfgcpu.sort
 
+# Use a greedy bin-packing algorithm, sorting the list accordingly.
 awk < $T/cfgcpu.sort > $T/cfgcpu.pack -v ncpus=$cpus '
 BEGIN {
 	njobs = 0;
 }
 
 {
+	# Read file of tests and corresponding required numbers of CPUs.
 	cf[njobs] = $1;
 	cpus[njobs] = $2;
 	njobs++;
@@ -229,26 +233,40 @@ END {
 	alldone = 0;
 	batch = 0;
 	nc = -1;
+
+	# Each pass through the following loop creates on test batch
+	# that can be executed concurrently given ncpus.  Note that a
+	# given test that requires more than the available CPUs will run in
+	# their own batch.  Such tests just have to make do with what
+	# is available.
 	while (nc != ncpus) {
 		batch++;
 		nc = ncpus;
+
+		# Each pass through the following loop considers one
+		# test for inclusion in the current batch.
 		for (i = 0; i < njobs; i++) {
 			if (done[i])
-				continue;
+				continue; # Already part of a batch.
 			if (nc >= cpus[i] || nc == ncpus) {
+
+				# This test fits into the current batch.
 				done[i] = batch;
 				nc -= cpus[i];
 				if (nc <= 0)
-					break;
+					break; # Too-big test in its own batch.
 			}
 		}
 	}
+
+	# Dump out the tests in batch order.
 	for (b = 1; b <= batch; b++)
 		for (i = 0; i < njobs; i++)
 			if (done[i] == b)
 				print cf[i], cpus[i];
 }'
 
+# Generate a script to execute the tests in appropriate batches.
 awk < $T/cfgcpu.pack \
 	-v CONFIGDIR="$CONFIGFRAG/$kversion/" \
 	-v KVM="$KVM" \
@@ -267,6 +285,7 @@ awk < $T/cfgcpu.pack \
 	i++;
 }
 
+# Dump out the scripting required to run one test batch.
 function dump(first, pastlast)
 {
 	print "echo ----start batch----"
@@ -313,23 +332,31 @@ END {
 	njobs = i;
 	nc = ncpus;
 	first = 0;
+
+	# Each pass through the following loop considers one test.
 	for (i = 0; i < njobs; i++) {
 		if (ncpus == 0) {
+			# Sequential test specified, each test its own batch.
 			dump(i, i + 1);
 			first = i;
 		} else if (nc < cpus[i] && i != 0) {
+			# Out of CPUs, dump out a batch.
 			dump(first, i);
 			first = i;
 			nc = ncpus;
 		}
+		# Account for the CPUs needed by the current test.
 		nc -= cpus[i];
 	}
+	# Dump the last batch.
 	if (ncpus != 0)
 		dump(first, i);
 }' > $T/script
 
 if test "$dryrun" = script
 then
+	# Dump out the script, but define the environment variables that
+	# it needs to run standalone.
 	echo CONFIGFRAG="$CONFIGFRAG; export CONFIGFRAG"
 	echo KVM="$KVM; export KVM"
 	echo KVPATH="$KVPATH; export KVPATH"
@@ -344,10 +371,12 @@ then
 	exit 0
 elif test "$dryrun" = sched
 then
+	# Extract the test run schedule from the script.
 	egrep 'start batch|Starting build\.' $T/script |
 		sed -e 's/:.*$//' -e 's/^echo //'
 	exit 0
 else
+	# Not a dryru, so run the script.
 	sh $T/script
 fi
 
-- 
1.8.1.5

