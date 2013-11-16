Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3KPAkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:40:51 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:38187 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab3KPAfw (ORCPT
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
Subject: [PATCH tip/core/rcu 26/28] rcutorture: Record results from repeated runs of the same test scenario
Date: Fri, 15 Nov 2013 16:35:39 -0800
Message-Id: <1384562141-32446-26-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-0928-0000-0000-0000037AA9F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Repeatedly running a given test, for example, by repeating the name
as in "--configs "TREE08 TREE08 TREE08" records the results only of
the last run of this test.  This is because the earlier results are
overwritten by the later results.

This commit therefore checks for earlier results, using numbered
file extensions to distinguish multiple runs.  The earlier example
would therefore create directories TREE01, TREE01.2, and TREE01.3.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rcutorture/bin/kvm.sh | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
index b8d278904dee..0783ec9c583e 100644
--- a/tools/testing/selftests/rcutorture/bin/kvm.sh
+++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
@@ -204,8 +204,22 @@ fi
 
 for CF in $configs
 do
+	# Running TREE01 multiple times creates TREE01, TREE01.2, TREE01.3, ...
 	rd=$resdir/$ds/$CF
-	mkdir $rd || :
+	if test -d "${rd}"
+	then
+		n="`ls -d "${rd}"* | grep '\.[0-9]\+$' |
+			sed -e 's/^.*\.\([0-9]\+\)/\1/' |
+			sort -k1n | tail -1`"
+		if test -z "$n"
+		then
+			rd="${rd}.2"
+		else
+			n="`expr $n + 1`"
+			rd="${rd}.${n}"
+		fi
+	fi
+	mkdir "${rd}"
 	echo Results directory: $rd
 	kvm-test-1-rcu.sh $CONFIGFRAG/$kversion/$CF $builddir $rd $dur "-nographic $RCU_QEMU_ARG" "rcutorture.test_no_idle_hz=1 rcutorture.verbose=1 $RCU_BOOTARGS"
 done
-- 
1.8.1.5

