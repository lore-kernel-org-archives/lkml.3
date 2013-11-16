Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab3KPAk7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:40:59 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:57064 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab3KPAfw (ORCPT
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
Subject: [PATCH tip/core/rcu 11/28] rcutorture: Eliminate duplicate .config-check code
Date: Fri, 15 Nov 2013 16:35:24 -0800
Message-Id: <1384562141-32446-11-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-9332-0000-0000-0000022BC1DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The commit uses configcheck.sh from within configinit.sh, replacing the
imperfect inline expansion that was there before.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
---
 .../testing/selftests/rcutorture/bin/configinit.sh | 27 +---------------------
 1 file changed, 1 insertion(+), 26 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/configinit.sh b/tools/testing/selftests/rcutorture/bin/configinit.sh
index 926fbd30bcbd..939c16cd03ab 100755
--- a/tools/testing/selftests/rcutorture/bin/configinit.sh
+++ b/tools/testing/selftests/rcutorture/bin/configinit.sh
@@ -51,31 +51,6 @@ cp $builddir/.config $builddir/.config.new
 yes '' | make $buildloc oldconfig > $builddir/Make.modconfig.out 2>&1
 
 # verify new config matches specification.
+configcheck.sh $builddir/.config $c
 
-sed -e 's/"//g' < $c > $T/c
-sed -e 's/"//g' < $builddir/.config > $T/.config
-sed -e 's/\(.*\)=n/# \1 is not set/' -e 's/^#CHECK#//' < $c |
-awk	'
-	{
-		print "if grep -q \"" $0 "\" < '"$T/.config"'";
-		print "then";
-		print "\t:";
-		print "else";
-		if ($1 == "#") {
-			print "\tif grep -q \"" $2 "\" < '"$T/.config"'";
-			print "\tthen";
-			print "\t\techo \":" $2 ": improperly set\"";
-			print "\telse";
-			print "\t\t:";
-			print "\tfi";
-		} else {
-			print "\techo \":" $0 ": improperly set\"";
-		}
-		print "fi";
-	}' | sh > $T/diagnostics
-if test -s $T/diagnostics
-then
-	cat $T/diagnostics
-	exit 1
-fi
 exit 0
-- 
1.8.1.5

