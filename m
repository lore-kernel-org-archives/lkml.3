Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaJOKHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:07:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54549 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaJOKGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:06:53 -0400
Date: Wed, 15 Oct 2014 03:06:24 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-agomujr7tuqaq6lu7kr6z7h6@git.kernel.org>
Cc: mingo@kernel.org, namhyung@kernel.org, acme@redhat.com, tglx@linutronix.de,
        dsahern@gmail.com, hpa@zytor.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        cebbert.lkml@gmail.com, jolsa@redhat.com, eranian@google.com
Reply-To: peterz@infradead.org, cebbert.lkml@gmail.com,
        adrian.hunter@intel.com, eranian@google.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, namhyung@kernel.org, mingo@kernel.org,
        hpa@zytor.com, acme@redhat.com, tglx@linutronix.de, dsahern@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Make sym->
 end be the first address after the symbol range
Git-Commit-ID: 2c241bd35e6f626ad6f867dcf9fefdc2315f125f
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

Commit-ID:  2c241bd35e6f626ad6f867dcf9fefdc2315f125f
Gitweb:     http://git.kernel.org/tip/2c241bd35e6f626ad6f867dcf9fefdc2315f125f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 14 Oct 2014 17:19:44 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Oct 2014 17:50:58 -0300

perf symbols: Make sym->end be the first address after the symbol range

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
index 3643752..7dabde1 100644
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
index c787a43..0783311 100644
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
index bec4b7b..eb2c19b 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -95,7 +95,7 @@ void symbols__delete(struct rb_root *symbols);
 
 static inline size_t symbol__size(const struct symbol *sym)
 {
-	return sym->end - sym->start + 1;
+	return sym->end - sym->start;
 }
 
 struct strlist;
