Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966024Ab3GSH6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:58:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35658 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965853Ab3GSHue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:50:34 -0400
Date: Fri, 19 Jul 2013 00:50:23 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-50e200f07948400694238e08e7add73df5ba8f83@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1366480949-32292-1-git-send-email-andi@firstfloor.org>
References: <1366480949-32292-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Default to cpu// for events v5
Git-Commit-ID: 50e200f07948400694238e08e7add73df5ba8f83
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:50:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50e200f07948400694238e08e7add73df5ba8f83
Gitweb:     http://git.kernel.org/tip/50e200f07948400694238e08e7add73df5ba8f83
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 20 Apr 2013 11:02:28 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:53:52 -0300

perf tools: Default to cpu// for events v5

When an event fails to parse and it's not in a new style format,
try to parse it again as a cpu event.

This allows to use sysfs exported events directly without //, so you can use

perf record -e mem-loads ...

instead of

perf record -e cpu/mem-loads/

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1366480949-32292-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/include/linux/string.h |  1 +
 tools/perf/util/parse-events.c         | 30 +++++++++++++++++++++++++++++-
 tools/perf/util/string.c               | 24 ++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/include/linux/string.h b/tools/perf/util/include/linux/string.h
index 6f19c54..97a8007 100644
--- a/tools/perf/util/include/linux/string.h
+++ b/tools/perf/util/include/linux/string.h
@@ -1,3 +1,4 @@
 #include <string.h>
 
 void *memdup(const void *src, size_t len);
+int str_append(char **s, int *len, const char *a);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index e853769..a5076f4 100644
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
@@ -823,6 +823,32 @@ int parse_events_name(struct list_head *list, char *name)
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
@@ -843,6 +869,8 @@ static int parse_events__scanner(const char *str, void *data, int start_token)
 	parse_events__flush_buffer(buffer, scanner);
 	parse_events__delete_buffer(buffer, scanner);
 	parse_events_lex_destroy(scanner);
+	if (ret && !strchr(str, '/'))
+		ret = parse_events_fixup(ret, str, data, start_token);
 	return ret;
 }
 
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 29c7b2c..f0b0c00 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -387,3 +387,27 @@ void *memdup(const void *src, size_t len)
 
 	return p;
 }
+
+/**
+ * str_append - reallocate string and append another
+ * @s: pointer to string pointer
+ * @len: pointer to len (initialized)
+ * @a: string to append.
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
