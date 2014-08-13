Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaHMWu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:50:56 -0400
Received: from mail.kernel.org ([198.145.19.201]:55527 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327AbaHMWuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:50:51 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 31/41] perf symbols: Don't demangle parameters and such by default
Date: Wed, 13 Aug 2014 19:48:17 -0300
Message-Id: <1407970107-24540-32-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Some C++ symbols have very long name and they make column length longer.
Most of them are about parameters including templates and we can ignore
such info most of time IMHO.

This patch passes DMGL_NO_OPTS by default when calling bfd_demangle().
One can still see full symbols with -v/--verbose option.

before:
  JS_CallFunctionValue(JSContext*, JSObject*, JS::Value, unsigned int, JS::Value*, JS::Value*)

after:
  JS_CallFunctionValue

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1406785662-5534-9-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c | 7 +++++--
 tools/perf/util/symbol.h     | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index d75349979e65..ec5ec1c9d9b5 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -939,8 +939,11 @@ new_symbol:
 		 * to it...
 		 */
 		if (symbol_conf.demangle) {
-			demangled = bfd_demangle(NULL, elf_name,
-						 DMGL_PARAMS | DMGL_ANSI);
+			int demangle_flags = DMGL_NO_OPTS;
+			if (verbose)
+				demangle_flags = DMGL_PARAMS | DMGL_ANSI;
+
+			demangled = bfd_demangle(NULL, elf_name, demangle_flags);
 			if (demangled != NULL)
 				elf_name = demangled;
 		}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index b95e3a36d654..3f95ea0357e3 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -60,6 +60,7 @@ extern Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 #endif
 
 #ifndef DMGL_PARAMS
+#define DMGL_NO_OPTS     0              /* For readability... */
 #define DMGL_PARAMS      (1 << 0)       /* Include function args */
 #define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
 #endif
-- 
1.9.3

