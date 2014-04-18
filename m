Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaDRKVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 06:21:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbaDRKVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 06:21:09 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Vladimir Nikulichev <nvs@tbricks.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/3] perf tools: Adjust symbols in VDSO
Date: Fri, 18 Apr 2014 12:20:42 +0200
Message-Id: <1397816443-14630-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397816443-14630-1-git-send-email-jolsa@redhat.com>
References: <1397816443-14630-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladimir Nikulichev <nvs@tbricks.com>

pert-report doesn't resolve function names in VDSO:

$ perf report --stdio -g flat,0.0,15,callee --sort pid
...
            8.76%
               0x7fff6b1fe861
               __gettimeofday
               ACE_OS::gettimeofday()
...

In this case symbol values should be adjusted the same way as for executables,
relocatable objects and prelinked libraries.

After fix:

$ perf report --stdio -g flat,0.0,15,callee --sort pid
...
            8.76%
               __vdso_gettimeofday
               __gettimeofday
               ACE_OS::gettimeofday()

Signed-off-by: Vladimir Nikulichev <nvs@tbricks.com>
Tested-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Link: http://lkml.kernel.org/r/969812.163009436-sendEmail@nvs
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/symbol-elf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 3b7dbf5..6864661 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -6,6 +6,7 @@
 #include <inttypes.h>
 
 #include "symbol.h"
+#include "vdso.h"
 #include <symbol/kallsyms.h>
 #include "debug.h"
 
@@ -618,6 +619,7 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 		GElf_Shdr shdr;
 		ss->adjust_symbols = (ehdr.e_type == ET_EXEC ||
 				ehdr.e_type == ET_REL ||
+				is_vdso_map(dso->short_name) ||
 				elf_section_by_name(elf, &ehdr, &shdr,
 						     ".gnu.prelink_undo",
 						     NULL) != NULL);
-- 
1.8.3.1

