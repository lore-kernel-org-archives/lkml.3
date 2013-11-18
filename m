Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab3KRUdR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 15:33:17 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35757 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab3KRUdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 15:33:04 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/8] perf symbol: Save vmlinux or kallsyms path loaded
Date: Mon, 18 Nov 2013 13:32:46 -0700
Message-Id: <1384806771-2945-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
In-Reply-To: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
References: <1384806771-2945-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save vmlinux or kallsyms path loaded using embedded default lookup (ie.,
not a user specified path). Upcoming perf sched timehist command requires
kernel symbols for properly computing idle times and prints a warning
if the kernel symbols are not loaded.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/symbol.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f55c18da1e40..915eb6c4a248 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1437,6 +1437,8 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
 			dso->data_type = DSO_BINARY_TYPE__VMLINUX;
 		dso__set_long_name(dso, (char *)vmlinux);
 		dso__set_loaded(dso, map->type);
+		if (symbol_conf.vmlinux_name == NULL)
+			symbol_conf.vmlinux_name = strdup(symfs_vmlinux);
 		pr_debug("Using %s for symbols\n", symfs_vmlinux);
 	}
 
@@ -1629,8 +1631,11 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 
 do_kallsyms:
 	err = dso__load_kallsyms(dso, kallsyms_filename, map, filter);
-	if (err > 0)
+	if (err > 0) {
+		if (symbol_conf.kallsyms_name == NULL)
+			symbol_conf.kallsyms_name = strdup(kallsyms_filename);
 		pr_debug("Using %s for symbols\n", kallsyms_filename);
+	}
 	free(kallsyms_allocated_filename);
 
 	if (err > 0 && !dso__is_kcore(dso)) {
-- 
1.8.3.4 (Apple Git-47)

