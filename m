Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbaJCFad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:30:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60953 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaJCFa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:30:29 -0400
Date: Thu, 2 Oct 2014 22:29:20 -0700
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-debfab74e453f079cd8b12b0604387a8c510ef3a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, peter@hurleysoftware.com,
        jason.low2@hp.com, dbueso@suse.de, chegu_vinod@hp.com,
        tglx@linutronix.de, aswin@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tim.c.chen@linux.intel.com, jason.low2@hp.com,
        peter@hurleysoftware.com, dbueso@suse.de, chegu_vinod@hp.com,
        tglx@linutronix.de, aswin@hp.com
In-Reply-To: <1410913017.2447.22.camel@j-VirtualBox>
References: <1410913017.2447.22.camel@j-VirtualBox>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/rwsem:
  Avoid double checking before try acquiring write lock
Git-Commit-ID: debfab74e453f079cd8b12b0604387a8c510ef3a
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

Commit-ID:  debfab74e453f079cd8b12b0604387a8c510ef3a
Gitweb:     http://git.kernel.org/tip/debfab74e453f079cd8b12b0604387a8c510ef3a
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Tue, 16 Sep 2014 17:16:57 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 3 Oct 2014 06:09:29 +0200

locking/rwsem: Avoid double checking before try acquiring write lock

Commit 9b0fc9c09f1b ("rwsem: skip initial trylock in rwsem_down_write_failed")
checks for if there are known active lockers in order to avoid write trylocking
using expensive cmpxchg() when it likely wouldn't get the lock.

However, a subsequent patch was added such that we directly
check for sem->count == RWSEM_WAITING_BIAS right before trying
that cmpxchg().

Thus, commit 9b0fc9c09f1b now just adds overhead.

This patch modifies it so that we only do a check for if
count == RWSEM_WAITING_BIAS.

Also, add a comment on why we do an "extra check" of count
before the cmpxchg().

Signed-off-by: Jason Low <jason.low2@hp.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1410913017.2447.22.camel@j-VirtualBox
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/rwsem-xadd.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
index 12166ec..7628c3f 100644
--- a/kernel/locking/rwsem-xadd.c
+++ b/kernel/locking/rwsem-xadd.c
@@ -250,16 +250,18 @@ EXPORT_SYMBOL(rwsem_down_read_failed);
 
 static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
 {
-	if (!(count & RWSEM_ACTIVE_MASK)) {
-		/* try acquiring the write lock */
-		if (sem->count == RWSEM_WAITING_BIAS &&
-		    cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
-			    RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
-			if (!list_is_singular(&sem->wait_list))
-				rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
-			return true;
-		}
+	/*
+	 * Try acquiring the write lock. Check count first in order
+	 * to reduce unnecessary expensive cmpxchg() operations.
+	 */
+	if (count == RWSEM_WAITING_BIAS &&
+	    cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
+		    RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
+		if (!list_is_singular(&sem->wait_list))
+			rwsem_atomic_update(RWSEM_WAITING_BIAS, sem);
+		return true;
 	}
+
 	return false;
 }
 
