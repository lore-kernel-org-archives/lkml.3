Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab3LKLIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:08:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60397 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab3LKLII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:08:08 -0500
Date: Wed, 11 Dec 2013 03:07:31 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-mb7eqhkyejq1qcf3p22wz2x7@git.kernel.org>
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
  Set alloc flag close to setting the long_name
Git-Commit-ID: 5230fb7db42914e47786a6e920d2624739b0f896
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:07:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5230fb7db42914e47786a6e920d2624739b0f896
Gitweb:     http://git.kernel.org/tip/5230fb7db42914e47786a6e920d2624739b0f896
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 10 Dec 2013 11:58:52 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 10 Dec 2013 16:51:09 -0300

perf symbols: Set alloc flag close to setting the long_name

This is a preparatory patch to do with dso__set_long_name what was done
with the short name variant.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-mb7eqhkyejq1qcf3p22wz2x7@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c |  2 +-
 tools/perf/util/symbol.c      | 31 +++++++++++--------------------
 tools/perf/util/symbol.h      |  3 ++-
 3 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 9c6989c..d7cff57 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -154,7 +154,7 @@ static struct dso *kernel_get_module_dso(const char *module)
 
 	vmlinux_name = symbol_conf.vmlinux_name;
 	if (vmlinux_name) {
-		if (dso__load_vmlinux(dso, map, vmlinux_name, NULL) <= 0)
+		if (dso__load_vmlinux(dso, map, vmlinux_name, false, NULL) <= 0)
 			return NULL;
 	} else {
 		if (dso__load_vmlinux_path(dso, map, NULL) <= 0) {
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 265a149..9a5de88 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1408,7 +1408,8 @@ struct map *map_groups__find_by_name(struct map_groups *mg,
 }
 
 int dso__load_vmlinux(struct dso *dso, struct map *map,
-		      const char *vmlinux, symbol_filter_t filter)
+		      const char *vmlinux, bool vmlinux_allocated,
+		      symbol_filter_t filter)
 {
 	int err = -1;
 	struct symsrc ss;
@@ -1438,6 +1439,7 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
 		else
 			dso->data_type = DSO_BINARY_TYPE__VMLINUX;
 		dso__set_long_name(dso, (char *)vmlinux);
+		dso->long_name_allocated = vmlinux_allocated;
 		dso__set_loaded(dso, map->type);
 		pr_debug("Using %s for symbols\n", symfs_vmlinux);
 	}
@@ -1456,21 +1458,16 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 
 	filename = dso__build_id_filename(dso, NULL, 0);
 	if (filename != NULL) {
-		err = dso__load_vmlinux(dso, map, filename, filter);
-		if (err > 0) {
-			dso->long_name_allocated = 1;
+		err = dso__load_vmlinux(dso, map, filename, true, filter);
+		if (err > 0)
 			goto out;
-		}
 		free(filename);
 	}
 
 	for (i = 0; i < vmlinux_path__nr_entries; ++i) {
-		err = dso__load_vmlinux(dso, map, vmlinux_path[i], filter);
-		if (err > 0) {
-			dso__set_long_name(dso, strdup(vmlinux_path[i]));
-			dso->long_name_allocated = 1;
+		err = dso__load_vmlinux(dso, map, vmlinux_path[i], false, filter);
+		if (err > 0)
 			break;
-		}
 	}
 out:
 	return err;
@@ -1607,15 +1604,8 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 	}
 
 	if (!symbol_conf.ignore_vmlinux && symbol_conf.vmlinux_name != NULL) {
-		err = dso__load_vmlinux(dso, map,
-					symbol_conf.vmlinux_name, filter);
-		if (err > 0) {
-			dso__set_long_name(dso,
-					   strdup(symbol_conf.vmlinux_name));
-			dso->long_name_allocated = 1;
-			return err;
-		}
-		return err;
+		return dso__load_vmlinux(dso, map, symbol_conf.vmlinux_name,
+					 false, filter);
 	}
 
 	if (!symbol_conf.ignore_vmlinux && vmlinux_path != NULL) {
@@ -1671,7 +1661,8 @@ static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
 		 */
 		if (symbol_conf.default_guest_vmlinux_name != NULL) {
 			err = dso__load_vmlinux(dso, map,
-				symbol_conf.default_guest_vmlinux_name, filter);
+						symbol_conf.default_guest_vmlinux_name,
+						false, filter);
 			return err;
 		}
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index f1031a1..6de9c2b 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -206,7 +206,8 @@ bool symsrc__possibly_runtime(struct symsrc *ss);
 
 int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter);
 int dso__load_vmlinux(struct dso *dso, struct map *map,
-		      const char *vmlinux, symbol_filter_t filter);
+		      const char *vmlinux, bool vmlinux_allocated,
+		      symbol_filter_t filter);
 int dso__load_vmlinux_path(struct dso *dso, struct map *map,
 			   symbol_filter_t filter);
 int dso__load_kallsyms(struct dso *dso, const char *filename, struct map *map,
