Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbaGEKqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:46:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58087 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555AbaGEKql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:46:41 -0400
Date: Sat, 5 Jul 2014 03:45:44 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-a22b4b012340b988dbe7a58461d6fcc582f34aa0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1403538095-31256-8-git-send-email-riel@redhat.com>
References: <1403538095-31256-8-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Change scan period code to match intent
Git-Commit-ID: a22b4b012340b988dbe7a58461d6fcc582f34aa0
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

Commit-ID:  a22b4b012340b988dbe7a58461d6fcc582f34aa0
Gitweb:     http://git.kernel.org/tip/a22b4b012340b988dbe7a58461d6fcc582f34aa0
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 23 Jun 2014 11:41:35 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:17:40 +0200

sched/numa: Change scan period code to match intent

Reading through the scan period code and comment, it appears the
intent was to slow down NUMA scanning when a majority of accesses
are on the local node, specifically a local:remote ratio of 3:1.

However, the code actually tests local / (local + remote), and
the actual cut-off point was around 30% local accesses, well before
a task has actually converged on a node.

Changing the threshold to 7 means scanning slows down when a task
has around 70% of its accesses local, which appears to match the
intent of the code more closely.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: mgorman@suse.de
Cc: chegu_vinod@hp.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1403538095-31256-8-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7bb2f46..a140c6a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1452,12 +1452,12 @@ static void update_numa_active_node_mask(struct numa_group *numa_group)
 /*
  * When adapting the scan rate, the period is divided into NUMA_PERIOD_SLOTS
  * increments. The more local the fault statistics are, the higher the scan
- * period will be for the next scan window. If local/remote ratio is below
- * NUMA_PERIOD_THRESHOLD (where range of ratio is 1..NUMA_PERIOD_SLOTS) the
- * scan period will decrease
+ * period will be for the next scan window. If local/(local+remote) ratio is
+ * below NUMA_PERIOD_THRESHOLD (where range of ratio is 1..NUMA_PERIOD_SLOTS)
+ * the scan period will decrease. Aim for 70% local accesses.
  */
 #define NUMA_PERIOD_SLOTS 10
-#define NUMA_PERIOD_THRESHOLD 3
+#define NUMA_PERIOD_THRESHOLD 7
 
 /*
  * Increase the scan period (slow down scanning) if the majority of
