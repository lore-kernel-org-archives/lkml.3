Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbaISLpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:45:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56087 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584AbaISLpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:45:34 -0400
Date: Fri, 19 Sep 2014 04:44:27 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-ef8ac06359ddf95431cf6bb04ad2b36fff562328@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mathieu.desnoyers@efficios.com, trond.myklebust@primarydata.com,
        torvalds@linux-foundation.org, peterz@infradead.org,
        sboyd@codeaurora.org, viro@zeniv.linux.org.uk, riel@redhat.com,
        john.stultz@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, torvalds@linux-foundation.org,
        trond.myklebust@primarydata.com, peterz@infradead.org,
        viro@zeniv.linux.org.uk, sboyd@codeaurora.org, john.stultz@linaro.org,
        riel@redhat.com, tglx@linutronix.de
In-Reply-To: <1410527535-9814-2-git-send-email-riel@redhat.com>
References: <1410527535-9814-2-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] seqlock:
  Add irqsave variant of read_seqbegin_or_lock()
Git-Commit-ID: ef8ac06359ddf95431cf6bb04ad2b36fff562328
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

Commit-ID:  ef8ac06359ddf95431cf6bb04ad2b36fff562328
Gitweb:     http://git.kernel.org/tip/ef8ac06359ddf95431cf6bb04ad2b36fff562328
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Fri, 12 Sep 2014 09:12:14 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:16 +0200

seqlock: Add irqsave variant of read_seqbegin_or_lock()

There are cases where read_seqbegin_or_lock() needs to block irqs,
because the seqlock in question nests inside a lock that is also
be taken from irq context.

Add read_seqbegin_or_lock_irqsave() and done_seqretry_irqrestore(), which
are almost identical to read_seqbegin_or_lock() and done_seqretry().

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: prarit@redhat.com
Cc: oleg@redhat.com
Cc: sgruszka@redhat.com
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Link: http://lkml.kernel.org/r/1410527535-9814-2-git-send-email-riel@redhat.com
[ Improved the readability of the code a bit. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/seqlock.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index cc35963..f5df8f6 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -456,4 +456,23 @@ read_sequnlock_excl_irqrestore(seqlock_t *sl, unsigned long flags)
 	spin_unlock_irqrestore(&sl->lock, flags);
 }
 
+static inline unsigned long
+read_seqbegin_or_lock_irqsave(seqlock_t *lock, int *seq)
+{
+	unsigned long flags = 0;
+
+	if (!(*seq & 1))	/* Even */
+		*seq = read_seqbegin(lock);
+	else			/* Odd */
+		read_seqlock_excl_irqsave(lock, flags);
+
+	return flags;
+}
+
+static inline void
+done_seqretry_irqrestore(seqlock_t *lock, int seq, unsigned long flags)
+{
+	if (seq & 1)
+		read_sequnlock_excl_irqrestore(lock, flags);
+}
 #endif /* __LINUX_SEQLOCK_H */
