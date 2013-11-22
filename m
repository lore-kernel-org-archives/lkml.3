Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab3KVTF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 14:05:26 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:31520 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab3KVTFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 14:05:17 -0500
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v7 4/4] qrwlock: Use smp_store_release() in write_unlock()
Date: Fri, 22 Nov 2013 14:04:47 -0500
Message-Id: <1385147087-26588-5-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1385147087-26588-1-git-send-email-Waiman.Long@hp.com>
References: <1385147087-26588-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the queue_write_unlock() function to use the
new smp_store_release() function in another pending patch. This patch
should only be merged if the other patch was merged.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/asm-generic/qrwlock.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
index 335473a..59c5972 100644
--- a/include/asm-generic/qrwlock.h
+++ b/include/asm-generic/qrwlock.h
@@ -176,9 +176,7 @@ static inline void queue_write_unlock(struct qrwlock *lock)
 	/*
 	 * Make sure that none of the critical section will be leaked out.
 	 */
-	smp_mb__before_clear_bit();
-	ACCESS_ONCE(lock->cnts.writer) = 0;
-	smp_mb__after_clear_bit();
+	smp_store_release(&lock->cnts.writer, 0)
 }
 
 /*
-- 
1.7.1

