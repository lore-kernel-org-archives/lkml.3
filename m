Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321AbaD1TNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:13:30 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:14983 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754732AbaD1TNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:13:21 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH] arm64: fixmap: fix missing sub-page offset for earlyprintk
Date: Mon, 28 Apr 2014 19:50:06 +0100
Message-Id: <1398711006-14943-1-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d57c33c5daa4 (add generic fixmap.h) added (among other
similar things) set_fixmap_io to deal with early ioremap of devices.

More recently, commit bf4b558eba92 (arm64: add early_ioremap support)
converted the arm64 earlyprintk to use set_fixmap_io. A side effect of
this conversion is that my virtual machines have stopped booting when
I pass "earlyprintk=uart8250-8bit,0x3f8" to the guest kernel.

Turns out that the new earlyprintk code doesn't care at all about
sub-page offsets, and just assumes that the earlyprintk device will
be page-aligned. Obviously, that doesn't play well with the above example.

Further investigation shows that set_fixmap_io uses __set_fixmap instead
of __set_fixmap_offset. A fix is to introduce a set_fixmap_offset_io that
uses the latter, and to remove the superflous call to fix_to_virt
(which only returns the value that set_fixmap_io has already given us).

With this applied, my VMs are back in business. Tested on a Cortex-A57
platform with kvmtool as platform emulation.

Cc: Mark Salter <msalter@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/early_printk.c | 6 ++----
 include/asm-generic/fixmap.h     | 3 +++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/early_printk.c b/arch/arm64/kernel/early_printk.c
index ffbbdde..2dc36d0 100644
--- a/arch/arm64/kernel/early_printk.c
+++ b/arch/arm64/kernel/early_printk.c
@@ -143,10 +143,8 @@ static int __init setup_early_printk(char *buf)
 	}
 	/* no options parsing yet */
 
-	if (paddr) {
-		set_fixmap_io(FIX_EARLYCON_MEM_BASE, paddr);
-		early_base = (void __iomem *)fix_to_virt(FIX_EARLYCON_MEM_BASE);
-	}
+	if (paddr)
+		early_base = (void __iomem *)set_fixmap_offset_io(FIX_EARLYCON_MEM_BASE, paddr);
 
 	printch = match->printch;
 	early_console = &early_console_dev;
diff --git a/include/asm-generic/fixmap.h b/include/asm-generic/fixmap.h
index 5a64ca4..f23174f 100644
--- a/include/asm-generic/fixmap.h
+++ b/include/asm-generic/fixmap.h
@@ -93,5 +93,8 @@ static inline unsigned long virt_to_fix(const unsigned long vaddr)
 #define set_fixmap_io(idx, phys) \
 	__set_fixmap(idx, phys, FIXMAP_PAGE_IO)
 
+#define set_fixmap_offset_io(idx, phys) \
+	__set_fixmap_offset(idx, phys, FIXMAP_PAGE_IO)
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ASM_GENERIC_FIXMAP_H */
-- 
1.8.3.4

