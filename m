Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab3LKLIE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:08:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60380 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab3LKLIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:08:00 -0500
Date: Wed, 11 Dec 2013 03:07:03 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-nu228f8vlp9w0lr7c0q77dqi@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Rename [sl]
 name_alloc to match the members they refer to
Git-Commit-ID: c7282f2efff9f115378b450b7aea51210fabb6ef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:07:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7282f2efff9f115378b450b7aea51210fabb6ef
Gitweb:     http://git.kernel.org/tip/c7282f2efff9f115378b450b7aea51210fabb6ef
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 10 Dec 2013 10:44:37 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Dec 2013 16:51:07 -0300

perf symbols: Rename [sl]name_alloc to match the members they refer to

So we now have:

   dso->short_name
   dso->short_name_len
   dso->short_name_allocated

Ditto for the 'long  variants. To more quickly grasp what they refer to.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-nu228f8vlp9w0lr7c0q77dqi@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c     | 4 ++--
 tools/perf/util/dso.h     | 4 ++--
 tools/perf/util/machine.c | 4 ++--
 tools/perf/util/symbol.c  | 6 +++---
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index a0c7c59..55c9835 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -465,9 +465,9 @@ void dso__delete(struct dso *dso)
 	int i;
 	for (i = 0; i < MAP__NR_TYPES; ++i)
 		symbols__delete(&dso->symbols[i]);
-	if (dso->sname_alloc)
+	if (dso->short_name_allocated)
 		free((char *)dso->short_name);
-	if (dso->lname_alloc)
+	if (dso->long_name_allocated)
 		free(dso->long_name);
 	dso_cache__free(&dso->cache);
 	dso__free_a2l(dso);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 384f2d9..00a232d 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -89,8 +89,8 @@ struct dso {
 	u8		 has_srcline:1;
 	u8		 hit:1;
 	u8		 annotate_warned:1;
-	u8		 sname_alloc:1;
-	u8		 lname_alloc:1;
+	u8		 short_name_allocated:1;
+	u8		 long_name_allocated:1;
 	u8		 sorted_by_name;
 	u8		 loaded;
 	u8		 rel;
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index bac817a..f66f309 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -764,7 +764,7 @@ static int map_groups__set_modules_path_dir(struct map_groups *mg,
 				goto out;
 			}
 			dso__set_long_name(map->dso, long_name);
-			map->dso->lname_alloc = 1;
+			map->dso->long_name_allocated = 1;
 			dso__kernel_module_get_build_id(map->dso, "");
 		}
 	}
@@ -936,7 +936,7 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
 			goto out_problem;
 
 		map->dso->short_name = name;
-		map->dso->sname_alloc = 1;
+		map->dso->short_name_allocated = 1;
 		map->end = map->start + event->mmap.len;
 	} else if (is_kernel_mmap) {
 		const char *symbol_name = (event->mmap.filename +
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index de87dba..265a149 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1458,7 +1458,7 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 	if (filename != NULL) {
 		err = dso__load_vmlinux(dso, map, filename, filter);
 		if (err > 0) {
-			dso->lname_alloc = 1;
+			dso->long_name_allocated = 1;
 			goto out;
 		}
 		free(filename);
@@ -1468,7 +1468,7 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 		err = dso__load_vmlinux(dso, map, vmlinux_path[i], filter);
 		if (err > 0) {
 			dso__set_long_name(dso, strdup(vmlinux_path[i]));
-			dso->lname_alloc = 1;
+			dso->long_name_allocated = 1;
 			break;
 		}
 	}
@@ -1612,7 +1612,7 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 		if (err > 0) {
 			dso__set_long_name(dso,
 					   strdup(symbol_conf.vmlinux_name));
-			dso->lname_alloc = 1;
+			dso->long_name_allocated = 1;
 			return err;
 		}
 		return err;
