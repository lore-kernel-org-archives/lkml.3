Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab3FGXNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:13:17 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:44548 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565Ab3FGXDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:47 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 05/31] mips/kvm: Use generic cache flushing functions.
Date: Fri,  7 Jun 2013 16:03:09 -0700
Message-Id: <1370646215-6543-6-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

We don't know if we have the r4k specific functions available, so use
universally available __flush_cache_all() instead.  This takes longer
as it flushes both i-cache and d-cache, but is available for all CPUs.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/kvm/kvm_mips_emul.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/mips/kvm/kvm_mips_emul.c b/arch/mips/kvm/kvm_mips_emul.c
index af9a661..a2c6687 100644
--- a/arch/mips/kvm/kvm_mips_emul.c
+++ b/arch/mips/kvm/kvm_mips_emul.c
@@ -916,8 +916,6 @@ kvm_mips_emulate_cache(uint32_t inst, uint32_t *opc, uint32_t cause,
 		       struct kvm_run *run, struct kvm_vcpu *vcpu)
 {
 	struct mips_coproc *cop0 = vcpu->arch.cop0;
-	extern void (*r4k_blast_dcache) (void);
-	extern void (*r4k_blast_icache) (void);
 	enum emulation_result er = EMULATE_DONE;
 	int32_t offset, cache, op_inst, op, base;
 	struct kvm_vcpu_arch *arch = &vcpu->arch;
@@ -954,9 +952,9 @@ kvm_mips_emulate_cache(uint32_t inst, uint32_t *opc, uint32_t cause,
 		     arch->gprs[base], offset);
 
 		if (cache == MIPS_CACHE_DCACHE)
-			r4k_blast_dcache();
+			__flush_cache_all();
 		else if (cache == MIPS_CACHE_ICACHE)
-			r4k_blast_icache();
+			__flush_cache_all();
 		else {
 			printk("%s: unsupported CACHE INDEX operation\n",
 			       __func__);
-- 
1.7.11.7

