Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab3LKLIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:08:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60438 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3LKLIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:08:43 -0500
Date: Wed, 11 Dec 2013 03:07:40 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-na7t1tqim22vuqkt4zq5n4ri@git.kernel.org>
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
Subject: [tip:perf/core] perf symbols:
  Remove open coded management of  long_name_allocated member
Git-Commit-ID: 7e155d4d5e2912f75443c18c02dd6f1dbd4eef84
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:07:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e155d4d5e2912f75443c18c02dd6f1dbd4eef84
Gitweb:     http://git.kernel.org/tip/7e155d4d5e2912f75443c18c02dd6f1dbd4eef84
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 10 Dec 2013 15:08:44 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Dec 2013 16:51:09 -0300

perf symbols: Remove open coded management of  long_name_allocated member

Instead of expecting callers to set this member accodingly so that later
at dso destruction it can, if needed, be correctly free()d, make it a
requirement by passing it as a parameter to dso__set_long_name.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-na7t1tqim22vuqkt4zq5n4ri@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c     | 13 +++++++++----
 tools/perf/util/dso.h     |  2 +-
 tools/perf/util/machine.c |  3 +--
 tools/perf/util/symbol.c  |  9 ++++-----
 tools/perf/util/vdso.c    |  2 +-
 5 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index f8c8497..ecb37d6 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -386,12 +386,17 @@ struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
 	return dso;
 }
 
-void dso__set_long_name(struct dso *dso, char *name)
+void dso__set_long_name(struct dso *dso, char *name, bool name_allocated)
 {
 	if (name == NULL)
 		return;
-	dso->long_name = name;
-	dso->long_name_len = strlen(name);
+
+	if (dso->long_name_allocated)
+		free(dso->long_name);
+
+	dso->long_name		 = name;
+	dso->long_name_len	 = strlen(name);
+	dso->long_name_allocated = name_allocated;
 }
 
 void dso__set_short_name(struct dso *dso, const char *name, bool name_allocated)
@@ -444,7 +449,7 @@ struct dso *dso__new(const char *name)
 	if (dso != NULL) {
 		int i;
 		strcpy(dso->name, name);
-		dso__set_long_name(dso, dso->name);
+		dso__set_long_name(dso, dso->name, false);
 		dso__set_short_name(dso, dso->name, false);
 		for (i = 0; i < MAP__NR_TYPES; ++i)
 			dso->symbols[i] = dso->symbol_names[i] = RB_ROOT;
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 8eceab7..7b43469 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -111,7 +111,7 @@ struct dso *dso__new(const char *name);
 void dso__delete(struct dso *dso);
 
 void dso__set_short_name(struct dso *dso, const char *name, bool name_allocated);
-void dso__set_long_name(struct dso *dso, char *name);
+void dso__set_long_name(struct dso *dso, char *name, bool name_allocated);
 
 int dso__name_len(const struct dso *dso);
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 09d5c66..751454b 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -763,8 +763,7 @@ static int map_groups__set_modules_path_dir(struct map_groups *mg,
 				ret = -1;
 				goto out;
 			}
-			dso__set_long_name(map->dso, long_name);
-			map->dso->long_name_allocated = 1;
+			dso__set_long_name(map->dso, long_name, true);
 			dso__kernel_module_get_build_id(map->dso, "");
 		}
 	}
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 9a5de88..5029ee1 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1159,7 +1159,7 @@ static int dso__load_kcore(struct dso *dso, struct map *map,
 		dso->data_type = DSO_BINARY_TYPE__GUEST_KCORE;
 	else
 		dso->data_type = DSO_BINARY_TYPE__KCORE;
-	dso__set_long_name(dso, strdup(kcore_filename));
+	dso__set_long_name(dso, strdup(kcore_filename), true);
 
 	close(fd);
 
@@ -1438,8 +1438,7 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
 			dso->data_type = DSO_BINARY_TYPE__GUEST_VMLINUX;
 		else
 			dso->data_type = DSO_BINARY_TYPE__VMLINUX;
-		dso__set_long_name(dso, (char *)vmlinux);
-		dso->long_name_allocated = vmlinux_allocated;
+		dso__set_long_name(dso, (char *)vmlinux, vmlinux_allocated);
 		dso__set_loaded(dso, map->type);
 		pr_debug("Using %s for symbols\n", symfs_vmlinux);
 	}
@@ -1631,7 +1630,7 @@ do_kallsyms:
 	free(kallsyms_allocated_filename);
 
 	if (err > 0 && !dso__is_kcore(dso)) {
-		dso__set_long_name(dso, strdup("[kernel.kallsyms]"));
+		dso__set_long_name(dso, strdup("[kernel.kallsyms]"), true);
 		map__fixup_start(map);
 		map__fixup_end(map);
 	}
@@ -1679,7 +1678,7 @@ static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
 		pr_debug("Using %s for symbols\n", kallsyms_filename);
 	if (err > 0 && !dso__is_kcore(dso)) {
 		machine__mmap_name(machine, path, sizeof(path));
-		dso__set_long_name(dso, strdup(path));
+		dso__set_long_name(dso, strdup(path), true);
 		map__fixup_start(map);
 		map__fixup_end(map);
 	}
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index 3915982..0ddb3b8 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -103,7 +103,7 @@ struct dso *vdso__dso_findnew(struct list_head *head)
 		dso = dso__new(VDSO__MAP_NAME);
 		if (dso != NULL) {
 			dsos__add(head, dso);
-			dso__set_long_name(dso, file);
+			dso__set_long_name(dso, file, false);
 		}
 	}
 
