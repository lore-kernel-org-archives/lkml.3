Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbaGAOQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:16:38 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:57098 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757595AbaGAOQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:16:36 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Mike Travis <travis@sgi.com>, Randy Dunlap <rdunlap@infradead.org>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>, kgdb-bugreport@lists.sourceforge.net
Subject: [RFC PATCH] kgdb: Timeout if secondary CPUs ignore the roundup
Date: Tue,  1 Jul 2014 15:16:14 +0100
Message-Id: <1404224174-25024-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if an active CPU fails to respond to a roundup request the
CPU that requested the roundup will become stuck. This needlessly
reduces the robustness of the debugger.

This patch introduces a timeout allowing the system state to be examined
even when the system contains unresponsive processors. It also modifies
kdb's cpu command to make it censor attempts to switch to unresponsive
processors and to report their state as (D)ead.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: kgdb-bugreport@lists.sourceforge.net
---
 kernel/debug/debug_core.c   | 9 +++++++--
 kernel/debug/kdb/kdb_main.c | 4 +++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 1adf62b..acd7497 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -471,6 +471,7 @@ static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs,
 	int cpu;
 	int trace_on = 0;
 	int online_cpus = num_online_cpus();
+	u64 time_left;
 
 	kgdb_info[ks->cpu].enter_kgdb++;
 	kgdb_info[ks->cpu].exception_state |= exception_state;
@@ -595,9 +596,13 @@ return_normal:
 	/*
 	 * Wait for the other CPUs to be notified and be waiting for us:
 	 */
-	while (kgdb_do_roundup && (atomic_read(&masters_in_kgdb) +
-				atomic_read(&slaves_in_kgdb)) != online_cpus)
+	time_left = loops_per_jiffy * HZ;
+	while (kgdb_do_roundup && --time_left &&
+	       (atomic_read(&masters_in_kgdb) + atomic_read(&slaves_in_kgdb)) !=
+		   online_cpus)
 		cpu_relax();
+	if (!time_left)
+		pr_crit("KGDB: Timed out waiting for secondary CPUs.\n");
 
 	/*
 	 * At this point the primary processor is completely
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 2f7c760..49f2425 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2157,6 +2157,8 @@ static void kdb_cpu_status(void)
 	for (start_cpu = -1, i = 0; i < NR_CPUS; i++) {
 		if (!cpu_online(i)) {
 			state = 'F';	/* cpu is offline */
+		} else if (!kgdb_info[i].enter_kgdb) {
+			state = 'D';	/* cpu is online but unresponsive */
 		} else {
 			state = ' ';	/* cpu is responding to kdb */
 			if (kdb_task_state_char(KDB_TSK(i)) == 'I')
@@ -2210,7 +2212,7 @@ static int kdb_cpu(int argc, const char **argv)
 	/*
 	 * Validate cpunum
 	 */
-	if ((cpunum > NR_CPUS) || !cpu_online(cpunum))
+	if ((cpunum > NR_CPUS) || !kgdb_info[cpunum].enter_kgdb)
 		return KDB_BADCPUNUM;
 
 	dbg_switch_cpu = cpunum;
-- 
1.9.3

