Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbaD2GbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 02:31:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56607 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbaD2Ga6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 02:30:58 -0400
Date: Mon, 28 Apr 2014 23:30:39 -0700
From: tip-bot for Oren Twaig <tipbot@zytor.com>
Message-ID: <tip-39025ba38278f3003ee538409f7c98970620ef49@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        shai@scalemp.com, oren@scalemp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        shai@scalemp.com, oren@scalemp.com, tglx@linutronix.de
In-Reply-To: <1398669697-2123-1-git-send-email-oren@scalemp.com>
References: <1398669697-2123-1-git-send-email-oren@scalemp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/vsmp: Fix irq routing
Git-Commit-ID: 39025ba38278f3003ee538409f7c98970620ef49
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

Commit-ID:  39025ba38278f3003ee538409f7c98970620ef49
Gitweb:     http://git.kernel.org/tip/39025ba38278f3003ee538409f7c98970620ef49
Author:     Oren Twaig <oren@scalemp.com>
AuthorDate: Mon, 28 Apr 2014 10:21:37 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 28 Apr 2014 09:27:34 +0200

x86/vsmp: Fix irq routing

Correct IRQ routing in case a vSMP box is detected
but the  Interrupt Routing Comply (IRC) value is set to
"comply", which leads to incorrect IRQ routing.

Before the patch:

When a vSMP box was detected and IRC was set to "comply",
users (and the kernel) couldn't effectively set the
destination of the IRQs. This is because the hook inside
vsmp_64.c always setup all CPUs as the IRQ destination using
cpumask_setall() as the return value for IRQ allocation mask.
Later, this "overrided" mask caused the kernel to set the IRQ
destination to the lowest online CPU in the mask (CPU0 usually).

After the patch:

When the IRC is set to "comply", users (and the kernel) can control
the destination of the IRQs as we will not be changing the
default "apic->vector_allocation_domain".

Signed-off-by: Oren Twaig <oren@scalemp.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
Link: http://lkml.kernel.org/r/1398669697-2123-1-git-send-email-oren@scalemp.com
[ Minor readability edits. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/vsmp_64.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index f6584a9..5edc34b 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -26,6 +26,9 @@
 
 #define TOPOLOGY_REGISTER_OFFSET 0x10
 
+/* Flag below is initialized once during vSMP PCI initialization. */
+static int irq_routing_comply = 1;
+
 #if defined CONFIG_PCI && defined CONFIG_PARAVIRT
 /*
  * Interrupt control on vSMPowered systems:
@@ -101,6 +104,10 @@ static void __init set_vsmp_pv_ops(void)
 #ifdef CONFIG_SMP
 	if (cap & ctl & BIT(8)) {
 		ctl &= ~BIT(8);
+
+		/* Interrupt routing set to ignore */
+		irq_routing_comply = 0;
+
 #ifdef CONFIG_PROC_FS
 		/* Don't let users change irq affinity via procfs */
 		no_irq_affinity = 1;
@@ -218,7 +225,9 @@ static void vsmp_apic_post_init(void)
 {
 	/* need to update phys_pkg_id */
 	apic->phys_pkg_id = apicid_phys_pkg_id;
-	apic->vector_allocation_domain = fill_vector_allocation_domain;
+
+	if (!irq_routing_comply)
+		apic->vector_allocation_domain = fill_vector_allocation_domain;
 }
 
 void __init vsmp_init(void)
