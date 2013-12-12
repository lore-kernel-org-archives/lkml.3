Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab3LLDo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 22:44:29 -0500
Received: from smtprelay0146.hostedemail.com ([216.40.44.146]:40054 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751542Ab3LLDoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 22:44:25 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,::::::::::::,RULES_HIT:2:41:69:355:379:541:800:960:968:973:982:988:989:1260:1345:1359:1431:1437:1535:1605:1730:1747:1777:1792:1801:2393:2553:2559:2562:2689:2693:2895:2898:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:3874:4050:4118:4321:4384:4605:5007:6119:6261:7875:7904:8603:8660:9163:9592:10004:10026:10226:10848:11026:11232:11658:11914:12043:12296:12517:12519:12555:13148:13161:13229:13230:13255,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: can43_7d7f6aa265400
X-Filterd-Recvd-Size: 7984
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>, Rob Landley <rob@landley.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH -next 1/2] seq_file: Rename static bool seq_overflow to public bool seq_is_buf_full
Date: Wed, 11 Dec 2013 19:44:11 -0800
Message-Id: <29f997a736cbb01706f76b52b8e7d34e548ed386.1386819513.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1386819513.git.joe@perches.com>
References: <cover.1386819513.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return values of seq_printf/puts/putc are frequently misused.

Start down a path to remove all the return value uses of these
functions.

Make the static bool seq_overflow public along with a rename of
the function to seq_is_buf_full.  Rename the still static
seq_set_overflow to seq_set_buf_full.

Update the documentation to not show return types for seq_printf
et al.  Add a description of seq_is_buf_full.

Signed-off-by: Joe Perches <joe@perches.com>
---
 Documentation/filesystems/seq_file.txt | 28 ++++++++++++++++------------
 fs/seq_file.c                          | 28 ++++++++++++++--------------
 include/linux/seq_file.h               |  8 ++++++++
 3 files changed, 38 insertions(+), 26 deletions(-)

diff --git a/Documentation/filesystems/seq_file.txt b/Documentation/filesystems/seq_file.txt
index a1e2e0d..794dbde 100644
--- a/Documentation/filesystems/seq_file.txt
+++ b/Documentation/filesystems/seq_file.txt
@@ -171,27 +171,23 @@ output must be passed to the seq_file code. Some utility functions have
 been defined which make this task easy.
 
 Most code will simply use seq_printf(), which works pretty much like
-printk(), but which requires the seq_file pointer as an argument. It is
-common to ignore the return value from seq_printf(), but a function
-producing complicated output may want to check that value and quit if
-something non-zero is returned; an error return means that the seq_file
-buffer has been filled and further output will be discarded.
+printk(), but which requires the seq_file pointer as an argument.
 
 For straight character output, the following functions may be used:
 
-	int seq_putc(struct seq_file *m, char c);
-	int seq_puts(struct seq_file *m, const char *s);
-	int seq_escape(struct seq_file *m, const char *s, const char *esc);
+	seq_putc(struct seq_file *m, char c);
+	seq_puts(struct seq_file *m, const char *s);
+	seq_escape(struct seq_file *m, const char *s, const char *esc);
 
 The first two output a single character and a string, just like one would
 expect. seq_escape() is like seq_puts(), except that any character in s
 which is in the string esc will be represented in octal form in the output.
 
-There is also a pair of functions for printing filenames:
+There are also a pair of functions for printing filenames:
 
-	int seq_path(struct seq_file *m, struct path *path, char *esc);
-	int seq_path_root(struct seq_file *m, struct path *path,
-			  struct path *root, char *esc)
+	seq_path(struct seq_file *m, struct path *path, char *esc);
+	seq_path_root(struct seq_file *m, struct path *path,
+		      struct path *root, char *esc)
 
 Here, path indicates the file of interest, and esc is a set of characters
 which should be escaped in the output.  A call to seq_path() will output
@@ -200,6 +196,14 @@ root is desired, it can be used with seq_path_root().  Note that, if it
 turns out that path cannot be reached from root, the value of root will be
 changed in seq_file_root() to a root which *does* work.
 
+A function producing complicated output may want to check
+	bool seq_is_buf_full(struct seq_file *m);
+and avoid further seq_<output> calls if true is returned.
+
+A true return from seq_is_buf_full means that the seq_file buffer is full
+and further output will be discarded.  The seq_show function will attempt
+to allocate a larger buffer and retry printing.
+
 
 Making it all work
 
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 1d641bb..2fda3a1 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -14,18 +14,18 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 
-
 /*
- * seq_files have a buffer which can may overflow. When this happens a larger
+ * seq_files have a buffer which may overflow. When this happens a larger
  * buffer is reallocated and all the data will be printed again.
  * The overflow state is true when m->count == m->size.
  */
-static bool seq_overflow(struct seq_file *m)
+bool seq_is_buf_full(struct seq_file *m)
 {
 	return m->count == m->size;
 }
+EXPORT_SYMBOL(seq_is_buf_full);
 
-static void seq_set_overflow(struct seq_file *m)
+static void seq_set_buf_full(struct seq_file *m)
 {
 	m->count = m->size;
 }
@@ -112,7 +112,7 @@ static int traverse(struct seq_file *m, loff_t offset)
 			error = 0;
 			m->count = 0;
 		}
-		if (seq_overflow(m))
+		if (seq_is_buf_full(m))
 			goto Eoverflow;
 		if (pos + m->count > offset) {
 			m->from = offset - pos;
@@ -255,7 +255,7 @@ Fill:
 			break;
 		}
 		err = m->op->show(m, p);
-		if (seq_overflow(m) || err) {
+		if (seq_is_buf_full(m) || err) {
 			m->count = offs;
 			if (likely(err <= 0))
 				break;
@@ -384,7 +384,7 @@ int seq_escape(struct seq_file *m, const char *s, const char *esc)
 			*p++ = '0' + (c & 07);
 			continue;
 		}
-		seq_set_overflow(m);
+		seq_set_buf_full(m);
 		return -1;
         }
 	m->count = p - m->buf;
@@ -403,7 +403,7 @@ int seq_vprintf(struct seq_file *m, const char *f, va_list args)
 			return 0;
 		}
 	}
-	seq_set_overflow(m);
+	seq_set_buf_full(m);
 	return -1;
 }
 EXPORT_SYMBOL(seq_vprintf);
@@ -545,7 +545,7 @@ int seq_bitmap(struct seq_file *m, const unsigned long *bits,
 			return 0;
 		}
 	}
-	seq_set_overflow(m);
+	seq_set_buf_full(m);
 	return -1;
 }
 EXPORT_SYMBOL(seq_bitmap);
@@ -561,7 +561,7 @@ int seq_bitmap_list(struct seq_file *m, const unsigned long *bits,
 			return 0;
 		}
 	}
-	seq_set_overflow(m);
+	seq_set_buf_full(m);
 	return -1;
 }
 EXPORT_SYMBOL(seq_bitmap_list);
@@ -690,7 +690,7 @@ int seq_puts(struct seq_file *m, const char *s)
 		m->count += len;
 		return 0;
 	}
-	seq_set_overflow(m);
+	seq_set_buf_full(m);
 	return -1;
 }
 EXPORT_SYMBOL(seq_puts);
@@ -724,7 +724,7 @@ int seq_put_decimal_ull(struct seq_file *m, char delimiter,
 	m->count += len;
 	return 0;
 overflow:
-	seq_set_overflow(m);
+	seq_set_buf_full(m);
 	return -1;
 }
 EXPORT_SYMBOL(seq_put_decimal_ull);
@@ -734,7 +734,7 @@ int seq_put_decimal_ll(struct seq_file *m, char delimiter,
 {
 	if (num < 0) {
 		if (m->count + 3 >= m->size) {
-			seq_set_overflow(m);
+			seq_set_buf_full(m);
 			return -1;
 		}
 		if (delimiter)
@@ -762,7 +762,7 @@ int seq_write(struct seq_file *seq, const void *data, size_t len)
 		seq->count += len;
 		return 0;
 	}
-	seq_set_overflow(seq);
+	seq_set_buf_full(seq);
 	return -1;
 }
 EXPORT_SYMBOL(seq_write);
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 52e0097..8a8f87f 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -43,6 +43,14 @@ struct seq_operations {
 #define SEQ_SKIP 1
 
 /**
+ * seq_is_buf_full - check if the buffer associated to seq_file is full
+ * @m: the seq_file handle
+ *
+ * Returns true if the buffer is full
+ */
+bool seq_is_buf_full(struct seq_file *m);
+
+/**
  * seq_get_buf - get buffer to write arbitrary data to
  * @m: the seq_file handle
  * @bufp: the beginning of the buffer is stored here
-- 
1.8.1.2.459.gbcd45b4.dirty

