Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbaBFQ2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:28:48 -0500
Received: from s3.sipsolutions.net ([144.76.43.152]:57508 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaBFQ2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:28:47 -0500
Message-ID: <1391704121.12789.20.camel@jlt4.sipsolutions.net>
Subject: [PATCH] sched/wait: suppress sparse 'variable shadowing' warning
From: Johannes Berg <johannes@sipsolutions.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Thu, 06 Feb 2014 17:28:41 +0100
In-Reply-To: <20140206111346.712edc04@gandalf.local.home>
References: <20140206111346.712edc04@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This warning seems to show up a lot now, since ___wait_event()
is (indirectly) used inside wait_event_timeout(), which also
has a variable called __ret. Rename the one in ___wait_event()
to ___ret (another leading underscore) to suppress the warning.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/wait.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 559044c..c55ea5c 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -195,7 +195,7 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 ({									\
 	__label__ __out;						\
 	wait_queue_t __wait;						\
-	long __ret = ret;						\
+	long ___ret = ret;						\
 									\
 	INIT_LIST_HEAD(&__wait.task_list);				\
 	if (exclusive)							\
@@ -210,7 +210,7 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 			break;						\
 									\
 		if (___wait_is_interruptible(state) && __int) {		\
-			__ret = __int;					\
+			___ret = __int;					\
 			if (exclusive) {				\
 				abort_exclusive_wait(&wq, &__wait,	\
 						     state, NULL);	\
@@ -222,7 +222,7 @@ wait_queue_head_t *bit_waitqueue(void *, int);
 		cmd;							\
 	}								\
 	finish_wait(&wq, &__wait);					\
-__out:	__ret;								\
+__out:	___ret;								\
 })
 
 #define __wait_event(wq, condition)					\
-- 
1.8.5.3



