Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbaCNVaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:30:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54049 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315AbaCNVac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:30:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 12/16] perf symbols: Introduce thread__find_cpumode_addr_location
Date: Fri, 14 Mar 2014 18:30:06 -0300
Message-Id: <1394832610-17818-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394832610-17818-1-git-send-email-acme@infradead.org>
References: <1394832610-17818-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Its one level up thread__find_addr_location, where it will look in
different domains for a sample: user, kernel, hypervisor, etc.

Will soon be used by a patchkit by Andi Kleen.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-so6nxkh7xj48bc5kq4jpj991@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 33 ++++++++-------------------------
 tools/perf/util/thread.c  | 21 +++++++++++++++++++++
 tools/perf/util/thread.h  |  5 +++++
 3 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 813e94e7cf29..a6799538069c 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1184,39 +1184,22 @@ static bool symbol__match_regex(struct symbol *sym, regex_t *regex)
 	return 0;
 }
 
-static const u8 cpumodes[] = {
-	PERF_RECORD_MISC_USER,
-	PERF_RECORD_MISC_KERNEL,
-	PERF_RECORD_MISC_GUEST_USER,
-	PERF_RECORD_MISC_GUEST_KERNEL
-};
-#define NCPUMODES (sizeof(cpumodes)/sizeof(u8))
-
 static void ip__resolve_ams(struct machine *machine, struct thread *thread,
 			    struct addr_map_symbol *ams,
 			    u64 ip)
 {
 	struct addr_location al;
-	size_t i;
-	u8 m;
 
 	memset(&al, 0, sizeof(al));
+	/*
+	 * We cannot use the header.misc hint to determine whether a
+	 * branch stack address is user, kernel, guest, hypervisor.
+	 * Branches may straddle the kernel/user/hypervisor boundaries.
+	 * Thus, we have to try consecutively until we find a match
+	 * or else, the symbol is unknown
+	 */
+	thread__find_cpumode_addr_location(thread, machine, MAP__FUNCTION, ip, &al);
 
-	for (i = 0; i < NCPUMODES; i++) {
-		m = cpumodes[i];
-		/*
-		 * We cannot use the header.misc hint to determine whether a
-		 * branch stack address is user, kernel, guest, hypervisor.
-		 * Branches may straddle the kernel/user/hypervisor boundaries.
-		 * Thus, we have to try consecutively until we find a match
-		 * or else, the symbol is unknown
-		 */
-		thread__find_addr_location(thread, machine, m, MAP__FUNCTION,
-				ip, &al);
-		if (al.map)
-			goto found;
-	}
-found:
 	ams->addr = ip;
 	ams->al_addr = al.addr;
 	ams->sym = al.sym;
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 0358882c8910..3ce0498bdae6 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -142,3 +142,24 @@ int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
 
 	return 0;
 }
+
+void thread__find_cpumode_addr_location(struct thread *thread,
+					struct machine *machine,
+					enum map_type type, u64 addr,
+					struct addr_location *al)
+{
+	size_t i;
+	const u8 const cpumodes[] = {
+		PERF_RECORD_MISC_USER,
+		PERF_RECORD_MISC_KERNEL,
+		PERF_RECORD_MISC_GUEST_USER,
+		PERF_RECORD_MISC_GUEST_KERNEL
+	};
+
+	for (i = 0; i < ARRAY_SIZE(cpumodes); i++) {
+		thread__find_addr_location(thread, machine, cpumodes[i], type,
+					   addr, al);
+		if (al->map)
+			break;
+	}
+}
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 5b856bf942e1..9a070743270c 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -58,6 +58,11 @@ void thread__find_addr_location(struct thread *thread, struct machine *machine,
 				u8 cpumode, enum map_type type, u64 addr,
 				struct addr_location *al);
 
+void thread__find_cpumode_addr_location(struct thread *thread,
+					struct machine *machine,
+					enum map_type type, u64 addr,
+					struct addr_location *al);
+
 static inline void *thread__priv(struct thread *thread)
 {
 	return thread->priv;
-- 
1.8.1.4

