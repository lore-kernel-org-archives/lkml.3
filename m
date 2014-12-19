Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaLSOBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:01:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45706 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbaLSOBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:01:48 -0500
Date: Fri, 19 Dec 2014 06:01:32 -0800
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-e10679825924580845c4825deaaddf5331ff627c@git.kernel.org>
Cc: tglx@linutronix.de, mingo@kernel.org, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, jbeulich@suse.com,
        jiang.liu@linux.intel.com, hpa@zytor.com
Reply-To: jiang.liu@linux.intel.com, jbeulich@suse.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@kernel.org, linux-kernel@vger.kernel.org,
        JBeulich@suse.com
In-Reply-To: <545747BE020000780004436E@mail.emea.novell.com>
References: <545747BE020000780004436E@mail.emea.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: irq: Fix placement of mp_should_keep_irq()
Git-Commit-ID: e10679825924580845c4825deaaddf5331ff627c
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

Commit-ID:  e10679825924580845c4825deaaddf5331ff627c
Gitweb:     http://git.kernel.org/tip/e10679825924580845c4825deaaddf5331ff627c
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Mon, 3 Nov 2014 08:15:42 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 16 Dec 2014 14:08:14 +0100

x86: irq: Fix placement of mp_should_keep_irq()

While f3761db164 ("x86, irq: Fix build error caused by
9eabc99a635a77cbf09") addressed the original build problem,
declaration, inline stub, and definition still seem misplaced: It isn't
really IO-APIC related, and it's being used solely in arch/x86/pci/.
This also means stubbing it out when !CONFIG_X86_IO_APIC was at least
questionable.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Link: http://lkml.kernel.org/r/545747BE020000780004436E@mail.emea.novell.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/io_apic.h |  3 ---
 arch/x86/include/asm/pci_x86.h |  2 ++
 arch/x86/kernel/apic/io_apic.c | 12 ------------
 arch/x86/pci/irq.c             | 12 ++++++++++++
 4 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 1733ab4..0aeed5c 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -227,8 +227,6 @@ static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned
 
 extern void io_apic_eoi(unsigned int apic, unsigned int vector);
 
-extern bool mp_should_keep_irq(struct device *dev);
-
 #else  /* !CONFIG_X86_IO_APIC */
 
 #define io_apic_assign_pci_irqs 0
@@ -239,7 +237,6 @@ static inline int mp_find_ioapic(u32 gsi) { return 0; }
 static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
 static inline int mp_map_gsi_to_irq(u32 gsi, unsigned int flags) { return gsi; }
 static inline void mp_unmap_irq(int irq) { }
-static inline bool mp_should_keep_irq(struct device *dev) { return 1; }
 
 static inline int save_ioapic_entries(void)
 {
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
index 7ffe0a2..a157b66 100644
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
