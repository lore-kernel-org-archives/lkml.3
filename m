Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbaKHSQx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:16:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:39546 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbaKHSQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:16:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413534155"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part3 v3 27/38] x86, irq: Kill x86_io_apic_ops.write and x86_io_apic_ops.modify
Date: Sun,  9 Nov 2014 02:13:27 +0800
Message-Id: <1415470418-10874-28-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_io_apic_ops.write is always set to native_io_apic_write(),
and nobody overrides it. So get rid of the indirection by changing
native_io_apic_write() as io_apic_write() and killing
x86_io_apic_ops.write.

Do the same for x86_io_apic_ops.modify and native_io_apic_modify().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
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
index 3755cd2bbb94..398717e7493d 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -185,8 +185,6 @@ struct x86_msi_ops {
 struct x86_io_apic_ops {
 	void		(*init)   (void);
 	unsigned int	(*read)   (unsigned int apic, unsigned int reg);
-	void		(*write)  (unsigned int apic, unsigned int reg, unsigned int value);
-	void		(*modify) (unsigned int apic, unsigned int reg, unsigned int value);
 	void		(*disable)(void);
 };
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index f0ef5832f527..7a3679e43b67 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -277,7 +277,8 @@ unsigned int native_io_apic_read(unsigned int apic, unsigned int reg)
 	return readl(&io_apic->data);
 }
 
-void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
+static void io_apic_write(unsigned int apic, unsigned int reg,
+			  unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 
@@ -291,7 +292,8 @@ void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int valu
  *
  * Older SiS APIC requires we rewrite the index register
  */
-void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
+static void io_apic_modify(unsigned int apic, unsigned int reg,
+			   unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index ac2b604c00ec..30140bdf6d62 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -151,7 +151,5 @@ u32 arch_msix_mask_irq(struct msi_desc *desc, u32 flag)
 struct x86_io_apic_ops x86_io_apic_ops = {
 	.init			= native_io_apic_init_mappings,
 	.read			= native_io_apic_read,
-	.write			= native_io_apic_write,
-	.modify			= native_io_apic_modify,
 	.disable		= native_disable_io_apic,
 };
-- 
1.7.10.4

