Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaA3VMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 16:12:23 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:43212 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbaA3VMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 16:12:18 -0500
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Michel Lespinasse <walken@google.com>, Shaohua Li <shli@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v5 1/2] mm: add kstrimdup function
Date: Thu, 30 Jan 2014 13:11:57 -0800
Message-Id: <1391116318-17253-2-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391116318-17253-1-git-send-email-sebastian.capella@linaro.org>
References: <1391116318-17253-1-git-send-email-sebastian.capella@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kstrimdup will duplicate and trim spaces from the passed in
null terminated string.  This is useful for strings coming from
sysfs that often include trailing whitespace due to user input.

Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Rik van Riel <riel@redhat.com> (commit_signer:5/10=50%)
Cc: Michel Lespinasse <walken@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 include/linux/string.h |    1 +
 mm/util.c              |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index ac889c5..f29f9a0 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -114,6 +114,7 @@ void *memchr_inv(const void *s, int c, size_t n);
 
 extern char *kstrdup(const char *s, gfp_t gfp);
 extern char *kstrndup(const char *s, size_t len, gfp_t gfp);
+extern char *kstrimdup(const char *s, gfp_t gfp);
 extern void *kmemdup(const void *src, size_t len, gfp_t gfp);
 
 extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
diff --git a/mm/util.c b/mm/util.c
index 808f375..2066b33 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1,6 +1,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/ctype.h>
 #include <linux/export.h>
 #include <linux/err.h>
 #include <linux/sched.h>
@@ -63,6 +64,35 @@ char *kstrndup(const char *s, size_t max, gfp_t gfp)
 EXPORT_SYMBOL(kstrndup);
 
 /**
+ * kstrimdup - Trim and copy a %NUL terminated string.
+ * @s: the string to trim and duplicate
+ * @gfp: the GFP mask used in the kmalloc() call when allocating memory
+ *
+ * Returns an address, which the caller must kfree, containing
+ * a duplicate of the passed string with leading and/or trailing
+ * whitespace (as defined by isspace) removed.
+ */
+char *kstrimdup(const char *s, gfp_t gfp)
+{
+	char *buf;
+	char *begin = skip_spaces(s);
+	size_t len = strlen(begin);
+
+	while (len > 1 && isspace(begin[len - 1]))
+		len--;
+
+	buf = kmalloc_track_caller(len + 1, gfp);
+	if (!buf)
+		return NULL;
+
+	memcpy(buf, begin, len);
+	buf[len] = '\0';
+
+	return buf;
+}
+EXPORT_SYMBOL(kstrimdup);
+
+/**
  * kmemdup - duplicate region of memory
  *
  * @src: memory region to duplicate
-- 
1.7.9.5

