Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934581Ab3E1V1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:27:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59875 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934340Ab3E1V0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:26:37 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 49/78] tracing: Fix leaks of filter preds
Date: Tue, 28 May 2013 14:19:58 -0700
Message-Id: <1369776027-17859-50-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 60705c89460fdc7227f2d153b68b3f34814738a4 upstream.

Special preds are created when folding a series of preds that
can be done in serial. These are allocated in an ops field of
the pred structure. But they were never freed, causing memory
leaks.

This was discovered using the kmemleak checker:

unreferenced object 0xffff8800797fd5e0 (size 32):
  comm "swapper/0", pid 1, jiffies 4294690605 (age 104.608s)
  hex dump (first 32 bytes):
    00 00 01 00 03 00 05 00 07 00 09 00 0b 00 0d 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff814b52af>] kmemleak_alloc+0x73/0x98
    [<ffffffff8111ff84>] kmemleak_alloc_recursive.constprop.42+0x16/0x18
    [<ffffffff81120e68>] __kmalloc+0xd7/0x125
    [<ffffffff810d47eb>] kcalloc.constprop.24+0x2d/0x2f
    [<ffffffff810d4896>] fold_pred_tree_cb+0xa9/0xf4
    [<ffffffff810d3781>] walk_pred_tree+0x47/0xcc
    [<ffffffff810d5030>] replace_preds.isra.20+0x6f8/0x72f
    [<ffffffff810d50b5>] create_filter+0x4e/0x8b
    [<ffffffff81b1c30d>] ftrace_test_event_filter+0x5a/0x155
    [<ffffffff8100028d>] do_one_initcall+0xa0/0x137
    [<ffffffff81afbedf>] kernel_init_freeable+0x14d/0x1dc
    [<ffffffff814b24b7>] kernel_init+0xe/0xdb
    [<ffffffff814d539c>] ret_from_fork+0x7c/0xb0
    [<ffffffffffffffff>] 0xffffffffffffffff

Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/trace/trace_events_filter.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index e5b0ca8..5a8a53e 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -777,7 +777,11 @@ static int filter_set_pred(struct event_filter *filter,
 
 static void __free_preds(struct event_filter *filter)
 {
+	int i;
+
 	if (filter->preds) {
+		for (i = 0; i < filter->n_preds; i++)
+			kfree(filter->preds[i].ops);
 		kfree(filter->preds);
 		filter->preds = NULL;
 	}
-- 
1.8.1.2

