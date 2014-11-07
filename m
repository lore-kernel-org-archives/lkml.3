Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaKGFbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:31:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57873 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaKGFb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:31:29 -0500
Date: Thu, 6 Nov 2014 21:31:11 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-b837a8bdc48925e6512412973b845c53cbe2b412@git.kernel.org>
Cc: paulus@samba.org, mingo@kernel.org, namhyung.kim@lge.com, jolsa@redhat.com,
        acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        dsahern@gmail.com, adrian.hunter@intel.com, namhyung@kernel.org,
        tglx@linutronix.de, a.p.zijlstra@chello.nl, hpa@zytor.com
Reply-To: namhyung@kernel.org, dsahern@gmail.com, adrian.hunter@intel.com,
        eranian@google.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, paulus@samba.org,
        acme@redhat.com, mingo@kernel.org, namhyung.kim@lge.com,
        jolsa@redhat.com
In-Reply-To: <1415063674-17206-8-git-send-email-namhyung@kernel.org>
References: <20140924073356.GB1962@gmail.com>
	<1415063674-17206-8-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix build-id matching on vmlinux
Git-Commit-ID: b837a8bdc48925e6512412973b845c53cbe2b412
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

Commit-ID:  b837a8bdc48925e6512412973b845c53cbe2b412
Gitweb:     http://git.kernel.org/tip/b837a8bdc48925e6512412973b845c53cbe2b412
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 4 Nov 2014 10:14:33 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Nov 2014 10:14:08 -0300

perf tools: Fix build-id matching on vmlinux

There's a problem on finding correct kernel symbols when perf report
runs on a different kernel.  Although a part of the problem was solved
by the prior commit 0a7e6d1b6844 ("perf tools: Check recorded kernel
version when finding vmlinux"), there's a remaining problem still.

When perf records samples, it synthesizes the kernel map using
machine__mmap_name() and ref_reloc_sym like "[kernel.kallsyms]_text".
You can easily see it using 'perf report -D' command.

After finishing record, it goes through the recorded events to find
maps/dsos actually used.  And then record build-id info of them.

During this process, it needs to load symbols in a dso and it'd call
dso__load_vmlinux_path() since the default value of the symbol_conf.
try_vmlinux_path is true.  However it changes dso->long_name to a real
path of the vmlinux file (e.g. /lib/modules/3.16.4/build/vmlinux) if one
is running on a custom kernel.

It resulted in that perf report reads the build-id of the vmlinux, but
cannot use it since it only knows about the [kernel.kallsyms] map.  It
then falls back to possible vmlinux paths by using the recorded kernel
version (in case of a recent version) or a running kernel silently.

Even with the recent tools, this still has a possibility of breaking
the result.  As the build directory is a symbolic link, if one built a
new kernel in the same directory with different source/config, the old
link to vmlinux will point the new file.  So it's absolutely needed to
use build-id when finding a kernel image.

In this patch, it's now changed to try to search a kernel dso in the
existing dso list which was constructed during build-id table parsing
so it'll always have a build-id.  If not found, search "[kernel.kallsyms]".

Before:

  $ perf report
  # Children      Self  Command  Shared Object      Symbol
  # ........  ........  .......  .................  ...............................
  #
      72.15%     0.00%  swapper  [kernel.kallsyms]  [k] set_curr_task_rt
      72.15%     0.00%  swapper  [kernel.kallsyms]  [k] native_calibrate_tsc
      72.15%     0.00%  swapper  [kernel.kallsyms]  [k] tsc_refine_calibration_work
      71.87%    71.87%  swapper  [kernel.kallsyms]  [k] module_finalize
   ...

After (for the same perf.data):

      72.15%     0.00%  swapper  vmlinux  [k] cpu_startup_entry
      72.15%     0.00%  swapper  vmlinux  [k] arch_cpu_idle
      72.15%     0.00%  swapper  vmlinux  [k] default_idle
      71.87%    71.87%  swapper  vmlinux  [k] native_safe_halt
   ...

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/20140924073356.GB1962@gmail.com
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1415063674-17206-8-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c  |  2 +-
 tools/perf/util/machine.c | 16 ++++++++++++++--
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 3e2c156..76442ca 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1269,7 +1269,7 @@ static int __event_process_build_id(struct build_id_event *bev,
 
 		dso__set_build_id(dso, &bev->build_id);
 
-		if (filename[0] == '[')
+		if (!is_kernel_module(filename, NULL))
 			dso->kernel = dso_type;
 
 		build_id__sprintf(dso->build_id, sizeof(dso->build_id),
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 946c7d6..53f90e9 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1085,8 +1085,20 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
 		 * Should be there already, from the build-id table in
 		 * the header.
 		 */
-		struct dso *kernel = __dsos__findnew(&machine->kernel_dsos,
-						     kmmap_prefix);
+		struct dso *kernel = NULL;
+		struct dso *dso;
+
+		list_for_each_entry(dso, &machine->kernel_dsos.head, node) {
+			if (is_kernel_module(dso->long_name, NULL))
+				continue;
+
+			kernel = dso;
+			break;
+		}
+
+		if (kernel == NULL)
+			kernel = __dsos__findnew(&machine->kernel_dsos,
+						 kmmap_prefix);
 		if (kernel == NULL)
 			goto out_problem;
 
