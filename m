Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab3BANHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:07:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:44233 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab3BANHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:07:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tiejun Chen <tiejun.chen@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 06/89] powerpc/book3e: Disable interrupt after preempt_schedule_irq
Date: Fri,  1 Feb 2013 14:07:21 +0100
Message-Id: <20130201130207.918022394@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiejun Chen <tiejun.chen@windriver.com>

commit 572177d7c77db1981ba2563e01478126482c43bc upstream.

In preempt case current arch_local_irq_restore() from
preempt_schedule_irq() may enable hard interrupt but we really
should disable interrupts when we return from the interrupt,
and so that we don't get interrupted after loading SRR0/1.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/entry_64.S |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -668,6 +668,19 @@ resume_kernel:
 	ld	r4,TI_FLAGS(r9)
 	andi.	r0,r4,_TIF_NEED_RESCHED
 	bne	1b
+
+	/*
+	 * arch_local_irq_restore() from preempt_schedule_irq above may
+	 * enable hard interrupt but we really should disable interrupts
+	 * when we return from the interrupt, and so that we don't get
+	 * interrupted after loading SRR0/1.
+	 */
+#ifdef CONFIG_PPC_BOOK3E
+	wrteei	0
+#else
+	ld	r10,PACAKMSR(r13) /* Get kernel MSR without EE */
+	mtmsrd	r10,1		  /* Update machine state */
+#endif /* CONFIG_PPC_BOOK3E */
 #endif /* CONFIG_PREEMPT */
 
 	.globl	fast_exc_return_irq


