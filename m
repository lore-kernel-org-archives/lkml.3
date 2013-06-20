Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046Ab3FTQTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:19:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48270 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976Ab3FTQTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:19:03 -0400
Date: Thu, 20 Jun 2013 09:18:36 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-8b4d801b2b123b6c09742f861fe44a8527b84d47@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stable@vger.kernel.org, vincent.weaver@maine.edu, fweisbec@gmail.com,
        tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, vincent.weaver@maine.edu, fweisbec@gmail.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20130620155006.GA6324@redhat.com>
References: <20130620155006.GA6324@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw_breakpoint: Fix cpu check in task_bp_pinned(
 cpu)
Git-Commit-ID: 8b4d801b2b123b6c09742f861fe44a8527b84d47
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Jun 2013 09:18:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b4d801b2b123b6c09742f861fe44a8527b84d47
Gitweb:     http://git.kernel.org/tip/8b4d801b2b123b6c09742f861fe44a8527b84d47
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Thu, 20 Jun 2013 17:50:06 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 20 Jun 2013 17:57:00 +0200

hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)

trinity fuzzer triggered WARN_ONCE("Can't find any breakpoint
slot") in arch_install_hw_breakpoint() but the problem is not
arch-specific.

The problem is, task_bp_pinned(cpu) checks "cpu == iter->cpu"
but this doesn't account the "all cpus" events with iter->cpu <
0.

This means that, say, register_user_hw_breakpoint(tsk) can
happily create the arbitrary number > HBP_NUM of breakpoints
which can not be activated. toggle_bp_task_slot() is equally
wrong by the same reason and nr_task_bp_pinned[] can have
negative entries.

Simple test:

	# perl -e 'sleep 1 while 1' &
	# perf record -e mem:0x10,mem:0x10,mem:0x10,mem:0x10,mem:0x10 -p `pidof perl`

Before this patch this triggers the same problem/WARN_ON(),
after the patch it correctly fails with -ENOSPC.

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20130620155006.GA6324@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/hw_breakpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index a64f8ae..a853dea 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -120,7 +120,7 @@ static int task_bp_pinned(int cpu, struct perf_event *bp, enum bp_type_idx type)
 	list_for_each_entry(iter, &bp_task_head, hw.bp_list) {
 		if (iter->hw.bp_target == tsk &&
 		    find_slot_idx(iter) == type &&
-		    cpu == iter->cpu)
+		    (iter->cpu < 0 || cpu == iter->cpu))
 			count += hw_breakpoint_weight(iter);
 	}
 
