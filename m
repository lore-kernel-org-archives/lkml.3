Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab3L2C7L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:59:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54968 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751759Ab3L2CJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:56 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Steven Rostedt" <srostedt@redhat.com>,
        "Steven Rostedt" <rostedt@goodmis.org>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.986206432@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 182/185] ftrace: Create ftrace_hash_empty() helper routine
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit 06a51d9307380c78bb5c92e68fc80ad2c7d7f890 upstream.

There are two types of hashes in the ftrace_ops; one type
is the filter_hash and the other is the notrace_hash. Either
one may be null, meaning it has no elements. But when elements
are added, the hash is allocated.

Throughout the code, a check needs to be made to see if a hash
exists or the hash has elements, but the check if the hash exists
is usually missing causing the possible "NULL pointer dereference bug".

Add a helper routine called "ftrace_hash_empty()" that returns
true if the hash doesn't exist or its count is zero. As they mean
the same thing.

Last-bug-reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/ftrace.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1017,6 +1017,11 @@ static struct ftrace_page	*ftrace_pages;
 
 static struct dyn_ftrace *ftrace_free_records;
 
+static bool ftrace_hash_empty(struct ftrace_hash *hash)
+{
+	return !hash || !hash->count;
+}
+
 static struct ftrace_func_entry *
 ftrace_lookup_ip(struct ftrace_hash *hash, unsigned long ip)
 {
@@ -1025,7 +1030,7 @@ ftrace_lookup_ip(struct ftrace_hash *has
 	struct hlist_head *hhd;
 	struct hlist_node *n;
 
-	if (!hash->count)
+	if (ftrace_hash_empty(hash))
 		return NULL;
 
 	if (hash->size_bits > 0)
@@ -1169,7 +1174,7 @@ alloc_and_copy_ftrace_hash(int size_bits
 		return NULL;
 
 	/* Empty hash? */
-	if (!hash || !hash->count)
+	if (ftrace_hash_empty(hash))
 		return new_hash;
 
 	size = 1 << hash->size_bits;
@@ -1294,9 +1299,9 @@ ftrace_ops_test(struct ftrace_ops *ops,
 	filter_hash = rcu_dereference_raw(ops->filter_hash);
 	notrace_hash = rcu_dereference_raw(ops->notrace_hash);
 
-	if ((!filter_hash || !filter_hash->count ||
+	if ((ftrace_hash_empty(filter_hash) ||
 	     ftrace_lookup_ip(filter_hash, ip)) &&
-	    (!notrace_hash || !notrace_hash->count ||
+	    (ftrace_hash_empty(notrace_hash) ||
 	     !ftrace_lookup_ip(notrace_hash, ip)))
 		ret = 1;
 	else
@@ -1348,7 +1353,7 @@ static void __ftrace_hash_rec_update(str
 	if (filter_hash) {
 		hash = ops->filter_hash;
 		other_hash = ops->notrace_hash;
-		if (!hash || !hash->count)
+		if (ftrace_hash_empty(hash))
 			all = 1;
 	} else {
 		inc = !inc;
@@ -1358,7 +1363,7 @@ static void __ftrace_hash_rec_update(str
 		 * If the notrace hash has no items,
 		 * then there's nothing to do.
 		 */
-		if (!hash || !hash->count)
+		if (ftrace_hash_empty(hash))
 			return;
 	}
 
@@ -1375,8 +1380,8 @@ static void __ftrace_hash_rec_update(str
 			if (!other_hash || !ftrace_lookup_ip(other_hash, rec->ip))
 				match = 1;
 		} else {
-			in_hash = hash && !!ftrace_lookup_ip(hash, rec->ip);
-			in_other_hash = other_hash && !!ftrace_lookup_ip(other_hash, rec->ip);
+			in_hash = !!ftrace_lookup_ip(hash, rec->ip);
+			in_other_hash = !!ftrace_lookup_ip(other_hash, rec->ip);
 
 			/*
 			 *
@@ -1384,7 +1389,7 @@ static void __ftrace_hash_rec_update(str
 			if (filter_hash && in_hash && !in_other_hash)
 				match = 1;
 			else if (!filter_hash && in_hash &&
-				 (in_other_hash || !other_hash->count))
+				 (in_other_hash || ftrace_hash_empty(other_hash)))
 				match = 1;
 		}
 		if (!match)
@@ -1799,7 +1804,7 @@ static int ops_traces_mod(struct ftrace_
 	struct ftrace_hash *hash;
 
 	hash = ops->filter_hash;
-	return !!(!hash || !hash->count);
+	return ftrace_hash_empty(hash);
 }
 
 static int ftrace_update_code(struct module *mod)
@@ -2112,7 +2117,8 @@ static void *t_start(struct seq_file *m,
 	 * off, we can short cut and just print out that all
 	 * functions are enabled.
 	 */
-	if (iter->flags & FTRACE_ITER_FILTER && !ops->filter_hash->count) {
+	if (iter->flags & FTRACE_ITER_FILTER &&
+	    ftrace_hash_empty(ops->filter_hash)) {
 		if (*pos > 0)
 			return t_hash_start(m, pos);
 		iter->flags |= FTRACE_ITER_PRINTALL;

