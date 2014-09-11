Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaIKIrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:47:47 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:9256 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbaIKIhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:37:34 -0400
From: Paul Burton <paul.burton@imgtec.com>
To: <linux-mips@linux-mips.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Paul Burton <paul.burton@imgtec.com>
Subject: [PATCH 10/10] MIPS: Kconfig option to better exercise/debug hybrid FPRs
Date: Thu, 11 Sep 2014 08:30:23 +0100
Message-ID: <1410420623-11691-11-git-send-email-paul.burton@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
References: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.159.78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hybrid FPR scheme exists to allow for compatibility between existing
FP32 code and newly compiled FP64A code. Such code should hopefully be
rare in the real world, and for the moment is difficult to come across.
All code except that built for the FP64 ABI can correctly execute using
the hybrid FPR scheme, so debugging the hybrid FPR implementation can
be eased by forcing all such code to use it. This is undesirable in
general due to the trap & emulate overhead of the hybrid FPR
implementation, but is a very useful option to have for debugging.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
---
 arch/mips/Kconfig.debug | 13 +++++++++++++
 arch/mips/kernel/elf.c  | 18 ++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/arch/mips/Kconfig.debug b/arch/mips/Kconfig.debug
index 3a2b775..88a9f43 100644
--- a/arch/mips/Kconfig.debug
+++ b/arch/mips/Kconfig.debug
@@ -122,4 +122,17 @@ config SPINLOCK_TEST
 	help
 	  Add several files to the debugfs to test spinlock speed.
 
+config FP32XX_HYBRID_FPRS
+	bool "Run FP32 & FPXX code with hybrid FPRs"
+	depends on MIPS_O32_FP64_SUPPORT
+	help
+	  The hybrid FPR scheme is normally used only when a program needs to
+	  execute a mix of FP32 & FP64A code, since the trapping & emulation
+	  that it entails is expensive. When enabled, this option will lead
+	  to the kernel running programs which use the FP32 & FPXX FP ABIs
+	  using the hybrid FPR scheme, which can be useful for debugging
+	  purposes.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/arch/mips/kernel/elf.c b/arch/mips/kernel/elf.c
index 34e9af5..abf8a1a 100644
--- a/arch/mips/kernel/elf.c
+++ b/arch/mips/kernel/elf.c
@@ -124,6 +124,24 @@ int arch_check_elf(void *_ehdr, bool has_interpreter,
 
 void mips_set_personality_fp(struct arch_elf_state *state)
 {
+	if (config_enabled(CONFIG_FP32XX_HYBRID_FPRS)) {
+		/*
+		 * Use hybrid FPRs for all code which can correctly execute
+		 * with that mode.
+		 */
+		switch (state->overall_abi) {
+		case MIPS_ABI_FP_DOUBLE:
+		case MIPS_ABI_FP_SINGLE:
+		case MIPS_ABI_FP_SOFT:
+		case MIPS_ABI_FP_XX:
+		case MIPS_ABI_FP_ANY:
+			/* FR=1, FRE=1 */
+			clear_thread_flag(TIF_32BIT_FPREGS);
+			set_thread_flag(TIF_HYBRID_FPREGS);
+			return;
+		}
+	}
+
 	switch (state->overall_abi) {
 	case MIPS_ABI_FP_DOUBLE:
 	case MIPS_ABI_FP_SINGLE:
-- 
2.0.4

