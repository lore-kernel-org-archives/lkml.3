Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577AbaD2AeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:34:09 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:47134 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979AbaD2AZs (ORCPT
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
Subject: [PATCH tip/core/rcu 04/45] torture: Make parse-rcutorture.sh less RCU-specific
Date: Mon, 28 Apr 2014 17:24:52 -0700
Message-Id: <1398731133-18925-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-9332-0000-0000-000000A24CF1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

It can be a bit jarring to see a locking test complain about RCU, so
this commit renames parse-rcutorture.sh to parse-torture.sh and makes
the messages it emits more generic.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 .../selftests/rcutorture/bin/kvm-recheck.sh        |   2 +-
 .../selftests/rcutorture/bin/kvm-test-1-run.sh     |   2 +-
 .../selftests/rcutorture/bin/parse-rcutorture.sh   | 106 ---------------------
 .../selftests/rcutorture/bin/parse-torture.sh      | 106 +++++++++++++++++++++
 4 files changed, 108 insertions(+), 108 deletions(-)
 delete mode 100755 tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh
 create mode 100755 tools/testing/selftests/rcutorture/bin/parse-torture.sh

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
index a44daaa259a9..26d78b7eaccf 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-recheck.sh
@@ -41,7 +41,7 @@ do
 		kvm-recheck-${TORTURE_SUITE}.sh $i
 		configcheck.sh $i/.config $i/ConfigFragment
 		parse-build.sh $i/Make.out $configfile
-		parse-rcutorture.sh $i/console.log $configfile
+		parse-torture.sh $i/console.log $configfile
 		parse-console.sh $i/console.log $configfile
 		if test -r $i/Warnings
 		then
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
index 94b28bb37d36..e82f4f201c8c 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-run.sh
@@ -199,5 +199,5 @@ then
 fi
 
 cp $builddir/console.log $resdir
-parse-${TORTURE_SUITE}torture.sh $resdir/console.log $title
+parse-torture.sh $resdir/console.log $title
 parse-console.sh $resdir/console.log $title
diff --git a/tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh b/tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh
deleted file mode 100755
index dd0a275d9796..000000000000
--- a/tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh
+++ /dev/null
@@ -1,106 +0,0 @@
-#!/bin/sh
-#
-# Check the console output from an rcutorture run for goodness.
-# The "file" is a pathname on the local system, and "title" is
-# a text string for error-message purposes.
-#
-# The file must contain rcutorture output, but can be interspersed
-# with other dmesg text.
-#
-# Usage:
-#	sh parse-rcutorture.sh file title
-#
-# This program is free software; you can redistribute it and/or modify
-# it under the terms of the GNU General Public License as published by
-# the Free Software Foundation; either version 2 of the License, or
-# (at your option) any later version.
-#
-# This program is distributed in the hope that it will be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, you can access it online at
-# http://www.gnu.org/licenses/gpl-2.0.html.
-#
-# Copyright (C) IBM Corporation, 2011
-#
-# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
-
-T=/tmp/parse-rcutorture.sh.$$
-file="$1"
-title="$2"
-
-trap 'rm -f $T.seq' 0
-
-. functions.sh
-
-# check for presence of rcutorture.txt file
-
-if test -f "$file" -a -r "$file"
-then
-	:
-else
-	echo $title unreadable rcutorture.txt file: $file
-	exit 1
-fi
-
-# check for abject failure
-
-if grep -q FAILURE $file || grep -q -e '-torture.*!!!' $file
-then
-	nerrs=`grep --binary-files=text '!!!' $file | tail -1 | awk '{for (i=NF-8;i<=NF;i++) sum+=$i; } END {print sum}'`
-	print_bug $title FAILURE, $nerrs instances
-	echo "   " $url
-	exit
-fi
-
-grep --binary-files=text 'torture:.*ver:' $file | grep --binary-files=text -v '(null)' | sed -e 's/^(initramfs)[^]]*] //' -e 's/^\[[^]]*] //' |
-awk '
-BEGIN	{
-	ver = 0;
-	badseq = 0;
-	}
-
-	{
-	if (!badseq && ($5 + 0 != $5 || $5 <= ver)) {
-		badseqno1 = ver;
-		badseqno2 = $5;
-		badseqnr = NR;
-		badseq = 1;
-	}
-	ver = $5
-	}
-
-END	{
-	if (badseq) {
-		if (badseqno1 == badseqno2 && badseqno2 == ver)
-			print "RCU GP HANG at " ver " rcutorture stat " badseqnr;
-		else
-			print "BAD SEQ " badseqno1 ":" badseqno2 " last:" ver " RCU version " badseqnr;
-	}
-	}' > $T.seq
-
-if grep -q SUCCESS $file
-then
-	if test -s $T.seq
-	then
-		print_warning $title $title `cat $T.seq`
-		echo "   " $file
-		exit 2
-	fi
-else
-	if grep -q RCU_HOTPLUG $file
-	then
-		print_warning HOTPLUG FAILURES $title `cat $T.seq`
-		echo "   " $file
-		exit 3
-	fi
-	echo $title no success message, `grep --binary-files=text 'ver:' $file | wc -l` successful RCU version messages
-	if test -s $T.seq
-	then
-		print_warning $title `cat $T.seq`
-	fi
-	exit 2
-fi
diff --git a/tools/testing/selftests/rcutorture/bin/parse-torture.sh b/tools/testing/selftests/rcutorture/bin/parse-torture.sh
new file mode 100755
index 000000000000..3455560ab4e4
--- /dev/null
+++ b/tools/testing/selftests/rcutorture/bin/parse-torture.sh
@@ -0,0 +1,106 @@
+#!/bin/sh
+#
+# Check the console output from a torture run for goodness.
+# The "file" is a pathname on the local system, and "title" is
+# a text string for error-message purposes.
+#
+# The file must contain torture output, but can be interspersed
+# with other dmesg text, as in console-log output.
+#
+# Usage:
+#	sh parse-torture.sh file title
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
+# Copyright (C) IBM Corporation, 2011
+#
+# Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+
+T=/tmp/parse-torture.sh.$$
+file="$1"
+title="$2"
+
+trap 'rm -f $T.seq' 0
+
+. functions.sh
+
+# check for presence of torture output file.
+
+if test -f "$file" -a -r "$file"
+then
+	:
+else
+	echo $title unreadable torture output file: $file
+	exit 1
+fi
+
+# check for abject failure
+
+if grep -q FAILURE $file || grep -q -e '-torture.*!!!' $file
+then
+	nerrs=`grep --binary-files=text '!!!' $file | tail -1 | awk '{for (i=NF-8;i<=NF;i++) sum+=$i; } END {print sum}'`
+	print_bug $title FAILURE, $nerrs instances
+	echo "   " $url
+	exit
+fi
+
+grep --binary-files=text 'torture:.*ver:' $file | grep --binary-files=text -v '(null)' | sed -e 's/^(initramfs)[^]]*] //' -e 's/^\[[^]]*] //' |
+awk '
+BEGIN	{
+	ver = 0;
+	badseq = 0;
+	}
+
+	{
+	if (!badseq && ($5 + 0 != $5 || $5 <= ver)) {
+		badseqno1 = ver;
+		badseqno2 = $5;
+		badseqnr = NR;
+		badseq = 1;
+	}
+	ver = $5
+	}
+
+END	{
+	if (badseq) {
+		if (badseqno1 == badseqno2 && badseqno2 == ver)
+			print "GP HANG at " ver " torture stat " badseqnr;
+		else
+			print "BAD SEQ " badseqno1 ":" badseqno2 " last:" ver " version " badseqnr;
+	}
+	}' > $T.seq
+
+if grep -q SUCCESS $file
+then
+	if test -s $T.seq
+	then
+		print_warning $title $title `cat $T.seq`
+		echo "   " $file
+		exit 2
+	fi
+else
+	if grep -q "_HOTPLUG:" $file
+	then
+		print_warning HOTPLUG FAILURES $title `cat $T.seq`
+		echo "   " $file
+		exit 3
+	fi
+	echo $title no success message, `grep --binary-files=text 'ver:' $file | wc -l` successful version messages
+	if test -s $T.seq
+	then
+		print_warning $title `cat $T.seq`
+	fi
+	exit 2
+fi
-- 
1.8.1.5

