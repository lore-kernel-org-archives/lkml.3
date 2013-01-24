Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab3AXTLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:11:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33308 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3AXTLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:11:03 -0500
Date: Thu, 24 Jan 2013 11:10:34 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-64ezdtiijolgti08ae3phxyj@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Decode read_format and sample_type in perf_evsel__fprintf
Git-Commit-ID: c79a439338f3a021f5a5ff6ea165b0d19d2eb0aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 11:10:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c79a439338f3a021f5a5ff6ea165b0d19d2eb0aa
Gitweb:     http://git.kernel.org/tip/c79a439338f3a021f5a5ff6ea165b0d19d2eb0aa
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 11 Dec 2012 10:54:12 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Dec 2012 17:21:02 -0300

perf evsel: Decode read_format and sample_type in perf_evsel__fprintf

Before those fields showed just a number, now it decodes each bit:

[root@sandy linux]# perf evlist -v
cycles: sample_freq=4000, size: 96, sample_type: IP|TID|TIME|CPU|PERIOD, read_format: TOTAL_TIME_ENABLED|TOTAL_TIME_RUNNING|ID, disabled: 1, inherit: 1, mmap: 1, comm: 1, freq: 1, sample_id_all: 1, exclude_guest: 1

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-64ezdtiijolgti08ae3phxyj@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 643df4b..7a2a3dc 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1257,6 +1257,53 @@ static int __if_fprintf(FILE *fp, bool *first, const char *field, u64 value)
 
 #define if_print(field) printed += __if_fprintf(fp, &first, #field, evsel->attr.field)
 
+struct bit_names {
+	int bit;
+	const char *name;
+};
+
+static int bits__fprintf(FILE *fp, const char *field, u64 value,
+			 struct bit_names *bits, bool *first)
+{
+	int i = 0, printed = comma_fprintf(fp, first, " %s: ", field);
+	bool first_bit = true;
+
+	do {
+		if (value & bits[i].bit) {
+			printed += fprintf(fp, "%s%s", first_bit ? "" : "|", bits[i].name);
+			first_bit = false;
+		}
+	} while (bits[++i].name != NULL);
+
+	return printed;
+}
+
+static int sample_type__fprintf(FILE *fp, bool *first, u64 value)
+{
+#define bit_name(n) { PERF_SAMPLE_##n, #n }
+	struct bit_names bits[] = {
+		bit_name(IP), bit_name(TID), bit_name(TIME), bit_name(ADDR),
+		bit_name(READ), bit_name(CALLCHAIN), bit_name(ID), bit_name(CPU),
+		bit_name(PERIOD), bit_name(STREAM_ID), bit_name(RAW),
+		bit_name(BRANCH_STACK), bit_name(REGS_USER), bit_name(STACK_USER),
+		{ .name = NULL, }
+	};
+#undef bit_name
+	return bits__fprintf(fp, "sample_type", value, bits, first);
+}
+
+static int read_format__fprintf(FILE *fp, bool *first, u64 value)
+{
+#define bit_name(n) { PERF_FORMAT_##n, #n }
+	struct bit_names bits[] = {
+		bit_name(TOTAL_TIME_ENABLED), bit_name(TOTAL_TIME_RUNNING),
+		bit_name(ID), bit_name(GROUP),
+		{ .name = NULL, }
+	};
+#undef bit_name
+	return bits__fprintf(fp, "read_format", value, bits, first);
+}
+
 int perf_evsel__fprintf(struct perf_evsel *evsel,
 			struct perf_attr_details *details, FILE *fp)
 {
@@ -1274,8 +1321,9 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
 		if_print(config1);
 		if_print(config2);
 		if_print(size);
-		if_print(sample_type);
-		if_print(read_format);
+		printed += sample_type__fprintf(fp, &first, evsel->attr.sample_type);
+		if (evsel->attr.read_format)
+			printed += read_format__fprintf(fp, &first, evsel->attr.read_format);
 		if_print(disabled);
 		if_print(inherit);
 		if_print(pinned);
