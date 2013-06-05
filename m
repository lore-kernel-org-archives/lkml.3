Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab3FEDPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 23:15:13 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:41565 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3FEDPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 23:15:10 -0400
X-AuditID: 85900ec0-d2ec7b900000151e-51-51aead3b854c
Subject: [PATCH -tip ] [BUGFIX] kprobes: Fix arch_prepare_kprobe to handle
 copy insn failures
To: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, "Frank Ch. Eigler" <fche@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com
Date: Wed, 05 Jun 2013 12:12:16 +0900
Message-ID: <20130605031216.15285.2001.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix arch_prepare_kprobe() to handle failures in copy instruction
correctly. This fix is related to the previous fix: 8101376
which made __copy_instruction return an error result if failed,
but caller site was not updated to handle it. Thus, this is the
other half of the bugfix.

This fix is also related to the following bug-report:

   https://bugzilla.redhat.com/show_bug.cgi?id=910649

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/kprobes/core.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 9895a9a..211bce4 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -365,10 +365,14 @@ int __kprobes __copy_instruction(u8 *dest, u8 *src)
 	return insn.length;
 }
 
-static void __kprobes arch_copy_kprobe(struct kprobe *p)
+static int __kprobes arch_copy_kprobe(struct kprobe *p)
 {
+	int ret;
+
 	/* Copy an instruction with recovering if other optprobe modifies it.*/
-	__copy_instruction(p->ainsn.insn, p->addr);
+	ret = __copy_instruction(p->ainsn.insn, p->addr);
+	if (!ret)
+		return -EINVAL;
 
 	/*
 	 * __copy_instruction can modify the displacement of the instruction,
@@ -384,6 +388,8 @@ static void __kprobes arch_copy_kprobe(struct kprobe *p)
 
 	/* Also, displacement change doesn't affect the first byte */
 	p->opcode = p->ainsn.insn[0];
+
+	return 0;
 }
 
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
@@ -397,8 +403,8 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	p->ainsn.insn = get_insn_slot();
 	if (!p->ainsn.insn)
 		return -ENOMEM;
-	arch_copy_kprobe(p);
-	return 0;
+
+	return arch_copy_kprobe(p);
 }
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)

