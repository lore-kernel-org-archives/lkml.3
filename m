Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbbAGSTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:19:50 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:39475 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbbAGSTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:19:48 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/12] rcutorture: Issue warnings on close calls due to Reader Batch blows
Date: Wed,  7 Jan 2015 10:19:27 -0800
Message-Id: <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20150107181915.GA7803@linux.vnet.ibm.com>
References: <20150107181915.GA7803@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010718-0009-0000-0000-000007C6931E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Normal rcutorture checking overestimates grace periods somewhat due to
the fact that there is a delay from a grace-period request until the
start of the corresponding grace period and another delay from the end
of that grace period to notification of the requestor.  This means that
rcutorture's detection of RCU bugs is less sensitive than it might be.

It turns out that rcutorture also checks the underlying grace-period
"completed" counter (displayed in Reader Batch output), which in theory
allows rcutorture to do exact checks.  In practice, memory misordering
(by both compiler and CPU) can result in false positives.  However,
experience on x86 shows that these false positives are quite rare,
occuring less than one time per 1,000 hours of testing.  This commit
therefore does the exact checking, giving a warning if any Reader Batch
blows happen, and flagging an error if they happen more often than
once every three hours in long tests.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 .../selftests/rcutorture/bin/kvm-recheck-rcu.sh        | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
index d6cc07fc137f..559e01ac86be 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
@@ -30,6 +30,7 @@ else
 	echo Unreadable results directory: $i
 	exit 1
 fi
+. tools/testing/selftests/rcutorture/bin/functions.sh
 
 configfile=`echo $i | sed -e 's/^.*\///'`
 ngps=`grep ver: $i/console.log 2> /dev/null | tail -1 | sed -e 's/^.* ver: //' -e 's/ .*$//'`
@@ -48,4 +49,21 @@ else
 		title="$title ($ngpsps per second)"
 	fi
 	echo $title
+	nclosecalls=`grep --binary-files=text 'torture: Reader Batch' $i/console.log | tail -1 | awk '{for (i=NF-8;i<=NF;i++) sum+=$i; } END {print sum}'`
+	if test -z "$nclosecalls"
+	then
+		exit 0
+	fi
+	if test "$nclosecalls" -eq 0
+	then
+		exit 0
+	fi
+	# Compute number of close calls per tenth of an hour
+	nclosecalls10=`awk -v nclosecalls=$nclosecalls -v dur=$dur 'BEGIN { print int(nclosecalls * 36000 / dur) }' < /dev/null`
+	if test $nclosecalls10 -gt 5 -a $nclosecalls -gt 1
+	then
+		print_bug $nclosecalls "Reader Batch close calls in" $(($dur/60)) minute run: $i
+	else
+		print_warning $nclosecalls "Reader Batch close calls in" $(($dur/60)) minute run: $i
+	fi
 fi
-- 
1.8.1.5

