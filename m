Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaBQWSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:18:41 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35250 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbaBQWNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:21 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 29/55] rcutorture: Add diagnostic for unscheduled system shutdown
Date: Mon, 17 Feb 2014 14:12:33 -0800
Message-Id: <1392675179-11560-29-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F3837
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently, rcutorture can terminate via rmmod, via self-shutdown,
via something else shutting the system down, or of course the usual
catastrophic termination.  The first two get flagged, so this commit adds
a message for the third.  For the fourth, your warranty is void as always.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/torture.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/torture.c b/kernel/torture.c
index ed360cf948da..d51de3029a5c 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -438,10 +438,12 @@ static int torture_shutdown_notify(struct notifier_block *unused1,
 				   unsigned long unused2, void *unused3)
 {
 	mutex_lock(&fullstop_mutex);
-	if (fullstop == FULLSTOP_DONTSTOP)
+	if (fullstop == FULLSTOP_DONTSTOP) {
+		VERBOSE_TOROUT_STRING("Unscheduled system shutdown detected");
 		fullstop = FULLSTOP_SHUTDOWN;
-	else
+	} else {
 		pr_warn("Concurrent rmmod and shutdown illegal!\n");
+	}
 	mutex_unlock(&fullstop_mutex);
 	return NOTIFY_DONE;
 }
-- 
1.8.1.5

