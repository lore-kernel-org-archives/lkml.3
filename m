Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbaJNVGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:06:50 -0400
Received: from mail.kernel.org ([198.145.19.201]:45099 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574AbaJNVGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:06:46 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 24/24] perf symbols: Make sym->end be the first address after the symbol range
Date: Tue, 14 Oct 2014 18:04:33 -0300
Message-Id: <1413320673-5784-25-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413320673-5784-1-git-send-email-acme@kernel.org>
References: <1413320673-5784-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To follow vm_area_struct->vm_end convention.

By adhering to the convention that ->end is the first address outside
the symbol's range we can do things like:

	sym->end = start + len;
	len = sym->end - sym->start;

This is also now the convention used for struct map->end, fixing some
off-by-one bugs.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-agomujr7tuqaq6lu7kr6z7h6@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 8 ++++----
 tools/perf/util/symbol.c   | 6 +++---
 tools/perf/util/symbol.h   | 2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 36437527dbb3..7dabde14ea54 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -478,7 +478,7 @@ static int __symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 
 	pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
 
-	if (addr < sym->start || addr > sym->end)
+	if (addr < sym->start || addr >= sym->end)
 		return -ERANGE;
 
 	offset = addr - sym->start;
@@ -836,7 +836,7 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 		    end = map__rip_2objdump(map, sym->end);
 
 		offset = line_ip - start;
-		if ((u64)line_ip < start || (u64)line_ip > end)
+		if ((u64)line_ip < start || (u64)line_ip >= end)
 			offset = -1;
 		else
 			parsed_line = tmp2 + 1;
@@ -966,7 +966,7 @@ fallback:
 		kce.kcore_filename = symfs_filename;
 		kce.addr = map__rip_2objdump(map, sym->start);
 		kce.offs = sym->start;
-		kce.len = sym->end + 1 - sym->start;
+		kce.len = sym->end - sym->start;
 		if (!kcore_extract__create(&kce)) {
 			delete_extract = true;
 			strlcpy(symfs_filename, kce.extract_filename,
@@ -987,7 +987,7 @@ fallback:
 		 disassembler_style ? "-M " : "",
 		 disassembler_style ? disassembler_style : "",
 		 map__rip_2objdump(map, sym->start),
-		 map__rip_2objdump(map, sym->end+1),
+		 map__rip_2objdump(map, sym->end),
 		 symbol_conf.annotate_asm_raw ? "" : "--no-show-raw",
 		 symbol_conf.annotate_src ? "-S" : "",
 		 symfs_filename, filename);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c787a43d529a..078331140d8c 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -186,7 +186,7 @@ void symbols__fixup_end(struct rb_root *symbols)
 		curr = rb_entry(nd, struct symbol, rb_node);
 
 		if (prev->end == prev->start && prev->end != curr->start)
-			prev->end = curr->start - 1;
+			prev->end = curr->start;
 	}
 
 	/* Last entry */
@@ -229,7 +229,7 @@ struct symbol *symbol__new(u64 start, u64 len, u8 binding, const char *name)
 		sym = ((void *)sym) + symbol_conf.priv_size;
 
 	sym->start   = start;
-	sym->end     = len ? start + len - 1 : start;
+	sym->end     = len ? start + len : start;
 	sym->binding = binding;
 	sym->namelen = namelen - 1;
 
@@ -325,7 +325,7 @@ static struct symbol *symbols__find(struct rb_root *symbols, u64 ip)
 
 		if (ip < s->start)
 			n = n->rb_left;
-		else if (ip > s->end)
+		else if (ip >= s->end)
 			n = n->rb_right;
 		else
 			return s;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index bec4b7bd09de..eb2c19bf8d90 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -95,7 +95,7 @@ void symbols__delete(struct rb_root *symbols);
 
 static inline size_t symbol__size(const struct symbol *sym)
 {
-	return sym->end - sym->start + 1;
+	return sym->end - sym->start;
 }
 
 struct strlist;
-- 
1.9.3

