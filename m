Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaBXPnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:43:22 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38059 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbaBXPkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:40:15 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jens Axboe <axboe@fb.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 04/11] smp: Iterate functions through llist_for_each_entry_safe()
Date: Mon, 24 Feb 2014 16:39:55 +0100
Message-Id: <1393256402-16907-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
References: <1393256402-16907-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

The IPI function llist iteration is open coded. Lets simplify this
with using an llist iterator.

Also we want to keep the iteration safe against possible
csd.llist->next value reuse from the IPI handler. At least the block
subsystem used to do such things so lets stay careful and use
llist_for_each_entry_safe().

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jens Axboe <axboe@fb.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/smp.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index ffee35b..e3852de 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -151,7 +151,8 @@ static void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
  */
 void generic_smp_call_function_single_interrupt(void)
 {
-	struct llist_node *entry, *next;
+	struct llist_node *entry;
+	struct call_single_data *csd, *csd_next;
 
 	/*
 	 * Shouldn't receive this interrupt on a cpu that is not yet online.
@@ -161,16 +162,9 @@ void generic_smp_call_function_single_interrupt(void)
 	entry = llist_del_all(&__get_cpu_var(call_single_queue));
 	entry = llist_reverse_order(entry);
 
-	while (entry) {
-		struct call_single_data *csd;
-
-		next = entry->next;
-
-		csd = llist_entry(entry, struct call_single_data, llist);
+	llist_for_each_entry_safe(csd, csd_next, entry, llist) {
 		csd->func(csd->info);
 		csd_unlock(csd);
-
-		entry = next;
 	}
 }
 
-- 
1.8.3.1

