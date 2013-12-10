Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab3LJPv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:51:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949Ab3LJPvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:51:48 -0500
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 15/18] mm: numa: Trace tasks that fail migration due to rate limiting
Date: Tue, 10 Dec 2013 15:51:33 +0000
Message-Id: <1386690695-27380-16-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386690695-27380-1-git-send-email-mgorman@suse.de>
References: <1386690695-27380-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A low local/remote numa hinting fault ratio is potentially explained by
failed migrations. This patch adds a tracepoint that fires when migration
fails due to migration rate limitation.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
---
 include/trace/events/migrate.h | 26 ++++++++++++++++++++++++++
 mm/migrate.c                   |  5 ++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/migrate.h b/include/trace/events/migrate.h
index ec2a6cc..3075ffb 100644
--- a/include/trace/events/migrate.h
+++ b/include/trace/events/migrate.h
@@ -45,6 +45,32 @@ TRACE_EVENT(mm_migrate_pages,
 		__print_symbolic(__entry->reason, MIGRATE_REASON))
 );
 
+TRACE_EVENT(mm_numa_migrate_ratelimit,
+
+	TP_PROTO(struct task_struct *p, int dst_nid, unsigned long nr_pages),
+
+	TP_ARGS(p, dst_nid, nr_pages),
+
+	TP_STRUCT__entry(
+		__array(	char,		comm,	TASK_COMM_LEN)
+		__field(	pid_t,		pid)
+		__field(	int,		dst_nid)
+		__field(	unsigned long,	nr_pages)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
+		__entry->pid		= p->pid;
+		__entry->dst_nid	= dst_nid;
+		__entry->nr_pages	= nr_pages;
+	),
+
+	TP_printk("comm=%s pid=%d dst_nid=%d nr_pages=%lu",
+		__entry->comm,
+		__entry->pid,
+		__entry->dst_nid,
+		__entry->nr_pages)
+);
 #endif /* _TRACE_MIGRATE_H */
 
 /* This part must be outside protection */
diff --git a/mm/migrate.c b/mm/migrate.c
index 564d5c9..8dc277d 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1608,8 +1608,11 @@ static bool numamigrate_update_ratelimit(pg_data_t *pgdat,
 			msecs_to_jiffies(migrate_interval_millisecs);
 		spin_unlock(&pgdat->numabalancing_migrate_lock);
 	}
-	if (pgdat->numabalancing_migrate_nr_pages > ratelimit_pages)
+	if (pgdat->numabalancing_migrate_nr_pages > ratelimit_pages) {
+		trace_mm_numa_migrate_ratelimit(current, pgdat->node_id,
+								nr_pages);
 		return true;
+	}
 
 	/*
 	 * This is an unlocked non-atomic update so errors are possible.
-- 
1.8.4

