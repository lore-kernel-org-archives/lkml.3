Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaKDBRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:17:20 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:33064 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaKDBRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:17:03 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 8/8] perf tools: Make vmlinux short name more like kallsyms short name
Date: Tue,  4 Nov 2014 10:14:34 +0900
Message-Id: <1415063674-17206-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1415063674-17206-1-git-send-email-namhyung@kernel.org>
References: <1415063674-17206-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous patch changed kernel dso name from '[kernel.kallsyms]' to
vmlinux.  However it might add confusion to old users accustomed to
the old name.  So change the short name to '[kernel.vmlinux]' to
reduce such confusion.

Before:
  # Overhead  Command         Shared Object            Symbol
  # ........  ..............  .......................  ...............................
  #
       9.83%  swapper         vmlinux                  [k] intel_idle
       4.10%  awk             libc-2.20.so             [.] __strcmp_sse2
       1.86%  sed             libc-2.20.so             [.] __strcmp_sse2
       1.78%  netctl-auto     libc-2.20.so             [.] __strcmp_sse2
       1.23%  netctl-auto     libc-2.20.so             [.] __mbrtowc
       1.21%  firefox         libxul.so                [.] 0x00000000024b62bd
       1.20%  swapper         vmlinux                  [k] cpuidle_enter_state
       1.03%  sleep           vmlinux                  [k] copy_user_generic_unrolled

After:
  # Overhead  Command         Shared Object            Symbol
  # ........  ..............  .......................  ...............................
  #
       9.83%  swapper         [kernel.vmlinux]         [k] intel_idle
       4.10%  awk             libc-2.20.so             [.] __strcmp_sse2
       1.86%  sed             libc-2.20.so             [.] __strcmp_sse2
       1.78%  netctl-auto     libc-2.20.so             [.] __strcmp_sse2
       1.23%  netctl-auto     libc-2.20.so             [.] __mbrtowc
       1.21%  firefox         libxul.so                [.] 0x00000000024b62bd
       1.20%  swapper         [kernel.vmlinux]         [k] cpuidle_enter_state
       1.03%  sleep           [kernel.vmlinux]         [k] copy_user_generic_unrolled

Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/machine.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 53f90e9c65fe..52e94902afb1 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1106,6 +1106,9 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
 		if (__machine__create_kernel_maps(machine, kernel) < 0)
 			goto out_problem;
 
+		if (strstr(dso->long_name, "vmlinux"))
+			dso__set_short_name(dso, "[kernel.vmlinux]", false);
+
 		machine__set_kernel_mmap_len(machine, event);
 
 		/*
-- 
2.1.2

