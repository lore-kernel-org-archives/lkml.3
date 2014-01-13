Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaAMUyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:54:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40426 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaAMUsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 14/38] perf header: Pack 'struct perf_session_env'
Date: Mon, 13 Jan 2014 17:47:15 -0300
Message-Id: <1389646059-24881-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Initial struct:

[acme@ssdandy linux]$ pahole -C perf_session_env ~/bin/perf
struct perf_session_env {
	char *                     hostname;             /*     0     8 */
	char *                     os_release;           /*     8     8 */
	char *                     version;              /*    16     8 */
	char *                     arch;                 /*    24     8 */
	int                        nr_cpus_online;       /*    32     4 */
	int                        nr_cpus_avail;        /*    36     4 */
	char *                     cpu_desc;             /*    40     8 */
	char *                     cpuid;                /*    48     8 */
	long long unsigned int     total_mem;            /*    56     8 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	int                        nr_cmdline;           /*    64     4 */

	/* XXX 4 bytes hole, try to pack */

	char *                     cmdline;              /*    72     8 */
	int                        nr_sibling_cores;     /*    80     4 */

	/* XXX 4 bytes hole, try to pack */

	char *                     sibling_cores;        /*    88     8 */
	int                        nr_sibling_threads;   /*    96     4 */

	/* XXX 4 bytes hole, try to pack */

	char *                     sibling_threads;      /*   104     8 */
	int                        nr_numa_nodes;        /*   112     4 */

	/* XXX 4 bytes hole, try to pack */

	char *                     numa_nodes;           /*   120     8 */
	/* --- cacheline 2 boundary (128 bytes) --- */
	int                        nr_pmu_mappings;      /*   128     4 */

	/* XXX 4 bytes hole, try to pack */

	char *                     pmu_mappings;         /*   136     8 */
	int                        nr_groups;            /*   144     4 */

	/* size: 152, cachelines: 3, members: 20 */
	/* sum members: 128, holes: 5, sum holes: 20 */
	/* padding: 4 */
	/* last cacheline: 24 bytes */
};
[acme@ssdandy linux]$

[acme@ssdandy linux]$ pahole -C perf_session_env --reorganize --show_reorg_steps ~/bin/perf | grep ^/ | grep -v Final
/* Moving 'nr_sibling_cores' from after 'cmdline' to after 'nr_cmdline' */
/* Moving 'nr_numa_nodes' from after 'sibling_threads' to after 'nr_sibling_threads' */
/* Moving 'nr_groups' from after 'pmu_mappings' to after 'nr_pmu_mappings' */
[acme@ssdandy linux]$

Final struct stats:

[acme@ssdandy linux]$ pahole -C perf_session_env --reorganize --show_reorg_steps ~/bin/perf | tail -4
	/* --- cacheline 2 boundary (128 bytes) --- */

	/* size: 128, cachelines: 2, members: 20 */
};   /* saved 24 bytes and 1 cacheline! */
[acme@ssdandy linux]$

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3d9tshamloinzxcqeb7mtd1n@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 307c9aed972e..a2d047bdf4ef 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -77,16 +77,16 @@ struct perf_session_env {
 	unsigned long long	total_mem;
 
 	int			nr_cmdline;
-	char			*cmdline;
 	int			nr_sibling_cores;
-	char			*sibling_cores;
 	int			nr_sibling_threads;
-	char			*sibling_threads;
 	int			nr_numa_nodes;
-	char			*numa_nodes;
 	int			nr_pmu_mappings;
-	char			*pmu_mappings;
 	int			nr_groups;
+	char			*cmdline;
+	char			*sibling_cores;
+	char			*sibling_threads;
+	char			*numa_nodes;
+	char			*pmu_mappings;
 };
 
 struct perf_header {
-- 
1.8.1.4

