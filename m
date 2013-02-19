Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586Ab3BSSdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:33:22 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58330 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933221Ab3BSSdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:33:20 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@suse.de>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 1/2] x86, CPU, AMD: Fix WC+ workaround for older hosts
Date: Tue, 19 Feb 2013 19:33:12 +0100
Message-Id: <1361298793-31834-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <5123BBBC.2080008@zytor.com>
References: <5123BBBC.2080008@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

The WC+ workaround for F10h introduces a new MSR and kvm host #GPs
on accesses to unknown MSRs if paravirt is not compiled in. Use the
exception-handling MSR accessors so as not to break 3.8 and later guests
booting on older hosts.

Remove a redundant family check while at it.

Cc: Gleb Natapov <gleb@redhat.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: http://lkml.kernel.org/r/20130219153655.GD26748@pd.tnic
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/amd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 721ef3208eb5..163af4a91d09 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -723,12 +723,14 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		 * performance degradation for certain nested-paging guests.
 		 * Prevent this conversion by clearing bit 24 in
 		 * MSR_AMD64_BU_CFG2.
+		 *
+		 * NOTE: we want to use the _safe accessors so as not to #GP kvm
+		 * guests on older kvm hosts.
 		 */
-		if (c->x86 == 0x10) {
-			rdmsrl(MSR_AMD64_BU_CFG2, value);
-			value &= ~(1ULL << 24);
-			wrmsrl(MSR_AMD64_BU_CFG2, value);
-		}
+
+		rdmsrl_safe(MSR_AMD64_BU_CFG2, &value);
+		value &= ~(1ULL << 24);
+		wrmsrl_safe(MSR_AMD64_BU_CFG2, value);
 	}
 
 	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
-- 
1.8.1.3.535.ga923c31

