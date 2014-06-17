Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbaFQLFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:05:00 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52239 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaFQLE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:04:57 -0400
Subject: [PATCH -tip v2 2/3] ftrace,
 kprobes: Support IPMODIFY flag to find IP modify conflict
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 17 Jun 2014 11:04:49 +0000
Message-ID: <20140617110449.15167.45320.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140617110436.15167.7179.stgit@kbuild-fedora.novalocal>
References: <20140617110436.15167.7179.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce FTRACE_OPS_FL_IPMODIFY to avoid conflict among
ftrace users who may modify regs->ip to change the execution
path. This also adds the flag to kprobe_ftrace_ops, since
ftrace-based kprobes already modifies regs->ip. Thus, if
another user modifies the regs->ip on the same function entry,
one of them will be broken. So both should add IPMODIFY flag
and make sure that ftrace_set_filter_ip() succeeds.

Note that currently conflicts of IPMODIFY are detected on the
filter hash. It does NOT care about the notrace hash. This means
that if you set filter hash all functions and notrace(mask)
some of them, the IPMODIFY flag will be applied to all
functions.

Changes in v2:
 - Add a description how __ftrace_hash_update_ipmodify() will
   handle the given hashes (NULL and EMPTY_HASH cases).
 - Clear FTRACE_OPS_FL_ENABLED after calling
   __unregister_ftrace_function() in error path.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 Documentation/trace/ftrace.txt |    5 ++
 include/linux/ftrace.h         |   10 ++-
 kernel/kprobes.c               |    2 -
 kernel/trace/ftrace.c          |  133 +++++++++++++++++++++++++++++++++++++++-
 4 files changed, 145 insertions(+), 5 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 2479b2a..0fcad7d 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -234,6 +234,11 @@ of ftrace. Here is a list of some of the key files:
 	will be displayed on the same line as the function that
 	is returning registers.
 
+	If the callback registered to be traced by a function with
+	the "ip modify" attribute (thus the regs->ip can be changed),
+	a 'I' will be displayed on the same line as the function that
+	can be overridden.
+
   function_profile_enabled:
 
 	When set it will enable all functions with either the function
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 404a686..5a43f8f 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -90,6 +90,9 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
  * INITIALIZED - The ftrace_ops has already been initialized (first use time
  *            register_ftrace_function() is called, it will initialized the ops)
  * DELETED - The ops are being deleted, do not let them be registered again.
+ * IPMODIFY - The ops can modify IP register. This must be set with SAVE_REGS
+ *            and if the other ops has been set this on same function, filter
+ *            update must be failed.
  */
 enum {
 	FTRACE_OPS_FL_ENABLED			= 1 << 0,
@@ -101,6 +104,7 @@ enum {
 	FTRACE_OPS_FL_STUB			= 1 << 6,
 	FTRACE_OPS_FL_INITIALIZED		= 1 << 7,
 	FTRACE_OPS_FL_DELETED			= 1 << 8,
+	FTRACE_OPS_FL_IPMODIFY			= 1 << 9,
 };
 
 /*
@@ -306,6 +310,7 @@ extern int ftrace_nr_registered_ops(void);
  * the dyn_ftrace descriptor represents.
  *
  * The second part is a mask:
+ *  IPMODIFY - the record wants to change IP address.
  *  ENABLED - the function is being traced
  *  REGS    - the record wants the function to save regs
  *  REGS_EN - the function is set up to save regs.
@@ -317,13 +322,14 @@ extern int ftrace_nr_registered_ops(void);
  * from tracing that function.
  */
 enum {
+	FTRACE_FL_IPMODIFY	= (1UL << 28),
 	FTRACE_FL_ENABLED	= (1UL << 29),
 	FTRACE_FL_REGS		= (1UL << 30),
 	FTRACE_FL_REGS_EN	= (1UL << 31)
 };
 
-#define FTRACE_FL_MASK		(0x7UL << 29)
-#define FTRACE_REF_MAX		((1UL << 29) - 1)
+#define FTRACE_FL_MASK		(0xfUL << 28)
+#define FTRACE_REF_MAX		((1UL << 28) - 1)
 
 struct dyn_ftrace {
 	unsigned long		ip; /* address of mcount call-site */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3214289..e52d86f 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -915,7 +915,7 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 #ifdef CONFIG_KPROBES_ON_FTRACE
 static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
 	.func = kprobe_ftrace_handler,
-	.flags = FTRACE_OPS_FL_SAVE_REGS,
+	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_IPMODIFY,
 };
 static int kprobe_ftrace_enabled;
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d65719d..5e09f39 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1293,6 +1293,9 @@ ftrace_hash_rec_disable(struct ftrace_ops *ops, int filter_hash);
 static void
 ftrace_hash_rec_enable(struct ftrace_ops *ops, int filter_hash);
 
+static int ftrace_hash_ipmodify_update(struct ftrace_ops *ops,
+				       struct ftrace_hash *new_hash);
+
 static int
 ftrace_hash_move(struct ftrace_ops *ops, int enable,
 		 struct ftrace_hash **dst, struct ftrace_hash *src)
@@ -1304,6 +1307,7 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	struct ftrace_hash *new_hash;
 	int size = src->count;
 	int bits = 0;
+	int ret;
 	int i;
 
 	/*
@@ -1339,6 +1343,16 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	}
 
 update:
+	/* Before everything, make sure this can be applied */
+	if (enable) {
+		/* IPMODIFY should be updated only when filter_hash updating */
+		ret = ftrace_hash_ipmodify_update(ops, new_hash);
+		if (ret < 0) {
+			free_ftrace_hash(new_hash);
+			return ret;
+		}
+	}
+
 	/*
 	 * Remove the current set, update the hash and add
 	 * them back.
@@ -1593,6 +1607,109 @@ static void ftrace_hash_rec_enable(struct ftrace_ops *ops,
 	__ftrace_hash_rec_update(ops, filter_hash, 1);
 }
 
+/*
+ * Try to update IPMODIFY flag on each ftrace_rec. Return 0 if it is OK
+ * or no-needed to update, -EBUSY if it detects a conflict of the flag
+ * on a ftrace_rec.
+ * Note that old_hash and new_hash has below meanings
+ *  - If the hash is NULL, it hits all recs
+ *  - If the hash is EMPTY_HASH, it hits nothing
+ *  - Others hits the recs which match the hash entries.
+ */
+static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
+					 struct ftrace_hash *old_hash,
+					 struct ftrace_hash *new_hash)
+{
+	struct ftrace_page *pg;
+	struct dyn_ftrace *rec, *end = NULL;
+	int in_old, in_new;
+
+	/* Only update if the ops has been registered */
+	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
+		return 0;
+
+	if (!(ops->flags & FTRACE_OPS_FL_SAVE_REGS) ||
+	    !(ops->flags & FTRACE_OPS_FL_IPMODIFY))
+		return 0;
+
+	/* Update rec->flags */
+	do_for_each_ftrace_rec(pg, rec) {
+		/* We need to update only differences of filter_hash */
+		in_old = !old_hash || ftrace_lookup_ip(old_hash, rec->ip);
+		in_new = !new_hash || ftrace_lookup_ip(new_hash, rec->ip);
+		if (in_old == in_new)
+			continue;
+
+		if (in_new) {
+			/* New entries must ensure no others are using it */
+			if (rec->flags & FTRACE_FL_IPMODIFY)
+				goto rollback;
+			rec->flags |= FTRACE_FL_IPMODIFY;
+		} else /* Removed entry */
+			rec->flags &= ~FTRACE_FL_IPMODIFY;
+	} while_for_each_ftrace_rec();
+
+	return 0;
+
+rollback:
+	end = rec;
+
+	/* Roll back what we did above */
+	do_for_each_ftrace_rec(pg, rec) {
+		if (rec == end)
+			goto err_out;
+
+		in_old = !old_hash || ftrace_lookup_ip(old_hash, rec->ip);
+		in_new = !new_hash || ftrace_lookup_ip(new_hash, rec->ip);
+		if (in_old == in_new)
+			continue;
+
+		if (in_new)
+			rec->flags &= ~FTRACE_FL_IPMODIFY;
+		else
+			rec->flags |= FTRACE_FL_IPMODIFY;
+	} while_for_each_ftrace_rec();
+
+err_out:
+	return -EBUSY;
+}
+
+static int ftrace_hash_ipmodify_enable(struct ftrace_ops *ops)
+{
+	struct ftrace_hash *hash = ops->filter_hash;
+
+	if (ftrace_hash_empty(hash))
+		hash = NULL;
+
+	return __ftrace_hash_update_ipmodify(ops, EMPTY_HASH, hash);
+}
+
+/* Disabling always succeeds */
+static void ftrace_hash_ipmodify_disable(struct ftrace_ops *ops)
+{
+	struct ftrace_hash *hash = ops->filter_hash;
+
+	if (ftrace_hash_empty(hash))
+		hash = NULL;
+
+	__ftrace_hash_update_ipmodify(ops, hash, EMPTY_HASH);
+}
+
+static int ftrace_hash_ipmodify_update(struct ftrace_ops *ops,
+				       struct ftrace_hash *new_hash)
+{
+	struct ftrace_hash *old_hash = ops->filter_hash;
+
+	if (ftrace_hash_empty(old_hash))
+		old_hash = NULL;
+
+	if (ftrace_hash_empty(new_hash))
+		new_hash = NULL;
+
+	return __ftrace_hash_update_ipmodify(ops, old_hash, new_hash);
+}
+
+
 static void print_ip_ins(const char *fmt, unsigned char *p)
 {
 	int i;
@@ -2078,6 +2195,15 @@ static int ftrace_startup(struct ftrace_ops *ops, int command)
 
 	ops->flags |= FTRACE_OPS_FL_ENABLED;
 
+	ret = ftrace_hash_ipmodify_enable(ops);
+	if (ret < 0) {
+		/* Rollback registration process */
+		__unregister_ftrace_function(ops);
+		ftrace_start_up--;
+		ops->flags &= ~FTRACE_OPS_FL_ENABLED;
+		return ret;
+	}
+
 	ftrace_hash_rec_enable(ops, 1);
 
 	ftrace_startup_enable(command);
@@ -2104,6 +2230,8 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 	 */
 	WARN_ON_ONCE(ftrace_start_up < 0);
 
+	/* Disabling ipmodify never be failed */
+	ftrace_hash_ipmodify_disable(ops);
 	ftrace_hash_rec_disable(ops, 1);
 
 	if (!global_start_up)
@@ -2641,9 +2769,10 @@ static int t_show(struct seq_file *m, void *v)
 
 	seq_printf(m, "%ps", (void *)rec->ip);
 	if (iter->flags & FTRACE_ITER_ENABLED)
-		seq_printf(m, " (%ld)%s",
+		seq_printf(m, " (%ld)%s%s",
 			   rec->flags & ~FTRACE_FL_MASK,
-			   rec->flags & FTRACE_FL_REGS ? " R" : "");
+			   rec->flags & FTRACE_FL_REGS ? " R" : "",
+			   rec->flags & FTRACE_FL_IPMODIFY ? " I" : "");
 	seq_printf(m, "\n");
 
 	return 0;


