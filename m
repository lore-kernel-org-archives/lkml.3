Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbaBQWNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:13:35 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:55058 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbaBQWNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:24 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 51/55] locktorture: Add kvm-recheck.sh plug-in for locktorture
Date: Mon, 17 Feb 2014 14:12:55 -0800
Message-Id: <1392675179-11560-51-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-3532-0000-0000-000005BEDD05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds the kvm-recheck-lock.sh plug-in for locktorture to
print out lock-specific progress statistics.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 .../selftests/rcutorture/bin/kvm-recheck-lock.sh   | 51 ++++++++++++++++++++++
 .../selftests/rcutorture/bin/kvm-recheck.sh        |  5 ++-
 2 files changed, 54 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
new file mode 100755
index 000000000000..829186e19eb1
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck-lock.sh
@@ -0,0 +1,51 @@
+#!/bin/bash
+#
+# Analyze a given results directory for locktorture progress.
+#
+# Usage: sh kvm-recheck-lock.sh resdir
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
+ncs=`grep "Writes:  Total:" $i/console.log 2> /dev/null | tail -1 | sed -e 's/^.* Total: //' -e 's/ .*$//'`
+if test -z "$ncs"
+then
+	echo $configfile
+else
+	title="$configfile ------- $ncs acquisitions/releases"
+	dur=`sed -e 's/^.* locktorture.shutdown_secs=//' -e 's/ .*$//' < $i/qemu-cmd 2> /dev/null`
+	if test -z "$dur"
+	then
+		:
+	else
+		ncsps=`awk -v ncs=$ncs -v dur=$dur '
+			BEGIN { print ncs / dur }' < /dev/null`
+		title="$title ($ncsps per second)"
+	fi
+	echo $title
+fi
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
index 31c87063231d..a44daaa259a9 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
@@ -1,6 +1,6 @@
 #!/bin/bash
 #
-# Given the results directories for previous KVM runs of rcutorture,
+# Given the results directories for previous KVM-based torture runs,
 # check the build and console output for errors.  Given a directory
 # containing results directories, this recursively checks them all.
 #
@@ -37,7 +37,8 @@ do
 			resdir=`echo $i | sed -e 's,/$,,' -e 's,/[^/]*$,,'`
 			head -1 $resdir/log
 		fi
-		kvm-recheck-rcu.sh $i
+		TORTURE_SUITE="`cat $i/../TORTURE_SUITE`"
+		kvm-recheck-${TORTURE_SUITE}.sh $i
 		configcheck.sh $i/.config $i/ConfigFragment
 		parse-build.sh $i/Make.out $configfile
 		parse-rcutorture.sh $i/console.log $configfile
-- 
1.8.1.5

