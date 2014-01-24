Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaAXPJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:09:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:53226 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbaAXPJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:09:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,713,1384329600"; 
   d="scan'208";a="471901256"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/8] perf tools: Set up ref_reloc_sym in machine__create_kernel_maps()
Date: Fri, 24 Jan 2014 17:10:14 +0200
Message-Id: <1390576218-1463-5-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1390576218-1463-1-git-send-email-adrian.hunter@intel.com>
References: <1390576218-1463-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ref_reloc_sym is always needed for the
kernel map in order to check for relocation.
Consequently set it up when the kernel map is
created.  Otherwise it was only beging set up
by 'perf record'.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 290c2e6..58a4e92 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -835,6 +835,20 @@ static int machine__create_modules(struct machine *machine)
 int machine__create_kernel_maps(struct machine *machine)
 {
 	struct dso *kernel = machine__get_kernel(machine);
+	char filename[PATH_MAX];
+	const char *name;
+	u64 addr;
+
+	machine__get_kallsyms_filename(machine, filename, PATH_MAX);
+
+	name = "_text";
+	addr = kallsyms__get_function_start(filename, name);
+	if (!addr) {
+		name = "_stext";
+		addr = kallsyms__get_function_start("/proc/kallsyms", name);
+		if (!addr)
+			return -1;
+	}
 
 	if (kernel == NULL ||
 	    __machine__create_kernel_maps(machine, kernel) < 0)
@@ -853,6 +867,13 @@ int machine__create_kernel_maps(struct machine *machine)
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
 
-- 
1.7.11.7

