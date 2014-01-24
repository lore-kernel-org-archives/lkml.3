Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaAXPJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:09:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:26769 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbaAXPJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:09:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,713,1384329600"; 
   d="scan'208";a="471901253"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/8] perf tools: Add machine__get_kallsyms_filename()
Date: Fri, 24 Jan 2014 17:10:13 +0200
Message-Id: <1390576218-1463-4-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1390576218-1463-1-git-send-email-adrian.hunter@intel.com>
References: <1390576218-1463-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out the logic used to make the
kallsyms full path name for a machine.
It will be reused in a subsequent patch.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index ded7459..290c2e6 100644
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
1.7.11.7

