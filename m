Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173AbaAaUbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:31:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55418 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494AbaAaU16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:27:58 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/12] perf machine: Add machine__get_kallsyms_filename()
Date: Fri, 31 Jan 2014 17:27:29 -0300
Message-Id: <1391200055-18250-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1391200055-18250-1-git-send-email-acme@infradead.org>
References: <1391200055-18250-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Separate out the logic used to make the kallsyms full path name for a
machine.  It will be reused in a subsequent patch.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1391004884-10334-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index ded74590b92f..290c2e6d4001 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -496,19 +496,22 @@ static int symbol__in_kernel(void *arg, const char *name,
 	return 1;
 }
 
+static void machine__get_kallsyms_filename(struct machine *machine, char *buf,
+					   size_t bufsz)
+{
+	if (machine__is_default_guest(machine))
+		scnprintf(buf, bufsz, "%s", symbol_conf.default_guest_kallsyms);
+	else
+		scnprintf(buf, bufsz, "%s/proc/kallsyms", machine->root_dir);
+}
+
 /* Figure out the start address of kernel map from /proc/kallsyms */
 static u64 machine__get_kernel_start_addr(struct machine *machine)
 {
-	const char *filename;
-	char path[PATH_MAX];
+	char filename[PATH_MAX];
 	struct process_args args;
 
-	if (machine__is_default_guest(machine))
-		filename = (char *)symbol_conf.default_guest_kallsyms;
-	else {
-		sprintf(path, "%s/proc/kallsyms", machine->root_dir);
-		filename = path;
-	}
+	machine__get_kallsyms_filename(machine, filename, PATH_MAX);
 
 	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
 		return 0;
-- 
1.8.1.4

