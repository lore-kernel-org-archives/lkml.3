Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab3K0GU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:20:27 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:50663 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab3K0GUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:20:15 -0500
X-AuditID: 9c930197-b7caaae000001cef-c2-52958f173af3
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 16/17] uprobes: Allocate ->utask before handler_chain() for tracing handlers
Date: Wed, 27 Nov 2013 15:20:02 +0900
Message-Id: <1385533203-10014-17-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

uprobe_trace_print() and uprobe_perf_print() need to pass the additional
info to call_fetch() methods, currently there is no simple way to do this.

current->utask looks like a natural place to hold this info, but we need
to allocate it before handler_chain().

This is a bit unfortunate, perhaps we will find a better solution later,
but this is simnple and should work right now.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/events/uprobes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index ad8e1bdca70e..a1aa4aed029c 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1744,6 +1744,10 @@ static void handle_swbp(struct pt_regs *regs)
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
1.7.11.7

