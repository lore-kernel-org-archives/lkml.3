Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab3JDReo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:34:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58816 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab3JDRel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:34:41 -0400
Date: Fri, 4 Oct 2013 10:34:09 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-854267f4384243b19c03a2942e84f06f2beb0952@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20131002092528.254863348@infradead.org>
References: <20131002092528.254863348@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait: Collapse __wait_event()
Git-Commit-ID: 854267f4384243b19c03a2942e84f06f2beb0952
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:34:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  854267f4384243b19c03a2942e84f06f2beb0952
Gitweb:     http://git.kernel.org/tip/854267f4384243b19c03a2942e84f06f2beb0952
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 2 Oct 2013 11:22:22 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:14:46 +0200

sched/wait: Collapse __wait_event()

Reduce macro complexity by using the new ___wait_event() helper.
No change in behaviour, identical generated code.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131002092528.254863348@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 29d0249..68e3a62 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -224,17 +224,8 @@ __out:	;								\
 } while (0)
 
 #define __wait_event(wq, condition) 					\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
-		if (condition)						\
-			break;						\
-		schedule();						\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+	___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0,		\
+		      ___wait_nop_ret, schedule())
 
 /**
  * wait_event - sleep until a condition gets true
