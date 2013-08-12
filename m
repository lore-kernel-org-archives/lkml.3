Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab3HLKWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:22:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48032 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab3HLKW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:22:28 -0400
Date: Mon, 12 Aug 2013 03:21:41 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-82e75d00adc5bde3cf98f11e937eed6127163969@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1375875537-4509-9-git-send-email-adrian.hunter@intel.com>
References: <1375875537-4509-9-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Adjust the vmlinux symtab matches kallsyms test again
Git-Commit-ID: 82e75d00adc5bde3cf98f11e937eed6127163969
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:21:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82e75d00adc5bde3cf98f11e937eed6127163969
Gitweb:     http://git.kernel.org/tip/82e75d00adc5bde3cf98f11e937eed6127163969
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 7 Aug 2013 14:38:52 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:33 -0300

perf tests: Adjust the vmlinux symtab matches kallsyms test again

The kallsyms maps now may map to kcore and the symbol values now may be
file offsets.  For comparison with vmlinux the virtual memory address is
needed which is obtained by unmapping the symbol value.

The "vmlinux symtab matches kallsyms" is adjusted accordingly.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375875537-4509-9-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/vmlinux-kallsyms.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/perf/tests/vmlinux-kallsyms.c b/tools/perf/tests/vmlinux-kallsyms.c
index e2e1498..2bd13ed 100644
--- a/tools/perf/tests/vmlinux-kallsyms.c
+++ b/tools/perf/tests/vmlinux-kallsyms.c
@@ -16,6 +16,8 @@ static int vmlinux_matches_kallsyms_filter(struct map *map __maybe_unused,
 	return 0;
 }
 
+#define UM(x) kallsyms_map->unmap_ip(kallsyms_map, (x))
+
 int test__vmlinux_matches_kallsyms(void)
 {
 	int err = -1;
@@ -74,7 +76,7 @@ int test__vmlinux_matches_kallsyms(void)
 		goto out;
 	}
 
-	ref_reloc_sym.addr = sym->start;
+	ref_reloc_sym.addr = UM(sym->start);
 
 	/*
 	 * Step 5:
@@ -131,7 +133,7 @@ int test__vmlinux_matches_kallsyms(void)
 							 mem_start, NULL, NULL);
 		pair = first_pair;
 
-		if (pair && pair->start == mem_start) {
+		if (pair && UM(pair->start) == mem_start) {
 next_pair:
 			if (strcmp(sym->name, pair->name) == 0) {
 				/*
@@ -143,11 +145,11 @@ next_pair:
 				 * off the real size. More than that and we
 				 * _really_ have a problem.
 				 */
-				s64 skew = mem_end - pair->end;
+				s64 skew = mem_end - UM(pair->end);
 				if (llabs(skew) >= page_size)
 					pr_debug("%#" PRIx64 ": diff end addr for %s v: %#" PRIx64 " k: %#" PRIx64 "\n",
 						 mem_start, sym->name, mem_end,
-						 pair->end);
+						 UM(pair->end));
 
 				/*
 				 * Do not count this as a failure, because we
@@ -165,7 +167,7 @@ detour:
 				if (nnd) {
 					struct symbol *next = rb_entry(nnd, struct symbol, rb_node);
 
-					if (next->start == mem_start) {
+					if (UM(next->start) == mem_start) {
 						pair = next;
 						goto next_pair;
 					}
