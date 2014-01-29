Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaA2Xsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 18:48:53 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35497 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaA2Xsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 18:48:51 -0500
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Shaohua Li <shli@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v4 1/2] mm: add kstrimdup function
Date: Wed, 29 Jan 2014 15:48:23 -0800
Message-Id: <1391039304-3172-2-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391039304-3172-1-git-send-email-sebastian.capella@linaro.org>
References: <1391039304-3172-1-git-send-email-sebastian.capella@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kstrimdup will duplicate and trim spaces from the passed in
null terminated string.  This is useful for strings coming from
sysfs that often include trailing whitespace due to user input.

Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com> (commit_signer:5/10=50%)
Cc: Michel Lespinasse <walken@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 include/linux/string.h |    1 +
 mm/util.c              |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

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
index a24aa22..da17de5 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -63,6 +63,25 @@ char *kstrndup(const char *s, size_t max, gfp_t gfp)
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
+	char *ret = kstrdup(skip_spaces(s), gfp);
+
+	if (ret)
+		strim(ret);
+	return ret;
+}
+EXPORT_SYMBOL(kstrimdup);
+
+/**
  * kmemdup - duplicate region of memory
  *
  * @src: memory region to duplicate
-- 
1.7.9.5

