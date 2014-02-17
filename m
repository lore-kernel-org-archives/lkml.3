Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbaBQW1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:27:39 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:44675 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbaBQWNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:15 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 10/55] rcutorture: Handle multiple runs of the same test
Date: Mon, 17 Feb 2014 14:12:14 -0800
Message-Id: <1392675179-11560-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-0928-0000-0000-000006C34EDA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit fixes handling numbering of multiple runs of the same test
so as to disambiguate output.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 29 ++++++++++++---------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 9fab7c8e76f0..ad3779cefdb8 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -238,42 +238,39 @@ function dump(first, pastlast)
 	jn=1
 	for (j = first; j < pastlast; j++) {
 		builddir=KVM "/b" jn
-		print "echo ", cf[j], cpus[j] ": Starting build."
-		print "rm -f " builddir ".*"
-		print "touch " builddir ".wait"
-		print "mkdir " builddir " > /dev/null 2>&1 || :"
+		cpusr[jn] = cpus[j];
 		if (cfrep[cf[j]] == "") {
-			cfr[j] = cf[j];
+			cfr[jn] = cf[j];
 			cfrep[cf[j]] = 1;
 		} else {
 			cfrep[cf[j]]++;
-			cfr[j] = cf[j] "." cfrep[cf[j]];
+			cfr[jn] = cf[j] "." cfrep[cf[j]];
 		}
-		print "mkdir " rd cfr[j] " || :";
-		print "kvm-test-1-rcu.sh " CONFIGDIR cf[j], builddir, rd cfr[j], dur " \"" RCU_QEMU_ARG "\" \"" RCU_BOOTARGS "\" > " builddir ".out 2>&1 &"
-		print "echo ", cf[j], cpus[j] ": Waiting for build to complete."
+		print "echo ", cfr[jn], cpusr[jn] ": Starting build.";
+		print "rm -f " builddir ".*";
+		print "touch " builddir ".wait";
+		print "mkdir " builddir " > /dev/null 2>&1 || :";
+		print "mkdir " rd cfr[jn] " || :";
+		print "kvm-test-1-rcu.sh " CONFIGDIR cf[j], builddir, rd cfr[jn], dur " \"" RCU_QEMU_ARG "\" \"" RCU_BOOTARGS "\" > " builddir ".out 2>&1 &"
+		print "echo ", cfr[jn], cpusr[jn] ": Waiting for build to complete."
 		print "while test -f " builddir ".wait"
 		print "do"
 		print "\tsleep 1"
 		print "done"
-		print "echo ", cf[j], cpus[j] ": Build complete."
+		print "echo ", cfr[jn], cpusr[jn] ": Build complete."
 		jn++;
 	}
-	k = first
 	for (j = 1; j < jn; j++) {
 		builddir=KVM "/b" j
 		print "rm -f " builddir ".ready"
-		print "echo ----", cf[k], cpus[k] ": Starting kernel"
-		k++;
+		print "echo ----", cfr[j], cpusr[j] ": Starting kernel"
 	}
 	print "wait"
 	print "echo ---- All kernel runs complete"
-	k = first
 	for (j = 1; j < jn; j++) {
 		builddir=KVM "/b" j
-		print "echo ----", cf[k], cpus[k] ": Build/run results:"
+		print "echo ----", cfr[j], cpusr[j] ": Build/run results:"
 		print "cat " builddir ".out"
-		k++;
 	}
 }
 
-- 
1.8.1.5

