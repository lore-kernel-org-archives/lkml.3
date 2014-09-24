Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaIXLQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:16:41 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:42317 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaIXLQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:16:12 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: rdunlap@infradead.org, viro@zeniv.linux.org.uk
Cc: linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk,
        akpm@linux-foundation.org, keescook@chromium.org,
        penguin-kernel@I-love.SAKURA.ne.jp, rob.jones@codethink.co.uk
Subject: [PATCH RESUBMIT 1/2] fs/seq_file: Create new function seq_open_init()
Date: Wed, 24 Sep 2014 12:15:55 +0100
Message-Id: <1411557356-10673-2-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411557356-10673-1-git-send-email-rob.jones@codethink.co.uk>
References: <1411557356-10673-1-git-send-email-rob.jones@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new function to help reduce boilerplate code.

This is a wrapper function for seq_open() that will simplify the code in a
significant number of cases where seq_open() is currently called.

It's first use is in __seq_open_private(), thereby recovering most of
the code space used by the new function.

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 fs/seq_file.c            |   34 ++++++++++++++++++++++------------
 include/linux/seq_file.h |    1 +
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index dc2dfec..4be3aa8 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -639,28 +639,38 @@ int seq_release_private(struct inode *inode, struct file *file)
 }
 EXPORT_SYMBOL(seq_release_private);
 
+int seq_open_init(struct file *f, const struct seq_operations *ops, void *p)
+{
+	struct seq_file *s;
+	int rc;
+
+	rc = seq_open(f, ops);
+	if (rc)
+		return rc;
+
+	s = f->private_data;
+	s->private = p;
+
+	return 0;
+}
+EXPORT_SYMBOL(seq_open_init);
+
 void *__seq_open_private(struct file *f, const struct seq_operations *ops,
 		size_t psize)
 {
 	int rc;
 	void *private;
-	struct seq_file *seq;
 
 	private = kzalloc(psize, GFP_KERNEL);
-	if (private == NULL)
-		goto out;
+	if (!private)
+		return NULL;
 
-	rc = seq_open(f, ops);
-	if (rc < 0)
-		goto out_free;
-
-	seq = f->private_data;
-	seq->private = private;
-	return private;
+	rc = seq_open_init(f, ops, private);
+	if (!rc)
+		return private;
 
-out_free:
 	kfree(private);
-out:
+
 	return NULL;
 }
 EXPORT_SYMBOL(__seq_open_private);
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 9382339..6b0d953 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -142,6 +142,7 @@ int single_open_size(struct file *, int (*)(struct seq_file *, void *), void *,
 int single_release(struct inode *, struct file *);
 void *__seq_open_private(struct file *, const struct seq_operations *, size_t);
 int seq_open_private(struct file *, const struct seq_operations *, size_t);
+int seq_open_init(struct file *, const struct seq_operations *, void *);
 int seq_release_private(struct inode *, struct file *);
 int seq_put_decimal_ull(struct seq_file *m, char delimiter,
 			unsigned long long num);
-- 
1.7.10.4

