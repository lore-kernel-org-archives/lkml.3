Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171AbaAaU2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:28:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55432 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078AbaAaU17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:27:59 -0500
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
Subject: [PATCH 07/12] perf machine: Set up ref_reloc_sym in machine__create_kernel_maps()
Date: Fri, 31 Jan 2014 17:27:30 -0300
Message-Id: <1391200055-18250-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1391200055-18250-1-git-send-email-acme@infradead.org>
References: <1391200055-18250-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The ref_reloc_sym is always needed for the kernel map in order to check
for relocation.  Consequently set it up when the kernel map is created.
Otherwise it was only being set up by 'perf record'.

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
Link: http://lkml.kernel.org/r/1391004884-10334-5-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 23 +++++++++++++++++++++++
 tools/perf/util/machine.h |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 290c2e6d4001..c872991e0f65 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -832,9 +832,25 @@ static int machine__create_modules(struct machine *machine)
 	return 0;
 }
 
+const char *ref_reloc_sym_names[] = {"_text", "_stext", NULL};
+
 int machine__create_kernel_maps(struct machine *machine)
 {
 	struct dso *kernel = machine__get_kernel(machine);
+	char filename[PATH_MAX];
+	const char *name;
+	u64 addr = 0;
+	int i;
+
+	machine__get_kallsyms_filename(machine, filename, PATH_MAX);
+
+	for (i = 0; (name = ref_reloc_sym_names[i]) != NULL; i++) {
+		addr = kallsyms__get_function_start(filename, name);
+		if (addr)
+			break;
+	}
+	if (!addr)
+		return -1;
 
 	if (kernel == NULL ||
 	    __machine__create_kernel_maps(machine, kernel) < 0)
@@ -853,6 +869,13 @@ int machine__create_kernel_maps(struct machine *machine)
 	 * Now that we have all the maps created, just set the ->end of them:
 	 */
 	map_groups__fixup_end(&machine->kmaps);
+
+	if (maps__set_kallsyms_ref_reloc_sym(machine->vmlinux_maps, name,
+					     addr)) {
+		machine__destroy_kernel_maps(machine);
+		return -1;
+	}
+
 	return 0;
 }
 
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 477133015440..f77e91e483dc 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -18,6 +18,8 @@ union perf_event;
 #define	HOST_KERNEL_ID			(-1)
 #define	DEFAULT_GUEST_KERNEL_ID		(0)
 
+extern const char *ref_reloc_sym_names[];
+
 struct machine {
 	struct rb_node	  rb_node;
 	pid_t		  pid;
-- 
1.8.1.4

