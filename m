Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaANQji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:39:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52682 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaANQjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:39:25 -0500
Date: Tue, 14 Jan 2014 08:38:39 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-3d9tshamloinzxcqeb7mtd1n@git.kernel.org>
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
Subject: [tip:perf/core] perf header: Pack 'struct perf_session_env'
Git-Commit-ID: 3ba4d2e1a8235d862657ded9f20b3170b477768b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:38:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ba4d2e1a8235d862657ded9f20b3170b477768b
Gitweb:     http://git.kernel.org/tip/3ba4d2e1a8235d862657ded9f20b3170b477768b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 6 Jan 2014 15:28:35 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:23 -0300

perf header: Pack 'struct perf_session_env'

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
index 307c9ae..a2d047b 100644
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
