Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbaEIJOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:14:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbaEIJOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:14:50 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [RFC PATCH 08/11] printk: try hard to print Oops message in NMI context
Date: Fri,  9 May 2014 11:11:02 +0200
Message-Id: <1399626665-29817-9-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops messages are important for debugging. We should try harder to get them into
the main ring buffer and print them to the console. This is problematic in NMI
context because the needed locks might already be taken.

What we can do, though, is to zap all printk locks. We already do this
when a printk recursion is detected. This should be safe because the system
is crashing and there shouldn't be any printk caller by now. In case somebody
manages to grab the logbuf_lock after zap_locks then we just fallback to the
NMI ring buffer and hope that someone else will merge the messages strings and
flush the buffer.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 7c992b8f44a4..cc6e77f6d72b 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2036,16 +2036,26 @@ asmlinkage int vprintk_emit(int facility, int level,
 	 * when we managed to preempt the currently running printk from NMI
 	 * context. When we are not sure, rather copy the current message
 	 * into NMI ring buffer and merge it later.
+	 *
+	 * Special case are Oops messages from NMI context. We try hard to print
+	 * them. So we forcefully drop existing locks, try to pass them via the
+	 * main log buffer, and even later push them to the console.
 	 */
 	if (likely(!in_nmi())) {
 		raw_spin_lock(&main_logbuf_lock);
 	} else {
 		/*
 		 * Always use NMI ring buffer if something is already
-		 * in the cont buffer.
+		 * in the cont buffer, except for Oops.
 		 */
-		if ((nmi_cont.len && nmi_cont.owner == current) ||
-		    !raw_spin_trylock(&main_logbuf_lock)) {
+		bool force_nmi_logbuf = nmi_cont.len &&
+			nmi_cont.owner == current &&
+			!oops_in_progress;
+
+		if (oops_in_progress)
+			zap_locks();
+
+		if (force_nmi_logbuf || !raw_spin_trylock(&main_logbuf_lock)) {
 			if (!nmi_log.buf) {
 				lockdep_on();
 				local_irq_restore(flags);
@@ -2178,8 +2188,12 @@ asmlinkage int vprintk_emit(int facility, int level,
 	/*
 	 * If called from the scheduler or NMI context, we can not get console
 	 * without a possible deadlock.
+	 *
+	 * The only exception are Oops messages from NMI context where all
+	 * relevant locks have been forcefully dropped above. We have to try
+	 * to get the console, otherwise the last messages would get lost.
 	 */
-	if (in_sched || in_nmi())
+	if (in_sched || (in_nmi() && !oops_in_progress))
 		return printed_len;
 
 	/*
-- 
1.8.4

