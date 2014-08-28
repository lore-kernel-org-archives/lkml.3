Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbaH1SMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:12:38 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46210 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaH1SMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:12:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/3] memory-barriers: Retain barrier() in fold-to-zero example
Date: Thu, 28 Aug 2014 11:12:29 -0700
Message-Id: <1409249550-23313-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409249550-23313-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828181208.GA22865@linux.vnet.ibm.com>
 <1409249550-23313-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-3532-0000-0000-00000436E163
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The transformation in the fold-to-zero example incorrectly omits the
barrier() directive.  This commit therefore adds it back in.

Reported-by: Pranith Kumar <pranith@gatech.edu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/memory-barriers.txt | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index d67c508eb660..600b45c6e2ad 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -679,12 +679,15 @@ equal to zero, in which case the compiler is within its rights to
 transform the above code into the following:
 
 	q = ACCESS_ONCE(a);
+	barrier();
 	ACCESS_ONCE(b) = p;
 	do_something_else();
 
-This transformation loses the ordering between the load from variable 'a'
-and the store to variable 'b'.  If you are relying on this ordering, you
-should do something like the following:
+This transformation fails to require that the CPU respect the ordering
+between the load from variable 'a' and the store to variable 'b'.
+Yes, the barrier() is still there, but it affects only the compiler,
+not the CPU.  Therefore, if you are relying on this ordering, you should
+do something like the following:
 
 	q = ACCESS_ONCE(a);
 	BUILD_BUG_ON(MAX <= 1); /* Order load from a with store to b. */
-- 
1.8.1.5

