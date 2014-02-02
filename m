Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaBBI4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 03:56:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41424 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaBBI4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 03:56:47 -0500
Date: Sun, 2 Feb 2014 00:56:28 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-d9b62aba87a82939c73f451a166c7a21342350d6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1391004884-10334-9-git-send-email-adrian.hunter@intel.com>
References: <1391004884-10334-9-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Adjust kallsyms for relocated kernel
Git-Commit-ID: d9b62aba87a82939c73f451a166c7a21342350d6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 02 Feb 2014 00:56:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d9b62aba87a82939c73f451a166c7a21342350d6
Gitweb:     http://git.kernel.org/tip/d9b62aba87a82939c73f451a166c7a21342350d6
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 29 Jan 2014 16:14:43 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 31 Jan 2014 17:21:53 -0300

perf tools: Adjust kallsyms for relocated kernel

If the kernel is relocated at boot time, kallsyms will not match data
recorded previously.

That does not matter for modules because they are corrected anyway.  It
also does not matter if vmlinux is being used for symbols. But if perf
tools has only kallsyms then the symbols will not match.

Fix by applying the delta gained by comparing the old and current
addresses of the relocation reference symbol.

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
Link: http://lkml.kernel.org/r/1391004884-10334-9-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 4ac1f87..a9d758a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -627,7 +627,7 @@ static int dso__split_kallsyms_for_kcore(struct dso *dso, struct map *map,
  * kernel range is broken in several maps, named [kernel].N, as we don't have
  * the original ELF section names vmlinux have.
  */
-static int dso__split_kallsyms(struct dso *dso, struct map *map,
+static int dso__split_kallsyms(struct dso *dso, struct map *map, u64 delta,
 			       symbol_filter_t filter)
 {
 	struct map_groups *kmaps = map__kmap(map)->kmaps;
@@ -692,6 +692,12 @@ static int dso__split_kallsyms(struct dso *dso, struct map *map,
 			char dso_name[PATH_MAX];
 			struct dso *ndso;
 
+			if (delta) {
+				/* Kernel was relocated at boot time */
+				pos->start -= delta;
+				pos->end -= delta;
+			}
+
 			if (count == 0) {
 				curr_map = map;
 				goto filter_symbol;
@@ -721,6 +727,10 @@ static int dso__split_kallsyms(struct dso *dso, struct map *map,
 			curr_map->map_ip = curr_map->unmap_ip = identity__map_ip;
 			map_groups__insert(kmaps, curr_map);
 			++kernel_range;
+		} else if (delta) {
+			/* Kernel was relocated at boot time */
+			pos->start -= delta;
+			pos->end -= delta;
 		}
 filter_symbol:
 		if (filter && filter(curr_map, pos)) {
@@ -1130,15 +1140,41 @@ out_err:
 	return -EINVAL;
 }
 
+/*
+ * If the kernel is relocated at boot time, kallsyms won't match.  Compute the
+ * delta based on the relocation reference symbol.
+ */
+static int kallsyms__delta(struct map *map, const char *filename, u64 *delta)
+{
+	struct kmap *kmap = map__kmap(map);
+	u64 addr;
+
+	if (!kmap->ref_reloc_sym || !kmap->ref_reloc_sym->name)
+		return 0;
+
+	addr = kallsyms__get_function_start(filename,
+					    kmap->ref_reloc_sym->name);
+	if (!addr)
+		return -1;
+
+	*delta = addr - kmap->ref_reloc_sym->addr;
+	return 0;
+}
+
 int dso__load_kallsyms(struct dso *dso, const char *filename,
 		       struct map *map, symbol_filter_t filter)
 {
+	u64 delta = 0;
+
 	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
 		return -1;
 
 	if (dso__load_all_kallsyms(dso, filename, map) < 0)
 		return -1;
 
+	if (kallsyms__delta(map, filename, &delta))
+		return -1;
+
 	symbols__fixup_duplicate(&dso->symbols[map->type]);
 	symbols__fixup_end(&dso->symbols[map->type]);
 
@@ -1150,7 +1186,7 @@ int dso__load_kallsyms(struct dso *dso, const char *filename,
 	if (!dso__load_kcore(dso, map, filename))
 		return dso__split_kallsyms_for_kcore(dso, map, filter);
 	else
-		return dso__split_kallsyms(dso, map, filter);
+		return dso__split_kallsyms(dso, map, delta, filter);
 }
 
 static int dso__load_perf_map(struct dso *dso, struct map *map,
