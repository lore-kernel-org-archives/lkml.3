Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbaCRIb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:31:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45704 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbaCRIbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:31:23 -0400
Date: Tue, 18 Mar 2014 01:30:36 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-so6nxkh7xj48bc5kq4jpj991@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        peterz@infradead.org, efault@gmx.de, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        efault@gmx.de, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Introduce thread__find_cpumode_addr_location
Git-Commit-ID: 52a3cb8cfca16db73cf825cb94325cf54da8304f
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

Commit-ID:  52a3cb8cfca16db73cf825cb94325cf54da8304f
Gitweb:     http://git.kernel.org/tip/52a3cb8cfca16db73cf825cb94325cf54da8304f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 11 Mar 2014 16:16:49 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 14 Mar 2014 18:08:40 -0300

perf symbols: Introduce thread__find_cpumode_addr_location

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
index 813e94e..a679953 100644
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
index 0358882..3ce0498 100644
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
index 5b856bf..9a07074 100644
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
