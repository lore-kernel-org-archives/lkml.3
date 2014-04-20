Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161046AbaDTICv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 04:02:51 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:59969 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086AbaDTICp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 04:02:45 -0400
Date: Sun, 20 Apr 2014 10:02:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20140420080235.GA23749@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: fd741edc25600e1660abd00b5c1bbe967018c6a0 Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf into perf/urgent

Three small tooling fixes.

 Thanks,

	Ingo

------------------>
Adrien BAK (1):
      perf tools: Improve error reporting

Alexander Yarygin (1):
      perf kvm: Fix 'Min time' counting in report command

Vladimir Nikulichev (1):
      perf tools: Adjust symbols in VDSO


 tools/perf/builtin-kvm.c     | 1 +
 tools/perf/builtin-record.c  | 2 +-
 tools/perf/util/data.c       | 9 ++++++++-
 tools/perf/util/symbol-elf.c | 2 ++
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 21c164b..0f1e5a2 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -404,6 +404,7 @@ static struct kvm_event *kvm_alloc_init_event(struct event_key *key)
 	}
 
 	event->key = *key;
+	init_stats(&event->total.stats);
 	return event;
 }
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index eb524f9..8ce62ef 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -374,7 +374,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 
 	session = perf_session__new(file, false, NULL);
 	if (session == NULL) {
-		pr_err("Not enough memory for reading perf file header\n");
+		pr_err("Perf session creation failed.\n");
 		return -1;
 	}
 
diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 1fbcd8b..55de44e 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -86,10 +86,17 @@ static int open_file_read(struct perf_data_file *file)
 
 static int open_file_write(struct perf_data_file *file)
 {
+	int fd;
+
 	if (check_backup(file))
 		return -1;
 
-	return open(file->path, O_CREAT|O_RDWR|O_TRUNC, S_IRUSR|S_IWUSR);
+	fd = open(file->path, O_CREAT|O_RDWR|O_TRUNC, S_IRUSR|S_IWUSR);
+
+	if (fd < 0)
+		pr_err("failed to open %s : %s\n", file->path, strerror(errno));
+
+	return fd;
 }
 
 static int open_file(struct perf_data_file *file)
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 3b7dbf5..6864661 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -6,6 +6,7 @@
 #include <inttypes.h>
 
 #include "symbol.h"
+#include "vdso.h"
 #include <symbol/kallsyms.h>
 #include "debug.h"
 
@@ -618,6 +619,7 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 		GElf_Shdr shdr;
 		ss->adjust_symbols = (ehdr.e_type == ET_EXEC ||
 				ehdr.e_type == ET_REL ||
+				is_vdso_map(dso->short_name) ||
 				elf_section_by_name(elf, &ehdr, &shdr,
 						     ".gnu.prelink_undo",
 						     NULL) != NULL);
