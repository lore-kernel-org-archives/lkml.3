Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937071Ab3DIQiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:38:17 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:45899 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759419Ab3DIQiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:38:14 -0400
Message-ID: <201304091638.r39Gc9kt017391@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 9 Apr 2013 12:33:07 -0400
Subject: [PATCH] tile: comment assumption about __insn_mtspr for <asm/irqflags.h>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-c6x-dev@linux-c6x.org>
References: <alpine.LFD.2.02.1304031433350.21884@ionos>	<1364998282-21437-1-git-send-email-vgupta@synopsys.com>	<20130404152808.GB15261@ab42.lan>	<515E54BD.2090300@synopsys.com>	<51602459.3040105@synopsys.com>	<CA+55aFw=-oJxujka-emxyRcY54MSe3qEjZ6xgzoE-roe3EFk5g@mail.gmail.com> <CA+55aFyvD2NtQatdaFZt+Q6ZPD0USofhgZHEock8rOx0ihSLhQ@mail.gmail.com>
In-Reply-To: <CA+55aFyvD2NtQatdaFZt+Q6ZPD0USofhgZHEock8rOx0ihSLhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arch_local_irq_save(), etc., routines are required to function
as compiler barriers.  They do, but it's subtle and requires knowing
that the gcc builtin __insn_mtspr() is marked as a memory clobber.
Provide a comment explaining the assumption.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/irqflags.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Linus wrote:
> Some other architectures (tile) have such subtle implementations
> (where is __insn_mtspr() defined?) that I have a hard time judging.

diff --git a/arch/tile/include/asm/irqflags.h b/arch/tile/include/asm/irqflags.h
index 241c0bb..c96f9bb 100644
--- a/arch/tile/include/asm/irqflags.h
+++ b/arch/tile/include/asm/irqflags.h
@@ -40,7 +40,15 @@
 #include <asm/percpu.h>
 #include <arch/spr_def.h>
 
-/* Set and clear kernel interrupt masks. */
+/*
+ * Set and clear kernel interrupt masks.
+ *
+ * NOTE: __insn_mtspr() is a compiler builtin marked as a memory
+ * clobber.  We rely on it being equivalent to a compiler barrier in
+ * this code since arch_local_irq_save() and friends must act as
+ * compiler barriers.  This compiler semantic is baked into enough
+ * places that the compiler will maintain it going forward.
+ */
 #if CHIP_HAS_SPLIT_INTR_MASK()
 #if INT_PERF_COUNT < 32 || INT_AUX_PERF_COUNT < 32 || INT_MEM_ERROR >= 32
 # error Fix assumptions about which word various interrupts are in
-- 
1.7.10.3

