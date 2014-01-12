Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbaALSn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:43:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46218 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaALSnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:43:22 -0500
Date: Sun, 12 Jan 2014 10:42:47 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-f3ae75de98c4bac145a87d830c156c96f9414022@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1389176153-3128-2-git-send-email-eranian@google.com>
References: <1389176153-3128-2-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Fix active_entry initialization
Git-Commit-ID: f3ae75de98c4bac145a87d830c156c96f9414022
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:42:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3ae75de98c4bac145a87d830c156c96f9414022
Gitweb:     http://git.kernel.org/tip/f3ae75de98c4bac145a87d830c156c96f9414022
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 8 Jan 2014 11:15:52 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 12 Jan 2014 10:16:07 +0100

perf/x86: Fix active_entry initialization

This patch fixes a problem with the initialization of the
struct perf_event active_entry field. It is defined inside
an anonymous union and was initialized in perf_event_alloc()
using INIT_LIST_HEAD(). However at that time, we do not know
whether the event is going to use active_entry or hlist_entry (SW).
Or at last, we don't want to make that determination there.
The problem is that hlist and list_head are not initialized
the same way. One is okay with NULL (from kzmalloc), the other
needs to pointers to point to self.

This patch resolves this problem by dropping the union.
This will avoid problems later on, if someone starts using
active_entry or hlist_entry without verifying that they
actually overlap. This also solves the initialization
problem.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: ak@linux.intel.com
Cc: acme@redhat.com
Cc: jolsa@redhat.com
Cc: zheng.z.yan@intel.com
Cc: bp@alien8.de
Cc: vincent.weaver@maine.edu
Cc: maria.n.dimakopoulou@gmail.com
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389176153-3128-2-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/perf_event.h | 6 ++----
 kernel/events/core.c       | 2 ++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8f4a70f..e56b07f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -319,10 +319,8 @@ struct perf_event {
 	 */
 	struct list_head		migrate_entry;
 
-	union {
-		struct hlist_node	hlist_entry;
-		struct list_head	active_entry;
-	};
+	struct hlist_node		hlist_entry;
+	struct list_head		active_entry;
 	int				nr_siblings;
 	int				group_flags;
 	struct perf_event		*group_leader;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 89d34f9..c3b6c27 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6670,6 +6670,8 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	INIT_LIST_HEAD(&event->sibling_list);
 	INIT_LIST_HEAD(&event->rb_entry);
 	INIT_LIST_HEAD(&event->active_entry);
+	INIT_HLIST_NODE(&event->hlist_entry);
+
 
 	init_waitqueue_head(&event->waitq);
 	init_irq_work(&event->pending, perf_pending_event);
