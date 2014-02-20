Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaBTBdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 20:33:22 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58001 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbaBTBdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 20:33:06 -0500
X-AuditID: 9c93016f-b7c65ae000004a2a-5f-53055b4cbce1
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 4/4] perf tools: Check compatible symtab type before loading dso
Date: Thu, 20 Feb 2014 10:32:56 +0900
Message-Id: <1392859976-32760-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1392859976-32760-1-git-send-email-namhyung@kernel.org>
References: <1392859976-32760-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When loading a dso it'll look for symbol tables of all possible types.
However it's just wasted of time to check incompatible types - like
trying kernel module when loading user library.

Cc: Stephane Eranian <eranian@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/symbol.c | 61 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 52 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index c3b014712fce..95e249779931 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1251,6 +1251,46 @@ out_failure:
 	return -1;
 }
 
+static bool dso__is_compatible_symtab_type(struct dso *dso, bool kmod,
+					   enum dso_binary_type type)
+{
+	switch (type) {
+	case DSO_BINARY_TYPE__JAVA_JIT:
+	case DSO_BINARY_TYPE__DEBUGLINK:
+	case DSO_BINARY_TYPE__SYSTEM_PATH_DSO:
+	case DSO_BINARY_TYPE__FEDORA_DEBUGINFO:
+	case DSO_BINARY_TYPE__UBUNTU_DEBUGINFO:
+	case DSO_BINARY_TYPE__BUILDID_DEBUGINFO:
+	case DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO:
+		return !kmod && dso->kernel == DSO_TYPE_USER;
+
+	case DSO_BINARY_TYPE__KALLSYMS:
+	case DSO_BINARY_TYPE__VMLINUX:
+	case DSO_BINARY_TYPE__KCORE:
+		return dso->kernel == DSO_TYPE_KERNEL;
+
+	case DSO_BINARY_TYPE__GUEST_KALLSYMS:
+	case DSO_BINARY_TYPE__GUEST_VMLINUX:
+	case DSO_BINARY_TYPE__GUEST_KCORE:
+		return dso->kernel == DSO_TYPE_GUEST_KERNEL;
+
+	case DSO_BINARY_TYPE__GUEST_KMODULE:
+	case DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE:
+		/*
+		 * kernel modules know their symtab type - it's set when
+		 * creating a module dso in machine__new_module().
+		 */
+		return kmod && dso->symtab_type == type;
+
+	case DSO_BINARY_TYPE__BUILD_ID_CACHE:
+		return true;
+
+	case DSO_BINARY_TYPE__NOT_FOUND:
+	default:
+		return false;
+	}
+}
+
 int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 {
 	char *name;
@@ -1261,6 +1301,7 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 	int ss_pos = 0;
 	struct symsrc ss_[2];
 	struct symsrc *syms_ss = NULL, *runtime_ss = NULL;
+	bool kmod;
 
 	dso__set_loaded(dso, map->type);
 
@@ -1301,7 +1342,11 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 	if (!name)
 		return -1;
 
-	/* Iterate over candidate debug images.
+	kmod = dso->symtab_type == DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE ||
+		dso->symtab_type == DSO_BINARY_TYPE__GUEST_KMODULE;
+
+	/*
+	 * Iterate over candidate debug images.
 	 * Keep track of "interesting" ones (those which have a symtab, dynsym,
 	 * and/or opd section) for processing.
 	 */
@@ -1311,6 +1356,9 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 
 		enum dso_binary_type symtab_type = binary_type_symtab[i];
 
+		if (!dso__is_compatible_symtab_type(dso, kmod, symtab_type))
+			continue;
+
 		if (dso__read_binary_type_filename(dso, symtab_type,
 						   root_dir, name, PATH_MAX))
 			continue;
@@ -1353,15 +1401,10 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 	if (!runtime_ss && syms_ss)
 		runtime_ss = syms_ss;
 
-	if (syms_ss) {
-		int km;
-
-		km = dso->symtab_type == DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE ||
-		     dso->symtab_type == DSO_BINARY_TYPE__GUEST_KMODULE;
-		ret = dso__load_sym(dso, map, syms_ss, runtime_ss, filter, km);
-	} else {
+	if (syms_ss)
+		ret = dso__load_sym(dso, map, syms_ss, runtime_ss, filter, kmod);
+	else
 		ret = -1;
-	}
 
 	if (ret > 0) {
 		int nr_plt;
-- 
1.7.11.7

