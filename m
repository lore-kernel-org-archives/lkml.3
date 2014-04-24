Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbaDXWBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:01:37 -0400
Received: from si-002-i45.relay.mailchannels.net ([184.154.112.210]:47479 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754797AbaDXWBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:01:34 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2014 18:01:33 EDT
X-Sender-Id: totalchoicehosting|x-authuser|oren%40scalemp.com
X-Sender-Id: totalchoicehosting|x-authuser|oren%40scalemp.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: totalchoicehosting%7Cx-authuser%7Coren%2540scalemp.com
X-MailChannels-Auth-Id: totalchoicehosting
From: Oren Twaig <oren@scalemp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Shai Fultheim <shai@scalemp.com>
Subject: [PATCH v2] X86: Hook apic vector allocation domain only when interrupt routing are set to ignore
Date: Fri, 25 Apr 2014 00:52:06 +0300
Message-Id: <1398376326-3055-1-git-send-email-oren@scalemp.com>
X-Mailer: git-send-email 1.7.9.5
X-AuthUser: oren@scalemp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vSMP Foundation provides locality based interrupt routing which needed
vector_allocation_domain to allow all online cpus can handle all possible
vectors. 

Enforcing Interrupt Routing Comply (IRC) mode requires us to unplug this hook as
otherwise the IOAPIC, MSI and MSIX destination selectors to always select the
lowest online cpu as the destination. I.e affinity of HW interrupts cannot be
controled by kernel and/or userspace code.

The purpose of the patch is to fix the code to set override vector allocation
domain only when IRC is set to ignore to allow the kernel and userspace to
effectively control the destination of the HW interrupts.

Signed-off-by: Oren Twaig <oren@scalemp.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
---

 arch/x86/kernel/vsmp_64.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index f6584a9..b7f8e5b 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -26,6 +26,8 @@
 
 #define TOPOLOGY_REGISTER_OFFSET 0x10
 
+static int irc = 1;
+
 #if defined CONFIG_PCI && defined CONFIG_PARAVIRT
 /*
  * Interrupt control on vSMPowered systems:
@@ -101,6 +103,10 @@ static void __init set_vsmp_pv_ops(void)
 #ifdef CONFIG_SMP
 	if (cap & ctl & BIT(8)) {
 		ctl &= ~BIT(8);
+
+		/* Interrupt routing set to ignore */
+		irc = 0;
+
 #ifdef CONFIG_PROC_FS
 		/* Don't let users change irq affinity via procfs */
 		no_irq_affinity = 1;
@@ -218,7 +224,9 @@ static void vsmp_apic_post_init(void)
 {
 	/* need to update phys_pkg_id */
 	apic->phys_pkg_id = apicid_phys_pkg_id;
-	apic->vector_allocation_domain = fill_vector_allocation_domain;
+
+	if (!irc)
+		apic->vector_allocation_domain = fill_vector_allocation_domain;
 }
 
 void __init vsmp_init(void)
