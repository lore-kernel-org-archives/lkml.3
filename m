Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbbAVO0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:26:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57850 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbbAVO0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:26:17 -0500
Date: Thu, 22 Jan 2015 06:25:52 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-9aa16365275a272283acbda665634ca3dc8b46fe@git.kernel.org>
Cc: tglx@linutronix.de, hpa@zytor.com, joro@8bytes.org,
        jiang.liu@linux.intel.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, tony.luck@intel.com, bp@alien8.de
Reply-To: bp@alien8.de, mingo@kernel.org, tony.luck@intel.com,
        jiang.liu@linux.intel.com, linux-kernel@vger.kernel.org,
        joro@8bytes.org, hpa@zytor.com, tglx@linutronix.de
In-Reply-To: <20150115211702.621431109@linutronix.de>
References: <20150115211702.621431109@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Make disable x2apic work really
Git-Commit-ID: 9aa16365275a272283acbda665634ca3dc8b46fe
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

Commit-ID:  9aa16365275a272283acbda665634ca3dc8b46fe
Gitweb:     http://git.kernel.org/tip/9aa16365275a272283acbda665634ca3dc8b46fe
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 15 Jan 2015 21:22:16 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 15:10:54 +0100

x86/apic: Make disable x2apic work really

If x2apic_preenabled is not enabled, then disable_x2apic() is not
called from various places which results in x2apic_disabled not being
set. So other code pathes can happily reenable the x2apic.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/20150115211702.621431109@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 08144f5..fdc6c60 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1479,8 +1479,6 @@ static bool nox2apic __initdata;
 
 #ifdef CONFIG_X86_X2APIC
 int x2apic_mode;
-/* x2apic enabled before OS handover */
-static int x2apic_preenabled;
 static int x2apic_disabled;
 static int __init setup_nox2apic(char *str)
 {
@@ -1535,18 +1533,19 @@ static __init void disable_x2apic(void)
 			setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 		}
 
-		x2apic_disabled = 1;
 		x2apic_mode = 0;
 
 		register_lapic_address(mp_lapic_addr);
 	}
+
+	x2apic_disabled = 1;
 }
 
 void check_x2apic(void)
 {
 	if (x2apic_enabled()) {
 		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
-		x2apic_preenabled = x2apic_mode = 1;
+		x2apic_mode = 1;
 	}
 }
 
@@ -1569,8 +1568,6 @@ void enable_x2apic(void)
 		wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
 	}
 }
-#else
-#define x2apic_preenabled	(0)
 #endif /* CONFIG_X86_X2APIC */
 
 static int __init try_to_enable_IR(void)
@@ -1599,8 +1596,7 @@ static __init void try_to_enable_x2apic(int ir_stat)
 		    (IS_ENABLED(CONFIG_HYPERVISOR_GUEST) &&
 		     !hypervisor_x2apic_available())) {
 			pr_info("IRQ remapping doesn't support X2APIC mode, disable x2apic.\n");
-			if (x2apic_preenabled)
-				disable_x2apic();
+			disable_x2apic();
 			return;
 		}
 
@@ -1643,7 +1639,7 @@ void __init enable_IR_x2apic(void)
 	legacy_pic->mask_all();
 	mask_ioapic_entries();
 
-	if (x2apic_preenabled && nox2apic)
+	if (nox2apic)
 		disable_x2apic();
 	/* If irq_remapping_prepare() succeded, try to enable it */
 	if (ir_stat >= 0)
