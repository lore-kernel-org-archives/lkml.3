Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaGKR1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:27:12 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:42731 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaGKR1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:27:11 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 3.16] x86,kprobes: Don't try to resolve kprobe faults from userspace
Date: Fri, 11 Jul 2014 10:27:01 -0700
Message-Id: <c4e339882c121aa76254f2adde3fcbdf502faec2.1405099506.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit:

    commit 6f6343f53d133bae516caf3d254bce37d8774625
    Author: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
    Date:   Thu Apr 17 17:17:33 2014 +0900

        kprobes/x86: Call exception handlers directly from do_int3/do_debug

appears to have inadvertently dropped a check that the int3 came
from kernel mode.  Trying to dereference addr when addr is
user-controlled is completely bogus.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

Changes from v1: Fixed the changelog message

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

