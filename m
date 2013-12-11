Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab3LKFNC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 00:13:02 -0500
Received: from smtprelay0093.hostedemail.com ([216.40.44.93]:57059 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750740Ab3LKFM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 00:12:56 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1431:1437:1534:1542:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3871:3874:4321:4605:5007:6261:7875:8603:9592:10004:10026:10848:11026:11658:11914:12296:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: songs11_709f0a3134c4f
X-Filterd-Recvd-Size: 2929
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -next 1/3] seq: Add a seq_overflow test.
Date: Tue, 10 Dec 2013 21:12:42 -0800
Message-Id: <f752df21274aef5c88da81d6c37d427bfe1859a2.1386738050.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1386738050.git.joe@perches.com>
References: <cover.1386738050.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seq_printf and seq_puts returns are often misused.

Instead of checking the seq_printf or seq_puts return,
add a new seq_overflow function to test if a seq_file has
overflowed the available buffer space.

This will eventually allow seq_printf and seq_puts to be
converted to have a void return instead of the int return
that is often assumed to have a size_t value instead of an
error/no-error value.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/seq_file.c            | 15 ++++++++-------
 include/linux/seq_file.h |  2 ++
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 1d641bb..aab0736 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -14,16 +14,17 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 
-
-/*
- * seq_files have a buffer which can may overflow. When this happens a larger
- * buffer is reallocated and all the data will be printed again.
- * The overflow state is true when m->count == m->size.
+/**
+ * seq_overflow - test if a seq_file has overflowed the space available
+ * @m: the seq_file handle
+ *
+ * Returns -1 when an overflow has occurred, 0 otherwise.
  */
-static bool seq_overflow(struct seq_file *m)
+int seq_overflow(struct seq_file *m)
 {
-	return m->count == m->size;
+	return m->count == m->size ? -1 : 0;
 }
+EXPORT_SYMBOL(seq_overflow);
 
 static void seq_set_overflow(struct seq_file *m)
 {
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 52e0097..f8f9dc0 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -107,6 +107,8 @@ int seq_write(struct seq_file *seq, const void *data, size_t len);
 __printf(2, 3) int seq_printf(struct seq_file *, const char *, ...);
 __printf(2, 0) int seq_vprintf(struct seq_file *, const char *, va_list args);
 
+int seq_overflow(struct seq_file *m);
+
 int seq_path(struct seq_file *, const struct path *, const char *);
 int seq_dentry(struct seq_file *, struct dentry *, const char *);
 int seq_path_root(struct seq_file *m, const struct path *path,
-- 
1.8.1.2.459.gbcd45b4.dirty

