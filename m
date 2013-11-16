Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3KPAgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:36:47 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:58272 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab3KPAfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:35:52 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH tip/core/rcu 18/28] rcutorture: Add --buildonly dry-run capability
Date: Fri, 15 Nov 2013 16:35:31 -0800
Message-Id: <1384562141-32446-18-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-6688-0000-0000-0000038DDF3E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds --buildonly, which does the builds specified by the
--configs argument, but does not boot or test the resulting kernels.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh | 5 +++++
 tools/testing/selftests/rcutorture/bin/kvm.sh            | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
index 93342f7ce6d5..3df1581e78ae 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
@@ -141,6 +141,11 @@ boot_args="`rcutorture_param_n_barrier_cbs "$boot_args"`"
 boot_args="$boot_args rcutorture.stat_interval=15 rcutorture.shutdown_secs=$seconds rcutorture.rcutorture_runnable=1"
 
 echo $QEMU $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append \"$qemu_append $boot_args\" > $resdir/qemu-cmd
+if test -n "$RCU_BUILDONLY"
+then
+	echo Build-only run specified, boot/test omitted.
+	exit 0
+fi
 $QEMU $qemu_args -m 512 -kernel $builddir/arch/x86/boot/bzImage -append "$qemu_append $boot_args" &
 qemu_pid=$!
 commandcompleted=0
diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index 979c34134634..6c67d0ca8c9a 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -41,6 +41,7 @@ kversion=""
 usage () {
 	echo "Usage: $scriptname optional arguments:"
 	echo "       --builddir absolute-pathname"
+	echo "       --buildonly"
 	echo "       --configs \"config-file list\""
 	echo "       --datestamp string"
 	echo "       --duration minutes"
@@ -83,6 +84,9 @@ do
 		gotbuilddir=1
 		shift
 		;;
+	--buildonly)
+		RCU_BUILDONLY=1; export RCU_BUILDONLY
+		;;
 	--configs)
 		checkarg --configs "(list of config files)" "$#" "$2" '^[^/]*$' '^--'
 		configs="$2"
-- 
1.8.1.5

