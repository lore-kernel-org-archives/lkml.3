Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab3LPEdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 23:33:35 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52030 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab3LPEcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 23:32:24 -0500
X-AuditID: 9c93017e-b7c17ae000003961-3d-52ae8254ba1b
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 16/17] uprobes: Allocate ->utask before handler_chain() for tracing handlers
Date: Mon, 16 Dec 2013 13:32:15 +0900
Message-Id: <1387168336-13213-17-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387168336-13213-1-git-send-email-namhyung@kernel.org>
References: <1387168336-13213-1-git-send-email-namhyung@kernel.org>
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
but this is simple and should work right now.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/events/uprobes.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 24b7d6ca871b..3cc8e0bb8acf 100644
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
1.7.11.7

