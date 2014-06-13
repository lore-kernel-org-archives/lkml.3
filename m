Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaFMGZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:25:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44103 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaFMGZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:25:32 -0400
Date: Thu, 12 Jun 2014 23:25:15 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-53fa8eaa093ad87eb59379de059e76d735a5de45@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1401892622-30848-4-git-send-email-jolsa@kernel.org>
References: <1401892622-30848-4-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add data_fd into dso object
Git-Commit-ID: 53fa8eaa093ad87eb59379de059e76d735a5de45
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

Commit-ID:  53fa8eaa093ad87eb59379de059e76d735a5de45
Gitweb:     http://git.kernel.org/tip/53fa8eaa093ad87eb59379de059e76d735a5de45
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 28 Apr 2014 16:43:43 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 12 Jun 2014 16:53:19 +0200

perf tools: Add data_fd into dso object

Adding data_fd into dso object so we could handle caching
of opened dso file data descriptors coming int next patches.

Adding dso__data_close interface to keep the data_fd updated
when the descriptor is closed.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1401892622-30848-4-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/dso.c              | 23 +++++++++++++++++++----
 tools/perf/util/dso.h              |  3 +++
 tools/perf/util/unwind-libunwind.c |  4 ++--
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 1c3cdaf..5acb4b8 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -159,6 +159,14 @@ static int open_dso(struct dso *dso, struct machine *machine)
 	return fd;
 }
 
+void dso__data_close(struct dso *dso)
+{
+	if (dso->data.fd >= 0) {
+		close(dso->data.fd);
+		dso->data.fd = -1;
+	}
+}
+
 int dso__data_fd(struct dso *dso, struct machine *machine)
 {
 	enum dso_binary_type binary_type_data[] = {
@@ -168,8 +176,13 @@ int dso__data_fd(struct dso *dso, struct machine *machine)
 	};
 	int i = 0;
 
-	if (dso->binary_type != DSO_BINARY_TYPE__NOT_FOUND)
-		return open_dso(dso, machine);
+	if (dso->data.fd >= 0)
+		return dso->data.fd;
+
+	if (dso->binary_type != DSO_BINARY_TYPE__NOT_FOUND) {
+		dso->data.fd = open_dso(dso, machine);
+		return dso->data.fd;
+	}
 
 	do {
 		int fd;
@@ -178,7 +191,7 @@ int dso__data_fd(struct dso *dso, struct machine *machine)
 
 		fd = open_dso(dso, machine);
 		if (fd >= 0)
-			return fd;
+			return dso->data.fd = fd;
 
 	} while (dso->binary_type != DSO_BINARY_TYPE__NOT_FOUND);
 
@@ -301,7 +314,7 @@ dso_cache__read(struct dso *dso, struct machine *machine,
 	if (ret <= 0)
 		free(cache);
 
-	close(fd);
+	dso__data_close(dso);
 	return ret;
 }
 
@@ -474,6 +487,7 @@ struct dso *dso__new(const char *name)
 		for (i = 0; i < MAP__NR_TYPES; ++i)
 			dso->symbols[i] = dso->symbol_names[i] = RB_ROOT;
 		dso->data.cache = RB_ROOT;
+		dso->data.fd = -1;
 		dso->symtab_type = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->binary_type = DSO_BINARY_TYPE__NOT_FOUND;
 		dso->loaded = 0;
@@ -506,6 +520,7 @@ void dso__delete(struct dso *dso)
 		dso->long_name_allocated = false;
 	}
 
+	dso__data_close(dso);
 	dso_cache__free(&dso->data.cache);
 	dso__free_a2l(dso);
 	zfree(&dso->symsrc_filename);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 7637fdd..e48dcf5 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -102,6 +102,7 @@ struct dso {
 	/* dso data file */
 	struct {
 		struct rb_root	 cache;
+		int		 fd;
 	} data;
 
 	char		 name[0];
@@ -147,6 +148,8 @@ int dso__read_binary_type_filename(const struct dso *dso, enum dso_binary_type t
 				   char *root_dir, char *filename, size_t size);
 
 int dso__data_fd(struct dso *dso, struct machine *machine);
+void dso__data_close(struct dso *dso);
+
 ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 			      u64 offset, u8 *data, ssize_t size);
 ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index bd5768d..4f8dd9e 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -250,7 +250,7 @@ static int read_unwind_spec_eh_frame(struct dso *dso, struct machine *machine,
 
 	/* Check the .eh_frame section for unwinding info */
 	offset = elf_section_offset(fd, ".eh_frame_hdr");
-	close(fd);
+	dso__data_close(dso);
 
 	if (offset)
 		ret = unwind_spec_ehframe(dso, machine, offset,
@@ -271,7 +271,7 @@ static int read_unwind_spec_debug_frame(struct dso *dso,
 
 	/* Check the .debug_frame section for unwinding info */
 	*offset = elf_section_offset(fd, ".debug_frame");
-	close(fd);
+	dso__data_close(dso);
 
 	if (*offset)
 		return 0;
