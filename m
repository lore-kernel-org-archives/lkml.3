Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaBBIzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 03:55:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41340 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbaBBIzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 03:55:38 -0500
Date: Sun, 2 Feb 2014 00:55:09 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-9176753d1ed56951a6ee2a0f0a3f367904e35567@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, mingo@redhat.com, eranian@google.com,
        acme@redhat.com, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
In-Reply-To: <1391004884-10334-2-git-send-email-adrian.hunter@intel.com>
References: <1391004884-10334-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols:
  Fix symbol annotation for relocated kernel
Git-Commit-ID: 9176753d1ed56951a6ee2a0f0a3f367904e35567
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 02 Feb 2014 00:55:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9176753d1ed56951a6ee2a0f0a3f367904e35567
Gitweb:     http://git.kernel.org/tip/9176753d1ed56951a6ee2a0f0a3f367904e35567
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 29 Jan 2014 16:14:36 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 31 Jan 2014 17:21:47 -0300

perf symbols: Fix symbol annotation for relocated kernel

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
index 3b97513..39cd2d0 100644
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
index 8f12f0f..3e9f336 100644
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
