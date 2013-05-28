Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab3E1Dz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52505 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758793Ab3E1DyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:18 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tom Zanussi" <tzanussi@gmail.com>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.617201858@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [39/94] tracing: Fix leaks of filter preds
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/trace_events_filter.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -769,7 +769,11 @@ static int filter_set_pred(struct event_
 
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

