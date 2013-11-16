Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3KPAgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:36:41 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:59597 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab3KPAfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:35:51 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH tip/core/rcu 12/28] rcutorture: Abstract qemu-flavor identification
Date: Fri, 15 Nov 2013 16:35:25 -0800
Message-Id: <1384562141-32446-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-1542-0000-0000-0000035637B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The task of working out which flavor of qemu to use gets more complex
as more types of CPUs are supported.  Adding Power makes three in addition
to 32-bit and 64-bit x86, so it is time to pull this out into a function.
This commit therefore creates an identify_qemu function and also adds
a --qemu-cmd command-line argument for the inevitable case where the
identify_qemu cannot figure it out.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 .../testing/selftests/rcutorture/bin/functions.sh  | 27 ++++++++++++++++++++++
 .../selftests/rcutorture/bin/kvm-test-1-rcu.sh     |  9 +++-----
 tools/testing/selftests/rcutorture/bin/kvm.sh      |  6 +++++
 3 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/functions.sh b/tools/testing/selftests/rcutorture/bin/functions.sh
index 8f912419ed7f..c974414ef7a5 100644
--- a/tools/testing/selftests/rcutorture/bin/functions.sh
+++ b/tools/testing/selftests/rcutorture/bin/functions.sh
@@ -51,3 +51,30 @@ configfrag_hotplug_cpu () {
 	fi
 	grep -q '^CONFIG_HOTPLUG_CPU=y$' "$1"
 }
+
+# identify_qemu builddir
+#
+# Returns our best guess as to which qemu command is appropriate for
+# the kernel at hand.  Override with the RCU_QEMU_CMD environment variable.
+identify_qemu () {
+	local u="`file "$1"`"
+	if test -n "$RCU_QEMU_CMD"
+	then
+		echo $RCU_QEMU_CMD
+	elif echo $u | grep -q x86-64
+	then
+		echo qemu-system-x86_64
+	elif echo $u | grep -q "Intel 80386"
+	then
+		echo qemu-system-i386
+	elif uname -a | grep -q ppc64
+	then
+		echo qemu-system-ppc64
+	else
+		echo Cannot figure out what qemu command to use! 1>&2
+		# Usually this will be one of /usr/bin/qemu-system-*
+		# Use RCU_QEMU_CMD environment variable or appropriate
+		# argument to top-level script.
+		exit 1
+	fi
+}
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
index 5526550a5d56..ddf3bd6eaf19 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
@@ -109,12 +109,9 @@ boot_args=$6
 cd $KVM
 kstarttime=`awk 'BEGIN { print systime() }' < /dev/null`
 echo ' ---' `date`: Starting kernel
-if file linux-2.6/*.o | grep -q 64-bit
-then
-	QEMU=qemu-system-x86_64
-else
-	QEMU=qemu-system-i386
-fi
+
+# Determine the appropriate flavor of qemu command.
+QEMU="`identify_qemu $builddir/vmlinux.o`"
 
 # Generate -smp qemu argument.
 cpu_count=`configNR_CPUS.sh $config_template`
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index bf6d68e96e94..89164c245ca1 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -45,6 +45,7 @@ usage () {
 	echo "       --datestamp string"
 	echo "       --duration minutes"
 	echo "       --kversion vN.NN"
+	echo "       --qemu-cmd qemu-system-..."
 	echo "       --rcu-kvm absolute-pathname"
 	echo "       --results absolute-pathname"
 	echo "       --relbuilddir relative-pathname"
@@ -101,6 +102,11 @@ do
 		kversion=$2
 		shift
 		;;
+	--qemu-cmd)
+		checkarg --qemu-cmd "(qemu-system-...)" $# "$2" 'qemu-system-' '^--'
+		RCU_QEMU_CMD="$2"; export RCU_QEMU_CMD
+		shift
+		;;
 	--rcu-kvm)
 		checkarg --rcu-kvm "(absolute pathname)" "$#" "$2" '^/' error
 		KVM=$2; export KVM
-- 
1.8.1.5

