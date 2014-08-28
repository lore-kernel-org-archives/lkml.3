Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaH1SMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:12:39 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39998 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaH1SMh (ORCPT
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
Subject: [PATCH tip/core/rcu 1/3] memory-barriers: Fix control-ordering no-transitivity example
Date: Thu, 28 Aug 2014 11:12:28 -0700
Message-Id: <1409249550-23313-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20140828181208.GA22865@linux.vnet.ibm.com>
References: <20140828181208.GA22865@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-8236-0000-0000-000004F82379
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The control-ordering example demonstrating lack of transitivity had
multiple problems.  This commit fixes them.

Reported-by: Nikolay Samofatov <nikolay.samofatov@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/memory-barriers.txt | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index a4de88fb55f0..d67c508eb660 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -697,30 +697,36 @@ should do something like the following:
 	}
 
 Finally, control dependencies do -not- provide transitivity.  This is
-demonstrated by two related examples:
+demonstrated by two related examples, with the initial values of
+x and y both being zero:
 
 	CPU 0                     CPU 1
 	=====================     =====================
 	r1 = ACCESS_ONCE(x);      r2 = ACCESS_ONCE(y);
-	if (r1 >= 0)              if (r2 >= 0)
+	if (r1 > 0)               if (r2 > 0)
 	  ACCESS_ONCE(y) = 1;       ACCESS_ONCE(x) = 1;
 
 	assert(!(r1 == 1 && r2 == 1));
 
 The above two-CPU example will never trigger the assert().  However,
 if control dependencies guaranteed transitivity (which they do not),
-then adding the following two CPUs would guarantee a related assertion:
+then adding the following CPU would guarantee a related assertion:
 
-	CPU 2                     CPU 3
-	=====================     =====================
-	ACCESS_ONCE(x) = 2;       ACCESS_ONCE(y) = 2;
+	CPU 2
+	=====================
+	ACCESS_ONCE(x) = 2;
+
+	assert(!(r1 == 2 && r2 == 1 && x == 2)); /* FAILS!!! */
 
-	assert(!(r1 == 2 && r2 == 2 && x == 1 && y == 1)); /* FAILS!!! */
+But because control dependencies do -not- provide transitivity, the above
+assertion can fail after the combined three-CPU example completes.  If you
+need the three-CPU example to provide ordering, you will need smp_mb()
+between the loads and stores in the CPU 0 and CPU 1 code fragments,
+that is, just before or just after the "if" statements.
 
-But because control dependencies do -not- provide transitivity, the
-above assertion can fail after the combined four-CPU example completes.
-If you need the four-CPU example to provide ordering, you will need
-smp_mb() between the loads and stores in the CPU 0 and CPU 1 code fragments.
+These two examples are the LB and WWC litmus tests from this paper:
+http://www.cl.cam.ac.uk/users/pes20/ppc-supplemental/test6.pdf and this
+site: https://www.cl.cam.ac.uk/~pes20/ppcmem/index.html.
 
 In summary:
 
-- 
1.8.1.5

