Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030322Ab3FTOtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:49:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47644 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030276Ab3FTOtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:49:09 -0400
Date: Thu, 20 Jun 2013 07:48:45 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-003002e04ed38618fc37b92ba128f5ca79d39f4f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, fche@redhat.com, hpa@zytor.com,
        mingo@kernel.org, masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org,
        jlebon@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, jlebon@redhat.com, tglx@linutronix.de
In-Reply-To: <20130605031216.15285.2001.stgit@mhiramat-M0-7522>
References: <20130605031216.15285.2001.stgit@mhiramat-M0-7522>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] kprobes:
  Fix arch_prepare_kprobe to handle copy insn failures
Git-Commit-ID: 003002e04ed38618fc37b92ba128f5ca79d39f4f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Jun 2013 07:48:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  003002e04ed38618fc37b92ba128f5ca79d39f4f
Gitweb:     http://git.kernel.org/tip/003002e04ed38618fc37b92ba128f5ca79d39f4f
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Wed, 5 Jun 2013 12:12:16 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 20 Jun 2013 14:25:48 +0200

kprobes: Fix arch_prepare_kprobe to handle copy insn failures

Fix arch_prepare_kprobe() to handle failures in copy instruction
correctly. This fix is related to the previous fix: 8101376
which made __copy_instruction return an error result if failed,
but caller site was not updated to handle it. Thus, this is the
other half of the bugfix.

This fix is also related to the following bug-report:

   https://bugzilla.redhat.com/show_bug.cgi?id=910649

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Jonathan Lebon <jlebon@redhat.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: systemtap@sourceware.org
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20130605031216.15285.2001.stgit@mhiramat-M0-7522
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/kprobes/core.c | 14 ++++++++++----
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
