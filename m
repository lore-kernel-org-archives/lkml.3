Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3F1S5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:57:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41879 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab3F1S5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:57:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 092/105] hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)
Date: Fri, 28 Jun 2013 11:51:54 -0700
Message-Id: <1372445527-24414-93-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 8b4d801b2b123b6c09742f861fe44a8527b84d47 upstream.

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
Link: http://lkml.kernel.org/r/20130620155006.GA6324@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/events/hw_breakpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index fe8a916..4a99beb 100644
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
 
-- 
1.8.1.2

