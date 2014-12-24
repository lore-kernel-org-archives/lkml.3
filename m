Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaLXHQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:16:50 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:40329 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaLXHPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:15:44 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 35/37] perf callchain: Save eh/debug frame offset for dwarf unwind
Date: Wed, 24 Dec 2014 16:15:31 +0900
Message-Id: <1419405333-27952-36-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When libunwind tries to resolve callchains it needs to know the offset
of .eh_frame_hdr or .debug_frame to access the dso.  Since it calls
dso__data_fd(), it'll try to grab dso->lock everytime for same
information.  So save it to dso_data struct and reuse it.

Note that there's a window between dso__data_fd() and actual use of
the fd.  The fd could be closed by other threads to deal with the open
file limit in dso cache code.  But I think it's ok since in that case
elf_section_offset() will return 0 so it'll be tried in next acess.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/dso.h              |  1 +
 tools/perf/util/unwind-libunwind.c | 31 ++++++++++++++++++++-----------
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 28e8bb320495..5cf8dfe04eac 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -143,6 +143,7 @@ struct dso {
 		u32		 status_seen;
 		size_t		 file_size;
 		struct list_head open_entry;
+		u64		 frame_offset;
 	} data;
 
 	union { /* Tool specific area */
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index 94929ec491f3..3cb78c36faad 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -244,14 +244,17 @@ static int read_unwind_spec_eh_frame(struct dso *dso, struct machine *machine,
 				     u64 *fde_count)
 {
 	int ret = -EINVAL, fd;
-	u64 offset;
+	u64 offset = dso->data.frame_offset;
 
-	fd = dso__data_fd(dso, machine);
-	if (fd < 0)
-		return -EINVAL;
+	if (offset == 0) {
+		fd = dso__data_fd(dso, machine);
+		if (fd < 0)
+			return -EINVAL;
 
-	/* Check the .eh_frame section for unwinding info */
-	offset = elf_section_offset(fd, ".eh_frame_hdr");
+		/* Check the .eh_frame section for unwinding info */
+		offset = elf_section_offset(fd, ".eh_frame_hdr");
+		dso->data.frame_offset = offset;
+	}
 
 	if (offset)
 		ret = unwind_spec_ehframe(dso, machine, offset,
@@ -265,14 +268,20 @@ static int read_unwind_spec_eh_frame(struct dso *dso, struct machine *machine,
 static int read_unwind_spec_debug_frame(struct dso *dso,
 					struct machine *machine, u64 *offset)
 {
-	int fd = dso__data_fd(dso, machine);
+	int fd;
+	u64 ofs = dso->data.frame_offset;
 
-	if (fd < 0)
-		return -EINVAL;
+	if (ofs == 0) {
+		fd = dso__data_fd(dso, machine);
+		if (fd < 0)
+			return -EINVAL;
 
-	/* Check the .debug_frame section for unwinding info */
-	*offset = elf_section_offset(fd, ".debug_frame");
+		/* Check the .debug_frame section for unwinding info */
+		ofs = elf_section_offset(fd, ".debug_frame");
+		dso->data.frame_offset = ofs;
+	}
 
+	*offset = ofs;
 	if (*offset)
 		return 0;
 
-- 
2.1.3

