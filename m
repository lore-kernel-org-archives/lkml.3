Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab3DLMan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 08:30:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:44689 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805Ab3DLMam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 08:30:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,462,1363158000"; 
   d="scan'208";a="285297563"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 3/4] dynamic_debug: reuse generic string_unescape function
Date: Fri, 12 Apr 2013 15:30:19 +0300
Message-Id: <1365769820-28953-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1365769820-28953-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1365769820-28953-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is kernel function to do the job in generic way. Let's use it.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 lib/dynamic_debug.c | 48 +++++-------------------------------------------
 1 file changed, 5 insertions(+), 43 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 4603245..99fec3a 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -24,6 +24,7 @@
 #include <linux/sysctl.h>
 #include <linux/ctype.h>
 #include <linux/string.h>
+#include <linux/string_helpers.h>
 #include <linux/uaccess.h>
 #include <linux/dynamic_debug.h>
 #include <linux/debugfs.h>
@@ -276,47 +277,6 @@ static inline int parse_lineno(const char *str, unsigned int *val)
 	return 0;
 }
 
-/*
- * Undo octal escaping in a string, inplace.  This is useful to
- * allow the user to express a query which matches a format
- * containing embedded spaces.
- */
-static char *unescape(char *str)
-{
-	char *in = str;
-	char *out = str;
-
-	while (*in) {
-		if (*in == '\\') {
-			if (in[1] == '\\') {
-				*out++ = '\\';
-				in += 2;
-				continue;
-			} else if (in[1] == 't') {
-				*out++ = '\t';
-				in += 2;
-				continue;
-			} else if (in[1] == 'n') {
-				*out++ = '\n';
-				in += 2;
-				continue;
-			} else if (isodigit(in[1]) &&
-				   isodigit(in[2]) &&
-				   isodigit(in[3])) {
-				*out++ = (((in[1] - '0') << 6) |
-					  ((in[2] - '0') << 3) |
-					  (in[3] - '0'));
-				in += 4;
-				continue;
-			}
-		}
-		*out++ = *in++;
-	}
-	*out = '\0';
-
-	return str;
-}
-
 static int check_set(const char **dest, char *src, char *name)
 {
 	int rc = 0;
@@ -370,8 +330,10 @@ static int ddebug_parse_query(char *words[], int nwords,
 		} else if (!strcmp(words[i], "module")) {
 			rc = check_set(&query->module, words[i+1], "module");
 		} else if (!strcmp(words[i], "format")) {
-			rc = check_set(&query->format, unescape(words[i+1]),
-				       "format");
+			string_unescape_inplace(words[i+1], UNESCAPE_SPACE |
+							    UNESCAPE_OCTAL |
+							    UNESCAPE_SPECIAL);
+			rc = check_set(&query->format, words[i+1], "format");
 		} else if (!strcmp(words[i], "line")) {
 			char *first = words[i+1];
 			char *last = strchr(first, '-');
-- 
1.8.2.rc0.22.gb3600c3

