Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbbALKXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:23:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:30960 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbbALKXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:23:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="439406049"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] fs/proc/array.c: convert to use string_escape_str()
Date: Mon, 12 Jan 2015 12:23:04 +0200
Message-Id: <1421058184-26936-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of custom approach let's use string_escape_str() to escape a given
string (task_name in this case).

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 fs/proc/array.c | 34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index bd117d0..a3ccf4c 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -81,6 +81,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/ptrace.h>
 #include <linux/tracehook.h>
+#include <linux/string_helpers.h>
 #include <linux/user_namespace.h>
 
 #include <asm/pgtable.h>
@@ -89,39 +90,18 @@
 
 static inline void task_name(struct seq_file *m, struct task_struct *p)
 {
-	int i;
-	char *buf, *end;
-	char *name;
+	char *buf;
 	char tcomm[sizeof(p->comm)];
 
 	get_task_comm(tcomm, p);
 
 	seq_puts(m, "Name:\t");
-	end = m->buf + m->size;
 	buf = m->buf + m->count;
-	name = tcomm;
-	i = sizeof(tcomm);
-	while (i && (buf < end)) {
-		unsigned char c = *name;
-		name++;
-		i--;
-		*buf = c;
-		if (!c)
-			break;
-		if (c == '\\') {
-			buf++;
-			if (buf < end)
-				*buf++ = c;
-			continue;
-		}
-		if (c == '\n') {
-			*buf++ = '\\';
-			if (buf < end)
-				*buf++ = 'n';
-			continue;
-		}
-		buf++;
-	}
+
+	/* Ignore error for now */
+	string_escape_str(tcomm, &buf, m->size - m->count,
+			  ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
+
 	m->count = buf - m->buf;
 	seq_putc(m, '\n');
 }
-- 
2.1.4

