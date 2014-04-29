Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbaD2AZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:25:56 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59706 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056AbaD2AZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:49 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 32/45] torture: Better summary diagnostics for build failures
Date: Mon, 28 Apr 2014 17:25:20 -0700
Message-Id: <1398731133-18925-32-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-0928-0000-0000-0000018D1376
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The reaction of kvm-recheck.sh is obscure at best, and easy to miss
completely.  This commit therefore prints "BUG: Build failed" in the
summary at the end of a run.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 .../selftests/rcutorture/bin/kvm-recheck-lock.sh   |  2 +-
 .../selftests/rcutorture/bin/kvm-recheck-rcu.sh    |  2 +-
 .../selftests/rcutorture/bin/kvm-recheck.sh        | 24 ++++++++++++++++------
 .../selftests/rcutorture/bin/kvm-test-1-run.sh     |  1 +
 4 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
index 829186e19eb1..7f1ff1a8fc4b 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
@@ -35,7 +35,7 @@ configfile=`echo $i | sed -e 's/^.*\///'`
 ncs=`grep "Writes:  Total:" $i/console.log 2> /dev/null | tail -1 | sed -e 's/^.* Total: //' -e 's/ .*$//'`
 if test -z "$ncs"
 then
-	echo $configfile
+	echo "$configfile -------"
 else
 	title="$configfile ------- $ncs acquisitions/releases"
 	dur=`sed -e 's/^.* locktorture.shutdown_secs=//' -e 's/ .*$//' < $i/qemu-cmd 2> /dev/null`
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
index d75b1dc5ae53..307c4b95f325 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
@@ -35,7 +35,7 @@ configfile=`echo $i | sed -e 's/^.*\///'`
 ngps=`grep ver: $i/console.log 2> /dev/null | tail -1 | sed -e 's/^.* ver: //' -e 's/ .*$//'`
 if test -z "$ngps"
 then
-	echo $configfile
+	echo "$configfile -------"
 else
 	title="$configfile ------- $ngps grace periods"
 	dur=`sed -e 's/^.* rcutorture.shutdown_secs=//' -e 's/ .*$//' < $i/qemu-cmd 2> /dev/null`
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
index 26d78b7eaccf..ee1f6cae3d70 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
@@ -25,6 +25,7 @@
 # Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
 
 PATH=`pwd`/tools/testing/selftests/rcutorture/bin:$PATH; export PATH
+. tools/testing/selftests/rcutorture/bin/functions.sh
 for rd in "$@"
 do
 	firsttime=1
@@ -39,13 +40,24 @@ do
 		fi
 		TORTURE_SUITE="`cat $i/../TORTURE_SUITE`"
 		kvm-recheck-${TORTURE_SUITE}.sh $i
-		configcheck.sh $i/.config $i/ConfigFragment
-		parse-build.sh $i/Make.out $configfile
-		parse-torture.sh $i/console.log $configfile
-		parse-console.sh $i/console.log $configfile
-		if test -r $i/Warnings
+		if test -f "$i/console.log"
 		then
-			cat $i/Warnings
+			configcheck.sh $i/.config $i/ConfigFragment
+			parse-build.sh $i/Make.out $configfile
+			parse-torture.sh $i/console.log $configfile
+			parse-console.sh $i/console.log $configfile
+			if test -r $i/Warnings
+			then
+				cat $i/Warnings
+			fi
+		else
+			if test -f "$i/qemu-cmd"
+			then
+				print_bug qemu failed
+			else
+				print_bug Build failed
+			fi
+			echo "   $i"
 		fi
 	done
 done
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index 7a95f86cc85a..51c34a91a375 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -106,6 +106,7 @@ then
 	fi
 else
 	cp $builddir/Make*.out $resdir
+	cp $builddir/.config $resdir || :
 	echo Build failed, not running KVM, see $resdir.
 	if test -f $builddir.wait
 	then
-- 
1.8.1.5

