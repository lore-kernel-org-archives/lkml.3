Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab3AaWc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:32:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44944 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886Ab3AaWc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:32:26 -0500
Date: Thu, 31 Jan 2013 14:32:14 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-086fc8f8037bf16f55f82c66b26a8b834f7349ec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1356075872-3054-8-git-send-email-fenghua.yu@intel.com>
References: <1356075872-3054-8-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86/tlbflush.h:
  Define __native_flush_tlb_global_irq_disabled()
Git-Commit-ID: 086fc8f8037bf16f55f82c66b26a8b834f7349ec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 14:32:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  086fc8f8037bf16f55f82c66b26a8b834f7349ec
Gitweb:     http://git.kernel.org/tip/086fc8f8037bf16f55f82c66b26a8b834f7349ec
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 20 Dec 2012 23:44:27 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 31 Jan 2013 13:19:16 -0800

x86/tlbflush.h: Define __native_flush_tlb_global_irq_disabled()

This function is called in __native_flush_tlb_global() and after
apply_microcode_early().

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1356075872-3054-8-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/tlbflush.h | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 0fee48e..50a7fc0 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -20,10 +20,20 @@ static inline void __native_flush_tlb(void)
 	native_write_cr3(native_read_cr3());
 }
 
+static inline void __native_flush_tlb_global_irq_disabled(void)
+{
+	unsigned long cr4;
+
+	cr4 = native_read_cr4();
+	/* clear PGE */
+	native_write_cr4(cr4 & ~X86_CR4_PGE);
+	/* write old PGE again and flush TLBs */
+	native_write_cr4(cr4);
+}
+
 static inline void __native_flush_tlb_global(void)
 {
 	unsigned long flags;
-	unsigned long cr4;
 
 	/*
 	 * Read-modify-write to CR4 - protect it from preemption and
@@ -32,11 +42,7 @@ static inline void __native_flush_tlb_global(void)
 	 */
 	raw_local_irq_save(flags);
 
-	cr4 = native_read_cr4();
-	/* clear PGE */
-	native_write_cr4(cr4 & ~X86_CR4_PGE);
-	/* write old PGE again and flush TLBs */
-	native_write_cr4(cr4);
+	__native_flush_tlb_global_irq_disabled();
 
 	raw_local_irq_restore(flags);
 }
