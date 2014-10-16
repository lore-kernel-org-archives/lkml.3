Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaJPFWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:22:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33469 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaJPFWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:22:37 -0400
Date: Wed, 15 Oct 2014 22:22:22 -0700
From: tip-bot for Kan Liang <tipbot@zytor.com>
Message-ID: <tip-42f60c2d63b0d3f7230d28ac37c1da4885d4ee65@git.kernel.org>
Cc: tglx@linutronix.de, acme@redhat.com, jolsa@redhat.com, kan.liang@intel.com,
        hpa@zytor.com, ak@linux.intel.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: kan.liang@intel.com, tglx@linutronix.de, jolsa@redhat.com,
        acme@redhat.com, hpa@zytor.com, ak@linux.intel.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1412694532-23391-2-git-send-email-kan.liang@intel.com>
References: <1412694532-23391-2-git-send-email-kan.liang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] Revert "perf tools: Default to cpu//
  for events v5"
Git-Commit-ID: 42f60c2d63b0d3f7230d28ac37c1da4885d4ee65
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42f60c2d63b0d3f7230d28ac37c1da4885d4ee65
Gitweb:     http://git.kernel.org/tip/42f60c2d63b0d3f7230d28ac37c1da4885d4ee65
Author:     Kan Liang <kan.liang@intel.com>
AuthorDate: Tue, 7 Oct 2014 11:08:49 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Oct 2014 16:04:33 -0300

Revert "perf tools: Default to cpu// for events v5"

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
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1412694532-23391-2-git-send-email-kan.liang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index d87767f..6afd610 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -357,27 +357,3 @@ void *memdup(const void *src, size_t len)
 
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
