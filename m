Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440AbaD2A2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:28:12 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36942 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095AbaD2AZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:51 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 34/45] torture: Use elapsed time to detect hangs
Date: Mon, 28 Apr 2014 17:25:22 -0700
Message-Id: <1398731133-18925-34-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-0928-0000-0000-000001809EF1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The kvm-test-1-run.sh currently counts "sleep 1" commands to detect
hangs.  This can fail spectacularly on busy systems, where "sleep 1"
might take far longer than one second to complete.  This commit
therefore changes hang detection to use elapsed time measurements.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 .../testing/selftests/rcutorture/bin/kvm-test-1-run.sh | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index 51c34a91a375..b1e85b049075 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -161,14 +161,18 @@ $QEMU $qemu_args -m 512 -kernel $builddir/$BOOT_IMAGE -append "$qemu_append $boo
 qemu_pid=$!
 commandcompleted=0
 echo Monitoring qemu job at pid $qemu_pid
-for ((i=0;i<$seconds;i++))
+while :
 do
+	kruntime=`awk 'BEGIN { print systime() - '"$kstarttime"' }' < /dev/null`
 	if kill -0 $qemu_pid > /dev/null 2>&1
 	then
+		if test $kruntime -ge $seconds
+		then
+			break;
+		fi
 		sleep 1
 	else
 		commandcompleted=1
-		kruntime=`awk 'BEGIN { print systime() - '"$kstarttime"' }' < /dev/null`
 		if test $kruntime -lt $seconds
 		then
 			echo Completed in $kruntime vs. $seconds >> $resdir/Warnings 2>&1
@@ -189,20 +193,22 @@ done
 if test $commandcompleted -eq 0
 then
 	echo Grace period for qemu job at pid $qemu_pid
-	for ((i=0;i<=$grace;i++))
+	while :
 	do
+		kruntime=`awk 'BEGIN { print systime() - '"$kstarttime"' }' < /dev/null`
 		if kill -0 $qemu_pid > /dev/null 2>&1
 		then
-			sleep 1
+			:
 		else
 			break
 		fi
-		if test $i -eq $grace
+		if test $kruntime -ge $((seconds + grace))
 		then
-			kruntime=`awk 'BEGIN { print systime() - '"$kstarttime"' }'`
 			echo "!!! Hang at $kruntime vs. $seconds seconds" >> $resdir/Warnings 2>&1
 			kill -KILL $qemu_pid
+			break
 		fi
+		sleep 1
 	done
 fi
 
-- 
1.8.1.5

