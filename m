Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbaEIJOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:14:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40921 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbaEIJOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:14:30 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [RFC PATCH 07/11] printk: right ordering of the cont buffers from NMI context
Date: Fri,  9 May 2014 11:11:01 +0200
Message-Id: <1399626665-29817-8-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the NMI log buffer, continuous messages were sometimes mixed
after merging to the main log buffer.

The problems are solved by the following two tricks. First, continuous messages
are always put into the NMI log buffer if it already contains something. Second,
the main cont buffer is always flushed before merging any message from the NMI
log buffer.

Note that the second part of a continuous message always has to be the first
message in the NMI log buffer. If the first part goes to the main log buffer,
we have the lock for the main log buffer and merge all previous messages.

The only drawback is that we check "nmi_cont" without having "nmi_logbuf_lock".
Well, parallel NMIs are very rare. In fact, they should not happen. In the
worst case, we crate some mess in the log.

I tested this a lot. I still see that a single line might get split into two
lines from time to time. In each case, this patch helped a lot. Especially it
fixed problems with ordering of the line parts.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 12435f3ef2d4..7c992b8f44a4 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1905,6 +1905,7 @@ static void merge_nmi_delayed_printk(void)
 	unsigned long nmi_first_id, nmi_next_id;
 	u32 old_main_next_idx;
 	u64 old_main_next_seq;
+	int main_cont_flushed = 0;
 
 	while (true) {
 		/*
@@ -1917,6 +1918,15 @@ static void merge_nmi_delayed_printk(void)
 		if (likely(nmi_merge_seq == seq_from_id(nmi_next_id)))
 			return;
 
+		/*
+		 * The main cont buffer might include the first part of the
+		 * first message from NMI context.
+		 */
+		if (unlikely(!main_cont_flushed)) {
+			cont_flush(&main_log, LOG_CONT);
+			main_cont_flushed = 1;
+		}
+
 		/* check if we lost some messages */
 		nmi_first_id = ACCESS_ONCE(nmi_log.nmi.first_id);
 		if (nmi_seq_is_invalid(nmi_merge_seq,
@@ -2030,7 +2040,12 @@ asmlinkage int vprintk_emit(int facility, int level,
 	if (likely(!in_nmi())) {
 		raw_spin_lock(&main_logbuf_lock);
 	} else {
-		if (!raw_spin_trylock(&main_logbuf_lock)) {
+		/*
+		 * Always use NMI ring buffer if something is already
+		 * in the cont buffer.
+		 */
+		if ((nmi_cont.len && nmi_cont.owner == current) ||
+		    !raw_spin_trylock(&main_logbuf_lock)) {
 			if (!nmi_log.buf) {
 				lockdep_on();
 				local_irq_restore(flags);
-- 
1.8.4

