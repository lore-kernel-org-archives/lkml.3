Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbaBQWOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:14:25 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:55036 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbaBQWNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:22 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 50/55] rcutorture: Gracefully handle NULL cleanup hooks
Date: Mon, 17 Feb 2014 14:12:54 -0800
Message-Id: <1392675179-11560-50-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-3532-0000-0000-000005BEDCF0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Although most torture tests will have some cleanup hook, it is possible
that one might not.  This commit therefore enables graceful handling of
a NULL cleanup hook during torture-test shutdown.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/torture.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/torture.c b/kernel/torture.c
index a93ee5722b50..0abaa8354bbe 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -454,7 +454,10 @@ static int torture_shutdown(void *arg)
 
 	VERBOSE_TOROUT_STRING("torture_shutdown task shutting down system");
 	shutdown_task = NULL;	/* Avoid self-kill deadlock. */
-	torture_shutdown_hook();/* Shut down the enclosing torture test. */
+	if (torture_shutdown_hook)
+		torture_shutdown_hook();
+	else
+		VERBOSE_TOROUT_STRING("No torture_shutdown_hook(), skipping.");
 	kernel_power_off();	/* Shut down the system. */
 	return 0;
 }
-- 
1.8.1.5

