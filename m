Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab3I3Pck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:32:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44565 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab3I3Pcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:32:36 -0400
Message-Id: <20130930152242.207382649@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 30 Sep 2013 17:22:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/6] sched, wait: Collapse __wait_event macros -v4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While poking at the cpu hotplug implementation I had a desire to use
wait_event() with schedule_preempt_disabled() and found the rediculous
amount of duplication in linux/wait.h.

These patches attempt to cure some of this while also making it
'trivial' to generate new variants.

Compile and boot tested on x86_64.

Changes since -v3:
 - added LKML to the CC (D'0h!!)
 - introduced ___wait_cond_timeout() to avoid double evalutation of 'condition'

Changes since -v2:
 - removed ___wait_cmd_lock_irq(), ___wait_cmd_lock_irq_timo()
 - renamed ___wait_cmd_test_timeout() to ___wait_test_timeout()
 - renamed ___wait_cmd_schedule_timeout() to ___wait_sched_timeout()
 - fixed schedule_timeout() invocations in patch 6; don't restart a
   schedule_timeout() at the total timeout; rather continue where we
   left off for a total fixed timeout.
 - use 'long' return type for ___wait_event() so that timeout values
   for schedule_timeout() fit.
 - fix wait_event_interruptible_lock_irq_timeout() and use long return type.


---
 arch/mips/kernel/rtlx.c         |   19 +-
 include/linux/tty.h             |   28 +---
 include/linux/wait.h            |  268 +++++++++++++---------------------------
 net/irda/af_irda.c              |    5 
 net/netfilter/ipvs/ip_vs_sync.c |    7 -
 5 files changed, 108 insertions(+), 219 deletions(-)

