Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab3HTBsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 21:48:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:44960 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab3HTBr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 21:47:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,916,1367996400"; 
   d="scan'208";a="389853530"
Subject: [PATCH] Enable dumping running process stack.
From: Leon Ma <xindong.ma@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Aug 2013 09:40:48 +0800
Message-ID: <1376962848.20932.11.camel@leonma-sh>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leon Ma <xindong.ma@intel.com>
Date: Fri, 16 Aug 2013 13:11:15 +0800
Subject: [PATCH] Enable dumping running process stack.

Currently, if the process is running, we can not dump the stack via
/proc/<pid>/stack, because in __save_stack_address() it will return
immediately if the address is not reliable.
Sometimes one process would run into dead loop in kernel, it will
facilitate debugging to have it's stack retrieved via procfs.

Signed-off-by: Leon Ma <xindong.ma@intel.com>
---
 arch/x86/kernel/dumpstack.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 1b81839..c892ceb 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -103,7 +103,10 @@ print_context_stack(struct thread_info *tinfo,
 				frame = frame->next_frame;
 				bp = (unsigned long) frame;
 			} else {
-				ops->address(data, addr, 0);
+				if (tinfo->task->state == TASK_RUNNING)
+					ops->address(data, addr, 1);
+				else
+					ops->address(data, addr, 0);
 			}
 			print_ftrace_graph_addr(addr, data, ops, tinfo, graph);
 		}
-- 
1.7.4.1



