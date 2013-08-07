Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485Ab3HGVME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:12:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47120 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933427Ab3HGVLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/47] perf util: Add parse_nsec_time() function
Date: Wed,  7 Aug 2013 18:10:42 -0300
Message-Id: <1375909874-22073-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The parse_nsec_time() function is for parsing a string of time into
64-bit nsec value.  It's a preparation of time filtering in some of perf
commands.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: David Ahern <dsahern@gmail.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1370310629-9642-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.c | 33 +++++++++++++++++++++++++++++++++
 tools/perf/util/util.h |  2 ++
 2 files changed, 35 insertions(+)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 9a06584..6d17b18 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -328,3 +328,36 @@ void put_tracing_file(char *file)
 {
 	free(file);
 }
+
+int parse_nsec_time(const char *str, u64 *ptime)
+{
+	u64 time_sec, time_nsec;
+	char *end;
+
+	time_sec = strtoul(str, &end, 10);
+	if (*end != '.' && *end != '\0')
+		return -1;
+
+	if (*end == '.') {
+		int i;
+		char nsec_buf[10];
+
+		if (strlen(++end) > 9)
+			return -1;
+
+		strncpy(nsec_buf, end, 9);
+		nsec_buf[9] = '\0';
+
+		/* make it nsec precision */
+		for (i = strlen(nsec_buf); i < 9; i++)
+			nsec_buf[i] = '0';
+
+		time_nsec = strtoul(nsec_buf, &end, 10);
+		if (*end != '\0')
+			return -1;
+	} else
+		time_nsec = 0;
+
+	*ptime = time_sec * NSEC_PER_SEC + time_nsec;
+	return 0;
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index cc1574e..a535359 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -208,6 +208,8 @@ static inline int has_extension(const char *filename, const char *ext)
 #define NSEC_PER_MSEC	1000000L
 #endif
 
+int parse_nsec_time(const char *str, u64 *ptime);
+
 extern unsigned char sane_ctype[256];
 #define GIT_SPACE		0x01
 #define GIT_DIGIT		0x02
-- 
1.8.1.4

