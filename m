Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaG2RkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:40:07 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:58932 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaG2RkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:40:05 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel@lists.codethink.co.uk, viro@ZenIV.linux.org.uk,
        ebiederm@xmission.com, ian.molton@codethink.co.uk,
        rob.jones@codethink.co.uk
Subject: [PATCH] seq_file: Allow private data to be supplied on seq_open
Date: Tue, 29 Jul 2014 18:39:53 +0100
Message-Id: <1406655593-12626-1-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a function seq_open_priv() that is identical to seq_open() except
that it accepts a void * parameter that it stores in the private field
of the struct seq_file.

Document seq_open_priv().

Some consumers of the seq_file interface need to pass data to their
iterators that is best obtained at the time the seq_file is opened.

At the moment these consumers have to obtain the struct seq_file pointer
(stored by seq_open() in file->private_data) and then store a pointer to
their own data in the private field of the struct seq_file so that it
can be accessed by the iterator functions.

Although this is not a long piece of code it is unneccessary boilerplate.

seq_open() remains in place and its behaviour remains unchanged so no
existing code should be broken by this patch.

Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 Documentation/filesystems/seq_file.txt |    9 +++++++++
 fs/seq_file.c                          |   30 ++++++++++++++++++++++++++++--
 include/linux/seq_file.h               |    1 +
 3 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/seq_file.txt b/Documentation/filesystems/seq_file.txt
index a1e2e0d..128ffee 100644
--- a/Documentation/filesystems/seq_file.txt
+++ b/Documentation/filesystems/seq_file.txt
@@ -226,6 +226,15 @@ be used for more than one file, you can store an arbitrary pointer in the
 private field of the seq_file structure; that value can then be retrieved
 by the iterator functions.
 
+There is also a function seq_open_priv() which behaves identically to
+seq_open() except that it takes an additional void * parameter that it
+stores in the private field of the seq_file structure, thereby making it
+available to the start function and thus all subsequent iterator functions
+Note that a corresponding wrapper function for seq_release() may need to
+be created to free any resources allocated by an open function that uses
+this capability (although, for simple cases, seq_release_private() may
+suffice).
+
 The other operations of interest - read(), llseek(), and release() - are
 all implemented by the seq_file code itself. So a virtual file's
 file_operations structure will look like:
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 1d641bb..9a0db94 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -31,9 +31,10 @@ static void seq_set_overflow(struct seq_file *m)
 }
 
 /**
- *	seq_open -	initialize sequential file
+ *	seq_open_priv -	initialize sequential file with private data
  *	@file: file we initialize
  *	@op: method table describing the sequence
+ *	@d: private data to be made available to the iterator functions
  *
  *	seq_open() sets @file, associating it with a sequence described
  *	by @op.  @op->start() sets the iterator up and returns the first
@@ -43,8 +44,12 @@ static void seq_set_overflow(struct seq_file *m)
  *	ERR_PTR(error).  In the end of sequence they return %NULL. ->show()
  *	returns 0 in case of success and negative number in case of error.
  *	Returning SEQ_SKIP means "discard this element and move on".
+ *
+ *	Supplying @d allows data that is only available at the time the file
+ *	is opened to be supplied to @op->start() (and thereby to @op->next()
+ *	as well).
  */
-int seq_open(struct file *file, const struct seq_operations *op)
+int seq_open_priv(struct file *file, const struct seq_operations *op, void *d)
 {
 	struct seq_file *p = file->private_data;
 
@@ -57,6 +62,7 @@ int seq_open(struct file *file, const struct seq_operations *op)
 	memset(p, 0, sizeof(*p));
 	mutex_init(&p->lock);
 	p->op = op;
+	p->private = d;
 #ifdef CONFIG_USER_NS
 	p->user_ns = file->f_cred->user_ns;
 #endif
@@ -80,6 +86,26 @@ int seq_open(struct file *file, const struct seq_operations *op)
 	file->f_mode &= ~FMODE_PWRITE;
 	return 0;
 }
+EXPORT_SYMBOL(seq_open_priv);
+
+/**
+ *	seq_open -	initialize sequential file
+ *	@file: file we initialize
+ *	@op: method table describing the sequence
+ *
+ *	seq_open() sets @file, associating it with a sequence described
+ *	by @op.  @op->start() sets the iterator up and returns the first
+ *	element of sequence. @op->stop() shuts it down.  @op->next()
+ *	returns the next element of sequence.  @op->show() prints element
+ *	into the buffer.  In case of error ->start() and ->next() return
+ *	ERR_PTR(error).  In the end of sequence they return %NULL. ->show()
+ *	returns 0 in case of success and negative number in case of error.
+ *	Returning SEQ_SKIP means "discard this element and move on".
+ */
+int seq_open(struct file *file, const struct seq_operations *op)
+{
+	return seq_open_priv(file, op, NULL);
+}
 EXPORT_SYMBOL(seq_open);
 
 static int traverse(struct seq_file *m, loff_t offset)
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 52e0097..fce87af 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -95,6 +95,7 @@ static inline void seq_setwidth(struct seq_file *m, size_t size)
 void seq_pad(struct seq_file *m, char c);
 
 char *mangle_path(char *s, const char *p, const char *esc);
+int seq_open_priv(struct file *, const struct seq_operations *, void *);
 int seq_open(struct file *, const struct seq_operations *);
 ssize_t seq_read(struct file *, char __user *, size_t, loff_t *);
 loff_t seq_lseek(struct file *, loff_t, int);
-- 
1.7.10.4

