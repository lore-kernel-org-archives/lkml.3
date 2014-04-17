Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaDQRkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:40:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbaDQRji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:39:38 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 2/3] perf tools: Cache dso data file descriptor
Date: Thu, 17 Apr 2014 19:39:11 +0200
Message-Id: <1397756352-26694-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397756352-26694-1-git-send-email-jolsa@redhat.com>
References: <1397756352-26694-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keeping the data file description open for the whole life
of the dso object.

The report shows just little speedup in dso__data_fd function
for report command processing dwarf unwind stacks.

Output from report over 1.5 GB data with DWARF unwind stacks:
(TODO fix perf diff)

  current code:
   0.22%  perf.old  perf.old                   [.] dso__data_fd

  change:
   0.15%  perf      perf                       [.] dso__data_fd

But a bigger overall speedup:

 Performance counter stats for './perf.old report -i perf-test.data --stdio':

   126,055,895,573      cycles:u                  #    2.463 GHz
   168,964,795,208      instructions:u            #    1.34  insns per cycle
      51174.366434      task-clock (msec)         #    0.997 CPUs utilized

      51.306236943 seconds time elapsed

 Performance counter stats for './perf report -i perf-test.data --stdio':

   112,531,906,656      cycles:u                  #    2.680 GHz
   163,466,037,207      instructions:u            #    1.45  insns per cycle
      41991.297576      task-clock (msec)         #    1.000 CPUs utilized

      41.985142753 seconds time elapsed

Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jean Pihet <jean.pihet@linaro.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/dso.c              | 15 +++++++++++----
 tools/perf/util/dso.h              |  1 +
 tools/perf/util/unwind-libunwind.c |  2 --
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 64453d6..0dca5d6 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -159,6 +159,12 @@ static int open_dso(struct dso *dso, struct machine *machine)
 	return fd;
 }
 
+static void dso__data_close(struct dso *dso)
+{
+	if (dso->data_fd >= 0)
+		close(dso->data_fd);
+}
+
 int dso__data_fd(struct dso *dso, struct machine *machine)
 {
 	enum dso_binary_type binary_type_data[] = {
@@ -168,8 +174,8 @@ int dso__data_fd(struct dso *dso, struct machine *machine)
 	};
 	int i = 0;
 
-	if (dso->binary_type != DSO_BINARY_TYPE__NOT_FOUND)
-		return open_dso(dso, machine);
+	if (dso->data_fd >= 0)
+		return dso->data_fd;
 
 	do {
 		int fd;
@@ -178,7 +184,7 @@ int dso__data_fd(struct dso *dso, struct machine *machine)
 
 		fd = open_dso(dso, machine);
 		if (fd >= 0)
-			return fd;
+			return dso->data_fd = fd;
 
 	} while (dso->binary_type != DSO_BINARY_TYPE__NOT_FOUND);
 
@@ -301,7 +307,6 @@ dso_cache__read(struct dso *dso, struct machine *machine,
 	if (ret <= 0)
 		free(cache);
 
-	close(fd);
 	return ret;
 }
 
@@ -485,6 +490,7 @@ struct dso *dso__new(const char *name)
 		dso->kernel = DSO_TYPE_USER;
 		dso->needs_swap = DSO_SWAP__UNSET;
 		INIT_LIST_HEAD(&dso->node);
+		dso->data_fd = -1;
 	}
 
 	return dso;
@@ -506,6 +512,7 @@ void dso__delete(struct dso *dso)
 		dso->long_name_allocated = false;
 	}
 
+	dso__data_close(dso);
 	dso_cache__free(&dso->cache);
 	dso__free_a2l(dso);
 	zfree(&dso->symsrc_filename);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index ab06f1c..6e48cdc 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -99,6 +99,7 @@ struct dso {
 	const char	 *long_name;
 	u16		 long_name_len;
 	u16		 short_name_len;
+	int		 data_fd;
 	char		 name[0];
 };
 
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index bd5768d..25578b9 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -250,7 +250,6 @@ static int read_unwind_spec_eh_frame(struct dso *dso, struct machine *machine,
 
 	/* Check the .eh_frame section for unwinding info */
 	offset = elf_section_offset(fd, ".eh_frame_hdr");
-	close(fd);
 
 	if (offset)
 		ret = unwind_spec_ehframe(dso, machine, offset,
@@ -271,7 +270,6 @@ static int read_unwind_spec_debug_frame(struct dso *dso,
 
 	/* Check the .debug_frame section for unwinding info */
 	*offset = elf_section_offset(fd, ".debug_frame");
-	close(fd);
 
 	if (*offset)
 		return 0;
-- 
1.8.3.1

