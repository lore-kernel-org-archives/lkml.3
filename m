Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab3EIFrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:47:05 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42651 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab3EIFrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:47:01 -0400
X-AuditID: 85900ec0-d56cbb900000151e-8c-518b38520aff
Subject: [PATCH 03/11] ftrace: Cleanup regex_lock and ftrace_lock around hash
 updating
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 09 May 2013 14:44:21 +0900
Message-ID: <20130509054421.30398.83411.stgit@mhiramat-M0-7522>
In-Reply-To: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
References: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup regex_lock and ftrace_lock locking points around
ftrace_ops hash update code.

The new rule is that regex_lock protects ops->*_hash
read-update-write code for each ftrace_ops. Usually,
hash update is done by following sequence.

1. allocate a new local hash and copy the original hash.
2. update the local hash.
3. move(actually, copy) back the local hash to ftrace_ops.
4. update ftrace entries if needed.
5. release the local hash.

This makes regex_lock to protect #1-#4, and ftrace_lock
to protect #3 and #4.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
---
 kernel/trace/ftrace.c |   59 +++++++++++++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 27 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 3f29b3d..0575b3f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2644,28 +2644,26 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 		return -ENOMEM;
 	}
 
+	iter->ops = ops;
+	iter->flags = flag;
+
+	mutex_lock(&ops->regex_lock);
+
 	if (flag & FTRACE_ITER_NOTRACE)
 		hash = ops->notrace_hash;
 	else
 		hash = ops->filter_hash;
 
-	iter->ops = ops;
-	iter->flags = flag;
-
 	if (file->f_mode & FMODE_WRITE) {
-		mutex_lock(&ftrace_lock);
 		iter->hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, hash);
-		mutex_unlock(&ftrace_lock);
-
 		if (!iter->hash) {
 			trace_parser_put(&iter->parser);
 			kfree(iter);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto out_unlock;
 		}
 	}
 
-	mutex_lock(&ops->regex_lock);
-
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC))
 		ftrace_filter_reset(iter->hash);
@@ -2685,6 +2683,8 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 		}
 	} else
 		file->private_data = iter;
+
+ out_unlock:
 	mutex_unlock(&ops->regex_lock);
 
 	return ret;
@@ -2999,7 +2999,7 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 	if (WARN_ON(not))
 		return -EINVAL;
 
-	mutex_lock(&ftrace_lock);
+	mutex_lock(&trace_probe_ops.regex_lock);
 
 	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
 	if (!hash) {
@@ -3057,14 +3057,16 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 
 	} while_for_each_ftrace_rec();
 
+	mutex_lock(&ftrace_lock);
 	ret = ftrace_hash_move(&trace_probe_ops, 1, orig_hash, hash);
 	if (ret < 0)
 		count = ret;
 
 	__enable_ftrace_function_probe();
+	mutex_unlock(&ftrace_lock);
 
  out_unlock:
-	mutex_unlock(&ftrace_lock);
+	mutex_unlock(&trace_probe_ops.regex_lock);
 	free_ftrace_hash(hash);
 
 	return count;
@@ -3104,7 +3106,7 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 			return;
 	}
 
-	mutex_lock(&ftrace_lock);
+	mutex_lock(&trace_probe_ops.regex_lock);
 
 	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
 	if (!hash)
@@ -3142,6 +3144,7 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 			list_add(&entry->free_list, &free_list);
 		}
 	}
+	mutex_lock(&ftrace_lock);
 	__disable_ftrace_function_probe();
 	/*
 	 * Remove after the disable is called. Otherwise, if the last
@@ -3153,9 +3156,10 @@ __unregister_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 		list_del(&entry->free_list);
 		ftrace_free_entry(entry);
 	}
+	mutex_unlock(&ftrace_lock);
 		
  out_unlock:
-	mutex_unlock(&ftrace_lock);
+	mutex_unlock(&trace_probe_ops.regex_lock);
 	free_ftrace_hash(hash);
 }
 
@@ -3271,11 +3275,10 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	} else
 		iter = file->private_data;
 
-	mutex_lock(&iter->ops->regex_lock);
-
-	ret = -ENODEV;
 	if (unlikely(ftrace_disabled))
-		goto out_unlock;
+		return -ENODEV;
+
+	/* iter->hash is a local copy, so we don't need regex_lock */
 
 	parser = &iter->parser;
 	read = trace_get_user(parser, ubuf, cnt, ppos);
@@ -3286,13 +3289,11 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 					   parser->idx, enable);
 		trace_parser_clear(parser);
 		if (ret)
-			goto out_unlock;
+			goto out;
 	}
 
 	ret = read;
-out_unlock:
-	mutex_unlock(&iter->ops->regex_lock);
-
+ out:
 	return ret;
 }
 
@@ -3344,16 +3345,19 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
 
+	mutex_lock(&ops->regex_lock);
+
 	if (enable)
 		orig_hash = &ops->filter_hash;
 	else
 		orig_hash = &ops->notrace_hash;
 
 	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
-	if (!hash)
-		return -ENOMEM;
+	if (!hash) {
+		ret = -ENOMEM;
+		goto out_regex_unlock;
+	}
 
-	mutex_lock(&ops->regex_lock);
 	if (reset)
 		ftrace_filter_reset(hash);
 	if (buf && !ftrace_match_records(hash, buf, len)) {
@@ -3566,8 +3570,6 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 	} else
 		iter = file->private_data;
 
-	mutex_lock(&iter->ops->regex_lock);
-
 	parser = &iter->parser;
 	if (trace_parser_loaded(parser)) {
 		parser->buffer[parser->idx] = 0;
@@ -3576,6 +3578,8 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 
 	trace_parser_put(parser);
 
+	mutex_lock(&iter->ops->regex_lock);
+
 	if (file->f_mode & FMODE_WRITE) {
 		filter_hash = !!(iter->flags & FTRACE_ITER_FILTER);
 
@@ -3593,10 +3597,11 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 
 		mutex_unlock(&ftrace_lock);
 	}
+
+	mutex_unlock(&iter->ops->regex_lock);
 	free_ftrace_hash(iter->hash);
 	kfree(iter);
 
-	mutex_unlock(&iter->ops->regex_lock);
 	return 0;
 }
 

