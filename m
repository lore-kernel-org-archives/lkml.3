Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbaJ1LDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:03:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50920 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbaJ1LDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:03:30 -0400
Date: Tue, 28 Oct 2014 04:02:38 -0700
From: tip-bot for Yasuaki Ishimatsu <tipbot@zytor.com>
Message-ID: <tip-2847c90e1b3ae95379af24894fc4f98e7f2fd705@git.kernel.org>
Cc: peterz@infradead.org, hpa@zytor.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, mingo@kernel.org
Reply-To: mingo@kernel.org, isimatu.yasuaki@jp.fujitsu.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        hpa@zytor.com, peterz@infradead.org
In-Reply-To: <54475703.8000505@jp.fujitsu.com>
References: <54475703.8000505@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Care divide error in update_task_scan_period()
Git-Commit-ID: 2847c90e1b3ae95379af24894fc4f98e7f2fd705
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

Commit-ID:  2847c90e1b3ae95379af24894fc4f98e7f2fd705
Gitweb:     http://git.kernel.org/tip/2847c90e1b3ae95379af24894fc4f98e7f2fd705
Author:     Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
AuthorDate: Wed, 22 Oct 2014 16:04:35 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:46:03 +0100

sched/fair: Care divide error in update_task_scan_period()

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
This patch always increments denominator for avoiding divide error.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/54475703.8000505@jp.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fbc0b82..e9abd4e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1530,7 +1530,7 @@ static void update_task_scan_period(struct task_struct *p,
 		 * scanning faster if shared accesses dominate as it may
 		 * simply bounce migrations uselessly
 		 */
-		ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (private + shared));
+		ratio = DIV_ROUND_UP(private * NUMA_PERIOD_SLOTS, (private + shared + 1));
 		diff = (diff * ratio) / NUMA_PERIOD_SLOTS;
 	}
 
