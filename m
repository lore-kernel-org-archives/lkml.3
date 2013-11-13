Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab3KMR0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:26:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52912 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795Ab3KMR0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:26:03 -0500
Date: Wed, 13 Nov 2013 09:25:22 -0800
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-46a73e8a1c1720f7713b5e2df68e9dd272015b5d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, riel@redhat.com, mgorman@suse.de,
        tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, riel@redhat.com, mgorman@suse.de,
        tglx@linutronix.de, prarit@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/numa:
  Fix NULL pointer dereference in task_numa_migrate()
Git-Commit-ID: 46a73e8a1c1720f7713b5e2df68e9dd272015b5d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 13 Nov 2013 09:25:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46a73e8a1c1720f7713b5e2df68e9dd272015b5d
Gitweb:     http://git.kernel.org/tip/46a73e8a1c1720f7713b5e2df68e9dd272015b5d
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 11 Nov 2013 19:29:25 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Nov 2013 13:33:51 +0100

sched/numa: Fix NULL pointer dereference in task_numa_migrate()

The cpusets code can split up the scheduler's domain tree into
smaller domains.  Some of those smaller domains may not cross
NUMA nodes at all, leading to a NULL pointer dereference on the
per-cpu sd_numa pointer.

Tasks cannot be migrated out of their domain, so the patch
also sets p->numa_preferred_nid to whereever they are, to
prevent the migration from being retried over and over again.

Reported-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Link: http://lkml.kernel.org/n/tip-oosqomw0Jput0Jkvoowhrqtu@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df77c60..c11e36f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1201,9 +1201,21 @@ static int task_numa_migrate(struct task_struct *p)
 	 */
 	rcu_read_lock();
 	sd = rcu_dereference(per_cpu(sd_numa, env.src_cpu));
-	env.imbalance_pct = 100 + (sd->imbalance_pct - 100) / 2;
+	if (sd)
+		env.imbalance_pct = 100 + (sd->imbalance_pct - 100) / 2;
 	rcu_read_unlock();
 
+	/*
+	 * Cpusets can break the scheduler domain tree into smaller
+	 * balance domains, some of which do not cross NUMA boundaries.
+	 * Tasks that are "trapped" in such domains cannot be migrated
+	 * elsewhere, so there is no point in (re)trying.
+	 */
+	if (unlikely(!sd)) {
+		p->numa_preferred_nid = cpu_to_node(task_cpu(p));
+		return -EINVAL;
+	}
+
 	taskweight = task_weight(p, env.src_nid);
 	groupweight = group_weight(p, env.src_nid);
 	update_numa_stats(&env.src_stats, env.src_nid);
