Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab3FZFft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 01:35:49 -0400
Received: from [213.199.154.249] ([213.199.154.249]:1351 "EHLO
	db9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751212Ab3FZFfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 01:35:47 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <kvm-ppc@vger.kernel.org>, <kvm@vger.kernel.org>, <agraf@suse.de>,
        <scottwood@freescale.com>, <tiejun.chen@windriver.com>,
        <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <mikey@neuling.org>
CC: Bharat Bhushan <Bharat.Bhushan@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 3/6 v5] powerpc: export debug registers save function for KVM
Date: Wed, 26 Jun 2013 11:12:23 +0530
Message-ID: <1372225346-5029-4-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1372225346-5029-1-git-send-email-Bharat.Bhushan@freescale.com>
References: <1372225346-5029-1-git-send-email-Bharat.Bhushan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM need this function when switching from vcpu to user-space
thread. My subsequent patch will use this function.

Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
 arch/powerpc/include/asm/switch_to.h |    4 ++++
 arch/powerpc/kernel/process.c        |    3 ++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/switch_to.h b/arch/powerpc/include/asm/switch_to.h
index 200d763..50b357f 100644
--- a/arch/powerpc/include/asm/switch_to.h
+++ b/arch/powerpc/include/asm/switch_to.h
@@ -30,6 +30,10 @@ extern void enable_kernel_spe(void);
 extern void giveup_spe(struct task_struct *);
 extern void load_up_spe(struct task_struct *);
 
+#ifdef CONFIG_PPC_ADV_DEBUG_REGS
+extern void switch_booke_debug_regs(struct thread_struct *new_thread);
+#endif
+
 #ifndef CONFIG_SMP
 extern void discard_lazy_cpu_state(void);
 #else
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 01ff496..da586aa 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -362,12 +362,13 @@ static void prime_debug_regs(struct thread_struct *thread)
  * debug registers, set the debug registers from the values
  * stored in the new thread.
  */
-static void switch_booke_debug_regs(struct thread_struct *new_thread)
+void switch_booke_debug_regs(struct thread_struct *new_thread)
 {
 	if ((current->thread.debug.dbcr0 & DBCR0_IDM)
 		|| (new_thread->debug.dbcr0 & DBCR0_IDM))
 			prime_debug_regs(new_thread);
 }
+EXPORT_SYMBOL_GPL(switch_booke_debug_regs);
 #else	/* !CONFIG_PPC_ADV_DEBUG_REGS */
 #ifndef CONFIG_HAVE_HW_BREAKPOINT
 static void set_debug_reg_defaults(struct thread_struct *thread)
-- 
1.7.0.4


