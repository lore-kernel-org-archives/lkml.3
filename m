Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933934Ab3HHCva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:51:30 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:44932 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933898Ab3HHCv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:51:28 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/19] perf top: Use new idle_sym check
Date: Wed,  7 Aug 2013 22:50:49 -0400
Message-Id: <1375930261-77273-8-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoids strcmp processing each sample.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-top.c |   25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 440c3b3..8eb0e3a 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -634,26 +634,9 @@ repeat:
 	return NULL;
 }
 
-/* Tag samples to be skipped. */
-static const char *skip_symbols[] = {
-	"intel_idle",
-	"default_idle",
-	"native_safe_halt",
-	"cpu_idle",
-	"enter_idle",
-	"exit_idle",
-	"mwait_idle",
-	"mwait_idle_with_hints",
-	"poll_idle",
-	"ppc64_runlatch_off",
-	"pseries_dedicated_idle_sleep",
-	NULL
-};
-
 static int symbol_filter(struct map *map __maybe_unused, struct symbol *sym)
 {
 	const char *name = sym->name;
-	int i;
 
 	/*
 	 * ppc64 uses function descriptors and appends a '.' to the
@@ -671,12 +654,8 @@ static int symbol_filter(struct map *map __maybe_unused, struct symbol *sym)
 	    strstr(name, "_text_end"))
 		return 1;
 
-	for (i = 0; skip_symbols[i]; i++) {
-		if (!strcmp(skip_symbols[i], name)) {
-			sym->ignore = true;
-			break;
-		}
-	}
+	if (symbol__is_idle(sym))
+		sym->ignore = true;
 
 	return 0;
 }
-- 
1.7.10.1

