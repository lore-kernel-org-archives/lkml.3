Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaBHQSz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 11:18:55 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35073 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaBHQSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 11:18:52 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jens Axboe <jens.axboe@oracle.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 04/11] smp: Iterate functions through llist_for_each_entry_safe()
Date: Sat,  8 Feb 2014 17:18:33 +0100
Message-Id: <1391876320-25068-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1391876320-25068-1-git-send-email-fweisbec@gmail.com>
References: <1391876320-25068-1-git-send-email-fweisbec@gmail.com>
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
Cc: Jens Axboe <jens.axboe@oracle.com>
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

