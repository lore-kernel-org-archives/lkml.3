Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbbATFxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:53:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:56179 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbbATFxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:53:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,432,1418112000"; 
   d="scan'208";a="664447801"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part2 v4 18/33] x86/irq: Kill x86_io_apic_ops.write and x86_io_apic_ops.modify
Date: Tue, 20 Jan 2015 13:51:38 +0800
Message-Id: <1421733113-15704-19-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_io_apic_ops.write is always set to native_io_apic_write(),
and nobody overrides it. So get rid of the indirection by changing
native_io_apic_write() as io_apic_write() and killing
x86_io_apic_ops.write.

Do the same for x86_io_apic_ops.modify and native_io_apic_modify().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: Grant Likely <grant.likely@linaro.org>
Link: http://lkml.kernel.org/r/1416901802-24211-28-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/io_apic.h  |   13 -------------
 arch/x86/include/asm/x86_init.h |    2 --
 arch/x86/kernel/apic/io_apic.c  |    6 ++++--
 arch/x86/kernel/x86_init.c      |    2 --
 4 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 1597c77725f9..21578af00243 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -208,8 +208,6 @@ extern void disable_ioapic_support(void);
 
 extern void __init native_io_apic_init_mappings(void);
 extern unsigned int native_io_apic_read(unsigned int apic, unsigned int reg);
-extern void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int val);
-extern void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val);
 extern void native_disable_io_apic(void);
 
 static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
@@ -217,15 +215,6 @@ static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
 	return x86_io_apic_ops.read(apic, reg);
 }
 
-static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
-{
-	x86_io_apic_ops.write(apic, reg, value);
-}
-static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
-{
-	x86_io_apic_ops.modify(apic, reg, value);
-}
-
 extern void setup_IO_APIC(void);
 extern void enable_IO_APIC(void);
 extern void disable_IO_APIC(void);
@@ -266,8 +255,6 @@ static inline void mp_save_irq(struct mpc_intsrc *m) { };
 static inline void disable_ioapic_support(void) { }
 #define native_io_apic_init_mappings	NULL
 #define native_io_apic_read		NULL
-#define native_io_apic_write		NULL
-#define native_io_apic_modify		NULL
 #define native_disable_io_apic		NULL
 #endif
 
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 09d4dab9302f..844b37d55a44 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -182,8 +182,6 @@ struct x86_msi_ops {
 struct x86_io_apic_ops {
 	void		(*init)   (void);
 	unsigned int	(*read)   (unsigned int apic, unsigned int reg);
-	void		(*write)  (unsigned int apic, unsigned int reg, unsigned int value);
-	void		(*modify) (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*disable)(void);
 };
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 77ad05eee418..a7583eb4b648 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -282,7 +282,8 @@ unsigned int native_io_apic_read(unsigned int apic, unsigned int reg)
 	return readl(&io_apic->data);
 }
 
-void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
+static void io_apic_write(unsigned int apic, unsigned int reg,
+			  unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 
@@ -296,7 +297,8 @@ void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int valu
  *
  * Older SiS APIC requires we rewrite the index register
  */
-void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
+static void io_apic_modify(unsigned int apic, unsigned int reg,
+			   unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index f612dc018fb6..633f07845099 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -141,7 +141,5 @@ void arch_restore_msi_irqs(struct pci_dev *dev)
 struct x86_io_apic_ops x86_io_apic_ops = {
 	.init			= native_io_apic_init_mappings,
 	.read			= native_io_apic_read,
-	.write			= native_io_apic_write,
-	.modify			= native_io_apic_modify,
 	.disable		= native_disable_io_apic,
 };
-- 
1.7.10.4

