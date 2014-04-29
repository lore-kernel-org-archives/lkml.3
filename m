Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbaD2AeC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:34:02 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37398 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002AbaD2AZs (ORCPT
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
Subject: [PATCH tip/core/rcu 21/45] torture: Report diagnostics from qemu
Date: Mon, 28 Apr 2014 17:25:09 -0700
Message-Id: <1398731133-18925-21-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-7164-0000-0000-0000015FD2DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The current script does record qemu diagnostics, but the user has to
know where to look for them.  This commit therefore puts them into the
Warnings file so that kvm-recheck.sh will display them.  This change is
especially useful if you are in the habit of killing the qemu process
when you realize that you messed something up, but then later on wonder
why the process terminated early.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index 86e6ffe6df45..7848227aa4c1 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -157,7 +157,7 @@ then
 	echo Build-only run specified, boot/test omitted.
 	exit 0
 fi
-$QEMU $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append "$qemu_append $boot_args" &
+$QEMU $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append "$qemu_append $boot_args"; echo $? > $resdir/qemu-retval &
 qemu_pid=$!
 commandcompleted=0
 echo Monitoring qemu job at pid $qemu_pid
@@ -172,6 +172,14 @@ do
 		if test $kruntime -lt $seconds
 		then
 			echo Completed in $kruntime vs. $seconds >> $resdir/Warnings 2>&1
+			grep "^(qemu) qemu:" $resdir/kvm-test-1-run.sh.out >> $resdir/Warnings 2>&1
+			killpid="`grep "^(qemu) qemu: terminating on signal [0-9]* from pid" $resdir/kvm-test-1-run.sh.out`"
+			if test -n "$killpid"
+			then
+				pscmd="`echo $killpid | sed -e 's/^.*from pid/ps -ef | grep/'`"
+				echo $pscmd >> $resdir/Warnings
+				echo $pscmd | sh >> $resdir/Warnings 2>&1
+			fi
 		else
 			echo ' ---' `date`: Kernel done
 		fi
-- 
1.8.1.5

