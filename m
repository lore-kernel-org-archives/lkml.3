Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbbA2IK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:10:58 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51669 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbbA2IKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:21 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 40/42] perf callchain: Save eh/debug frame offset for dwarf unwind
Date: Thu, 29 Jan 2015 17:07:21 +0900
Message-Id: <1422518843-25818-41-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
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
index c18fcc0e8081..323ee08d56fc 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -141,6 +141,7 @@ struct dso {
 		u32		 status_seen;
 		size_t		 file_size;
 		struct list_head open_entry;
+		u64		 frame_offset;
 	} data;
 
 	union { /* Tool specific area */
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index 7ed6eaf232b6..3219b20837b5 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -266,14 +266,17 @@ static int read_unwind_spec_eh_frame(struct dso *dso, struct machine *machine,
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
@@ -287,14 +290,20 @@ static int read_unwind_spec_eh_frame(struct dso *dso, struct machine *machine,
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
2.2.2

