Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaANQkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:40:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52766 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaANQk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:40:28 -0500
Date: Tue, 14 Jan 2014 08:39:46 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-ahh6vfzyh8fsygjwrsbroeu0@git.kernel.org>
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
Subject: [tip:perf/core] perf report:
  Move logic to warn about kptr_restrict'ed kernels to separate function
Git-Commit-ID: fad2918ed5171e6299a9b4b885d0459f35ee7377
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:39:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fad2918ed5171e6299a9b4b885d0459f35ee7377
Gitweb:     http://git.kernel.org/tip/fad2918ed5171e6299a9b4b885d0459f35ee7377
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 8 Jan 2014 10:10:00 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:25 -0300

perf report: Move logic to warn about kptr_restrict'ed kernels to separate function

Its too big, better have a separate function for it so that the main
logic gets shorter/clearer.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ahh6vfzyh8fsygjwrsbroeu0@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 56 ++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index bf8dd2e..f2ff860 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -412,14 +412,41 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 	return 0;
 }
 
+static void report__warn_kptr_restrict(const struct report *rep)
+{
+	struct map *kernel_map = rep->session->machines.host.vmlinux_maps[MAP__FUNCTION];
+	struct kmap *kernel_kmap = map__kmap(kernel_map);
+
+	if (kernel_map == NULL ||
+	    (kernel_map->dso->hit &&
+	     (kernel_kmap->ref_reloc_sym == NULL ||
+	      kernel_kmap->ref_reloc_sym->addr == 0))) {
+		const char *desc =
+		    "As no suitable kallsyms nor vmlinux was found, kernel samples\n"
+		    "can't be resolved.";
+
+		if (kernel_map) {
+			const struct dso *kdso = kernel_map->dso;
+			if (!RB_EMPTY_ROOT(&kdso->symbols[MAP__FUNCTION])) {
+				desc = "If some relocation was applied (e.g. "
+				       "kexec) symbols may be misresolved.";
+			}
+		}
+
+		ui__warning(
+"Kernel address maps (/proc/{kallsyms,modules}) were restricted.\n\n"
+"Check /proc/sys/kernel/kptr_restrict before running 'perf record'.\n\n%s\n\n"
+"Samples in kernel modules can't be resolved as well.\n\n",
+		desc);
+	}
+}
+
 static int __cmd_report(struct report *rep)
 {
 	int ret = -EINVAL;
 	u64 nr_samples;
 	struct perf_session *session = rep->session;
 	struct perf_evsel *pos;
-	struct map *kernel_map;
-	struct kmap *kernel_kmap;
 	const char *help = "For a higher level overview, try: perf report --sort comm,dso";
 	struct ui_progress prog;
 	struct perf_data_file *file = session->file;
@@ -444,30 +471,7 @@ static int __cmd_report(struct report *rep)
 	if (ret)
 		return ret;
 
-	kernel_map = session->machines.host.vmlinux_maps[MAP__FUNCTION];
-	kernel_kmap = map__kmap(kernel_map);
-	if (kernel_map == NULL ||
-	    (kernel_map->dso->hit &&
-	     (kernel_kmap->ref_reloc_sym == NULL ||
-	      kernel_kmap->ref_reloc_sym->addr == 0))) {
-		const char *desc =
-		    "As no suitable kallsyms nor vmlinux was found, kernel samples\n"
-		    "can't be resolved.";
-
-		if (kernel_map) {
-			const struct dso *kdso = kernel_map->dso;
-			if (!RB_EMPTY_ROOT(&kdso->symbols[MAP__FUNCTION])) {
-				desc = "If some relocation was applied (e.g. "
-				       "kexec) symbols may be misresolved.";
-			}
-		}
-
-		ui__warning(
-"Kernel address maps (/proc/{kallsyms,modules}) were restricted.\n\n"
-"Check /proc/sys/kernel/kptr_restrict before running 'perf record'.\n\n%s\n\n"
-"Samples in kernel modules can't be resolved as well.\n\n",
-		desc);
-	}
+	report__warn_kptr_restrict(rep);
 
 	if (use_browser == 0) {
 		if (verbose > 3)
