Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934108Ab3E1N0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:26:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50464 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933926Ab3E1N0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:26:38 -0400
Date: Tue, 28 May 2013 06:25:51 -0700
From: "tip-bot for Michael S. Tsirkin" <tipbot@zytor.com>
Message-ID: <tip-114276ac0a3beb9c391a410349bd770653e185ce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, mst@redhat.com,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mst@redhat.com, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <1369577426-26721-10-git-send-email-mst@redhat.com>
References: <1369577426-26721-10-git-send-email-mst@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/mm] mm, sched:
  Drop voluntary schedule from might_fault()
Git-Commit-ID: 114276ac0a3beb9c391a410349bd770653e185ce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  114276ac0a3beb9c391a410349bd770653e185ce
Gitweb:     http://git.kernel.org/tip/114276ac0a3beb9c391a410349bd770653e185ce
Author:     Michael S. Tsirkin <mst@redhat.com>
AuthorDate: Sun, 26 May 2013 17:32:13 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:41:11 +0200

mm, sched: Drop voluntary schedule from might_fault()

might_fault() is called from functions like copy_to_user()
which most callers expect to be very fast, like a couple of
instructions.

So functions like memcpy_toiovec() call them many times in a loop.

But might_fault() calls might_sleep() and with CONFIG_PREEMPT_VOLUNTARY
this results in a function call.

Let's not do this - just call __might_sleep() that produces
a diagnostic for sleep within atomic, but drop
might_preempt().

Here's a test sending traffic between the VM and the host,
host is built with CONFIG_PREEMPT_VOLUNTARY:

 before:
	incoming: 7122.77   Mb/s
	outgoing: 8480.37   Mb/s

 after:
	incoming: 8619.24   Mb/s
	outgoing: 9455.42   Mb/s

As a side effect, this fixes an issue pointed
out by Ingo: might_fault might schedule differently
depending on PROVE_LOCKING. Now there's no
preemption point in both cases, so it's consistent.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1369577426-26721-10-git-send-email-mst@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/kernel.h | 2 +-
 mm/memory.c            | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index e9ef6d6..24719ea 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -198,7 +198,7 @@ void might_fault(void);
 #else
 static inline void might_fault(void)
 {
-	might_sleep();
+	__might_sleep(__FILE__, __LINE__, 0);
 }
 #endif
 
diff --git a/mm/memory.c b/mm/memory.c
index 6dc1882..c1f190f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4222,7 +4222,8 @@ void might_fault(void)
 	if (segment_eq(get_fs(), KERNEL_DS))
 		return;
 
-	might_sleep();
+	__might_sleep(__FILE__, __LINE__, 0);
+
 	/*
 	 * it would be nicer only to annotate paths which are not under
 	 * pagefault_disable, however that requires a larger audit and
