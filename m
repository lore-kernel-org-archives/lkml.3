Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbbAGSXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:23:11 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:39491 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbbAGSTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:19:49 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/12] rcutorture: Make build-output parsing correctly flag RCU's warnings
Date: Wed,  7 Jan 2015 10:19:29 -0800
Message-Id: <1420654779-11213-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107181915.GA7803@linux.vnet.ibm.com>
 <1420654779-11213-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010718-0009-0000-0000-000007C69329
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 .../testing/selftests/rcutorture/bin/parse-build.sh  | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/parse-build.sh b/tools/testing/selftests/rcutorture/bin/parse-build.sh
index 499d1e598e42..a6b57622c2e5 100755
--- a/tools/testing/selftests/rcutorture/bin/parse-build.sh
+++ b/tools/testing/selftests/rcutorture/bin/parse-build.sh
@@ -26,12 +26,15 @@
 #
 # Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
 
-T=$1
+F=$1
 title=$2
+T=/tmp/parse-build.sh.$$
+trap 'rm -rf $T' 0
+mkdir $T
 
 . functions.sh
 
-if grep -q CC < $T
+if grep -q CC < $F
 then
 	:
 else
@@ -39,18 +42,21 @@ else
 	exit 1
 fi
 
-if grep -q "error:" < $T
+if grep -q "error:" < $F
 then
 	print_bug $title build errors:
-	grep "error:" < $T
+	grep "error:" < $F
 	exit 2
 fi
-exit 0
 
-if egrep -q "rcu[^/]*\.c.*warning:|rcu.*\.h.*warning:" < $T
+grep warning: < $F > $T/warnings
+grep "include/linux/*rcu*\.h:" $T/warnings > $T/hwarnings
+grep "kernel/rcu/[^/]*:" $T/warnings > $T/cwarnings
+cat $T/hwarnings $T/cwarnings > $T/rcuwarnings
+if test -s $T/rcuwarnings
 then
 	print_warning $title build errors:
-	egrep "rcu[^/]*\.c.*warning:|rcu.*\.h.*warning:" < $T
+	cat $T/rcuwarnings
 	exit 2
 fi
 exit 0
-- 
1.8.1.5

