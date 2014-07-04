Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaGDC72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 22:59:28 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:56171 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaGDC71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 22:59:27 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86,kprobes: Don't try to resolve kprobe faults from userspace
Date: Thu,  3 Jul 2014 19:59:20 -0700
Message-Id: <6becf74d2eb73d4c9a1f33ef998da6e52a5ed57c.1404442700.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit:

    commit 6f6343f53d133bae516caf3d254bce37d8774625
    Author: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
    Date:   Thu Apr 17 17:17:33 2014 +0900

        kprobes/x86: Call exception handlers directly from do_int3/do_debug

Trying to dereference addr when addr is user-controlled is
completely bogus.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/kprobes/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 7596df6..67e6d19 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -574,6 +574,9 @@ int kprobe_int3_handler(struct pt_regs *regs)
 	struct kprobe *p;
 	struct kprobe_ctlblk *kcb;
 
+	if (user_mode_vm(regs))
+		return 0;
+
 	addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
 	/*
 	 * We don't want to be preempted for the entire
-- 
1.9.3

