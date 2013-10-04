Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab3JDRey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:34:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58823 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab3JDRev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:34:51 -0400
Date: Fri, 4 Oct 2013 10:34:19 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-ddc1994b8217527e1818f690f17597fc9cedf81b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20131002092528.325264677@infradead.org>
References: <20131002092528.325264677@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait: Collapse __wait_event_timeout()
Git-Commit-ID: ddc1994b8217527e1818f690f17597fc9cedf81b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:34:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ddc1994b8217527e1818f690f17597fc9cedf81b
Gitweb:     http://git.kernel.org/tip/ddc1994b8217527e1818f690f17597fc9cedf81b
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 2 Oct 2013 11:22:23 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:14:47 +0200

sched/wait: Collapse __wait_event_timeout()

Reduce macro complexity by using the new ___wait_event() helper.
No change in behaviour, identical generated code.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131002092528.325264677@infradead.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 68e3a62..546b94e 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -247,17 +247,9 @@ do {									\
 } while (0)
 
 #define __wait_event_timeout(wq, condition, ret)			\
-do {									\
-	DEFINE_WAIT(__wait);						\
-									\
-	for (;;) {							\
-		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
-		if (___wait_cond_timeout(condition, ret))		\
-			break;						\
-		ret = schedule_timeout(ret);				\
-	}								\
-	finish_wait(&wq, &__wait);					\
-} while (0)
+	___wait_event(wq, ___wait_cond_timeout(condition, ret), 	\
+		      TASK_UNINTERRUPTIBLE, 0, ret,			\
+		      ret = schedule_timeout(ret))
 
 /**
  * wait_event_timeout - sleep until a condition gets true or a timeout elapses
