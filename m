Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab3GAUKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:10:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab3GAUK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 06/26] hw_breakpoint: Fix cpu check in task_bp_pinned(cpu)
Date: Mon,  1 Jul 2013 13:10:01 -0700
Message-Id: <20130701200730.605800878@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200729.872850414@linuxfoundation.org>
References: <20130701200729.872850414@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/events/hw_breakpoint.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -120,7 +120,7 @@ static int task_bp_pinned(int cpu, struc
 	list_for_each_entry(iter, &bp_task_head, hw.bp_list) {
 		if (iter->hw.bp_target == tsk &&
 		    find_slot_idx(iter) == type &&
-		    cpu == iter->cpu)
+		    (iter->cpu < 0 || cpu == iter->cpu))
 			count += hw_breakpoint_weight(iter);
 	}
 


