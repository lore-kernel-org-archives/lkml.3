Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3BURsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:48:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42958 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab3BURsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:48:21 -0500
Date: Thu, 21 Feb 2013 09:46:13 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-1ba476a0c9bd0907fa31a74d47e9f4f84b404690@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linuxfoundation.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, tglx@linutronix.de
Reply-To: paulmck@linux.vnet.ibm.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        torvalds@linuxfoundation.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.02.1302202155320.22263@ionos>
References: <alpine.LFD.2.02.1302202155320.22263@ionos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] irq: Sanitize invoke_softirq
Git-Commit-ID: 1ba476a0c9bd0907fa31a74d47e9f4f84b404690
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Feb 2013 09:46:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ba476a0c9bd0907fa31a74d47e9f4f84b404690
Gitweb:     http://git.kernel.org/tip/1ba476a0c9bd0907fa31a74d47e9f4f84b404690
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 21 Feb 2013 18:17:42 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 21 Feb 2013 18:32:45 +0100

irq: Sanitize invoke_softirq

With the irq protection in irq_exit, we can remove the #ifdeffery and
the bh_disable/enable dance in invoke_softirq()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1302202155320.22263@ionos

---
 kernel/softirq.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index d1f7943..aebc590 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -322,18 +322,10 @@ void irq_enter(void)
 
 static inline void invoke_softirq(void)
 {
-	if (!force_irqthreads) {
-#ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
+	if (!force_irqthreads)
 		__do_softirq();
-#else
-		do_softirq();
-#endif
-	} else {
-		__local_bh_disable((unsigned long)__builtin_return_address(0),
-				SOFTIRQ_OFFSET);
+	else
 		wakeup_softirqd();
-		__local_bh_enable(SOFTIRQ_OFFSET);
-	}
 }
 
 /*
