Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab3HRBi2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 21:38:28 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:43195 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab3HRBiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 21:38:10 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/11] rcu: Switch to exedited grace periods for suspend as well as hibernation
Date: Sat, 17 Aug 2013 18:37:51 -0700
Message-Id: <1376789876-27594-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376789876-27594-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130818013735.GA27234@linux.vnet.ibm.com>
 <1376789876-27594-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081801-7606-0000-0000-00000E6C1068
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjørn Mork <bjorn@mork.no>

Commit 587ff2cf ("rcu: Expedite grace periods during suspend/resume")
enabled expedited grace periods for hibernation, but not for suspend.
The same issue applies to both cases, so this commit simply applies the
same logic by adding additional cases to the switch statement.

Note that this commit also switches from PM_POST_RESTORE to the
combination of PM_POST_HIBERNATION and PM_POST_SUSPEND.  A separate
patch from Borislav Petkov corrects the documentation to indicate that
this is necessary.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 405f2303..9184056 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -3050,10 +3050,12 @@ static int rcu_pm_notify(struct notifier_block *self,
 {
 	switch (action) {
 	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
 		if (nr_cpu_ids <= 256) /* Expediting bad for large systems. */
 			rcu_expedited = 1;
 		break;
-	case PM_POST_RESTORE:
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
 		rcu_expedited = 0;
 		break;
 	default:
-- 
1.8.1.5

