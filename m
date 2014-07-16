Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935230AbaGPTYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:24:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44543 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935174AbaGPTYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:24:03 -0400
Date: Wed, 16 Jul 2014 12:23:49 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-0cdd192cf40fb6dbf03ec3af1c670068de3fd26c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
In-Reply-To: <c4e339882c121aa76254f2adde3fcbdf502faec2.1405099506.git.luto@amacapital.net>
References: <c4e339882c121aa76254f2adde3fcbdf502faec2.1405099506.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] kprobes/x86: Don'
 t try to resolve kprobe faults from userspace
Git-Commit-ID: 0cdd192cf40fb6dbf03ec3af1c670068de3fd26c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0cdd192cf40fb6dbf03ec3af1c670068de3fd26c
Gitweb:     http://git.kernel.org/tip/0cdd192cf40fb6dbf03ec3af1c670068de3fd26c
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Fri, 11 Jul 2014 10:27:01 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 14:16:32 +0200

kprobes/x86: Don't try to resolve kprobe faults from userspace

This commit:

    commit 6f6343f53d133bae516caf3d254bce37d8774625
    Author: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
    Date:   Thu Apr 17 17:17:33 2014 +0900

        kprobes/x86: Call exception handlers directly from do_int3/do_debug

appears to have inadvertently dropped a check that the int3 came
from kernel mode.  Trying to dereference addr when addr is
user-controlled is completely bogus.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/c4e339882c121aa76254f2adde3fcbdf502faec2.1405099506.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
