Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaGKMIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 08:08:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:34943 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaGKMIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 08:08:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,642,1400050800"; 
   d="scan'208";a="560473041"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Marek Vasut <marex@denx.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 1/5] seq_file: provide an analogue of print_hex_dump()
Date: Fri, 11 Jul 2014 15:08:42 +0300
Message-Id: <1405080526-6319-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1405080526-6319-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1405080526-6319-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new seq_hex_dump() is a complete analogue of print_hex_dump().

We have few users of this functionality already. It allows to reduce their
codebase.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 fs/seq_file.c            | 35 +++++++++++++++++++++++++++++++++++
 include/linux/seq_file.h |  4 ++++
 2 files changed, 39 insertions(+)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 1d641bb..64ad5a0 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -10,6 +10,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/cred.h>
+#include <linux/printk.h>
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
@@ -782,6 +783,40 @@ void seq_pad(struct seq_file *m, char c)
 }
 EXPORT_SYMBOL(seq_pad);
 
+/* Analogue of print_hex_dump() */
+void seq_hex_dump(struct seq_file *m, const char *prefix_str, int prefix_type,
+		  int rowsize, int groupsize, const void *buf, size_t len,
+		  bool ascii)
+{
+	const u8 *ptr = buf;
+	int i, linelen, remaining = len;
+	unsigned char linebuf[32 * 3 + 2 + 32 + 1];
+
+	if (rowsize != 16 && rowsize != 32)
+		rowsize = 16;
+
+	for (i = 0; i < len; i += rowsize) {
+		linelen = min(remaining, rowsize);
+		remaining -= rowsize;
+
+		hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
+				   linebuf, sizeof(linebuf), ascii);
+
+		switch (prefix_type) {
+		case DUMP_PREFIX_ADDRESS:
+			seq_printf(m, "%s%p: %s\n", prefix_str, ptr + i, linebuf);
+			break;
+		case DUMP_PREFIX_OFFSET:
+			seq_printf(m, "%s%.8x: %s\n", prefix_str, i, linebuf);
+			break;
+		default:
+			seq_printf(m, "%s%s\n", prefix_str, linebuf);
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL(seq_hex_dump);
+
 struct list_head *seq_list_start(struct list_head *head, loff_t pos)
 {
 	struct list_head *lh;
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 52e0097..6a8be4c 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -107,6 +107,10 @@ int seq_write(struct seq_file *seq, const void *data, size_t len);
 __printf(2, 3) int seq_printf(struct seq_file *, const char *, ...);
 __printf(2, 0) int seq_vprintf(struct seq_file *, const char *, va_list args);
 
+void seq_hex_dump(struct seq_file *m, const char *prefix_str, int prefix_type,
+		  int rowsize, int groupsize, const void *buf, size_t len,
+		  bool ascii);
+
 int seq_path(struct seq_file *, const struct path *, const char *);
 int seq_dentry(struct seq_file *, struct dentry *, const char *);
 int seq_path_root(struct seq_file *m, const struct path *path,
-- 
2.0.1

