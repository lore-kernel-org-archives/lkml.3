Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab3KPAjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:39:07 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:59677 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab3KPAgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:36:07 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH tip/core/rcu 27/28] rcutorture: Flag errors and warnings with color coding
Date: Fri, 15 Nov 2013 16:35:40 -0800
Message-Id: <1384562141-32446-27-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-1542-0000-0000-000003563801
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The output of the rcutorture scripts often requires interpretation, so
this commit simplifies this interpretation by tagging messages as
BUGs (colored red) or WARNINGs (colored yellow).

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rcutorture/bin/functions.sh    | 16 ++++++++++++++++
 .../testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh |  5 ++---
 tools/testing/selftests/rcutorture/bin/parse-build.sh  | 18 ++++++++++++++----
 .../testing/selftests/rcutorture/bin/parse-console.sh  |  4 +++-
 .../selftests/rcutorture/bin/parse-rcutorture.sh       | 10 ++++++----
 5 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/functions.sh b/tools/testing/selftests/rcutorture/bin/functions.sh
index d0d19ebd2a94..963b6f04d4ef 100644
--- a/tools/testing/selftests/rcutorture/bin/functions.sh
+++ b/tools/testing/selftests/rcutorture/bin/functions.sh
@@ -134,6 +134,22 @@ identify_qemu_vcpus () {
 	lscpu | grep '^CPU(s):' | sed -e 's/CPU(s)://'
 }
 
+# print_bug
+#
+# Prints "BUG: " in red followed by remaining arguments
+print_bug () {
+	printf '\033[031mBUG: \033[m'
+	echo $*
+}
+
+# print_warning
+#
+# Prints "WARNING: " in yellow followed by remaining arguments
+print_warning () {
+	printf '\033[033mWARNING: \033[m'
+	echo $*
+}
+
 # specify_qemu_cpus qemu-cmd qemu-args #cpus
 #
 # Appends a string containing "-smp XXX" to qemu-args, unless the incoming
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
index 3df1581e78ae..46f97d33e1ba 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
@@ -188,6 +188,5 @@ then
 fi
 
 cp $builddir/console.log $resdir
-parse-rcutorture.sh $resdir/console.log $title >> $resdir/Warnings 2>&1
-parse-console.sh $resdir/console.log $title >> $resdir/Warnings 2>&1
-cat $resdir/Warnings
+parse-rcutorture.sh $resdir/console.log $title
+parse-console.sh $resdir/console.log $title
diff --git a/tools/testing/selftests/rcutorture/bin/parse-build.sh b/tools/testing/selftests/rcutorture/bin/parse-build.sh
index 2e0e9f7ebbb0..9da2c7ba3fce 100755
--- a/tools/testing/selftests/rcutorture/bin/parse-build.sh
+++ b/tools/testing/selftests/rcutorture/bin/parse-build.sh
@@ -30,18 +30,28 @@
 T=$1
 title=$2
 
+. functions.sh
+
 if grep -q CC < $T
 then
 	:
 else
-	echo $title no build
+	print_bug $title no build
 	exit 1
 fi
 
-if egrep -q "error:|rcu[^/]*\.c.*warning:|rcu.*\.h.*warning:" < $T
+if grep -q "error:" < $T
+then
+	print_bug $title build errors:
+	grep "error:" < $T
+	exit 2
+fi
+exit 0
+
+if egrep -q "rcu[^/]*\.c.*warning:|rcu.*\.h.*warning:" < $T
 then
-	echo $title build errors:
-	egrep "error:|rcu[^/]*\.c.*warning:|rcu.*\.h.*warning:" < $T
+	print_warning $title build errors:
+	egrep "rcu[^/]*\.c.*warning:|rcu.*\.h.*warning:" < $T
 	exit 2
 fi
 exit 0
diff --git a/tools/testing/selftests/rcutorture/bin/parse-console.sh b/tools/testing/selftests/rcutorture/bin/parse-console.sh
index bc1496fa1263..8f4be78f06b6 100755
--- a/tools/testing/selftests/rcutorture/bin/parse-console.sh
+++ b/tools/testing/selftests/rcutorture/bin/parse-console.sh
@@ -31,9 +31,11 @@ trap 'rm -f $T' 0
 file="$1"
 title="$2"
 
+. functions.sh
+
 egrep 'Badness|WARNING:|Warn|BUG|===========|Call Trace:|Oops:' < $file | grep -v 'ODEBUG: ' | grep -v 'Warning: unable to open an initial console' > $T
 if test -s $T
 then
-	echo Assertion failure in $file $title
+	print_warning Assertion failure in $file $title
 	cat $T
 fi
diff --git a/tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh b/tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh
index 37368a046a9f..ac2f75a83225 100755
--- a/tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh
+++ b/tools/testing/selftests/rcutorture/bin/parse-rcutorture.sh
@@ -34,6 +34,8 @@ title="$2"
 
 trap 'rm -f $T.seq' 0
 
+. functions.sh
+
 # check for presence of rcutorture.txt file
 
 if test -f "$file" -a -r "$file"
@@ -49,7 +51,7 @@ fi
 if grep -q FAILURE $file || grep -q -e '-torture.*!!!' $file
 then
 	nerrs=`grep --binary-files=text '!!!' $file | tail -1 | awk '{for (i=NF-8;i<=NF;i++) sum+=$i; } END {print sum}'`
-	echo $title FAILURE, $nerrs instances
+	print_bug $title FAILURE, $nerrs instances
 	echo "   " $url
 	exit
 fi
@@ -84,21 +86,21 @@ if grep -q SUCCESS $file
 then
 	if test -s $T.seq
 	then
-		echo WARNING $title `cat $T.seq`
+		print_warning $title $title `cat $T.seq`
 		echo "   " $file
 		exit 2
 	fi
 else
 	if grep -q RCU_HOTPLUG $file
 	then
-		echo WARNING: HOTPLUG FAILURES $title `cat $T.seq`
+		print_warning HOTPLUG FAILURES $title `cat $T.seq`
 		echo "   " $file
 		exit 3
 	fi
 	echo $title no success message, `grep --binary-files=text 'ver:' $file | wc -l` successful RCU version messages
 	if test -s $T.seq
 	then
-		echo WARNING $title `cat $T.seq`
+		print_warning $title `cat $T.seq`
 	fi
 	exit 2
 fi
-- 
1.8.1.5

