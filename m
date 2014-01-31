Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155AbaAaU2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:28:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55425 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933069AbaAaU16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:27:58 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/12] perf symbols: Fix symbol annotation for relocated kernel
Date: Fri, 31 Jan 2014 17:27:27 -0300
Message-Id: <1391200055-18250-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1391200055-18250-1-git-send-email-acme@infradead.org>
References: <1391200055-18250-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Kernel maps map memory addresses to file offsets.

For symbol annotation, objdump needs the object VMA addresses.  For an
unrelocated kernel, that is the same as the memory address.

The addresses passed to objdump for symbol annotation did not take into
account kernel relocation.

This patch fixes that.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1391004884-10334-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/map.c        | 5 +++--
 tools/perf/util/map.h        | 1 +
 tools/perf/util/symbol-elf.c | 2 ++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 3b97513f0e77..39cd2d0faff6 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -39,6 +39,7 @@ void map__init(struct map *map, enum map_type type,
 	map->start    = start;
 	map->end      = end;
 	map->pgoff    = pgoff;
+	map->reloc    = 0;
 	map->dso      = dso;
 	map->map_ip   = map__map_ip;
 	map->unmap_ip = map__unmap_ip;
@@ -288,7 +289,7 @@ u64 map__rip_2objdump(struct map *map, u64 rip)
 	if (map->dso->rel)
 		return rip - map->pgoff;
 
-	return map->unmap_ip(map, rip);
+	return map->unmap_ip(map, rip) - map->reloc;
 }
 
 /**
@@ -311,7 +312,7 @@ u64 map__objdump_2mem(struct map *map, u64 ip)
 	if (map->dso->rel)
 		return map->unmap_ip(map, ip + map->pgoff);
 
-	return ip;
+	return ip + map->reloc;
 }
 
 void map_groups__init(struct map_groups *mg)
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 18068c6b71c1..257e513205ce 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -36,6 +36,7 @@ struct map {
 	bool			erange_warned;
 	u32			priv;
 	u64			pgoff;
+	u64			reloc;
 	u32			maj, min; /* only valid for MMAP2 record */
 	u64			ino;      /* only valid for MMAP2 record */
 	u64			ino_generation;/* only valid for MMAP2 record */
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 8f12f0f5101d..3e9f336740fa 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -751,6 +751,8 @@ int dso__load_sym(struct dso *dso, struct map *map,
 			if (strcmp(elf_name, kmap->ref_reloc_sym->name))
 				continue;
 			kmap->ref_reloc_sym->unrelocated_addr = sym.st_value;
+			map->reloc = kmap->ref_reloc_sym->addr -
+				     kmap->ref_reloc_sym->unrelocated_addr;
 			break;
 		}
 	}
-- 
1.8.1.4

