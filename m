Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaGGWpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:45:13 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45278 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaGGWpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:45:06 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/3] torture: Clean up diagnostics from --buildonly runs
Date: Mon,  7 Jul 2014 15:44:56 -0700
Message-Id: <1404773097-9932-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404773097-9932-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707224434.GA9624@linux.vnet.ibm.com>
 <1404773097-9932-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-1344-0000-0000-000002A9C743
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently the post-processing complains about the lack of rcutorture
output when --buildonly is set and also emits misleading messages about
kernels being started and finishing.  This commit suppresses these
complaints and messages.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 .../testing/selftests/rcutorture/bin/kvm-recheck.sh |  8 +++++++-
 .../selftests/rcutorture/bin/kvm-test-1-run.sh      |  8 ++++++--
 tools/testing/selftests/rcutorture/bin/kvm.sh       | 21 ++++++++++++---------
 3 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
index ee1f6cae3d70..3f6c9b78d177 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
@@ -54,10 +54,16 @@ do
 			if test -f "$i/qemu-cmd"
 			then
 				print_bug qemu failed
+				echo "   $i"
+			elif test -f "$i/buildonly"
+			then
+				echo Build-only run, no boot/test
+				configcheck.sh $i/.config $i/ConfigFragment
+				parse-build.sh $i/Make.out $configfile
 			else
 				print_bug Build failed
+				echo "   $i"
 			fi
-			echo "   $i"
 		fi
 	done
 done
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index fa37010c34db..0f69dcbf9def 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -132,7 +132,10 @@ boot_args=$6
 
 cd $KVM
 kstarttime=`awk 'BEGIN { print systime() }' < /dev/null`
-echo ' ---' `date`: Starting kernel
+if test -z "$TORTURE_BUILDONLY"
+then
+	echo ' ---' `date`: Starting kernel
+fi
 
 # Generate -smp qemu argument.
 qemu_args="-nographic $qemu_args"
@@ -158,12 +161,13 @@ boot_args="`configfrag_boot_params "$boot_args" "$config_template"`"
 # Generate kernel-version-specific boot parameters
 boot_args="`per_version_boot_params "$boot_args" $builddir/.config $seconds`"
 
-echo $QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
 if test -n "$TORTURE_BUILDONLY"
 then
 	echo Build-only run specified, boot/test omitted.
+	touch $resdir/buildonly
 	exit 0
 fi
+echo $QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
 ( $QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append "$qemu_append $boot_args"; echo $? > $resdir/qemu-retval ) &
 qemu_pid=$!
 commandcompleted=0
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 40285c58653e..589e9c38413b 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -340,12 +340,18 @@ function dump(first, pastlast)
 	for (j = 1; j < jn; j++) {
 		builddir=KVM "/b" j
 		print "rm -f " builddir ".ready"
-		print "echo ----", cfr[j], cpusr[j] ovf ": Starting kernel. `date`";
-		print "echo ----", cfr[j], cpusr[j] ovf ": Starting kernel. `date` >> " rd "/log";
+		print "if test -z \"$TORTURE_BUILDONLY\""
+		print "then"
+		print "\techo ----", cfr[j], cpusr[j] ovf ": Starting kernel. `date`";
+		print "\techo ----", cfr[j], cpusr[j] ovf ": Starting kernel. `date` >> " rd "/log";
+		print "fi"
 	}
 	print "wait"
-	print "echo ---- All kernel runs complete. `date`";
-	print "echo ---- All kernel runs complete. `date` >> " rd "/log";
+	print "if test -z \"$TORTURE_BUILDONLY\""
+	print "then"
+	print "\techo ---- All kernel runs complete. `date`";
+	print "\techo ---- All kernel runs complete. `date` >> " rd "/log";
+	print "fi"
 	for (j = 1; j < jn; j++) {
 		builddir=KVM "/b" j
 		print "echo ----", cfr[j], cpusr[j] ovf ": Build/run results:";
@@ -385,10 +391,7 @@ echo
 echo
 echo " --- `date` Test summary:"
 echo Results directory: $resdir/$ds
-if test -z "$TORTURE_BUILDONLY"
-then
-	kvm-recheck.sh $resdir/$ds
-fi
+kvm-recheck.sh $resdir/$ds
 ___EOF___
 
 if test "$dryrun" = script
@@ -403,7 +406,7 @@ then
 		sed -e 's/:.*$//' -e 's/^echo //'
 	exit 0
 else
-	# Not a dryru, so run the script.
+	# Not a dryrun, so run the script.
 	sh $T/script
 fi
 
-- 
1.8.1.5

