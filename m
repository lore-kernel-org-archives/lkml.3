Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab3HLKTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:19:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47816 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307Ab3HLKTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:19:34 -0400
Date: Mon, 12 Aug 2013 03:18:56 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-3b47abe1b5f5446ab41a3a139b6075f46f77f21f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        andi@firstfloor.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1370310629-9642-1-git-send-email-namhyung@kernel.org>
References: <1370310629-9642-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf util: Add parse_nsec_time() function
Git-Commit-ID: 3b47abe1b5f5446ab41a3a139b6075f46f77f21f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:19:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b47abe1b5f5446ab41a3a139b6075f46f77f21f
Gitweb:     http://git.kernel.org/tip/3b47abe1b5f5446ab41a3a139b6075f46f77f21f
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 4 Jun 2013 10:50:29 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:26 -0300

perf util: Add parse_nsec_time() function

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
