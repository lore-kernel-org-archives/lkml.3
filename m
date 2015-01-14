Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbbANTVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:21:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39892 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbbANTVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:21:12 -0500
Date: Wed, 14 Jan 2015 11:20:32 -0800
From: tip-bot for Heiko Carstens <tipbot@zytor.com>
Message-ID: <tip-0f1ba9a2cea52896448ef4e14a4cb1880b8e5bee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hpa@zytor.com, tglx@linutronix.de, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, heiko.carstens@de.ibm.com
Reply-To: tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com
In-Reply-To: <20150107090441.GC4365@osiris>
References: <20150107090441.GC4365@osiris>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] softirq/preempt: Add missing current->
 preempt_disable_ip update
Git-Commit-ID: 0f1ba9a2cea52896448ef4e14a4cb1880b8e5bee
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

Commit-ID:  0f1ba9a2cea52896448ef4e14a4cb1880b8e5bee
Gitweb:     http://git.kernel.org/tip/0f1ba9a2cea52896448ef4e14a4cb1880b8e5bee
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Wed, 7 Jan 2015 10:04:41 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 14 Jan 2015 15:16:21 +0100

softirq/preempt: Add missing current->preempt_disable_ip update

While debugging some "sleeping function called from invalid context" bug I
realized that the debugging message "Preemption disabled at:" pointed to
an incorrect function.

In particular if the last function/action that disabled preemption was
spin_lock_bh() then current->preempt_disable_ip won't be updated.

The reason for this is that __local_bh_disable_ip() will increase
preempt_count manually instead of calling preempt_count_add(), which
would handle the update correctly.

It look like the manual handling was done to work around some lockdep issue.

So add the missing update of current->preempt_disable_ip to
__local_bh_disable_ip() as well.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20150107090441.GC4365@osiris
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/softirq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 501baa9..b9ae816 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -114,8 +114,12 @@ void __local_bh_disable_ip(unsigned long ip, unsigned int cnt)
 		trace_softirqs_off(ip);
 	raw_local_irq_restore(flags);
 
-	if (preempt_count() == cnt)
+	if (preempt_count() == cnt) {
+#ifdef CONFIG_DEBUG_PREEMPT
+		current->preempt_disable_ip = get_parent_ip(CALLER_ADDR1);
+#endif
 		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
+	}
 }
 EXPORT_SYMBOL(__local_bh_disable_ip);
 #endif /* CONFIG_TRACE_IRQFLAGS */
