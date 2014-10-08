Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaJHGoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 02:44:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35436 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaJHGoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 02:44:11 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <5434DCFF.1040208@jp.fujitsu.com>
Date: Wed, 8 Oct 2014 15:43:11 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <mingo@redhat.com>, <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <riel@redhat.com>, <tkhai@yandex.ru>
Subject: [PATCH] sched/fair: Care divide error in update_task_scan_period()
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While offling node by hot removing memory, the following divide error
occurs:

  divide error: 0000 [#1] SMP
  [...]
  Call Trace:
   [...] handle_mm_fault
   [...] ? try_to_wake_up
   [...] ? wake_up_state
   [...] __do_page_fault
   [...] ? do_futex
   [...] ? put_prev_entity
   [...] ? __switch_to
   [...] do_page_fault
   [...] page_fault
  [...]
  RIP  [<ffffffff810a7081>] task_numa_fault
   RSP <ffff88084eb2bcb0>

The issue occurs as follows:
  1. When page fault occurs and page is allocated from node 1,
     task_struct->numa_faults_buffer_memory[] of node 1 is
     incremented and p->numa_faults_locality[] is also incremented
     as follows:

     o numa_faults_buffer_memory[]       o numa_faults_locality[]
              NR_NUMA_HINT_FAULT_TYPES
             |      0     |     1     |
     ----------------------------------  ----------------------
      node 0 |      0     |     0     |   remote |      0     |
      node 1 |      0     |     1     |   locale |      1     |
     ----------------------------------  ----------------------

  2. node 1 is offlined by hot removing memory.

  3. When page fault occurs, fault_types[] is calculated by using
     p->numa_faults_buffer_memory[] of all online nodes in
     task_numa_placement(). But node 1 was offline by step 2. So
     the fault_types[] is calculated by using only
     p->numa_faults_buffer_memory[] of node 0. So both of fault_types[]
     are set to 0.

  4. The values(0) of fault_types[] pass to update_task_scan_period().

  5. numa_faults_locality[1] is set to 1. So the following division is
     calculated.

        static void update_task_scan_period(struct task_struct *p,
                                unsigned long shared, unsigned long private){
        ...
                ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (private + shared));
        }

  6. But both of private and shared are set to 0. So divide error
     occurs here.

  The divide error is rare case because the trigger is node offline.
  By this patch, when both of private and shared are set to 0, diff
  is just set to 0, not calculating the division.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 kernel/sched/fair.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bfa3c86..fb7dc3f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1496,18 +1496,26 @@ static void update_task_scan_period(struct task_struct *p,
 			slot = 1;
 		diff = slot * period_slot;
 	} else {
-		diff = -(NUMA_PERIOD_THRESHOLD - ratio) * period_slot;
+		if (unlikely((private + shared) == 0))
+			/*
+			 * This is a rare case. The trigger is node offline.
+			 */
+			diff = 0;
+		else {
+			diff = -(NUMA_PERIOD_THRESHOLD - ratio) * period_slot;

-		/*
-		 * Scale scan rate increases based on sharing. There is an
-		 * inverse relationship between the degree of sharing and
-		 * the adjustment made to the scanning period. Broadly
-		 * speaking the intent is that there is little point
-		 * scanning faster if shared accesses dominate as it may
-		 * simply bounce migrations uselessly
-		 */
-		ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (private + shared));
-		diff = (diff * ratio) / NUMA_PERIOD_SLOTS;
+			/*
+			 * Scale scan rate increases based on sharing. There is
+			 * an inverse relationship between the degree of sharing
+			 * and the adjustment made to the scanning period.
+			 * Broadly speaking the intent is that there is little
+			 * point scanning faster if shared accesses dominate as
+			 * it may simply bounce migrations uselessly
+			 */
+			ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS,
+							(private + shared));
+			diff = (diff * ratio) / NUMA_PERIOD_SLOTS;
+		}
 	}

 	p->numa_scan_period = clamp(p->numa_scan_period + diff,
-- 
1.8.3.1


