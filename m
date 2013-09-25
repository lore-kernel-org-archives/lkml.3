Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab3IYRUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 13:20:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54926 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3IYRUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 13:20:41 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/6] perf symbols: Demangle cloned functions
Date: Wed, 25 Sep 2013 14:20:28 -0300
Message-Id: <1380129628-16808-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380129628-16808-1-git-send-email-acme@infradead.org>
References: <1380129628-16808-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The libbfd C++ demangler doesn't seem to deal with cloned functions,
like symbol.clone.NUM.

Just strip the dot part before demangling and add it back later.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1378998998-10802-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index a9c829b..d2a888e 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -928,8 +928,33 @@ int dso__load_sym(struct dso *dso, struct map *map,
 		 * to it...
 		 */
 		if (symbol_conf.demangle) {
-			demangled = bfd_demangle(NULL, elf_name,
+			/*
+			 * The demangler doesn't deal with cloned functions.
+			 * XXXX.clone.NUM or similar
+			 * Strip the dot part and readd it later.
+			 */
+			char *p = (char *)elf_name, *dot;
+			dot = strchr(elf_name, '.');
+			if (dot) {
+				p = strdup(elf_name);
+				if (!p)
+					goto new_symbol;
+				dot = strchr(p, '.');
+				*dot = 0;
+			}
+
+			demangled = bfd_demangle(NULL, p,
 						 DMGL_PARAMS | DMGL_ANSI);
+			if (dot)
+				*dot = '.';
+			if (demangled && dot) {
+				demangled = realloc(demangled, strlen(demangled) + strlen(dot) + 1);
+				if (!demangled)
+					goto new_symbol;
+				strcpy(demangled + (dot - p), dot);
+			}
+			if (p != elf_name)
+				free(p);
 			if (demangled != NULL)
 				elf_name = demangled;
 		}
-- 
1.8.1.4

