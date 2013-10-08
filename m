Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3JHC5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:57:46 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53826 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab3JHC5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:57:20 -0400
From: Kees Cook <keescook@chromium.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, joe@perches.com,
        keescook@chromium.org
Subject: [PATCH 1/3] seq_file: Introduce seq_setwidth() and seq_pad()
Date: Mon,  7 Oct 2013 19:56:49 -0700
Message-Id: <1381201011-4230-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

There are several users who want to know bytes written by seq_*() for alignment
purpose. Currently they are using %n format for knowing it because seq_*()
returns 0 on success.

This patch introduces seq_setwidth() and seq_pad() for allowing them to align
without using %n format.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Kees Cook <keescook@chromium.org>
---
 fs/seq_file.c            |   15 +++++++++++++++
 include/linux/seq_file.h |   15 +++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 3135c25..40e471e 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -764,6 +764,21 @@ int seq_write(struct seq_file *seq, const void *data, size_t len)
 }
 EXPORT_SYMBOL(seq_write);
 
+/**
+ * seq_pad - write padding spaces to buffer
+ * @m: seq_file identifying the buffer to which data should be written
+ * @c: the byte to append after padding if non-zero
+ */
+void seq_pad(struct seq_file *m, char c)
+{
+	int size = m->pad_until - m->count;
+	if (size > 0)
+		seq_printf(m, "%*s", size, "");
+	if (c)
+		seq_putc(m, c);
+}
+EXPORT_SYMBOL(seq_pad);
+
 struct list_head *seq_list_start(struct list_head *head, loff_t pos)
 {
 	struct list_head *lh;
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 4e32edc..52e0097 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -20,6 +20,7 @@ struct seq_file {
 	size_t size;
 	size_t from;
 	size_t count;
+	size_t pad_until;
 	loff_t index;
 	loff_t read_pos;
 	u64 version;
@@ -79,6 +80,20 @@ static inline void seq_commit(struct seq_file *m, int num)
 	}
 }
 
+/**
+ * seq_setwidth - set padding width
+ * @m: the seq_file handle
+ * @size: the max number of bytes to pad.
+ *
+ * Call seq_setwidth() for setting max width, then call seq_printf() etc. and
+ * finally call seq_pad() to pad the remaining bytes.
+ */
+static inline void seq_setwidth(struct seq_file *m, size_t size)
+{
+	m->pad_until = m->count + size;
+}
+void seq_pad(struct seq_file *m, char c);
+
 char *mangle_path(char *s, const char *p, const char *esc);
 int seq_open(struct file *, const struct seq_operations *);
 ssize_t seq_read(struct file *, char __user *, size_t, loff_t *);
-- 
1.7.9.5

