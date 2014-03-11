Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbaCKMha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:37:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35546 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbaCKMh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:37:28 -0400
Date: Tue, 11 Mar 2014 05:36:47 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-177c53d943368fc97644ebc0a250dc8e2d124250@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hch@infradead.org, riel@redhat.com,
        akpm@linux-foundation.org, mgorman@suse.de, tglx@linutronix.de,
        prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hch@infradead.org, riel@redhat.com,
        akpm@linux-foundation.org, mgorman@suse.de, tglx@linutronix.de,
        prarit@redhat.com
In-Reply-To: <20140228123905.GK3104@twins.programming.kicks-ass.net>
References: <20140228123905.GK3104@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] stop_machine: Fix^2 race between stop_two_cpus()
  and stop_cpus()
Git-Commit-ID: 177c53d943368fc97644ebc0a250dc8e2d124250
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

Commit-ID:  177c53d943368fc97644ebc0a250dc8e2d124250
Gitweb:     http://git.kernel.org/tip/177c53d943368fc97644ebc0a250dc8e2d124250
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 28 Feb 2014 13:39:05 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 11:33:47 +0100

stop_machine: Fix^2 race between stop_two_cpus() and stop_cpus()

We must use smp_call_function_single(.wait=1) for the
irq_cpu_stop_queue_work() to ensure the queueing is actually done under
stop_cpus_lock. Without this we could have dropped the lock by the time
we do the queueing and get the race we tried to fix.

Fixes: 7053ea1a34fa ("stop_machine: Fix race between stop_two_cpus() and stop_cpus()")

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140228123905.GK3104@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/stop_machine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 84571e0..01fbae5 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -293,7 +293,7 @@ int stop_two_cpus(unsigned int cpu1, unsigned int cpu2, cpu_stop_fn_t fn, void *
 	 */
 	smp_call_function_single(min(cpu1, cpu2),
 				 &irq_cpu_stop_queue_work,
-				 &call_args, 0);
+				 &call_args, 1);
 	lg_local_unlock(&stop_cpus_lock);
 	preempt_enable();
 
