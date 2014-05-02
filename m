Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbaEBTEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:04:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50827 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaEBTEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:04:36 -0400
Date: Fri, 2 May 2014 12:03:18 -0700
Message-Id: <201405021903.s42J3I8e012072@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.14-rc4
Cc: Behan Webster <behanw@converseincode.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oren Twaig <oren@scalemp.com>, Shai Fultheim <shai@scalemp.com>,
        Thomas Gleixner <tglx@linutronix.de>, dwmw2@infradead.org,
        pageexec@freemail.hu, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Two very small changes: one fix for the vSMP Foundation platform, and
one to help LLVM not choke on options it doesn't understand (although
it probably should.)

The following changes since commit c089b229dfdd09d59a11d8bc2344bf8196d575ce:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml (2014-04-21 10:05:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

  x86/vsmp: Fix irq routing (2014-04-28 09:27:34 +0200)

----------------------------------------------------------------
Behan Webster (1):
      x86: LLVMLinux: Wrap -mno-80387 with cc-option

Oren Twaig (1):
      x86/vsmp: Fix irq routing

 arch/x86/Makefile         |  4 +++-
 arch/x86/kernel/vsmp_64.c | 11 ++++++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index d1b7c377a234..ce6ad7e6a7d7 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -83,7 +83,9 @@ else
         KBUILD_CFLAGS += -m64
 
         # Don't autogenerate traditional x87, MMX or SSE instructions
-        KBUILD_CFLAGS += -mno-mmx -mno-sse -mno-80387 -mno-fp-ret-in-387
+        KBUILD_CFLAGS += -mno-mmx -mno-sse
+        KBUILD_CFLAGS += $(call cc-option,-mno-80387)
+        KBUILD_CFLAGS += $(call cc-option,-mno-fp-ret-in-387)
 
 	# Use -mpreferred-stack-boundary=3 if supported.
 	KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=3)
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index f6584a90aba3..5edc34b5b951 100644
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
