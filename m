Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbaGaFsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 01:48:23 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:61085 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbaGaFro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 01:47:44 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 8/8] perf symbol: Don't demangle parameters and such by default
Date: Thu, 31 Jul 2014 14:47:42 +0900
Message-Id: <1406785662-5534-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406785662-5534-1-git-send-email-namhyung@kernel.org>
References: <1406785662-5534-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some C++ symbols have very long name and they make column length
longer.  Most of them are about parameters including templates and we
can ignore such info most of time IMHO.

This patch passes DMGL_NO_OPTS by default when calling bfd_demangle().
One can still see full symbols with -v/--verbose option.

before:
  JS_CallFunctionValue(JSContext*, JSObject*, JS::Value, unsigned int, JS::Value*, JS::Value*)

after:
  JS_CallFunctionValue

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
index e7295e93cff9..c16dc16f83d5 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -59,6 +59,7 @@ extern Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 #endif
 
 #ifndef DMGL_PARAMS
+#define DMGL_NO_OPTS     0              /* For readability... */
 #define DMGL_PARAMS      (1 << 0)       /* Include function args */
 #define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
 #endif
-- 
2.0.0

