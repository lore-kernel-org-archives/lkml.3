Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaKPUKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:10:04 -0500
Received: from smtprelay0193.hostedemail.com ([216.40.44.193]:41760 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751484AbaKPUJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:09:59 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:2693:3138:3139:3140:3141:3142:3352:3865:3866:3870:3871:3872:4277:4321:5007:6119:6261:7903:8531:10004:10848:11026:11658:11914:12296:12517:12519:12555:13311:13357:14096:14394:21080:21088,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bells71_56f1a80395c2b
X-Filterd-Recvd-Size: 2114
From: Joe Perches <joe@perches.com>
To: Ionut Alexa <ionut.m.alexa@gmail.com>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [UNNECESSARY PATCH 14/16] signal: Convert for (;;) to do {} while
Date: Sun, 16 Nov 2014 12:09:21 -0800
Message-Id: <017139b38b6f7d9163c6d8ccbce8b3ea61c734c6.1416167046.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141116180059.GS7996@ZenIV.linux.org.uk>
References: <20141116180059.GS7996@ZenIV.linux.org.uk>
In-Reply-To: <cover.1416167046.git.joe@perches.com>
References: <cover.1416167046.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So the return value is at end of the function.

No change of compiled x86-64 object.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/signal.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 9b133eb..739d261 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1345,21 +1345,21 @@ int kill_pid_info(int sig, struct siginfo *info, struct pid *pid)
 	int error = -ESRCH;
 	struct task_struct *p;
 
-	for (;;) {
+	do {
 		rcu_read_lock();
 		p = pid_task(pid, PIDTYPE_PID);
 		if (p)
 			error = group_send_sig_info(sig, info, p);
 		rcu_read_unlock();
-		if (likely(!p || error != -ESRCH))
-			return error;
 
 		/*
-		 * The task was unhashed in between, try again.  If it
-		 * is dead, pid_task() will return NULL, if we race with
-		 * de_thread() it will find the new leader.
+		 * If the task is dead, pid_task() will return NULL
+		 * If we race with de_thread() it will find the new leader.
+		 * The task was unhashed in between, try again.
 		 */
-	}
+	} while (unlikely(p && error == -ESRCH));
+
+	return error;
 }
 
 int kill_proc_info(int sig, struct siginfo *info, pid_t pid)
-- 
2.1.2

