Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaBQW1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:27:36 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35138 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbaBQWNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:16 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 13/55] rcutorture: Flag tests requiring more CPUs than are available
Date: Mon, 17 Feb 2014 14:12:17 -0800
Message-Id: <1392675179-11560-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F37F7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds a "(!)" flag after the number of CPUs required by a
given test if that test requires more than the available number of CPUs.
Note that these flags appear only when the number of CPUs is specified
using the --cpus argument.  In the absence of a --cpus argument, no
tests are flagged.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 7ef3b245c778..c099f8695112 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -300,30 +300,34 @@ function dump(first, pastlast)
 			cfrep[cf[j]]++;
 			cfr[jn] = cf[j] "." cfrep[cf[j]];
 		}
-		print "echo ", cfr[jn], cpusr[jn] ": Starting build.";
+		if (cpusr[jn] > ncpus && ncpus != 0)
+			ovf = "(!)";
+		else
+			ovf = "";
+		print "echo ", cfr[jn], cpusr[jn] ovf ": Starting build.";
 		print "rm -f " builddir ".*";
 		print "touch " builddir ".wait";
 		print "mkdir " builddir " > /dev/null 2>&1 || :";
 		print "mkdir " rd cfr[jn] " || :";
 		print "kvm-test-1-rcu.sh " CONFIGDIR cf[j], builddir, rd cfr[jn], dur " \"" RCU_QEMU_ARG "\" \"" RCU_BOOTARGS "\" > " builddir ".out 2>&1 &"
-		print "echo ", cfr[jn], cpusr[jn] ": Waiting for build to complete."
+		print "echo ", cfr[jn], cpusr[jn] ovf ": Waiting for build to complete."
 		print "while test -f " builddir ".wait"
 		print "do"
 		print "\tsleep 1"
 		print "done"
-		print "echo ", cfr[jn], cpusr[jn] ": Build complete."
+		print "echo ", cfr[jn], cpusr[jn] ovf ": Build complete."
 		jn++;
 	}
 	for (j = 1; j < jn; j++) {
 		builddir=KVM "/b" j
 		print "rm -f " builddir ".ready"
-		print "echo ----", cfr[j], cpusr[j] ": Starting kernel"
+		print "echo ----", cfr[j], cpusr[j] ovf ": Starting kernel"
 	}
 	print "wait"
 	print "echo ---- All kernel runs complete"
 	for (j = 1; j < jn; j++) {
 		builddir=KVM "/b" j
-		print "echo ----", cfr[j], cpusr[j] ": Build/run results:"
+		print "echo ----", cfr[j], cpusr[j] ovf ": Build/run results:"
 		print "cat " builddir ".out"
 	}
 }
-- 
1.8.1.5

