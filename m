Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbbAGJEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:04:54 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:53295 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbbAGJEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:04:46 -0500
Date: Wed, 7 Jan 2015 10:04:41 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH/resend] softirq/preempt: add missing
 current->preempt_disable_ip update
Message-ID: <20150107090441.GC4365@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010709-0041-0000-0000-000002C5EB9E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/softirq.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 501baa9ac1be..edd51027e3ab 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -114,8 +114,13 @@ void __local_bh_disable_ip(unsigned long ip, unsigned int cnt)
 		trace_softirqs_off(ip);
 	raw_local_irq_restore(flags);
 
-	if (preempt_count() == cnt)
-		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
+	if (preempt_count() == cnt) {
+		unsigned long ip = get_parent_ip(CALLER_ADDR1);
+#ifdef CONFIG_DEBUG_PREEMPT
+		current->preempt_disable_ip = ip;
+#endif
+		trace_preempt_off(CALLER_ADDR0, ip);
+	}
 }
 EXPORT_SYMBOL(__local_bh_disable_ip);
 #endif /* CONFIG_TRACE_IRQFLAGS */
-- 
1.8.5.5

