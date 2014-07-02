Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaGBON0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:13:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52525 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbaGBONZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:13:25 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Mike Travis <travis@sgi.com>, Randy Dunlap <rdunlap@infradead.org>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH v2] kgdb: Timeout if secondary CPUs ignore the roundup
Date: Wed,  2 Jul 2014 15:12:59 +0100
Message-Id: <1404310379-30228-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404224174-25024-1-git-send-email-daniel.thompson@linaro.org>
References: <1404224174-25024-1-git-send-email-daniel.thompson@linaro.org>
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

Notes:
    Changes since v1:
    - Set CATASTROPHIC if the system contains unresponsive processors
      (Jason Wessel)

 kernel/debug/debug_core.c       | 9 +++++++--
 kernel/debug/kdb/kdb_debugger.c | 4 ++++
 kernel/debug/kdb/kdb_main.c     | 4 +++-
 3 files changed, 14 insertions(+), 3 deletions(-)

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
diff --git a/kernel/debug/kdb/kdb_debugger.c b/kernel/debug/kdb/kdb_debugger.c
index 8859ca3..15e1a7a 100644
--- a/kernel/debug/kdb/kdb_debugger.c
+++ b/kernel/debug/kdb/kdb_debugger.c
@@ -129,6 +129,10 @@ int kdb_stub(struct kgdb_state *ks)
 		ks->pass_exception = 1;
 		KDB_FLAG_SET(CATASTROPHIC);
 	}
+	/* set CATASTROPHIC if the system contains unresponsive processors */
+	for_each_online_cpu(i)
+		if (!kgdb_info[i].enter_kgdb)
+			KDB_FLAG_SET(CATASTROPHIC);
 	if (KDB_STATE(SSBPT) && reason == KDB_REASON_SSTEP) {
 		KDB_STATE_CLEAR(SSBPT);
 		KDB_STATE_CLEAR(DOING_SS);
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

