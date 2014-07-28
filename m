Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaG1FWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 01:22:43 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:59894 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaG1FWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 01:22:38 -0400
Subject: [PATCH ftrace/core v4 2/4] ftrace,
 kprobes: Support IPMODIFY flag to find IP modify conflict
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 28 Jul 2014 05:22:29 +0000
Message-ID: <20140728052229.29491.71944.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140728052215.29491.23631.stgit@kbuild-fedora.novalocal>
References: <20140728052215.29491.23631.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce FTRACE_OPS_FL_IPMODIFY to avoid conflict among
ftrace users who may modify regs->ip to change the execution
path. If two or more users modify the regs->ip on the same
function entry, one of them will be broken. So they must add
IPMODIFY flag and make sure that ftrace_set_filter_ip() succeeds.

Note that ftrace doesn't allow ftrace_ops which has IPMODIFY
flag to have notrace hash, and the ftrace_ops must have a
filter hash (so that the ftrace_ops can hook only specific
entries), because it strongly depends on the address and
must be allowed for only few selected functions.

Changes in v4:
 - Split kprobe's part from this patch.
 - Add no-notrace hash check.
 - Reject if the filter_hash is empty. Since IPMODIFY action
   is very address sensitive, empty hash (means hooking all
   functions) must not be allowed.

Changes in v3:
 - Update for the latest ftrace/core.
 - Add a comment about FTRACE_OPS_FL_* attribute flags.
 - Don't check FTRACE_OPS_FL_SAVE_REGS in
   __ftrace_hash_update_ipmodify().
 - Fix comments.

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
 Documentation/trace/ftrace.txt |    5 +
 include/linux/ftrace.h         |   16 ++++
 kernel/trace/ftrace.c          |  143 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 160 insertions(+), 4 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 2479b2a..aa7e5bd 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -234,6 +234,11 @@ of ftrace. Here is a list of some of the key files:
 	will be displayed on the same line as the function that
 	is returning registers.
 
+	If the callback registered to be traced by a function with
+	the "ip modify" attribute (thus the regs->ip can be changed),
+	an 'I' will be displayed on the same line as the function that
+	can be overridden.
+
   function_profile_enabled:
 
 	When set it will enable all functions with either the function
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 6bb5e3f..905ec9f 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -59,6 +59,11 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
 /*
  * FTRACE_OPS_FL_* bits denote the state of ftrace_ops struct and are
  * set in the flags member.
+ * CONTROL, SAVE_REGS, SAVE_REGS_IF_SUPPORTED, RECURSION_SAFE, STUB and
+ * IPMODIFY are a kind of attribute flags which can be set only before
+ * registering the ftrace_ops, and can not be modified while registered.
+ * Changing those attribute flags after regsitering ftrace_ops will
+ * cause unexpected results.
  *
  * ENABLED - set/unset when ftrace_ops is registered/unregistered
  * DYNAMIC - set when ftrace_ops is registered to denote dynamically
@@ -89,6 +94,10 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
  * INITIALIZED - The ftrace_ops has already been initialized (first use time
  *            register_ftrace_function() is called, it will initialized the ops)
  * DELETED - The ops are being deleted, do not let them be registered again.
+ * IPMODIFY - The ops can modify the IP register. This can only be set with
+ *            SAVE_REGS. If another ops is already registered for any of the
+ *            functions that this ops will be registered for, then this ops
+ *            will fail to register or set_filter_ip.
  */
 enum {
 	FTRACE_OPS_FL_ENABLED			= 1 << 0,
@@ -100,6 +109,7 @@ enum {
 	FTRACE_OPS_FL_STUB			= 1 << 6,
 	FTRACE_OPS_FL_INITIALIZED		= 1 << 7,
 	FTRACE_OPS_FL_DELETED			= 1 << 8,
+	FTRACE_OPS_FL_IPMODIFY			= 1 << 9,
 };
 
 /*
@@ -281,6 +291,7 @@ extern int ftrace_nr_registered_ops(void);
  *  ENABLED - the function is being traced
  *  REGS    - the record wants the function to save regs
  *  REGS_EN - the function is set up to save regs.
+ *  IPMODIFY - the record allows for the IP address to be changed.
  *
  * When a new ftrace_ops is registered and wants a function to save
  * pt_regs, the rec->flag REGS is set. When the function has been
@@ -294,10 +305,11 @@ enum {
 	FTRACE_FL_REGS_EN	= (1UL << 29),
 	FTRACE_FL_TRAMP		= (1UL << 28),
 	FTRACE_FL_TRAMP_EN	= (1UL << 27),
+	FTRACE_FL_IPMODIFY	= (1UL << 26),
 };
 
-#define FTRACE_REF_MAX_SHIFT	27
-#define FTRACE_FL_BITS		5
+#define FTRACE_REF_MAX_SHIFT	26
+#define FTRACE_FL_BITS		6
 #define FTRACE_FL_MASKED_BITS	((1UL << FTRACE_FL_BITS) - 1)
 #define FTRACE_FL_MASK		(FTRACE_FL_MASKED_BITS << FTRACE_REF_MAX_SHIFT)
 #define FTRACE_REF_MAX		((1UL << FTRACE_REF_MAX_SHIFT) - 1)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 979bd8c..788c500 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1292,6 +1292,9 @@ ftrace_hash_rec_disable(struct ftrace_ops *ops, int filter_hash);
 static void
 ftrace_hash_rec_enable(struct ftrace_ops *ops, int filter_hash);
 
+static int ftrace_hash_ipmodify_update(struct ftrace_ops *ops,
+				       struct ftrace_hash *new_hash);
+
 static int
 ftrace_hash_move(struct ftrace_ops *ops, int enable,
 		 struct ftrace_hash **dst, struct ftrace_hash *src)
@@ -1303,8 +1306,13 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	struct ftrace_hash *new_hash;
 	int size = src->count;
 	int bits = 0;
+	int ret;
 	int i;
 
+	/* Reject setting notrace hash on IPMODIFY ftrace_ops */
+	if (ops->flags & FTRACE_OPS_FL_IPMODIFY && !enable)
+		return -EINVAL;
+
 	/*
 	 * If the new source is empty, just free dst and assign it
 	 * the empty_hash.
@@ -1338,6 +1346,16 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	}
 
 update:
+	/* Make sure this can be applied if it is IPMODIFY ftrace_ops */
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
@@ -1682,6 +1700,115 @@ static void ftrace_hash_rec_enable(struct ftrace_ops *ops,
 	__ftrace_hash_rec_update(ops, filter_hash, 1);
 }
 
+/*
+ * Try to update IPMODIFY flag on each ftrace_rec. Return 0 if it is OK
+ * or no-needed to update, -EBUSY if it detects a conflict of the flag
+ * on a ftrace_rec, and -EINVAL if the new_hash tries to trace all recs.
+ * Note that old_hash and new_hash has below meanings
+ *  - If the hash is NULL, it hits all recs (if IPMODIFY is set, this is rejected)
+ *  - If the hash is EMPTY_HASH, it hits nothing
+ *  - Anything else hits the recs which match the hash entries.
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
+	if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY))
+		return 0;
+
+	/*
+	 * Since the IPMODIFY is very address sensitive action, we do not allow
+	 * ftrace_ops to set all functions to new hash.
+	 */
+	if (!new_hash || !old_hash)
+		return -EINVAL;
+
+	/* Update rec->flags */
+	do_for_each_ftrace_rec(pg, rec) {
+		/* We need to update only differences of filter_hash */
+		in_old = !!ftrace_lookup_ip(old_hash, rec->ip);
+		in_new = !!ftrace_lookup_ip(new_hash, rec->ip);
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
+		in_old = !!ftrace_lookup_ip(old_hash, rec->ip);
+		in_new = !!ftrace_lookup_ip(new_hash, rec->ip);
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
@@ -2322,6 +2449,15 @@ static int ftrace_startup(struct ftrace_ops *ops, int command)
 
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
@@ -2348,6 +2484,8 @@ static int ftrace_shutdown(struct ftrace_ops *ops, int command)
 	 */
 	WARN_ON_ONCE(ftrace_start_up < 0);
 
+	/* Disabling ipmodify never fails */
+	ftrace_hash_ipmodify_disable(ops);
 	ftrace_hash_rec_disable(ops, 1);
 
 	ops->flags &= ~FTRACE_OPS_FL_ENABLED;
@@ -2898,9 +3036,10 @@ static int t_show(struct seq_file *m, void *v)
 
 	seq_printf(m, "%ps", (void *)rec->ip);
 	if (iter->flags & FTRACE_ITER_ENABLED) {
-		seq_printf(m, " (%ld)%s",
+		seq_printf(m, " (%ld)%s%s",
 			   ftrace_rec_count(rec),
-			   rec->flags & FTRACE_FL_REGS ? " R" : "  ");
+			   rec->flags & FTRACE_FL_REGS ? " R" : "  ",
+			   rec->flags & FTRACE_FL_IPMODIFY ? " I" : "  ");
 		if (rec->flags & FTRACE_FL_TRAMP_EN) {
 			struct ftrace_ops *ops;
 


