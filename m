Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaCMH2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 03:28:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33556 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaCMH2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 03:28:32 -0400
Date: Thu, 13 Mar 2014 00:28:07 -0700
From: tip-bot for Jean Pihet <tipbot@zytor.com>
Message-ID: <tip-5aa158b708b07bab47147aa164e3948e8a4c548f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        will.deacon@arm.com, acme@ghostprotocols.net, jean.pihet@linaro.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, acme@ghostprotocols.net, jean.pihet@linaro.org,
        jolsa@redhat.com, tglx@linutronix.de
In-Reply-To: <1391451509-31265-4-git-send-email-jean.pihet@linaro.org>
References: <1391451509-31265-4-git-send-email-jean.pihet@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] ARM64, perf:
  Support dwarf unwinding in compat mode
Git-Commit-ID: 5aa158b708b07bab47147aa164e3948e8a4c548f
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

Commit-ID:  5aa158b708b07bab47147aa164e3948e8a4c548f
Gitweb:     http://git.kernel.org/tip/5aa158b708b07bab47147aa164e3948e8a4c548f
Author:     Jean Pihet <jean.pihet@linaro.org>
AuthorDate: Mon, 3 Feb 2014 19:18:29 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 12 Mar 2014 13:45:30 +0100

ARM64, perf: Support dwarf unwinding in compat mode

Add support for unwinding using the dwarf information in compat
mode. Using the correct user stack pointer allows perf to record
the frames correctly in the native and compat modes.

Note that although the dwarf frame unwinding works ok using
libunwind in native mode (on ARMv7 & ARMv8), some changes are
required to the libunwind code for the compat mode. Those
changes are posted separately on the libunwind mailing list.

Tested on ARMv8 platform with v8 and compat v7 binaries, the
latter are statically built.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Arnaldo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: patches@linaro.org
Cc: linaro-kernel@lists.linaro.org
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lkml.kernel.org/r/1391451509-31265-4-git-send-email-jean.pihet@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm64/include/asm/compat.h | 2 +-
 arch/arm64/include/asm/ptrace.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index fda2704..e71f81f 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -228,7 +228,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 	return (u32)(unsigned long)uptr;
 }
 
-#define compat_user_stack_pointer() (current_pt_regs()->compat_sp)
+#define compat_user_stack_pointer() (user_stack_pointer(current_pt_regs()))
 
 static inline void __user *arch_compat_alloc_user_space(long len)
 {
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index fbb0020..86d5b54 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -133,7 +133,7 @@ struct pt_regs {
 	(!((regs)->pstate & PSR_F_BIT))
 
 #define user_stack_pointer(regs) \
-	((regs)->sp)
+	(!compat_user_mode(regs)) ? ((regs)->sp) : ((regs)->compat_sp)
 
 /*
  * Are the current registers suitable for user mode? (used to maintain
