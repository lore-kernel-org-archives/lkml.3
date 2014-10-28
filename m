Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbaJ1LOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:14:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51340 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbaJ1LN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:13:58 -0400
Date: Tue, 28 Oct 2014 04:13:44 -0700
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-de8bf1a32bd379a4f953c3146b82c8a438d7aa5d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@kernel.org,
        JBeulich@suse.com, jbeulich@suse.com, hpa@zytor.com,
        jiang.liu@linux.intel.com
Reply-To: jiang.liu@linux.intel.com, hpa@zytor.com, jbeulich@suse.com,
        JBeulich@suse.com, mingo@kernel.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
In-Reply-To: <54184CC802000078000355EE@mail.emea.novell.com>
References: <54184CC802000078000355EE@mail.emea.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] ix86: Fix build failure when !CONFIG_X86_IO_APIC
Git-Commit-ID: de8bf1a32bd379a4f953c3146b82c8a438d7aa5d
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

Commit-ID:  de8bf1a32bd379a4f953c3146b82c8a438d7aa5d
Gitweb:     http://git.kernel.org/tip/de8bf1a32bd379a4f953c3146b82c8a438d7aa5d
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Tue, 16 Sep 2014 13:44:24 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 11:06:16 +0100

ix86: Fix build failure when !CONFIG_X86_IO_APIC

mp_should_keep_irq() isn't really IO-APIC related, and
considering that it's being used solely in arch/x86/pci/ likely
both declaration and definition got misplaced even without
considering the resulting build failure:

  .../arch/x86/pci/irq.c: In function ‘pirq_disable_irq’:
  .../arch/x86/pci/irq.c:1259: error: implicit declaration of function ‘mp_should_keep_irq’
  make[3]: *** [arch/x86/pci/irq.o] Error 1

Move them to better places.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Link: http://lkml.kernel.org/r/54184CC802000078000355EE@mail.emea.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/io_apic.h |  2 --
 arch/x86/include/asm/pci_x86.h |  2 ++
 arch/x86/kernel/apic/io_apic.c | 12 ------------
 arch/x86/pci/irq.c             | 12 ++++++++++++
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 1733ab4..51b25f5 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -227,8 +227,6 @@ static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned
 
 extern void io_apic_eoi(unsigned int apic, unsigned int vector);
 
-extern bool mp_should_keep_irq(struct device *dev);
-
 #else  /* !CONFIG_X86_IO_APIC */
 
 #define io_apic_assign_pci_irqs 0
diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index fa1195d..164e3f8 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -93,6 +93,8 @@ extern raw_spinlock_t pci_config_lock;
 extern int (*pcibios_enable_irq)(struct pci_dev *dev);
 extern void (*pcibios_disable_irq)(struct pci_dev *dev);
 
+extern bool mp_should_keep_irq(struct device *dev);
+
 struct pci_raw_ops {
 	int (*read)(unsigned int domain, unsigned int bus, unsigned int devfn,
 						int reg, int len, u32 *val);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 1183d54..d3ad43b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3964,18 +3964,6 @@ int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node)
 	return ret;
 }
 
-bool mp_should_keep_irq(struct device *dev)
-{
-	if (dev->power.is_prepared)
-		return true;
-#ifdef	CONFIG_PM_RUNTIME
-	if (dev->power.runtime_status == RPM_SUSPENDING)
-		return true;
-#endif
-
-	return false;
-}
-
 /* Enable IOAPIC early just for system timer */
 void __init pre_init_apic_IRQ0(void)
 {
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index eb500c2..cb50e28 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -1254,6 +1254,18 @@ static int pirq_enable_irq(struct pci_dev *dev)
 	return 0;
 }
 
+bool mp_should_keep_irq(struct device *dev)
+{
+	if (dev->power.is_prepared)
+		return true;
+#ifdef CONFIG_PM_RUNTIME
+	if (dev->power.runtime_status == RPM_SUSPENDING)
+		return true;
+#endif
+
+	return false;
+}
+
 static void pirq_disable_irq(struct pci_dev *dev)
 {
 	if (io_apic_assign_pci_irqs && !mp_should_keep_irq(&dev->dev) &&
