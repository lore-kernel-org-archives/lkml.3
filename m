Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab3LJJQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:16:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44033 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab3LJJQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:16:26 -0500
Date: Tue, 10 Dec 2013 01:15:57 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-0058aef65eda9c9dde8253af702d542ba7eef697@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, ak@linux.intel.com, dsahern@gmail.com,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
Reply-To: mingo@kernel.org, mingo@redhat.com, eranian@google.com,
        acme@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        ak@linux.intel.com, tglx@linutronix.de, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@gmail.com,
        adrian.hunter@intel.com
In-Reply-To: <1386055390-13757-6-git-send-email-adrian.hunter@intel.com>
References: <1386055390-13757-6-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Retain symbol source file name to lookup source line numbers
Git-Commit-ID: 0058aef65eda9c9dde8253af702d542ba7eef697
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:16:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0058aef65eda9c9dde8253af702d542ba7eef697
Gitweb:     http://git.kernel.org/tip/0058aef65eda9c9dde8253af702d542ba7eef697
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 3 Dec 2013 09:23:08 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 13:46:36 -0300

perf symbols: Retain symbol source file name to lookup source line numbers

Currently, lookup of an ip's source file name and line number is done
using the dso file name.

Instead retain the file name used to lookup the dso's symbols and use
that.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1386055390-13757-6-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c     | 1 +
 tools/perf/util/dso.h     | 1 +
 tools/perf/util/srcline.c | 7 ++++++-
 tools/perf/util/symbol.c  | 2 ++
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 68aa55a..49da968 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -470,6 +470,7 @@ void dso__delete(struct dso *dso)
 		free(dso->long_name);
 	dso_cache__free(&dso->cache);
 	dso__free_a2l(dso);
+	free(dso->symsrc_filename);
 	free(dso);
 }
 
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index d8613dc..7142e52 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -78,6 +78,7 @@ struct dso {
 	struct rb_root	 symbol_names[MAP__NR_TYPES];
 	struct rb_root	 cache;
 	void		 *a2l;
+	char		 *symsrc_filename;
 	enum dso_kernel_type	kernel;
 	enum dso_swap_type	needs_swap;
 	enum dso_binary_type	symtab_type;
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 25b85b2..93795f9 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -249,11 +249,16 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	char *file = NULL;
 	unsigned line = 0;
 	char *srcline;
-	char *dso_name = dso->long_name;
+	char *dso_name;
 
 	if (!dso->has_srcline)
 		return SRCLINE_UNKNOWN;
 
+	if (dso->symsrc_filename)
+		dso_name = dso->symsrc_filename;
+	else
+		dso_name = dso->long_name;
+
 	if (dso_name[0] == '[')
 		goto out;
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 360eefe..de87dba 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1336,6 +1336,8 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 		if (!syms_ss && symsrc__has_symtab(ss)) {
 			syms_ss = ss;
 			next_slot = true;
+			if (!dso->symsrc_filename)
+				dso->symsrc_filename = strdup(name);
 		}
 
 		if (!runtime_ss && symsrc__possibly_runtime(ss)) {
