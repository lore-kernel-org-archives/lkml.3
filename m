Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbaBQWaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:30:00 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35064 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbaBQWNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:13 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/55] rcutorture: Print grace-period performance statistics
Date: Mon, 17 Feb 2014 14:12:05 -0800
Message-Id: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20140217221231.GA8419@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F3798
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Sometime problems can manifest themselves as unusually slow grace periods.
This commit therefore prints the number of rcutorture updates during the
test and the number per second.  These statistics are harvested from the
config.out and qemu-cmd files, and are silently omitted if these files
are not available, as would be the case if there was a build failure or
a boot-time hang.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm-recheck.sh | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
index baef09f3469b..e3b1af3677e3 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
@@ -31,7 +31,24 @@ do
 	for i in $dirs
 	do
 		configfile=`echo $i | sed -e 's/^.*\///'`
-		echo $configfile
+		ngps=`grep ver: $i/console.log 2> /dev/null | tail -1 | sed -e 's/^.* ver: //' -e 's/ .*$//'`
+		if test -z "$ngps"
+		then
+			echo $configfile
+		else
+			title="$configfile ------- $ngps grace periods"
+			dur=`sed -e 's/^.* rcutorture.shutdown_secs=//' -e 's/ .*$//' < $i/qemu-cmd 2> /dev/null`
+			if test -z "$dur"
+			then
+				:
+			else
+				ngpsps=$((ngps / dur))
+				ngpsps=`awk -v ngps=$ngps -v dur=$dur '
+					BEGIN { print ngps / dur }' < /dev/null`
+				title="$title ($ngpsps per second)"
+			fi
+			echo $title
+		fi
 		configcheck.sh $i/.config $i/ConfigFragment
 		parse-build.sh $i/Make.out $configfile
 		parse-rcutorture.sh $i/console.log $configfile
-- 
1.8.1.5

