Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbaB0Nam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:30:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54857 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaB0Nag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:30:36 -0500
Date: Thu, 27 Feb 2014 05:30:12 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-1029f9fedf87fa6f52096991588fa54ffd159584@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, adrian.hunter@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1392859976-32760-4-git-send-email-namhyung@kernel.org>
References: <1392859976-32760-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Check compatible symtab type before loading dso
Git-Commit-ID: 1029f9fedf87fa6f52096991588fa54ffd159584
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

Commit-ID:  1029f9fedf87fa6f52096991588fa54ffd159584
Gitweb:     http://git.kernel.org/tip/1029f9fedf87fa6f52096991588fa54ffd159584
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 20 Feb 2014 10:32:56 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Feb 2014 16:25:01 -0300

perf symbols: Check compatible symtab type before loading dso

When loading a dso it'll look for symbol tables of all possible types.
However it's just wasted of time to check incompatible types - like
trying kernel module when loading user library.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1392859976-32760-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 61 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 52 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 46e2ede..0ada68b 100644
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
@@ -1351,15 +1399,10 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
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
