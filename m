Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab3AYLGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:06:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41275 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab3AYLGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:06:30 -0500
Date: Fri, 25 Jan 2013 03:06:07 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-5323f60c7578e9ddc92d1ca8a2d7b08284624cd1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, acme@ghostprotocols.net, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1355726345-29553-4-git-send-email-namhyung@kernel.org>
References: <1355726345-29553-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf header: Ensure read/
 write finished successfully
Git-Commit-ID: 5323f60c7578e9ddc92d1ca8a2d7b08284624cd1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:06:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5323f60c7578e9ddc92d1ca8a2d7b08284624cd1
Gitweb:     http://git.kernel.org/tip/5323f60c7578e9ddc92d1ca8a2d7b08284624cd1
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 17 Dec 2012 15:38:54 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:11 -0300

perf header: Ensure read/write finished successfully

Use readn instead of read and check return value of do_write.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1355726345-29553-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 63 +++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b7da463..bb578d2 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -148,7 +148,7 @@ static char *do_read_string(int fd, struct perf_header *ph)
 	u32 len;
 	char *buf;
 
-	sz = read(fd, &len, sizeof(len));
+	sz = readn(fd, &len, sizeof(len));
 	if (sz < (ssize_t)sizeof(len))
 		return NULL;
 
@@ -159,7 +159,7 @@ static char *do_read_string(int fd, struct perf_header *ph)
 	if (!buf)
 		return NULL;
 
-	ret = read(fd, buf, len);
+	ret = readn(fd, buf, len);
 	if (ret == (ssize_t)len) {
 		/*
 		 * strings are padded by zeroes
@@ -1051,16 +1051,25 @@ static int write_pmu_mappings(int fd, struct perf_header *h __maybe_unused,
 	struct perf_pmu *pmu = NULL;
 	off_t offset = lseek(fd, 0, SEEK_CUR);
 	__u32 pmu_num = 0;
+	int ret;
 
 	/* write real pmu_num later */
-	do_write(fd, &pmu_num, sizeof(pmu_num));
+	ret = do_write(fd, &pmu_num, sizeof(pmu_num));
+	if (ret < 0)
+		return ret;
 
 	while ((pmu = perf_pmu__scan(pmu))) {
 		if (!pmu->name)
 			continue;
 		pmu_num++;
-		do_write(fd, &pmu->type, sizeof(pmu->type));
-		do_write_string(fd, pmu->name);
+
+		ret = do_write(fd, &pmu->type, sizeof(pmu->type));
+		if (ret < 0)
+			return ret;
+
+		ret = do_write_string(fd, pmu->name);
+		if (ret < 0)
+			return ret;
 	}
 
 	if (pwrite(fd, &pmu_num, sizeof(pmu_num), offset) != sizeof(pmu_num)) {
@@ -1209,14 +1218,14 @@ read_event_desc(struct perf_header *ph, int fd)
 	size_t msz;
 
 	/* number of events */
-	ret = read(fd, &nre, sizeof(nre));
+	ret = readn(fd, &nre, sizeof(nre));
 	if (ret != (ssize_t)sizeof(nre))
 		goto error;
 
 	if (ph->needs_swap)
 		nre = bswap_32(nre);
 
-	ret = read(fd, &sz, sizeof(sz));
+	ret = readn(fd, &sz, sizeof(sz));
 	if (ret != (ssize_t)sizeof(sz))
 		goto error;
 
@@ -1244,7 +1253,7 @@ read_event_desc(struct perf_header *ph, int fd)
 		 * must read entire on-file attr struct to
 		 * sync up with layout.
 		 */
-		ret = read(fd, buf, sz);
+		ret = readn(fd, buf, sz);
 		if (ret != (ssize_t)sz)
 			goto error;
 
@@ -1253,7 +1262,7 @@ read_event_desc(struct perf_header *ph, int fd)
 
 		memcpy(&evsel->attr, buf, msz);
 
-		ret = read(fd, &nr, sizeof(nr));
+		ret = readn(fd, &nr, sizeof(nr));
 		if (ret != (ssize_t)sizeof(nr))
 			goto error;
 
@@ -1274,7 +1283,7 @@ read_event_desc(struct perf_header *ph, int fd)
 		evsel->id = id;
 
 		for (j = 0 ; j < nr; j++) {
-			ret = read(fd, id, sizeof(*id));
+			ret = readn(fd, id, sizeof(*id));
 			if (ret != (ssize_t)sizeof(*id))
 				goto error;
 			if (ph->needs_swap)
@@ -1506,14 +1515,14 @@ static int perf_header__read_build_ids_abi_quirk(struct perf_header *header,
 	while (offset < limit) {
 		ssize_t len;
 
-		if (read(input, &old_bev, sizeof(old_bev)) != sizeof(old_bev))
+		if (readn(input, &old_bev, sizeof(old_bev)) != sizeof(old_bev))
 			return -1;
 
 		if (header->needs_swap)
 			perf_event_header__bswap(&old_bev.header);
 
 		len = old_bev.header.size - sizeof(old_bev);
-		if (read(input, filename, len) != len)
+		if (readn(input, filename, len) != len)
 			return -1;
 
 		bev.header = old_bev.header;
@@ -1548,14 +1557,14 @@ static int perf_header__read_build_ids(struct perf_header *header,
 	while (offset < limit) {
 		ssize_t len;
 
-		if (read(input, &bev, sizeof(bev)) != sizeof(bev))
+		if (readn(input, &bev, sizeof(bev)) != sizeof(bev))
 			goto out;
 
 		if (header->needs_swap)
 			perf_event_header__bswap(&bev.header);
 
 		len = bev.header.size - sizeof(bev);
-		if (read(input, filename, len) != len)
+		if (readn(input, filename, len) != len)
 			goto out;
 		/*
 		 * The a1645ce1 changeset:
@@ -1641,7 +1650,7 @@ static int process_nrcpus(struct perf_file_section *section __maybe_unused,
 	size_t ret;
 	u32 nr;
 
-	ret = read(fd, &nr, sizeof(nr));
+	ret = readn(fd, &nr, sizeof(nr));
 	if (ret != sizeof(nr))
 		return -1;
 
@@ -1650,7 +1659,7 @@ static int process_nrcpus(struct perf_file_section *section __maybe_unused,
 
 	ph->env.nr_cpus_online = nr;
 
-	ret = read(fd, &nr, sizeof(nr));
+	ret = readn(fd, &nr, sizeof(nr));
 	if (ret != sizeof(nr))
 		return -1;
 
@@ -1684,7 +1693,7 @@ static int process_total_mem(struct perf_file_section *section __maybe_unused,
 	uint64_t mem;
 	size_t ret;
 
-	ret = read(fd, &mem, sizeof(mem));
+	ret = readn(fd, &mem, sizeof(mem));
 	if (ret != sizeof(mem))
 		return -1;
 
@@ -1756,7 +1765,7 @@ static int process_cmdline(struct perf_file_section *section __maybe_unused,
 	u32 nr, i;
 	struct strbuf sb;
 
-	ret = read(fd, &nr, sizeof(nr));
+	ret = readn(fd, &nr, sizeof(nr));
 	if (ret != sizeof(nr))
 		return -1;
 
@@ -1792,7 +1801,7 @@ static int process_cpu_topology(struct perf_file_section *section __maybe_unused
 	char *str;
 	struct strbuf sb;
 
-	ret = read(fd, &nr, sizeof(nr));
+	ret = readn(fd, &nr, sizeof(nr));
 	if (ret != sizeof(nr))
 		return -1;
 
@@ -1813,7 +1822,7 @@ static int process_cpu_topology(struct perf_file_section *section __maybe_unused
 	}
 	ph->env.sibling_cores = strbuf_detach(&sb, NULL);
 
-	ret = read(fd, &nr, sizeof(nr));
+	ret = readn(fd, &nr, sizeof(nr));
 	if (ret != sizeof(nr))
 		return -1;
 
@@ -1850,7 +1859,7 @@ static int process_numa_topology(struct perf_file_section *section __maybe_unuse
 	struct strbuf sb;
 
 	/* nr nodes */
-	ret = read(fd, &nr, sizeof(nr));
+	ret = readn(fd, &nr, sizeof(nr));
 	if (ret != sizeof(nr))
 		goto error;
 
@@ -1862,15 +1871,15 @@ static int process_numa_topology(struct perf_file_section *section __maybe_unuse
 
 	for (i = 0; i < nr; i++) {
 		/* node number */
-		ret = read(fd, &node, sizeof(node));
+		ret = readn(fd, &node, sizeof(node));
 		if (ret != sizeof(node))
 			goto error;
 
-		ret = read(fd, &mem_total, sizeof(u64));
+		ret = readn(fd, &mem_total, sizeof(u64));
 		if (ret != sizeof(u64))
 			goto error;
 
-		ret = read(fd, &mem_free, sizeof(u64));
+		ret = readn(fd, &mem_free, sizeof(u64));
 		if (ret != sizeof(u64))
 			goto error;
 
@@ -1909,7 +1918,7 @@ static int process_pmu_mappings(struct perf_file_section *section __maybe_unused
 	u32 type;
 	struct strbuf sb;
 
-	ret = read(fd, &pmu_num, sizeof(pmu_num));
+	ret = readn(fd, &pmu_num, sizeof(pmu_num));
 	if (ret != sizeof(pmu_num))
 		return -1;
 
@@ -1925,7 +1934,7 @@ static int process_pmu_mappings(struct perf_file_section *section __maybe_unused
 	strbuf_init(&sb, 128);
 
 	while (pmu_num) {
-		if (read(fd, &type, sizeof(type)) != sizeof(type))
+		if (readn(fd, &type, sizeof(type)) != sizeof(type))
 			goto error;
 		if (ph->needs_swap)
 			type = bswap_32(type);
@@ -2912,7 +2921,7 @@ int perf_event__process_tracing_data(union perf_event *event,
 				 session->repipe);
 	padding = PERF_ALIGN(size_read, sizeof(u64)) - size_read;
 
-	if (read(session->fd, buf, padding) < 0)
+	if (readn(session->fd, buf, padding) < 0)
 		die("reading input file");
 	if (session->repipe) {
 		int retw = write(STDOUT_FILENO, buf, padding);
