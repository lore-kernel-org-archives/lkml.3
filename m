Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab3JDHvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 03:51:45 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:38983 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3JDHvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 03:51:44 -0400
Date: Fri, 4 Oct 2013 09:51:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] irq fix
Message-ID: <20131004075140.GA13294@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

   HEAD: 0d119fb57614fe947aa9048f61d680bbede64170 Merge branch 'irq/urgent-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks into irq/urgent

Frederic's minimal fix for hardirq/softirq nesting crashes.

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (1):
      irq: Force hardirq exit's softirq processing on its own stack


 kernel/softirq.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 53cc09c..d7d498d 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -328,10 +328,19 @@ void irq_enter(void)
 
 static inline void invoke_softirq(void)
 {
-	if (!force_irqthreads)
-		__do_softirq();
-	else
+	if (!force_irqthreads) {
+		/*
+		 * We can safely execute softirq on the current stack if
+		 * it is the irq stack, because it should be near empty
+		 * at this stage. But we have no way to know if the arch
+		 * calls irq_exit() on the irq stack. So call softirq
+		 * in its own stack to prevent from any overrun on top
+		 * of a potentially deep task stack.
+		 */
+		do_softirq();
+	} else {
 		wakeup_softirqd();
+	}
 }
 
 static inline void tick_irq_exit(void)
