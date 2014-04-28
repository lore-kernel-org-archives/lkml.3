Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaD1HVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 03:21:55 -0400
Received: from ar-005-i193.relay.mailchannels.net ([162.253.144.75]:20149 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751288AbaD1HVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 03:21:54 -0400
X-Sender-Id: totalchoicehosting|x-authuser|oren%40scalemp.com
X-Sender-Id: totalchoicehosting|x-authuser|oren%40scalemp.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: totalchoicehosting%7Cx-authuser%7Coren%2540scalemp.com
X-MailChannels-Auth-Id: totalchoicehosting
From: Oren Twaig <oren@scalemp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Shai Fultheim <shai@scalemp.com>, Oren Twaig <oren@scalemp.com>
Subject: [PATCH v3] X86: Hook apic vector allocation domain only when interrupt routing are set to ignore
Date: Mon, 28 Apr 2014 10:21:37 +0300
Message-Id: <1398669697-2123-1-git-send-email-oren@scalemp.com>
X-Mailer: git-send-email 1.7.9.5
X-AuthUser: oren@scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct IRQ routing in case a vSMP Foundation box is detected but the 
Interrupt Routing Comply (IRC) is set to "comply".

Before the patch:
When a vSMP Foundation box was detected and IRC was set to "comply", users (and
kernel) couldn't effectively set the destination of the IRQs. This is because
the hook inside vsmp_64.c always setup all CPUs as the IRQ destination using
cpumask_setall() as the return value for IRQ allocation mask. Later, this
"overrided" mask caused the kernel to set the IRQ destination to the lowest
online CPU in the mask (CPU0 usually).

After the patch:
When the IRC is set to "comply", Users (and kernel) can control the destination
of the IRQs as we will not be changing the default
"apic->vector_allocation_domain".

Signed-off-by: Oren Twaig <oren@scalemp.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
---
 arch/x86/kernel/vsmp_64.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index f6584a9..39dd854 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -26,6 +26,9 @@
 
 #define TOPOLOGY_REGISTER_OFFSET 0x10
 
+/* Flag below is initialized once during vSMP Foundation PCI initialization. */
+static int interrupt_routing_comply = 1;
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
+		interrupt_routing_comply = 0;
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
+	if (!interrupt_routing_comply)
+		apic->vector_allocation_domain = fill_vector_allocation_domain;
 }
 
 void __init vsmp_init(void)
