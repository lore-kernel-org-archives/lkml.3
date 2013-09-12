Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab3ILPRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:17:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:46906 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab3ILPRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:17:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,891,1371106800"; 
   d="scan'208";a="359571936"
From: Andi Kleen <andi@firstfloor.org>
To: acme@infradead.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, tools: Demangle cloned functions
Date: Thu, 12 Sep 2013 08:16:38 -0700
Message-Id: <1378998998-10802-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The libbfd C++ demangler doesn't seem to deal with cloned functions,
like symbol.clone.NUM.

Just strip the dot part before demangling and add it back later.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/util/symbol-elf.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index a7b9ab5..0d49bc7 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -912,8 +912,33 @@ int dso__load_sym(struct dso *dso, struct map *map,
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
1.8.3.1

