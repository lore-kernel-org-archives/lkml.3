Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab3KPAiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:38:10 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:51068 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab3KPAgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:36:08 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH tip/core/rcu 10/28] rcutorture: Make test output less chatty
Date: Fri, 15 Nov 2013 16:35:23 -0800
Message-Id: <1384562141-32446-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-0928-0000-0000-000003BD1562
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit drops no-longer-needed diagnostics from the output.  Some of
them are retained in logfiles, in case they are ever needed.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 .../testing/selftests/rcutorture/bin/configinit.sh |  2 --
 .../selftests/rcutorture/bin/kvm-test-1-rcu.sh     |  2 +-
 tools/testing/selftests/rcutorture/bin/kvm.sh      | 25 +++++++++++++---------
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/configinit.sh b/tools/testing/selftests/rcutorture/bin/configinit.sh
index 1f09d599e9d9..926fbd30bcbd 100755
--- a/tools/testing/selftests/rcutorture/bin/configinit.sh
+++ b/tools/testing/selftests/rcutorture/bin/configinit.sh
@@ -14,8 +14,6 @@
 # for example, "O=/tmp/foo".  If this argument is omitted, the .config
 # file will be generated directly in the current directory.
 
-echo configinit.sh $*
-
 T=/tmp/configinit.sh.$$
 trap 'rm -rf $T' 0
 mkdir $T
diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
index 618aa4d766d3..5526550a5d56 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
@@ -62,7 +62,7 @@ then
 fi
 cp $config_template $resdir/ConfigFragment
 echo ' ---' `date`: Starting build
-echo ' ---' Kconfig fragment at: $config_template
+echo ' ---' Kconfig fragment at: $config_template >> $resdir/log
 cat << '___EOF___' >> $T
 CONFIG_RCU_TORTURE_TEST=y
 ___EOF___
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 92f726b01044..bf6d68e96e94 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -28,6 +28,7 @@
 # Authors: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
 
 scriptname=$0
+args="$*"
 
 dur=30
 KVM=`pwd`/tools/testing/selftests/rcutorture; export KVM
@@ -73,7 +74,6 @@ checkarg () {
 
 while test $# -gt 0
 do
-	echo ":$1:"
 	case "$1" in
 	--builddir)
 		checkarg --builddir "(absolute pathname)" "$#" "$2" '^/' error
@@ -133,11 +133,6 @@ do
 	shift
 done
 
-echo "builddir=$builddir"
-echo "dur=$dur"
-echo "KVM=$KVM"
-echo "resdir=$resdir"
-
 PATH=${KVM}/bin:$PATH; export PATH
 CONFIGFRAG=${KVM}/configs; export CONFIGFRAG
 KVPATH=${CONFIGFRAG}/$kversion; export KVPATH
@@ -150,12 +145,19 @@ fi
 if test -z "$resdir"
 then
 	resdir=$KVM/res
-	mkdir $resdir || :
+	if ! test -e $resdir
+	then
+		mkdir $resdir || :
+	fi
 else
-	mkdir -p "$resdir" || :
+	if ! test -e $resdir
+	then
+		mkdir -p "$resdir" || :
+	fi
 fi
 mkdir $resdir/$ds
-echo Datestamp: $ds
+touch $resdir/$ds/log
+echo $scriptname $args >> $resdir/$ds/log
 
 pwd > $resdir/$ds/testid.txt
 if test -d .git
@@ -164,7 +166,10 @@ then
 	git rev-parse HEAD >> $resdir/$ds/testid.txt
 fi
 builddir=$KVM/b1
-mkdir $builddir || :
+if ! test -e $builddir
+then
+	mkdir $builddir || :
+fi
 
 for CF in $configs
 do
-- 
1.8.1.5

