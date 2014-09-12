Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbaILNTQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:19:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbaILNTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:19:13 -0400
From: Aaron Tomlin <atomlin@redhat.com>
To: peterz@infradead.org
Cc: mingo@redhat.com, dzickus@redhat.com, bmr@redhat.com, jcastillo@redhat.com,
        atomlin@redhat.com, oleg@redhat.com, riel@redhat.com,
        prarit@redhat.com, jgh@redhat.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, x86@kernel.org, rostedt@goodmis.org,
        hannes@cmpxchg.org, aneesh.kumar@linux.vnet.ibm.com,
        akpm@linux-foundation.org, akpm@google.com,
        linuxppc-dev@lists.ozlabs.org, minchan@kernel.org, mpe@ellerman.id.au
Subject: [PATCH v4 0/3] sched: Always check the integrity of the canary
Date: Fri, 12 Sep 2014 14:16:16 +0100
Message-Id: <1410527779-8133-1-git-send-email-atomlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Please let me know if this iteration is satisfactory. Thanks.


Currently in the event of a stack overrun a call to schedule()
does not check for this type of corruption. This corruption is
often silent and can go unnoticed. However once the corrupted
region is examined at a later stage, the outcome is undefined
and often results in a sporadic page fault which cannot be
handled.

The first patch adds a canary to init_task's end of stack.
While the second patch provides a helper to determine the
integrity of the canary. The third checks for a stack
overrun and takes appropriate action since the damage
is already done, there is no point in continuing.


Changes since v3:

 * Add Michael Ellerman's Acked-by to first patch
   (for powerpc)
 * Fix compiler error - Michael Ellerman
 * Set default Kconfig option to n - Michael Ellerman

Changes since v2:

 * Use BUG_ON in schedule_debug() - Peter Zijlstra
 * Use a more explicit function
   name for setting the canary - Chuck Ebbert

Changes since v1:

 * Rebased against v3.17-rc4
 * Add a canary to init_task - Oleg Nesterov
 * Fix various code formatting issues - Peter Zijlstra
 * Introduce Kconfig option - Peter Zijlstra

Aaron Tomlin (3):
  init/main.c: Give init_task a canary
  sched: Add helper for task stack page overrun checking
  sched: BUG when stack end location is over written

 arch/powerpc/mm/fault.c    |  5 +----
 arch/x86/mm/fault.c        |  5 +----
 include/linux/sched.h      |  4 ++++
 init/main.c                |  1 +
 kernel/fork.c              | 12 +++++++++---
 kernel/sched/core.c        |  3 +++
 kernel/trace/trace_stack.c |  4 +---
 lib/Kconfig.debug          | 12 ++++++++++++
 8 files changed, 32 insertions(+), 14 deletions(-)

-- 
1.9.3

