Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbaEIJPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:15:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbaEIJPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:15:51 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [RFC PATCH 11/11] printk: avoid staling when merging NMI log buffer
Date: Fri,  9 May 2014 11:11:05 +0200
Message-Id: <1399626665-29817-12-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New messages can appear in NMI log buffer at any time. The call merging them
into the main log buffer might have hard times to catch up with the flood. It
can be even interrupted by an NMI that adds new messages itself.

It would make sense to limit the number of copied messages and postpone
the merging to a later time and even another CPU. We could nicely reuse
the IRQ work here.

One drawback is that it might create mess when merging continuous lines
but this would be very rare. IMHO, it is not worth making the code more
complicated.

To be honest, I am not much happy with the current limit 5000 messages.
The number is sucked out of my little finger ;-) I would feel better with
some limit but I also might be too paranoid. Any better idea is welcome.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 9c97b6daccc3..26accbf2186d 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -380,6 +380,8 @@ static struct printk_log nmi_log = {
  */
 #define NMI_MAX_LEN_POWER (min(NMI_IDX_BYTES, sizeof(nmi_log.buf_len) * 8 - 1))
 #define NMI_MAX_LEN (1UL << NMI_MAX_LEN_POWER)
+/* maximum number of merged strings in one call */
+#define NMI_MAX_MERGE 5000
 
 /* maximum number of messages that fit into NMI log buffer */
 static unsigned int nmi_max_messages;
@@ -1974,6 +1976,7 @@ static void merge_nmi_delayed_printk(void)
 	u32 old_main_next_idx;
 	u64 old_main_next_seq;
 	int main_cont_flushed = 0;
+	int merged = 0;
 
 	while (true) {
 		/*
@@ -2004,6 +2007,13 @@ restart_merge:
 			nmi_merge_idx = idx_from_id(nmi_first_id);
 		}
 
+		/* do not stale CPU with too many merges */
+		if (merged++ > NMI_MAX_MERGE) {
+			__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
+			irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+			return;
+		}
+
 		/*
 		 * Make sure that the whole message has been written for the
 		 * given idx.
-- 
1.8.4

