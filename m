Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbaBQW2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:28:35 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:51016 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbaBQWNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:14 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 04/55] rcutorture: Allow kvm-test-1-rcu.sh to pause after build
Date: Mon, 17 Feb 2014 14:12:08 -0800
Message-Id: <1392675179-11560-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-9332-0000-0000-000003230113
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Parallel rcutorture runs is valuable on large systems, but it is not a
good idea to do (say) five builds in parallel if each build believes it
has the whole system at its disposal, especially if the system is shared.
It is also bad to restrict the build to (say) a single CPU just because
the corresponding rcutorture run uses only a single CPU.  This commit
therefore adds a kvm-test-1-rcu.sh ability to pause after the build
completes, which will allow kvm.sh to do a number of builds serially
(with each build thus having the full system at its disposal), then
allow the rcutorture runs to proceed in parallel.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
index 2cb7facbc86d..c3a396518113 100755
--- a/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm-test-1-rcu.sh
@@ -96,11 +96,23 @@ then
 	cp $builddir/.config $resdir
 	cp $builddir/arch/x86/boot/bzImage $resdir
 	parse-build.sh $resdir/Make.out $title
+	if test -f $builddir.wait
+	then
+		mv $builddir.wait $builddir.ready
+	fi
 else
 	cp $builddir/Make*.out $resdir
 	echo Build failed, not running KVM, see $resdir.
+	if test -f $builddir.wait
+	then
+		mv $builddir.wait $builddir.ready
+	fi
 	exit 1
 fi
+while test -f $builddir.ready
+do
+	sleep 1
+done
 minutes=$4
 seconds=$(($minutes * 60))
 qemu_args=$5
-- 
1.8.1.5

