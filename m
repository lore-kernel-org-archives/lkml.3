Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241AbaD2Aat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:30:49 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37436 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933089AbaD2AZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 18/45] torture: Make "--dryrun script" use same environment as normal run
Date: Mon, 28 Apr 2014 17:25:06 -0700
Message-Id: <1398731133-18925-18-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-7164-0000-0000-0000015FD2E7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

In a normal torture-test run, the script inherits its environment
variables, but this does not work when producing a script that is
to run later.  Therefore, definitions and exports are prepended to
a dryrun script but not to a script that is run immediately.  This
commit reconciles this by placing definitions and exports at the
beginning of the script in both cases.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 28 ++++++++++++---------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 8aa62a2dccb5..93a6c5a8517d 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -241,8 +241,19 @@ END {
 
 # Generate a script to execute the tests in appropriate batches.
 cat << ___EOF___ > $T/script
-TORTURE_SUITE="$TORTURE_SUITE"; export TORTURE_SUITE
+CONFIGFRAG="$CONFIGFRAG"; export CONFIGFRAG
+KVM="$KVM"; export KVM
+KVPATH="$KVPATH"; export KVPATH
+PATH="$PATH"; export PATH
+TORTURE_BUILDONLY="$TORTURE_BUILDONLY"; export TORTURE_BUILDONLY
 TORTURE_DEFCONFIG="$TORTURE_DEFCONFIG"; export TORTURE_DEFCONFIG
+TORTURE_INITRD="$TORTURE_INITRD"; export TORTURE_INITRD
+TORTURE_KMAKE_ARG="$TORTURE_KMAKE_ARG"; export TORTURE_KMAKE_ARG
+TORTURE_QEMU_CMD="$TORTURE_QEMU_CMD"; export TORTURE_QEMU_CMD
+TORTURE_QEMU_INTERACTIVE="$TORTURE_QEMU_INTERACTIVE";
+	export TORTURE_QEMU_INTERACTIVE
+TORTURE_QEMU_MAC="$TORTURE_QEMU_MAC"; export TORTURE_QEMU_MAC
+TORTURE_SUITE="$TORTURE_SUITE"; export TORTURE_SUITE
 if ! test -e $resdir
 then
 	mkdir -p "$resdir" || :
@@ -371,21 +382,6 @@ ___EOF___
 
 if test "$dryrun" = script
 then
-	# Dump out the script, but define the environment variables that
-	# it needs to run standalone.
-	echo CONFIGFRAG="$CONFIGFRAG; export CONFIGFRAG"
-	echo KVM="$KVM; export KVM"
-	echo KVPATH="$KVPATH; export KVPATH"
-	echo PATH="$PATH; export PATH"
-	echo TORTURE_BUILDONLY="$TORTURE_BUILDONLY; export TORTURE_BUILDONLY"
-	echo TORTURE_INITRD="$TORTURE_INITRD; export TORTURE_INITRD"
-	echo TORTURE_KMAKE_ARG="$TORTURE_KMAKE_ARG; export TORTURE_KMAKE_ARG"
-	echo TORTURE_QEMU_CMD="$TORTURE_QEMU_CMD; export TORTURE_QEMU_CMD"
-	echo TORTURE_QEMU_INTERACTIVE="$TORTURE_QEMU_INTERACTIVE;
-		export TORTURE_QEMU_INTERACTIVE"
-	echo TORTURE_QEMU_MAC="$TORTURE_QEMU_MAC; export TORTURE_QEMU_MAC"
-	echo "mkdir -p "$resdir" || :"
-	echo "mkdir $resdir/$ds"
 	cat $T/script
 	exit 0
 elif test "$dryrun" = sched
-- 
1.8.1.5

