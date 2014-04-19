Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbaDSRCc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 13:02:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbaDSRCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 13:02:13 -0400
Date: Sat, 19 Apr 2014 19:02:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] uprobes/x86: Fix is_64bit_mm() with CONFIG_X86_X32
Message-ID: <20140419170202.GA30876@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140419170104.GA30667@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is_64bit_mm() assumes that mm->context.ia32_compat means the 32-bit
instruction set, this is not true if the task is TIF_X32.

Change set_personality_ia32() to initialize mm->context.ia32_compat
by TIF_X32 or TIF_IA32 instead of 1. This allows to fix is_64bit_mm()
without affecting other users, they all treat ia32_compat as "bool".

TIF_ in ->ia32_compat looks a bit strange, but this is grep-friendly
and avoids the new define's.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/process_64.c |    7 ++++---
 arch/x86/kernel/uprobes.c    |    2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 9c0280f..9b53940 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -413,12 +413,11 @@ void set_personality_ia32(bool x32)
 	set_thread_flag(TIF_ADDR32);
 
 	/* Mark the associated mm as containing 32-bit tasks. */
-	if (current->mm)
-		current->mm->context.ia32_compat = 1;
-
 	if (x32) {
 		clear_thread_flag(TIF_IA32);
 		set_thread_flag(TIF_X32);
+		if (current->mm)
+			current->mm->context.ia32_compat = TIF_X32;
 		current->personality &= ~READ_IMPLIES_EXEC;
 		/* is_compat_task() uses the presence of the x32
 		   syscall bit flag to determine compat status */
@@ -426,6 +425,8 @@ void set_personality_ia32(bool x32)
 	} else {
 		set_thread_flag(TIF_IA32);
 		clear_thread_flag(TIF_X32);
+		if (current->mm)
+			current->mm->context.ia32_compat = TIF_IA32;
 		current->personality |= force_personality32;
 		/* Prepare the first "return" to user space */
 		current_thread_info()->status |= TS_COMPAT;
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index f445b00..4bbeb60 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -245,7 +245,7 @@ static int uprobe_init_insn(struct arch_uprobe *auprobe, struct insn *insn, bool
 static inline bool is_64bit_mm(struct mm_struct *mm)
 {
 	return	!config_enabled(CONFIG_IA32_EMULATION) ||
-		!mm->context.ia32_compat;
+		!(mm->context.ia32_compat == TIF_IA32);
 }
 /*
  * If arch_uprobe->insn doesn't use rip-relative addressing, return
-- 
1.5.5.1

