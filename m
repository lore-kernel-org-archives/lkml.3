Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab3G3LcI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:32:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30838 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab3G3Lb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:31:56 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=2Ni0HE4liHYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=xdUSHFmPnVYA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=4K-K1uyHAAAA:8 a=20KFwNOVAAAA:8 a=WTJdmG3rAAAA:8 a=PsatnBWikvlk-PGygYQA:9 a=jeBq3FmKZ4MA:10 a=wATGTE7Z8MQA:10 a=jEp0ucaQiEUA:10 a=nsF78Xlgl7EA:10 a=aro9dyyeon38tDMO:21 a=yUl9dU2_r2zny-Bn:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130730113153.375039705@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 30 Jul 2013 07:27:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        =?UTF-8?q?J=C3=B6rn=20Engel?= <joern@logfs.org>,
        Dave Jones <davej@redhat.com>, Steve Hodgson <steve@purestorage.com>
Subject: [for-next-3.11][PATCH 8/8] ftrace: Clear module traced functions on unload module
References: <20130730112718.273490378@goodmis.org>
Content-Disposition: inline; filename=0008-ftrace-Clear-module-traced-functions-on-unload-modul.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

There's been a nasty bug that would show up and not give much info.
The bug displayed the following warning:

 WARNING: at kernel/trace/ftrace.c:1529 __ftrace_hash_rec_update+0x1e3/0x230()
 Pid: 20903, comm: bash Tainted: G           O 3.6.11+ #38405.trunk
 Call Trace:
  [<ffffffff8103e5ff>] warn_slowpath_common+0x7f/0xc0
  [<ffffffff8103e65a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff810c2ee3>] __ftrace_hash_rec_update+0x1e3/0x230
  [<ffffffff810c4f28>] ftrace_hash_move+0x28/0x1d0
  [<ffffffff811401cc>] ? kfree+0x2c/0x110
  [<ffffffff810c68ee>] ftrace_regex_release+0x8e/0x150
  [<ffffffff81149f1e>] __fput+0xae/0x220
  [<ffffffff8114a09e>] ____fput+0xe/0x10
  [<ffffffff8105fa22>] task_work_run+0x72/0x90
  [<ffffffff810028ec>] do_notify_resume+0x6c/0xc0
  [<ffffffff8126596e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
  [<ffffffff815c0f88>] int_signal+0x12/0x17
 ---[ end trace 793179526ee09b2c ]---

It was finally narrowed down to unloading a module that was being traced.

It was actually more than that. When functions are being traced, there's
a table of all functions that have a ref count of the number of active
tracers attached to that function. When a function trace callback is
registered to a function, the function's record ref count is incremented.
When it is unregistered, the function's record ref count is decremented.
If an inconsistency is detected (ref count goes below zero) the above
warning is shown and the function tracing is permanently disabled until
reboot.

When a module is unloaded, it frees the function records that represent
the module functions. These records exist on their own pages, that is
function records for one module will not exist on the same page as
function records for other modules or even the core kernel.

Now, when a callback is registered to a function, it holds a "hash" of
function addresses that it traces. When it unregisters, the hash is
examined and any record that exists in the hash will decrement the
functions record's ref count. Hashes that point to a module function
that was freed are simply ignored.

But what happens if the trace is still going on and you reload the same
module. If the module is allocated in the same location, the hashes
of the registered functions will still be mapped to the module functions
(if it was tracing the module function). The problem is that the module
would allocate new function record tables with their ref counts as zero.
When a callback is unregistered, if the hash matches the function record
of a reloaded module, it will dec the ref count, but as it was zero it
would trigger the above warning and disable function tracing.

With the help of Steve and Joern, we found a reproducer:

 Using uinput module and uinput_release function.

 modprobe uinput
 echo uinput_release > /sys/kernel/debug/tracing/set_ftrace_filter
 rmmod uinput
 modprobe uinput
 // check /proc/modules to see if loaded in same addr, otherwise try again
 echo > /sys/kernel/debug/tracing/set_ftrace_filter

 [BOOM]

The solution here is on module unload, look at all the registered funtion
callbacks and remove any hash entry that points to any function in the
module that is about to be removed.

Link: http://lkml.kernel.org/r/CADHUQJ58icP+d3QTXheiCnZwu6hrAqG2heMhhcuQvghXavHRFw@mail.gmail.com

Reported-by: Jörn Engel <joern@logfs.org>
Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Steve Hodgson <steve@purestorage.com>
Tested-by: Steve Hodgson <steve@purestorage.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 92d3334..6de8cbd 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4061,6 +4061,63 @@ static int ftrace_process_locs(struct module *mod,
 
 #ifdef CONFIG_MODULES
 
+/*
+ * If the filter is cleared, then all functions may end up being
+ * traced. We need to pass that information down to update the
+ * records.
+ */
+static bool remove_rec_entry(struct ftrace_hash *hash, struct dyn_ftrace *rec)
+{
+	struct ftrace_func_entry *entry;
+
+	entry = ftrace_lookup_ip(hash, rec->ip);
+	if (!entry)
+		return false;
+
+	free_hash_entry(hash, entry);
+
+	/* If we cleared the hash, then we now trace all functions */
+	return ftrace_hash_empty(hash);
+}
+
+static void clear_recs(struct ftrace_ops *ops, struct ftrace_page *pg)
+{
+	struct dyn_ftrace *rec;
+	bool update = false;
+	int i;
+
+	for (i = 0; i < pg->index; i++) {
+		rec = &pg->records[i];
+
+		/* If the filter hash gets cleared, we trace all functions */
+		if (remove_rec_entry(ops->filter_hash, rec))
+			update = true;
+		remove_rec_entry(ops->notrace_hash, rec);
+	}
+
+	if (update) {
+		ftrace_hash_rec_enable(ops, 1);
+		if (ftrace_enabled)
+			ftrace_run_update_code(FTRACE_UPDATE_CALLS);
+	}
+}
+
+static bool ops_has_filter(struct ftrace_ops *ops)
+{
+	return !ftrace_hash_empty(ops->filter_hash) ||
+		!ftrace_hash_empty(ops->notrace_hash);
+}
+
+static void clear_hashes(struct ftrace_page *pg)
+{
+	struct ftrace_ops *ops;
+
+	for (ops = ftrace_ops_list; ops != &ftrace_list_end; ops = ops->next) {
+		if ((ops->flags & FTRACE_OPS_FL_ENABLED) && ops_has_filter(ops))
+			clear_recs(ops, pg);
+	}
+}
+
 #define next_to_ftrace_page(p) container_of(p, struct ftrace_page, next)
 
 void ftrace_release_mod(struct module *mod)
@@ -4094,6 +4151,9 @@ void ftrace_release_mod(struct module *mod)
 			if (pg == ftrace_pages)
 				ftrace_pages = next_to_ftrace_page(last_pg);
 
+			/* Make sure no hashes reference this module record */
+			clear_hashes(pg);
+
 			*last_pg = pg->next;
 			order = get_count_order(pg->size / ENTRIES_PER_PAGE);
 			free_pages((unsigned long)pg->records, order);
-- 
1.7.10.4


