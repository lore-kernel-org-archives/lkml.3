Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaKREal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 23:30:41 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:53335 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaKREak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 23:30:40 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf tools: Fix segfault due to invalid kernel dso access
Date: Tue, 18 Nov 2014 13:30:28 +0900
Message-Id: <1416285028-30572-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri reported that the commit 96d78059d6d9 ("perf tools: Make vmlinux
short name more like kallsyms short name") segfaults on perf script.

When processing kernel mmap event, it should access the 'kernel'
variable as sometimes it cannot find a matching dso from build-id
table so 'dso' might be invalid.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/machine.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 52e94902afb1..85033d80fd6a 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1106,8 +1106,8 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
 		if (__machine__create_kernel_maps(machine, kernel) < 0)
 			goto out_problem;
 
-		if (strstr(dso->long_name, "vmlinux"))
-			dso__set_short_name(dso, "[kernel.vmlinux]", false);
+		if (strstr(kernel->long_name, "vmlinux"))
+			dso__set_short_name(kernel, "[kernel.vmlinux]", false);
 
 		machine__set_kernel_mmap_len(machine, event);
 
-- 
2.1.2

