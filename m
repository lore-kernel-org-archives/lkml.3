Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758327Ab3EQWTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:19:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab3EQVhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>
Subject: [ 036/102] tracing: Fix leaks of filter preds
Date: Fri, 17 May 2013 14:35:51 -0700
Message-Id: <20130517213248.121906563@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_events_filter.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -777,7 +777,11 @@ static int filter_set_pred(struct event_
 
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


