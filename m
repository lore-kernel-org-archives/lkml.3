Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaA2ONU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:13:20 -0500
Received: from mga14.intel.com ([143.182.124.37]:53968 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbaA2ONN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:13:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,742,1384329600"; 
   d="scan'208";a="466608358"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 4/9] perf tools: Set up ref_reloc_sym in machine__create_kernel_maps()
Date: Wed, 29 Jan 2014 16:14:39 +0200
Message-Id: <1391004884-10334-5-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com>
References: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ref_reloc_sym is always needed for the
kernel map in order to check for relocation.
Consequently set it up when the kernel map is
created.  Otherwise it was only being set up
by 'perf record'.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 23 +++++++++++++++++++++++
 tools/perf/util/machine.h |  2 ++
 2 files changed, 25 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 290c2e6..c872991 100644
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
index 4771330..f77e91e 100644
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
1.7.11.7

