Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab3LJJRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:17:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44051 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab3LJJQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:16:37 -0500
Date: Tue, 10 Dec 2013 01:16:06 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-906049c8276eb99af997f73d602649a98e360035@git.kernel.org>
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
In-Reply-To: <1386055390-13757-8-git-send-email-adrian.hunter@intel.com>
References: <1386055390-13757-8-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Do not disable source line lookup just because of 1 failure
Git-Commit-ID: 906049c8276eb99af997f73d602649a98e360035
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:16:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  906049c8276eb99af997f73d602649a98e360035
Gitweb:     http://git.kernel.org/tip/906049c8276eb99af997f73d602649a98e360035
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 3 Dec 2013 09:23:10 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 13:46:36 -0300

perf tools: Do not disable source line lookup just because of 1 failure

Looking up an ip's source file name and line number does not succeed
always.  Current logic disables the lookup for a dso entirely on any
failure.  Change it so that disabling never happens if there has ever
been a successful lookup for that dso but disable if the first 123
lookups fail.

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
Link: http://lkml.kernel.org/r/1386055390-13757-8-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c     |  1 +
 tools/perf/util/dso.h     |  1 +
 tools/perf/util/srcline.c | 20 ++++++++++++++++----
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 49da968..a0c7c59 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -451,6 +451,7 @@ struct dso *dso__new(const char *name)
 		dso->sorted_by_name = 0;
 		dso->has_build_id = 0;
 		dso->has_srcline = 1;
+		dso->a2l_fails = 1;
 		dso->kernel = DSO_TYPE_USER;
 		dso->needs_swap = DSO_SWAP__UNSET;
 		INIT_LIST_HEAD(&dso->node);
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 7142e52..384f2d9 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -79,6 +79,7 @@ struct dso {
 	struct rb_root	 cache;
 	void		 *a2l;
 	char		 *symsrc_filename;
+	unsigned int	 a2l_fails;
 	enum dso_kernel_type	kernel;
 	enum dso_swap_type	needs_swap;
 	enum dso_binary_type	symtab_type;
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index 93795f9..0c07556 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -244,6 +244,12 @@ void dso__free_a2l(struct dso *dso __maybe_unused)
 
 #endif /* HAVE_LIBBFD_SUPPORT */
 
+/*
+ * Number of addr2line failures (without success) before disabling it for that
+ * dso.
+ */
+#define A2L_FAIL_LIMIT 123
+
 char *get_srcline(struct dso *dso, unsigned long addr)
 {
 	char *file = NULL;
@@ -268,15 +274,21 @@ char *get_srcline(struct dso *dso, unsigned long addr)
 	if (!addr2line(dso_name, addr, &file, &line, dso))
 		goto out;
 
-	if (asprintf(&srcline, "%s:%u", file, line) < 0)
-		srcline = SRCLINE_UNKNOWN;
+	if (asprintf(&srcline, "%s:%u", file, line) < 0) {
+		free(file);
+		goto out;
+	}
+
+	dso->a2l_fails = 0;
 
 	free(file);
 	return srcline;
 
 out:
-	dso->has_srcline = 0;
-	dso__free_a2l(dso);
+	if (dso->a2l_fails && ++dso->a2l_fails > A2L_FAIL_LIMIT) {
+		dso->has_srcline = 0;
+		dso__free_a2l(dso);
+	}
 	return SRCLINE_UNKNOWN;
 }
 
