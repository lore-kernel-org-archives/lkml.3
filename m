Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbaA2ONI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:13:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:53968 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaA2OND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:13:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,742,1384329600"; 
   d="scan'208";a="466608289"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 1/9] perf tools: Fix symbol annotation for relocated kernel
Date: Wed, 29 Jan 2014 16:14:36 +0200
Message-Id: <1391004884-10334-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com>
References: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel maps map memory addresses to file offsets.
For symbol annotation, objdump needs the object VMA
addresses.  For an unrelocated kernel, that is the
same as the memory address.

The addresses passed to objdump for symbol annotation
did not take into account kernel relocation.  This
patch fixes that.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/map.c        | 5 +++--
 tools/perf/util/map.h        | 1 +
 tools/perf/util/symbol-elf.c | 2 ++
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index ee1dd68..b46f527 100644
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
index 18068c6..257e513 100644
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
index 7594567..8ce52da 100644
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
1.7.11.7

