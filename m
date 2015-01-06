Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbbAFTqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:46:04 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:44735 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbbAFTp5 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 6 Jan 2015 14:45:57 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 6/6] locking/osq: No need for load/acquire when acquire-polling
Date: Tue,  6 Jan 2015 11:45:09 -0800
Message-Id: <1420573509-24774-7-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1420573509-24774-1-git-send-email-dave@stgolabs.net>
References: <1420573509-24774-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both mutexes and rwsems took a performance hit when we switched
over from the original mcs code to the cancelable variant (osq).
The reason being the use of smp_load_acquire() when polling for
node->locked. This is not needed as reordering is not an issue,
as such, relax the barrier semantics. Paul describes the scenario
nicely: https://lkml.org/lkml/2013/11/19/405

o If we start polling before the insertion is complete, all that
happens is that the first few polls have no chance of seeing a lock
grant.

o Ordering the polling against the initialization -- the above
 xchg() is already doing that for us.

The smp_load_acquire() when unqueuing make sense. In addition,
we don't need to worry about leaking the critical region as
osq is only used internally.

This impacts both regular and large levels of concurrency,
ie on a 40 core system with a disk intensive workload:

disk-1               804.83 (  0.00%)      828.16 (  2.90%)
disk-61             8063.45 (  0.00%)    18181.82 (125.48%)
disk-121            7187.41 (  0.00%)    20119.17 (179.92%)
disk-181            6933.32 (  0.00%)    20509.91 (195.82%)
disk-241            6850.81 (  0.00%)    20397.80 (197.74%)
disk-301            6815.22 (  0.00%)    20287.58 (197.68%)
disk-361            7080.40 (  0.00%)    20205.22 (185.37%)
disk-421            7076.13 (  0.00%)    19957.33 (182.04%)
disk-481            7083.25 (  0.00%)    19784.06 (179.31%)
disk-541            7038.39 (  0.00%)    19610.92 (178.63%)
disk-601            7072.04 (  0.00%)    19464.53 (175.23%)
disk-661            7010.97 (  0.00%)    19348.23 (175.97%)
disk-721            7069.44 (  0.00%)    19255.33 (172.37%)
disk-781            7007.58 (  0.00%)    19103.14 (172.61%)
disk-841            6981.18 (  0.00%)    18964.22 (171.65%)
disk-901            6968.47 (  0.00%)    18826.72 (170.17%)
disk-961            6964.61 (  0.00%)    18708.02 (168.62%)

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/osq_lock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/osq_lock.c b/kernel/locking/osq_lock.c
index 9c6e251..aa56e3c 100644
--- a/kernel/locking/osq_lock.c
+++ b/kernel/locking/osq_lock.c
@@ -109,7 +109,7 @@ bool osq_lock(struct optimistic_spin_queue *lock)
 	 * cmpxchg in an attempt to undo our queueing.
 	 */
 
-	while (!smp_load_acquire(&node->locked)) {
+	while (!ACCESS_ONCE(node->locked)) {
 		/*
 		 * If we need to reschedule bail... so we can block.
 		 */
-- 
2.1.2

