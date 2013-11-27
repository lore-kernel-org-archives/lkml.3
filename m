Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab3K0OIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:08:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47629 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab3K0OIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:08:30 -0500
Date: Wed, 27 Nov 2013 06:07:52 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-71ad88efebbcde374bddf904b96f3a7fc82d45d4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, ak@linux.intel.com,
        tglx@linutronix.de
In-Reply-To: <1384275531-10892-2-git-send-email-eranian@google.com>
References: <1384275531-10892-2-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Add active_entry list head to struct perf_event
Git-Commit-ID: 71ad88efebbcde374bddf904b96f3a7fc82d45d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 27 Nov 2013 06:07:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  71ad88efebbcde374bddf904b96f3a7fc82d45d4
Gitweb:     http://git.kernel.org/tip/71ad88efebbcde374bddf904b96f3a7fc82d45d4
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 12 Nov 2013 17:58:48 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 27 Nov 2013 11:16:38 +0100

perf: Add active_entry list head to struct perf_event

This patch adds a new field to the struct perf_event.
It is intended to be used to chain events which are
active (enabled). It helps in the hardware layer
for PMUs which do not have actual counter restrictions, i.e.,
free running read-only counters. Active events are chained
as opposed to being tracked via the counter they use.

To save space we use a union with hlist_entry as both
are mutually exclusive (suggested by Jiri Olsa).

Signed-off-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: acme@redhat.com
Cc: jolsa@redhat.com
Cc: zheng.z.yan@intel.com
Cc: bp@alien8.de
Cc: maria.n.dimakopoulou@gmail.com
Link: http://lkml.kernel.org/r/1384275531-10892-2-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h | 5 ++++-
 kernel/events/core.c       | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2e069d1..8f4a70f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -319,7 +319,10 @@ struct perf_event {
 	 */
 	struct list_head		migrate_entry;
 
-	struct hlist_node		hlist_entry;
+	union {
+		struct hlist_node	hlist_entry;
+		struct list_head	active_entry;
+	};
 	int				nr_siblings;
 	int				group_flags;
 	struct perf_event		*group_leader;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 72348dc..403b781 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6655,6 +6655,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	INIT_LIST_HEAD(&event->event_entry);
 	INIT_LIST_HEAD(&event->sibling_list);
 	INIT_LIST_HEAD(&event->rb_entry);
+	INIT_LIST_HEAD(&event->active_entry);
 
 	init_waitqueue_head(&event->waitq);
 	init_irq_work(&event->pending, perf_pending_event);
