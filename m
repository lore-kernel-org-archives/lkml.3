Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbaJCQPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 12:15:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:52029 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbaJCQPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 12:15:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="395172432"
From: kan.liang@intel.com
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, acme@kernel.org,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V7 1/4] Revert "perf tools: Default to cpu// for events v5"
Date: Fri,  3 Oct 2014 12:09:05 -0400
Message-Id: <1412352548-7603-2-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1412352548-7603-1-git-send-email-kan.liang@intel.com>
References: <1412352548-7603-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

This reverts commit 50e200f07948 ("perf tools: Default to cpu// for
events v5")

The fixup cannot handle the case that
new style format(which without //) mixed with
other different formats.

For example,
group events with new style format: {mem-stores,mem-loads}
some hardware event + new style event: cycles,mem-loads
Cache event + new style event: LLC-loads,mem-loads
Raw event + new style event:
cpu/event=0xc8,umask=0x08/,mem-loads
old style event and new stytle mixture: mem-stores,cpu/mem-loads/

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/util/include/linux/string.h |  1 -
 tools/perf/util/parse-events.c         | 30 +-----------------------------
 tools/perf/util/string.c               | 24 ------------------------
 3 files changed, 1 insertion(+), 54 deletions(-)

diff --git a/tools/perf/util/include/linux/string.h b/tools/perf/util/include/linux/string.h
index 97a8007..6f19c54 100644
--- a/tools/perf/util/include/linux/string.h
+++ b/tools/perf/util/include/linux/string.h
@@ -1,4 +1,3 @@
 #include <string.h>
 
 void *memdup(const void *src, size_t len);
-int str_append(char **s, int *len, const char *a);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index d76aa30..c5642e6 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -6,7 +6,7 @@
 #include "parse-options.h"
 #include "parse-events.h"
 #include "exec_cmd.h"
-#include "linux/string.h"
+#include "string.h"
 #include "symbol.h"
 #include "cache.h"
 #include "header.h"
@@ -863,32 +863,6 @@ int parse_events_name(struct list_head *list, char *name)
 	return 0;
 }
 
-static int parse_events__scanner(const char *str, void *data, int start_token);
-
-static int parse_events_fixup(int ret, const char *str, void *data,
-			      int start_token)
-{
-	char *o = strdup(str);
-	char *s = NULL;
-	char *t = o;
-	char *p;
-	int len = 0;
-
-	if (!o)
-		return ret;
-	while ((p = strsep(&t, ",")) != NULL) {
-		if (s)
-			str_append(&s, &len, ",");
-		str_append(&s, &len, "cpu/");
-		str_append(&s, &len, p);
-		str_append(&s, &len, "/");
-	}
-	free(o);
-	if (!s)
-		return -ENOMEM;
-	return parse_events__scanner(s, data, start_token);
-}
-
 static int parse_events__scanner(const char *str, void *data, int start_token)
 {
 	YY_BUFFER_STATE buffer;
@@ -909,8 +883,6 @@ static int parse_events__scanner(const char *str, void *data, int start_token)
 	parse_events__flush_buffer(buffer, scanner);
 	parse_events__delete_buffer(buffer, scanner);
 	parse_events_lex_destroy(scanner);
-	if (ret && !strchr(str, '/'))
-		ret = parse_events_fixup(ret, str, data, start_token);
 	return ret;
 }
 
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 2553e5b..4b0ff22 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -387,27 +387,3 @@ void *memdup(const void *src, size_t len)
 
 	return p;
 }
-
-/**
- * str_append - reallocate string and append another
- * @s: pointer to string pointer
- * @len: pointer to len (initialized)
- * @a: string to append.
- */
-int str_append(char **s, int *len, const char *a)
-{
-	int olen = *s ? strlen(*s) : 0;
-	int nlen = olen + strlen(a) + 1;
-	if (*len < nlen) {
-		*len = *len * 2;
-		if (*len < nlen)
-			*len = nlen;
-		*s = realloc(*s, *len);
-		if (!*s)
-			return -ENOMEM;
-		if (olen == 0)
-			**s = 0;
-	}
-	strcat(*s, a);
-	return 0;
-}
-- 
1.8.3.2

