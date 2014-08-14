Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbaHNIuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:50:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36581 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbaHNIuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:50:10 -0400
Date: Thu, 14 Aug 2014 01:49:54 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-e71e79457b79a52827039d9d7f253321bfd342bd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1406785662-5534-9-git-send-email-namhyung@kernel.org>
References: <1406785662-5534-9-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Don'
 t demangle parameters and such by default
Git-Commit-ID: e71e79457b79a52827039d9d7f253321bfd342bd
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

Commit-ID:  e71e79457b79a52827039d9d7f253321bfd342bd
Gitweb:     http://git.kernel.org/tip/e71e79457b79a52827039d9d7f253321bfd342bd
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 31 Jul 2014 14:47:42 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 17:39:25 -0300

perf symbols: Don't demangle parameters and such by default

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
index d753499..ec5ec1c 100644
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
index b95e3a3..3f95ea0 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -60,6 +60,7 @@ extern Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 #endif
 
 #ifndef DMGL_PARAMS
+#define DMGL_NO_OPTS     0              /* For readability... */
 #define DMGL_PARAMS      (1 << 0)       /* Include function args */
 #define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
 #endif
