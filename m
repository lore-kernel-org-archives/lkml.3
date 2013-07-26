Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab3GZDXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 23:23:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25124 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab3GZDXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 23:23:22 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=_6S4gJz81GoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=UirpL7NoV14A:10 a=n7wth9FETl1aMdHGFu8A:9 a=QEXdDO2ut3YA:10 a=--p0SGYcLhAI-fe4:21 a=knc-3tx5Mif3Vh5B:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374808998.6580.12.camel@gandalf.local.home>
Subject: Re: __ftrace_hash_rec_update FTRACE_WARN_ON.
From: Steven Rostedt <rostedt@goodmis.org>
To: Steve Hodgson <steve@purestorage.com>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Date: Thu, 25 Jul 2013 23:23:18 -0400
In-Reply-To: <1374778741.3356.181.camel@gandalf.local.home>
References: <20130705142629.GA325@redhat.com>
	 <1373036034.22688.155.camel@gandalf.local.home>
	 <20130724160422.GA3641@logfs.org>
	 <1374715444.3356.163.camel@gandalf.local.home>
	 <CADHUQJ4yweA4zNKqtsq=iQkX+o6UmA-dwWV1d-0SdJbpGtZR5A@mail.gmail.com>
	 <1374778741.3356.181.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 14:59 -0400, Steven Rostedt wrote:

> Now that I know what's the problem, it shouldn't be too hard to fix.

It was a bit more involved to fix than I expected. I don't like the fact
that if you filter on only module functions and remove that module, you
now remove the filter and it traces all functions. Oh well, that's the
side effect of removing modules that you are only tracing. If you trace
something other than the module you filter on, it will on remove the
functions that belong to the module but keep the other functions.

So, removing the module, is basically the same as doing:

 echo '!:mod:<module>' > set_ftrace_filter

and acts the same, almost. It only affects the filter if the function
trace is currently active. Otherwise it doesn't remove the functions
from the filter, as it only removes functions from active filters. This
is because ftrace is only aware of filters that are activated. I also
added code (set for a separate patch, but combined for this email) that
will add a 64 bit ref counter. Every time a module removes functions
from ftrace, the counter is incremented. If a filter is activated it has
its ref number checked with the current number. If it is different, then
it tests all the functions in its filter to see if any should be removed
(no longer exists).

The reason for the warning, was that we enable the function and it was
mapped in the filter. When we removed the module, we removed its
functions from the table that keeps track of functions being traced (low
level tracking, below filters). But we never cleared the filter. When
the module was added again, it was put back into the same location,
where the filter matched the address, but the low level table had the
function disabled, and the filter said it was enabled. When an update
was made, this discrepancy appeared and caused issues.

You can try this patch to see if it fixes your issues. There may be some
fuzz to apply it because I added it on top of my current queue that
needs to go out for 3.11.

-- Steve

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9f15c00..3e6ed8f 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -114,6 +114,7 @@ struct ftrace_ops {
 	struct ftrace_hash		*notrace_hash;
 	struct ftrace_hash		*filter_hash;
 	struct mutex			regex_lock;
+	u64				mod_cnt;
 #endif
 };
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 92d3334..366f524 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -93,6 +93,9 @@ struct ftrace_pid {
 	struct pid *pid;
 };
 
+/* Keep track of modules unloading and ops updating filters */
+static u64 mod_ref_cnt;
+
 /*
  * ftrace_disabled is set when an anomaly is discovered.
  * ftrace_disabled is much stronger than ftrace_enabled.
@@ -321,6 +324,18 @@ static void add_ftrace_ops(struct ftrace_ops **list, struct ftrace_ops *ops)
 	rcu_assign_pointer(*list, ops);
 }
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+static void verify_ops(struct ftrace_ops *ops);
+#else
+static inline void verify_ops(struct ftrace_ops *ops) { }
+#endif
+
+static void add_main_ftrace_ops(struct ftrace_ops *ops)
+{
+	verify_ops(ops);
+	add_ftrace_ops(&ftrace_ops_list, ops);
+}
+
 static int remove_ftrace_ops(struct ftrace_ops **list, struct ftrace_ops *ops)
 {
 	struct ftrace_ops **p;
@@ -352,7 +367,7 @@ static void add_ftrace_list_ops(struct ftrace_ops **list,
 	int first = *list == &ftrace_list_end;
 	add_ftrace_ops(list, ops);
 	if (first)
-		add_ftrace_ops(&ftrace_ops_list, main_ops);
+		add_main_ftrace_ops(main_ops);
 }
 
 static int remove_ftrace_list_ops(struct ftrace_ops **list,
@@ -405,7 +420,7 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 			return -ENOMEM;
 		add_ftrace_list_ops(&ftrace_control_list, &control_ops, ops);
 	} else
-		add_ftrace_ops(&ftrace_ops_list, ops);
+		add_main_ftrace_ops(ops);
 
 	if (ftrace_enabled)
 		update_ftrace_function();
@@ -1351,6 +1366,38 @@ alloc_and_copy_ftrace_hash(int size_bits, struct ftrace_hash *hash)
 	return NULL;
 }
 
+static void verify_ops(struct ftrace_ops *ops)
+{
+	struct ftrace_hash *hash;
+	struct hlist_node *tn;
+	struct ftrace_func_entry *entry;
+	int size;
+	int i;
+
+	/*
+	 * If a module was removed, we may need to verify
+	 * the filters of this ops.
+	 */
+	if (ops->mod_cnt == mod_ref_cnt)
+		return;
+
+	/* We only need to verify the filter that may enable ops */
+	hash = ops->filter_hash;
+	if (ftrace_hash_empty(hash))
+		return;
+
+	size = 1 << hash->size_bits;
+	for (i = 0; i < size; i++) {
+		hlist_for_each_entry_safe(entry, tn, &hash->buckets[i], hlist) {
+			if (!ftrace_location(entry->ip))
+				free_hash_entry(hash, entry);
+		}
+	}
+
+	/* This ops is now verified. */
+	ops->mod_cnt = mod_ref_cnt;
+}
+
 static void
 ftrace_hash_rec_disable(struct ftrace_ops *ops, int filter_hash);
 static void
@@ -4061,6 +4108,66 @@ static int ftrace_process_locs(struct module *mod,
 
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
+	/* This ops is registered and is cleared here */
+	ops->mod_cnt = mod_ref_cnt;
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
@@ -4068,6 +4175,7 @@ void ftrace_release_mod(struct module *mod)
 	struct dyn_ftrace *rec;
 	struct ftrace_page **last_pg;
 	struct ftrace_page *pg;
+	bool update_ref = true;
 	int order;
 
 	mutex_lock(&ftrace_lock);
@@ -4090,10 +4198,23 @@ void ftrace_release_mod(struct module *mod)
 			if (WARN_ON(pg == ftrace_pages_start))
 				goto out_unlock;
 
+			/*
+			 * A module is removing records from ftrace.
+			 * Any ops not currently registered need to be 
+			 * verified before they get registered.
+			 */
+			if (update_ref) {
+				mod_ref_cnt++;
+				update_ref = false;
+			}
+
 			/* Check if we are deleting the last page */
 			if (pg == ftrace_pages)
 				ftrace_pages = next_to_ftrace_page(last_pg);
 
+			/* Make sure no hashes reference this module record */
+			clear_hashes(pg);
+
 			*last_pg = pg->next;
 			order = get_count_order(pg->size / ENTRIES_PER_PAGE);
 			free_pages((unsigned long)pg->records, order);


