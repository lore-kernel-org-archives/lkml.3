Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaIEE7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 00:59:24 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:38492 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaIEE7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 00:59:22 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>, stable@vger.kernel.org
Subject: [PATCH v2] perf tools: Fix build-id matching on vmlinux
Date: Fri,  5 Sep 2014 13:59:17 +0900
Message-Id: <1409893157-469-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
dso__load_vmlinux() since the default value of the symbol_conf.try_
vmlinux_path is true.  However it changes dso->long_name to a real
path of the vmlinux file (e.g. /lib/modules/3.16.0-rc2+/build/vmlinux)
if one is running on a custom kernel.

It resulted in that perf report reads the build-id of the vmlinux, but
cannot use it since it only knows about the [kernel.kallsyms] map.  It
then falls back to possible vmlinux paths by using the recorded kernel
version (in case of a recent version) or a running kernel silently.

Even with the recent tools, this still has a possibility of breaking
the result.  As the build directory is a symbolic link, if one built a
new kernel in the same directory with different source/config, the old
link to vmlinux will point the new file.  So it's absolutely needed to
use build-id when finding a kernel image.

In this patch, it's now changed to try to search a kernel dso using
"vmlinux" shortname (which always has a build-id) and, if not found,
search "[kernel.kallsyms]".

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

Cc: stable@vger.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/machine.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b2ec38bf211e..d9f828f3b54f 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1060,10 +1060,14 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
 				strlen(kmmap_prefix));
 		/*
 		 * Should be there already, from the build-id table in
-		 * the header.
+		 * the header (but maybe with a different name: "vmlinux").
 		 */
-		struct dso *kernel = __dsos__findnew(&machine->kernel_dsos,
-						     kmmap_prefix);
+		struct dso *kernel = dsos__find(&machine->kernel_dsos,
+						"vmlinux", true);
+
+		if (kernel == NULL)
+			kernel = __dsos__findnew(&machine->kernel_dsos,
+						 kmmap_prefix);
 		if (kernel == NULL)
 			goto out_problem;
 
-- 
2.1.0

