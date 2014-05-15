Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbaEOT0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:26:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457AbaEOT0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:26:47 -0400
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Elliott@hp.com, Don Zickus <dzickus@redhat.com>,
        thomas.mingarelli@hp.com
Subject: [PATCH 5/6] x86, nmi: Move default external NMI handler to its own routine
Date: Thu, 15 May 2014 15:25:48 -0400
Message-Id: <1400181949-157170-6-git-send-email-dzickus@redhat.com>
In-Reply-To: <1400181949-157170-1-git-send-email-dzickus@redhat.com>
References: <1400181949-157170-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have setup an NMI subtye called NMI_EXT, there is really
no need to hard code the default external NMI handler in the main
nmi handler routine.

Move it to a proper function and register it on boot.  This change is
just code movement.

In addition, update the hpwdt to allow it to unregister the default
handler on its registration (and vice versa).  This allows the driver
to take control of that io port (which it ultimately wanted to do
originally), but in a cleaner way.

Tested by HP to make sure I didn't break anything. :-)

Cc: thomas.mingarelli@hp.com
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/include/asm/nmi.h |    3 ++
 arch/x86/kernel/nmi.c      |   81 +++++++++++++++++++++++++++----------------
 drivers/watchdog/hpwdt.c   |   14 +++++++
 3 files changed, 68 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 8631a49..c8ffab3 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -64,4 +64,7 @@ void stop_nmi(void);
 void restart_nmi(void);
 void local_touch_nmi(void);
 
+int register_nmi_default_external_handler(void);
+void unregister_nmi_default_external_handler(void);
+
 #endif /* _ASM_X86_NMI_H */
diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index a5835ad..458be2a 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -74,11 +74,6 @@ static DEFINE_PER_CPU(struct nmi_stats, nmi_stats);
 static int ignore_nmis;
 
 int unknown_nmi_panic;
-/*
- * Prevent NMI reason port (0x61) being accessed simultaneously, can
- * only be used in NMI handler.
- */
-static DEFINE_RAW_SPINLOCK(nmi_reason_lock);
 
 static int __init setup_unknown_nmi_panic(char *str)
 {
@@ -421,7 +416,6 @@ static DEFINE_PER_CPU(unsigned long, last_nmi_rip);
 
 static __kprobes void default_do_nmi(struct pt_regs *regs)
 {
-	unsigned char reason = 0;
 	int handled;
 	bool b2b = false;
 
@@ -472,30 +466,6 @@ static __kprobes void default_do_nmi(struct pt_regs *regs)
 		return;
 	}
 
-	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
-	raw_spin_lock(&nmi_reason_lock);
-	reason = x86_platform.get_nmi_reason();
-
-	if (reason & NMI_REASON_MASK) {
-		if (reason & NMI_REASON_SERR)
-			pci_serr_error(reason, regs);
-		else if (reason & NMI_REASON_IOCHK)
-			io_check_error(reason, regs);
-#ifdef CONFIG_X86_32
-		/*
-		 * Reassert NMI in case it became active
-		 * meanwhile as it's edge-triggered:
-		 */
-		reassert_nmi();
-#endif
-		__this_cpu_add(nmi_stats.external, 1);
-		raw_spin_unlock(&nmi_reason_lock);
-		/* kick off delayed work in case we swallowed external NMI */
-		nmi_queue_work();
-		return;
-	}
-	raw_spin_unlock(&nmi_reason_lock);
-
 	/* expected delayed queued NMI? Don't flag as unknown */
 	if (nmi_queue_work_clear())
 		return;
@@ -537,6 +507,57 @@ static __kprobes void default_do_nmi(struct pt_regs *regs)
 }
 
 /*
+ * Prevent NMI reason port (0x61) being accessed simultaneously, can
+ * only be used in NMI handler.
+ */
+static DEFINE_RAW_SPINLOCK(nmi_reason_lock);
+
+static int __kprobes
+nmi_default_external_handler(unsigned int cmd, struct pt_regs *regs)
+{
+	unsigned char reason = 0;
+	int ret = NMI_DONE;
+
+	/* Non-CPU-specific NMI: NMI sources can be processed on any CPU */
+	raw_spin_lock(&nmi_reason_lock);
+	reason = x86_platform.get_nmi_reason();
+
+	if (reason & NMI_REASON_MASK) {
+		if (reason & NMI_REASON_SERR)
+			pci_serr_error(reason, regs);
+		else if (reason & NMI_REASON_IOCHK)
+			io_check_error(reason, regs);
+#ifdef CONFIG_X86_32
+		/*
+		 * Reassert NMI in case it became active
+		 * meanwhile as it's edge-triggered:
+		 */
+		reassert_nmi();
+#endif
+		ret = NMI_HANDLED;
+	}
+	raw_spin_unlock(&nmi_reason_lock);
+
+	return ret;
+}
+
+int register_nmi_default_external_handler(void)
+{
+	register_nmi_handler(NMI_EXT, nmi_default_external_handler,
+				0, "plat");
+
+	return 0;
+}
+EXPORT_SYMBOL(register_nmi_default_external_handler);
+early_initcall(register_nmi_default_external_handler);
+
+void unregister_nmi_default_external_handler(void)
+{
+	unregister_nmi_handler(NMI_EXT, "plat");
+}
+EXPORT_SYMBOL(unregister_nmi_default_external_handler);
+
+/*
  * NMIs can hit breakpoints which will cause it to lose its
  * NMI context with the CPU when the breakpoint does an iret.
  */
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index dd70ee7..10e7813 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -37,6 +37,7 @@
 #include <asm/cacheflush.h>
 #endif /* CONFIG_HPWDT_NMI_DECODING */
 #include <asm/nmi.h>
+#include <asm/mach_traps.h>
 
 #define HPWDT_VERSION			"1.3.3"
 #define SECS_TO_TICKS(secs)		((secs) * 1000 / 128)
@@ -486,6 +487,15 @@ static int hpwdt_pretimeout(unsigned int ulReason, struct pt_regs *regs)
 		goto out;
 
 	spin_lock_irqsave(&rom_lock, rom_pl);
+	if (ulReason == NMI_EXT) {
+		unsigned char reason = 0;
+		reason = x86_platform.get_nmi_reason();
+
+		if (!(reason & NMI_REASON_MASK)) {
+			spin_unlock_irqrestore(&rom_lock, rom_pl);
+			goto out;
+		}
+	}
 	if (!die_nmi_called && !is_icru && !is_uefi)
 		asminline_call(&cmn_regs, cru_rom_addr);
 	die_nmi_called = 1;
@@ -740,6 +750,9 @@ static int hpwdt_init_nmi_decoding(struct pci_dev *dev)
 	if (retval)
 		goto error1;
 
+	/* hpwdt is the new external port 0x61 handler */
+	unregister_nmi_default_external_handler();
+
 	dev_info(&dev->dev,
 			"HP Watchdog Timer Driver: NMI decoding initialized"
 			", allow kernel dump: %s (default = 0/OFF)\n",
@@ -761,6 +774,7 @@ static void hpwdt_exit_nmi_decoding(void)
 {
 	unregister_nmi_handler(NMI_UNKNOWN, "hpwdt");
 	unregister_nmi_handler(NMI_EXT, "hpwdt");
+	register_nmi_default_external_handler();
 	if (cru_rom_addr)
 		iounmap(cru_rom_addr);
 }
-- 
1.7.1

