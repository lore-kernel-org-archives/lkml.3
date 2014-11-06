Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaKFVGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:06:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:43358 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbaKFVF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:05:59 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/18] perf tools: Make vmlinux short name more like kallsyms short name
Date: Thu,  6 Nov 2014 18:04:35 -0300
Message-Id: <1415307879-912-15-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415307879-912-1-git-send-email-acme@kernel.org>
References: <1415307879-912-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The previous patch changed kernel dso name from '[kernel.kallsyms]' to
vmlinux.  However it might add confusion to old users accustomed to the
old name.  So change the short name to '[kernel.vmlinux]' to reduce such
confusion.

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

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1415063674-17206-9-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.9.3

