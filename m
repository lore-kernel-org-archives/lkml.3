Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaACCMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 21:12:33 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:36589 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753372AbaACCLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 21:11:51 -0500
Message-Id: <20140103021146.891440418@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 02 Jan 2014 21:10:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 16/17] uprobes: Allocate ->utask before handler_chain() for tracing handlers
References: <20140103021021.238772653@goodmis.org>
Content-Disposition: inline; filename=0016-uprobes-Allocate-utask-before-handler_chain-for-trac.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

uprobe_trace_print() and uprobe_perf_print() need to pass the additional
info to call_fetch() methods, currently there is no simple way to do this.

current->utask looks like a natural place to hold this info, but we need
to allocate it before handler_chain().

This is a bit unfortunate, perhaps we will find a better solution later,
but this is simple and should work right now.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/events/uprobes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 24b7d6c..3cc8e0b 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1828,6 +1828,10 @@ static void handle_swbp(struct pt_regs *regs)
 	if (unlikely(!test_bit(UPROBE_COPY_INSN, &uprobe->flags)))
 		goto out;
 
+	/* Tracing handlers use ->utask to communicate with fetch methods */
+	if (!get_utask())
+		goto out;
+
 	handler_chain(uprobe, regs);
 	if (can_skip_sstep(uprobe, regs))
 		goto out;
-- 
1.8.4.3


