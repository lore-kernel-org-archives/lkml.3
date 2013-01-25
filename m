Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3AYWdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:33:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:32870 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441Ab3AYWdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:33:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,541,1355126400"; 
   d="scan'208";a="276768182"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 17/18] perf, tools: Default to cpu// for events v5
Date: Fri, 25 Jan 2013 14:33:11 -0800
Message-Id: <1359153192-13409-18-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359153192-13409-1-git-send-email-andi@firstfloor.org>
References: <1359153192-13409-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When an event fails to parse and it's not in a new style format,
try to parse it again as a cpu event.

This allows to use sysfs exported events directly without //, so I can use

perf record -e tx-aborts ...

instead of

perf record -e cpu/tx-aborts/

v2: Handle multiple events
v3: Move to separate function
v4: Move library function to util/string.c
v5: Handle unhandleable errors
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/include/linux/string.h |    1 +
 tools/perf/util/parse-events.c         |   32 ++++++++++++++++++++++++++++++--
 tools/perf/util/string.c               |   25 +++++++++++++++++++++++++
 3 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/include/linux/string.h b/tools/perf/util/include/linux/string.h
index 6f19c54..97a8007 100644
--- a/tools/perf/util/include/linux/string.h
+++ b/tools/perf/util/include/linux/string.h
@@ -1,3 +1,4 @@
 #include <string.h>
 
 void *memdup(const void *src, size_t len);
+int str_append(char **s, int *len, const char *a);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index f6f6aaa..7c1250f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -6,7 +6,7 @@
 #include "parse-options.h"
 #include "parse-events.h"
 #include "exec_cmd.h"
-#include "string.h"
+#include "linux/string.h"
 #include "symbol.h"
 #include "cache.h"
 #include "header.h"
@@ -834,6 +834,32 @@ int parse_events_name(struct list_head *list, char *name)
 	return 0;
 }
 
+static int parse_events__scanner(const char *str, void *data, int start_token);
+
+static int parse_events_fixup(int ret, const char *str, void *data,
+			      int start_token)
+{
+	char *o = strdup(str);
+	char *s = NULL;
+	char *t = o;
+	char *p;
+	int len = 0;
+
+	if (!o)
+		return ret;
+	while ((p = strsep(&t, ",")) != NULL) {
+		if (s)
+			str_append(&s, &len, ",");
+		str_append(&s, &len, "cpu/");
+		str_append(&s, &len, p);
+		str_append(&s, &len, "/");
+	}
+	free(o);
+	if (!s)
+		return -ENOMEM;
+	return parse_events__scanner(s, data, start_token);
+}
+
 static int parse_events__scanner(const char *str, void *data, int start_token)
 {
 	YY_BUFFER_STATE buffer;
@@ -854,7 +880,9 @@ static int parse_events__scanner(const char *str, void *data, int start_token)
 	parse_events__flush_buffer(buffer, scanner);
 	parse_events__delete_buffer(buffer, scanner);
 	parse_events_lex_destroy(scanner);
-	return ret;
+	if (ret && !strchr(str, '/'))
+		ret = parse_events_fixup(ret, str, data, start_token);
+ 	return ret;
 }
 
 /*
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 29c7b2c..fce558b 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -387,3 +387,28 @@ void *memdup(const void *src, size_t len)
 
 	return p;
 }
+
+/**
+ * str_append - reallocate string and append another
+ * @s: pointer to string pointer
+ * @len: pointer to len (initialized)
+ * @a: string to append.
+ * Also allow the caller to mishandle unhandleable errors.
+ */
+int str_append(char **s, int *len, const char *a)
+{
+	int olen = *s ? strlen(*s) : 0;
+	int nlen = olen + strlen(a) + 1;
+	if (*len < nlen) {
+		*len = *len * 2;
+		if (*len < nlen)
+			*len = nlen;
+		*s = realloc(*s, *len);
+		if (!*s)
+			return -ENOMEM;
+		if (olen == 0)
+			**s = 0;
+	}
+	strcat(*s, a);
+	return 0;
+}
-- 
1.7.7.6

