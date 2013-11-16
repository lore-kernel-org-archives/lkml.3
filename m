Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab3KPAj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:39:58 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:59615 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762Ab3KPAfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:35:53 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH tip/core/rcu 28/28] rcutorture: Move checkarg to functions.sh
Date: Fri, 15 Nov 2013 16:35:41 -0800
Message-Id: <1384562141-32446-28-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-1542-0000-0000-0000035637BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 .../testing/selftests/rcutorture/bin/functions.sh  | 24 +++++++++++++++++++++
 tools/testing/selftests/rcutorture/bin/kvm.sh      | 25 +++-------------------
 2 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/functions.sh b/tools/testing/selftests/rcutorture/bin/functions.sh
index 963b6f04d4ef..3052f1bea6bf 100644
--- a/tools/testing/selftests/rcutorture/bin/functions.sh
+++ b/tools/testing/selftests/rcutorture/bin/functions.sh
@@ -28,6 +28,30 @@ bootparam_hotplug_cpu () {
 	echo "$1" | grep -q "rcutorture\.onoff_"
 }
 
+# checkarg --argname argtype $# arg mustmatch cannotmatch
+#
+# Checks the specified argument "arg" against the mustmatch and cannotmatch
+# patterns.
+checkarg () {
+	if test $3 -le 1
+	then
+		echo $1 needs argument $2 matching \"$5\"
+		usage
+	fi
+	if echo "$4" | grep -q -e "$5"
+	then
+		:
+	else
+		echo $1 $2 \"$4\" must match \"$5\"
+		usage
+	fi
+	if echo "$4" | grep -q -e "$6"
+	then
+		echo $1 $2 \"$4\" must not match \"$6\"
+		usage
+	fi
+}
+
 # configfrag_boot_params bootparam-string config-fragment-file
 #
 # Adds boot parameters from the .boot file, if any.
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 0783ec9c583e..7ba375ebe396 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -32,6 +32,7 @@ args="$*"
 
 dur=30
 KVM="`pwd`/tools/testing/selftests/rcutorture"; export KVM
+PATH=${KVM}/bin:$PATH; export PATH
 builddir="${KVM}/b1"
 RCU_INITRD="$KVM/initrd"; export RCU_INITRD
 RCU_KMAKE_ARG=""; export RCU_KMAKE_ARG
@@ -40,6 +41,8 @@ configs=""
 ds=`date +%Y.%m.%d-%H:%M:%S`
 kversion=""
 
+. functions.sh
+
 usage () {
 	echo "Usage: $scriptname optional arguments:"
 	echo "       --bootargs kernel-boot-arguments"
@@ -60,27 +63,6 @@ usage () {
 	exit 1
 }
 
-# checkarg --argname argtype $# arg mustmatch cannotmatch
-checkarg () {
-	if test $3 -le 1
-	then
-		echo $1 needs argument $2 matching \"$5\"
-		usage
-	fi
-	if echo "$4" | grep -q -e "$5"
-	then
-		:
-	else
-		echo $1 $2 \"$4\" must match \"$5\"
-		usage
-	fi
-	if echo "$4" | grep -q -e "$6"
-	then
-		echo $1 $2 \"$4\" must not match \"$6\"
-		usage
-	fi
-}
-
 while test $# -gt 0
 do
 	case "$1" in
@@ -164,7 +146,6 @@ do
 	shift
 done
 
-PATH=${KVM}/bin:$PATH; export PATH
 CONFIGFRAG=${KVM}/configs; export CONFIGFRAG
 KVPATH=${CONFIGFRAG}/$kversion; export KVPATH
 
-- 
1.8.1.5

