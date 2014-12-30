Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaL3Awj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 19:52:39 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:38128 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaL3Awh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 19:52:37 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3.19 1/3] x86, mpx: Check user mode bitness correctly when decoding instructions
Date: Mon, 29 Dec 2014 16:52:25 -0800
Message-Id: <8207ea76edd142f4a118ad3093b28ec422d92e53.1419900414.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1419900414.git.luto@amacapital.net>
References: <cover.1419900414.git.luto@amacapital.net>
In-Reply-To: <cover.1419900414.git.luto@amacapital.net>
References: <cover.1419900414.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When decoding a user instruction, the bitness depends on CS, not on
TIF_IA32.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/ptrace.h | 5 +++++
 arch/x86/mm/mpx.c             | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 86fc2bb82287..189113c74726 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -144,6 +144,11 @@ static inline bool user_64bit_mode(struct pt_regs *regs)
 	(test_thread_flag(TIF_IA32) 	\
 	 ? current_pt_regs()->sp 	\
 	 : this_cpu_read(old_rsp))
+#else
+static inline bool user_64bit_mode(struct pt_regs *regs)
+{
+	return false;
+}
 #endif
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/mm/mpx.c b/arch/x86/mm/mpx.c
index 67ebf5751222..082ab9c4ac1c 100644
--- a/arch/x86/mm/mpx.c
+++ b/arch/x86/mm/mpx.c
@@ -217,7 +217,7 @@ static int mpx_insn_decode(struct insn *insn,
 			   struct pt_regs *regs)
 {
 	unsigned char buf[MAX_INSN_SIZE];
-	int x86_64 = !test_thread_flag(TIF_IA32);
+	int x86_64 = user_64bit_mode(regs);
 	int not_copied;
 	int nr_copied;
 
-- 
2.1.0

