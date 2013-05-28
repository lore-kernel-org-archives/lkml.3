Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209Ab3E1Dzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52579 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758851Ab3E1DyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:15 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Namhyung Kim" <namhyung.kim@lge.com>,
        "Namhyung Kim" <namhyung@kernel.org>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.879023017@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [71/94] sched/debug: Limit sd->*_idx range on sysctl
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung.kim@lge.com>

commit 201c373e8e4823700d3160d5c28e1ab18fd1193e upstream.

Various sd->*_idx's are used for refering the rq's load average table
when selecting a cpu to run.  However they can be set to any number
with sysctl knobs so that it can crash the kernel if something bad is
given. Fix it by limiting them into the actual range.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1345104204-8317-1-git-send-email-namhyung@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.2:
 - Adjust filename
 - s/umode_t/mode_t/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sched.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6672,16 +6672,25 @@ static void sd_free_ctl_entry(struct ctl
 	*tablep = NULL;
 }
 
+static int min_load_idx = 0;
+static int max_load_idx = CPU_LOAD_IDX_MAX;
+
 static void
 set_table_entry(struct ctl_table *entry,
 		const char *procname, void *data, int maxlen,
-		mode_t mode, proc_handler *proc_handler)
+		mode_t mode, proc_handler *proc_handler,
+		bool load_idx)
 {
 	entry->procname = procname;
 	entry->data = data;
 	entry->maxlen = maxlen;
 	entry->mode = mode;
 	entry->proc_handler = proc_handler;
+
+	if (load_idx) {
+		entry->extra1 = &min_load_idx;
+		entry->extra2 = &max_load_idx;
+	}
 }
 
 static struct ctl_table *
@@ -6693,30 +6702,30 @@ sd_alloc_ctl_domain_table(struct sched_d
 		return NULL;
 
 	set_table_entry(&table[0], "min_interval", &sd->min_interval,
-		sizeof(long), 0644, proc_doulongvec_minmax);
+		sizeof(long), 0644, proc_doulongvec_minmax, false);
 	set_table_entry(&table[1], "max_interval", &sd->max_interval,
-		sizeof(long), 0644, proc_doulongvec_minmax);
+		sizeof(long), 0644, proc_doulongvec_minmax, false);
 	set_table_entry(&table[2], "busy_idx", &sd->busy_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[3], "idle_idx", &sd->idle_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[4], "newidle_idx", &sd->newidle_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[5], "wake_idx", &sd->wake_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[6], "forkexec_idx", &sd->forkexec_idx,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, true);
 	set_table_entry(&table[7], "busy_factor", &sd->busy_factor,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[8], "imbalance_pct", &sd->imbalance_pct,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[9], "cache_nice_tries",
 		&sd->cache_nice_tries,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[10], "flags", &sd->flags,
-		sizeof(int), 0644, proc_dointvec_minmax);
+		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[11], "name", sd->name,
-		CORENAME_MAX_SIZE, 0444, proc_dostring);
+		CORENAME_MAX_SIZE, 0444, proc_dostring, false);
 	/* &table[12] is terminator */
 
 	return table;

