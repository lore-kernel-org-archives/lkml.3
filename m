Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbaBQWO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:14:29 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:44751 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102AbaBQWNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:22 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 41/55] rcutorture: Abstract kvm-recheck.sh
Date: Mon, 17 Feb 2014 14:12:45 -0800
Message-Id: <1392675179-11560-41-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-0928-0000-0000-000006C34F23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit creates a plug-in to allow kvm-recheck.sh to process
non-rcutorture console output.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 .../selftests/rcutorture/bin/kvm-recheck-rcu.sh    | 51 ++++++++++++++++++++++
 .../selftests/rcutorture/bin/kvm-recheck.sh        | 20 +--------
 2 files changed, 52 insertions(+), 19 deletions(-)
 create mode 100755 tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
new file mode 100755
index 000000000000..d75b1dc5ae53
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck-rcu.sh
@@ -0,0 +1,51 @@
+#!/bin/bash
+#
+# Analyze a given results directory for rcutorture progress.
+#
+# Usage: sh kvm-recheck-rcu.sh resdir
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, you can access it online at
+# http://www.gnu.org/licenses/gpl-2.0.html.
+#
+# Copyright (C) IBM Corporation, 2014
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+i="$1"
+if test -d $i
+then
+	:
+else
+	echo Unreadable results directory: $i
+	exit 1
+fi
+
+configfile=`echo $i | sed -e 's/^.*\///'`
+ngps=`grep ver: $i/console.log 2> /dev/null | tail -1 | sed -e 's/^.* ver: //' -e 's/ .*$//'`
+if test -z "$ngps"
+then
+	echo $configfile
+else
+	title="$configfile ------- $ngps grace periods"
+	dur=`sed -e 's/^.* rcutorture.shutdown_secs=//' -e 's/ .*$//' < $i/qemu-cmd 2> /dev/null`
+	if test -z "$dur"
+	then
+		:
+	else
+		ngpsps=`awk -v ngps=$ngps -v dur=$dur '
+			BEGIN { print ngps / dur }' < /dev/null`
+		title="$title ($ngpsps per second)"
+	fi
+	echo $title
+fi
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
index 89b5dbac5327..31c87063231d 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
@@ -37,25 +37,7 @@ do
 			resdir=`echo $i | sed -e 's,/$,,' -e 's,/[^/]*$,,'`
 			head -1 $resdir/log
 		fi
-		configfile=`echo $i | sed -e 's/^.*\///'`
-		ngps=`grep ver: $i/console.log 2> /dev/null | tail -1 | sed -e 's/^.* ver: //' -e 's/ .*$//'`
-		if test -z "$ngps"
-		then
-			echo $configfile
-		else
-			title="$configfile ------- $ngps grace periods"
-			dur=`sed -e 's/^.* rcutorture.shutdown_secs=//' -e 's/ .*$//' < $i/qemu-cmd 2> /dev/null`
-			if test -z "$dur"
-			then
-				:
-			else
-				ngpsps=$((ngps / dur))
-				ngpsps=`awk -v ngps=$ngps -v dur=$dur '
-					BEGIN { print ngps / dur }' < /dev/null`
-				title="$title ($ngpsps per second)"
-			fi
-			echo $title
-		fi
+		kvm-recheck-rcu.sh $i
 		configcheck.sh $i/.config $i/ConfigFragment
 		parse-build.sh $i/Make.out $configfile
 		parse-rcutorture.sh $i/console.log $configfile
-- 
1.8.1.5

