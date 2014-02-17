Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbaBQWau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:30:50 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:54846 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbaBQWNM (ORCPT
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
Subject: [PATCH tip/core/rcu 11/55] rcutorture: Do better bin packing
Date: Mon, 17 Feb 2014 14:12:15 -0800
Message-Id: <1392675179-11560-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-3532-0000-0000-000005BEDC59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Running the standard set of rcutorture tests on 24 CPUs results in
the following sub-optimal schedule:

	----start batch----
	 TREE07 16
	----start batch----
	 TREE08 16
	 SRCU-P 8
	----start batch----
	 TREE01 8
	 TREE02 8
	 TREE03 8
	----start batch----
	 TREE04 8
	 TREE05 8
	 TREE06 8
	----start batch----
	 SRCU-N 4
	 TINY01 1
	 TINY02 1
	 TREE09 1

If one of the eight-CPU runs were to be moved into the first batch,
the test suite would complete in four batches rather than five.

This commit therefore uses a greedy algorithm to re-order the test
entries so that the sequential batching will produce an optimal schedule
in this case:

	----start batch----
	 TREE07 16
	 SRCU-P 8
	----start batch----
	 TREE08 16
	 TREE01 8
	----start batch----
	 TREE02 8
	 TREE03 8
	 TREE04 8
	----start batch----
	 TREE05 8
	 TREE06 8
	 SRCU-N 4
	 TINY01 1
	 TINY02 1
	 TREE09 1

Please note that this is still not an optimal bin-packing algorithm,
however, it does produce optimal solutions for most common scenarios.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 37 ++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index ad3779cefdb8..18649b87ea6c 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -214,7 +214,42 @@ do
 done
 sort -k2nr $T/cfgcpu > $T/cfgcpu.sort
 
-awk < $T/cfgcpu.sort \
+awk < $T/cfgcpu.sort > $T/cfgcpu.pack -v ncpus=$cpus '
+BEGIN {
+	njobs = 0;
+}
+
+{
+	cf[njobs] = $1;
+	cpus[njobs] = $2;
+	njobs++;
+}
+
+END {
+	alldone = 0;
+	batch = 0;
+	nc = -1;
+	while (nc != ncpus) {
+		batch++;
+		nc = ncpus;
+		for (i = 0; i < njobs; i++) {
+			if (done[i])
+				continue;
+			if (nc >= cpus[i] || nc == ncpus) {
+				done[i] = batch;
+				nc -= cpus[i];
+				if (nc <= 0)
+					break;
+			}
+		}
+	}
+	for (b = 1; b <= batch; b++)
+		for (i = 0; i < njobs; i++)
+			if (done[i] == b)
+				print cf[i], cpus[i];
+}'
+
+awk < $T/cfgcpu.pack \
 	-v CONFIGDIR="$CONFIGFRAG/$kversion/" \
 	-v KVM="$KVM" \
 	-v ncpus=$cpus \
-- 
1.8.1.5

