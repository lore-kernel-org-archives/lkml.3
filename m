Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbbAVO0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:26:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57833 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbbAVOZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:25:58 -0500
Date: Thu, 22 Jan 2015 06:25:34 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-2ca5b40479246087695d9e6343075b47ee6887ea@git.kernel.org>
Cc: mingo@kernel.org, jiang.liu@linux.intel.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, bp@alien8.de, joro@8bytes.org,
        tony.luck@intel.com
Reply-To: jiang.liu@linux.intel.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, bp@alien8.de, tony.luck@intel.com, joro@8bytes.org,
        tglx@linutronix.de, hpa@zytor.com
In-Reply-To: <20150115211702.541280622@linutronix.de>
References: <20150115211702.541280622@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/ioapic: Check x2apic really
Git-Commit-ID: 2ca5b40479246087695d9e6343075b47ee6887ea
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

Commit-ID:  2ca5b40479246087695d9e6343075b47ee6887ea
Gitweb:     http://git.kernel.org/tip/2ca5b40479246087695d9e6343075b47ee6887ea
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:14 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:54 +0100

x86/ioapic: Check x2apic really

The x2apic_preenabled flag is just a horrible hack and if X2APIC
support is disabled it does not reflect the actual hardware
state. Check the hardware instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/20150115211702.541280622@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h    | 2 --
 arch/x86/kernel/apic/apic.c    | 4 +++-
 arch/x86/kernel/apic/io_apic.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index d2225fd..392bbcf 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -178,7 +178,6 @@ static inline u64 native_x2apic_icr_read(void)
 
 extern int x2apic_mode;
 extern int x2apic_phys;
-extern int x2apic_preenabled;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
 static inline int x2apic_enabled(void)
@@ -210,7 +209,6 @@ static inline void x2apic_force_phys(void)
 }
 
 #define x2apic_mode		(0)
-#define	x2apic_preenabled	(0)
 #define	x2apic_supported()	(0)
 #endif
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index ff2a8b8..08144f5 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1480,7 +1480,7 @@ static bool nox2apic __initdata;
 #ifdef CONFIG_X86_X2APIC
 int x2apic_mode;
 /* x2apic enabled before OS handover */
-int x2apic_preenabled;
+static int x2apic_preenabled;
 static int x2apic_disabled;
 static int __init setup_nox2apic(char *str)
 {
@@ -1569,6 +1569,8 @@ void enable_x2apic(void)
 		wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
 	}
 }
+#else
+#define x2apic_preenabled	(0)
 #endif /* CONFIG_X86_X2APIC */
 
 static int __init try_to_enable_IR(void)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 3f5f604..e5e00f5 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2295,7 +2295,7 @@ static inline void __init check_timer(void)
 	}
 	local_irq_disable();
 	apic_printk(APIC_QUIET, KERN_INFO "..... failed :(.\n");
-	if (x2apic_preenabled)
+	if (apic_is_x2apic_enabled())
 		apic_printk(APIC_QUIET, KERN_INFO
 			    "Perhaps problem with the pre-enabled x2apic mode\n"
 			    "Try booting with x2apic and interrupt-remapping disabled in the bios.\n");
