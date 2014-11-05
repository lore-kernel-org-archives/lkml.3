Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaKETZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 14:25:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:52025 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751046AbaKETZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 14:25:46 -0500
Message-Id: <20141105192543.879544439@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 05 Nov 2014 14:24:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 1/8] seq_file: Rename seq_overflow() to seq_has_overflowed() and make
 public
References: <20141105192426.348510548@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-seq_file-Rename-seq_overflow-to-seq_has_overflowed-a.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

The return values of seq_printf/puts/putc are frequently misused.

Start down a path to remove all the return value uses of these
functions.

Move the seq_overflow() to a global inlined function called
seq_has_overflowed() that can be used by the users of seq_file() calls.

Update the documentation to not show return types for seq_printf
et al.  Add a description of seq_has_overflowed().

Link: http://lkml.kernel.org/p/848ac7e3d1c31cddf638a8526fa3c59fa6fdeb8a.1412031505.git.joe@perches.com

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Joe Perches <joe@perches.com>
[ Reworked the original patch from Joe ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/filesystems/seq_file.txt | 22 +++++++++++++---------
 fs/seq_file.c                          | 15 ++-------------
 include/linux/seq_file.h               | 15 +++++++++++++++
 3 files changed, 30 insertions(+), 22 deletions(-)

diff --git a/Documentation/filesystems/seq_file.txt b/Documentation/filesystems/seq_file.txt
index 8ea3e90ace07..b797ed38de46 100644
--- a/Documentation/filesystems/seq_file.txt
+++ b/Documentation/filesystems/seq_file.txt
@@ -180,23 +180,19 @@ output must be passed to the seq_file code. Some utility functions have
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
 
 	int seq_path(struct seq_file *m, struct path *path, char *esc);
 	int seq_path_root(struct seq_file *m, struct path *path,
@@ -209,6 +205,14 @@ root is desired, it can be used with seq_path_root().  Note that, if it
 turns out that path cannot be reached from root, the value of root will be
 changed in seq_file_root() to a root which *does* work.
 
+A function producing complicated output may want to check
+	bool seq_has_overflowed(struct seq_file *m);
+and avoid further seq_<output> calls if true is returned.
+
+A true return from seq_has_overflowed means that the seq_file buffer will
+be discarded and the seq_show function will attempt to allocate a larger
+buffer and retry printing.
+
 
 Making it all work
 
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 3857b720cb1b..353948ba1c5b 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -16,17 +16,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 
-
-/*
- * seq_files have a buffer which can may overflow. When this happens a larger
- * buffer is reallocated and all the data will be printed again.
- * The overflow state is true when m->count == m->size.
- */
-static bool seq_overflow(struct seq_file *m)
-{
-	return m->count == m->size;
-}
-
 static void seq_set_overflow(struct seq_file *m)
 {
 	m->count = m->size;
@@ -124,7 +113,7 @@ static int traverse(struct seq_file *m, loff_t offset)
 			error = 0;
 			m->count = 0;
 		}
-		if (seq_overflow(m))
+		if (seq_has_overflowed(m))
 			goto Eoverflow;
 		if (pos + m->count > offset) {
 			m->from = offset - pos;
@@ -267,7 +256,7 @@ Fill:
 			break;
 		}
 		err = m->op->show(m, p);
-		if (seq_overflow(m) || err) {
+		if (seq_has_overflowed(m) || err) {
 			m->count = offs;
 			if (likely(err <= 0))
 				break;
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 52e0097f61f0..cf6a9daaaf6d 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -43,6 +43,21 @@ struct seq_operations {
 #define SEQ_SKIP 1
 
 /**
+ * seq_has_overflowed - check if the buffer has overflowed
+ * @m: the seq_file handle
+ *
+ * seq_files have a buffer which may overflow. When this happens a larger
+ * buffer is reallocated and all the data will be printed again.
+ * The overflow state is true when m->count == m->size.
+ *
+ * Returns true if the buffer received more than it can hold.
+ */
+static inline bool seq_has_overflowed(struct seq_file *m)
+{
+	return m->count == m->size;
+}
+
+/**
  * seq_get_buf - get buffer to write arbitrary data to
  * @m: the seq_file handle
  * @bufp: the beginning of the buffer is stored here
-- 
2.1.1


