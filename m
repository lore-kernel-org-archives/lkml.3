Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaBBI4L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 03:56:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41376 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaBBI4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 03:56:07 -0500
Date: Sun, 2 Feb 2014 00:55:43 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-5512cf24bed2de56f1ef44b6cc9a0a9b15499cea@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1391004884-10334-5-git-send-email-adrian.hunter@intel.com>
References: <1391004884-10334-5-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf machine:
  Set up ref_reloc_sym in machine__create_kernel_maps()
Git-Commit-ID: 5512cf24bed2de56f1ef44b6cc9a0a9b15499cea
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 02 Feb 2014 00:55:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5512cf24bed2de56f1ef44b6cc9a0a9b15499cea
Gitweb:     http://git.kernel.org/tip/5512cf24bed2de56f1ef44b6cc9a0a9b15499cea
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 29 Jan 2014 16:14:39 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 31 Jan 2014 17:21:49 -0300

perf machine: Set up ref_reloc_sym in machine__create_kernel_maps()

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
