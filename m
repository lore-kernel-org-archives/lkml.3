Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbaJ1Dhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:37:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbaJ1Dh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:37:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bryan ODonoghue <pure.logic@nexus-software.ie>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.17 022/146] x86/intel/quark: Switch off CR4.PGE so TLB flush uses CR3 instead
Date: Tue, 28 Oct 2014 11:32:44 +0800
Message-Id: <20141028033344.402148144@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <pure.logic@nexus-software.ie>

commit ee1b5b165c0a2f04d2107e634e51f05d0eb107de upstream.

Quark x1000 advertises PGE via the standard CPUID method
PGE bits exist in Quark X1000's PTEs. In order to flush
an individual PTE it is necessary to reload CR3 irrespective
of the PTE.PGE bit.

See Quark Core_DevMan_001.pdf section 6.4.11

This bug was fixed in Galileo kernels, unfixed vanilla kernels are expected to
crash and burn on this platform.

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1411514784-14885-1-git-send-email-pure.logic@nexus-software.ie
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/intel.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -144,6 +144,21 @@ static void early_init_intel(struct cpui
 			setup_clear_cpu_cap(X86_FEATURE_ERMS);
 		}
 	}
+
+	/*
+	 * Intel Quark Core DevMan_001.pdf section 6.4.11
+	 * "The operating system also is required to invalidate (i.e., flush)
+	 *  the TLB when any changes are made to any of the page table entries.
+	 *  The operating system must reload CR3 to cause the TLB to be flushed"
+	 *
+	 * As a result cpu_has_pge() in arch/x86/include/asm/tlbflush.h should
+	 * be false so that __flush_tlb_all() causes CR3 insted of CR4.PGE
+	 * to be modified
+	 */
+	if (c->x86 == 5 && c->x86_model == 9) {
+		pr_info("Disabling PGE capability bit\n");
+		setup_clear_cpu_cap(X86_FEATURE_PGE);
+	}
 }
 
 #ifdef CONFIG_X86_32


