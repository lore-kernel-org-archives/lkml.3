Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab3ISI5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 04:57:16 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:54641 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3ISI5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 04:57:15 -0400
X-Nat-Received: from [202.181.97.72]:54699 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379580975.4315
To: linux@horizon.com, keescook@chromium.org
Cc: akpm@linux-foundation.org, dan.carpenter@oracle.com, geert@linux-m68k.org,
        JBeulich@suse.com, joe@perches.com, kosaki.motohiro@gmail.com,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <CAGXu5jL+NeBw2_vXymM81UdtS6UO7KZA2S4rf3gwM_7nSJ2h6g@mail.gmail.com>
	<20130917205742.16147.qmail@science.horizon.com>
In-Reply-To: <20130917205742.16147.qmail@science.horizon.com>
Message-Id: <201309191756.BCF65661.MQFOLSJOFHFtOV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 19 Sep 2013 17:56:13 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 19092013 #11114935, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

George Spelvin wrote:
> >>   seq_setwidth(m, 21);
> >>   seq_printf(m, "%s%d", con->name, con->index);
> >>   seq_pad(m, '\n');
> 
> > Ooh, I like this a lot! Much cleaner.
> 
> That's certainly a good way to do it, too.
> My "general principles" filter thinks it should be in a local variable
> if it can, but if hiding it in the struct seq_file is fine if people
> find that cleaner.

I think the good point of seq_file is that users don't need to worry about
length calculation for overflow detection. This patch helps users to simplify
length calculation for alignment. I think this approach is better if adding
a size_t to the seq_file is acceptable.

So, the patch follows.
----------------------------------------
>From 02b28fd709971f71e5de9a5b595ff4fd059028b3 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Thu, 19 Sep 2013 17:23:17 +0900
Subject: [PATCH] seq_file: Introduce seq_setwidth() and seq_pad()

There are several users who want to know bytes written by seq_*() for alignment
purpose. Currently they are using %n format for knowing it because seq_*()
returns 0 on success.

This patch introduces seq_setwidth() and seq_pad() for allowing them to align
without using %n format.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/seq_file.c            |   15 +++++++++++++++
 include/linux/seq_file.h |   15 +++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

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
1.7.1
