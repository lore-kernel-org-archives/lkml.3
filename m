Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab3FYVQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:16:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48599 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3FYVQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:16:35 -0400
Date: Tue, 25 Jun 2013 14:15:51 -0700
From: tip-bot for Colin Cross <tipbot@zytor.com>
Message-ID: <tip-88c8004fd3a5fdd2378069de86b90b21110d33a4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dvhart@linux.intel.com, rdunlap@infradead.org, viro@zeniv.linux.org.uk,
        ccross@android.com, tj@kernel.org, tglx@linutronix.de, oleg@redhat.com,
        rjw@sisk.pl
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dvhart@linux.intel.com, rdunlap@infradead.org, viro@zeniv.linux.org.uk,
        ccross@android.com, tj@kernel.org, oleg@redhat.com, tglx@linutronix.de,
        rjw@sisk.pl
In-Reply-To: <1367458508-9133-8-git-send-email-ccross@android.com>
References: <1367458508-9133-8-git-send-email-ccross@android.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] futex: Use freezable blocking call
Git-Commit-ID: 88c8004fd3a5fdd2378069de86b90b21110d33a4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 25 Jun 2013 14:15:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88c8004fd3a5fdd2378069de86b90b21110d33a4
Gitweb:     http://git.kernel.org/tip/88c8004fd3a5fdd2378069de86b90b21110d33a4
Author:     Colin Cross <ccross@android.com>
AuthorDate: Wed, 1 May 2013 18:35:05 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 25 Jun 2013 23:11:19 +0200

futex: Use freezable blocking call

Avoid waking up every thread sleeping in a futex_wait call during
suspend and resume by calling a freezable blocking call.  Previous
patches modified the freezer to avoid sending wakeups to threads
that are blocked in freezable blocking calls.

This call was selected to be converted to a freezable call because
it doesn't hold any locks or release any resources when interrupted
that might be needed by another freezing task or a kernel driver
during suspend, and is a common site where idle userspace tasks are
blocked.

Signed-off-by: Colin Cross <ccross@android.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: arve@android.com
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Link: http://lkml.kernel.org/r/1367458508-9133-8-git-send-email-ccross@android.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 49dacfb..c3a1a55 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -62,6 +62,7 @@
 #include <linux/ptrace.h>
 #include <linux/sched/rt.h>
 #include <linux/hugetlb.h>
+#include <linux/freezer.h>
 
 #include <asm/futex.h>
 
@@ -1808,7 +1809,7 @@ static void futex_wait_queue_me(struct futex_hash_bucket *hb, struct futex_q *q,
 		 * is no timeout, or if it has yet to expire.
 		 */
 		if (!timeout || timeout->task)
-			schedule();
+			freezable_schedule();
 	}
 	__set_current_state(TASK_RUNNING);
 }
