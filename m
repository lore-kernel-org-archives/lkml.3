Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933149Ab3CYSux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 14:50:53 -0400
Received: from relay1.sgi.com ([192.48.179.29]:37463 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933026Ab3CYSuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 14:50:11 -0400
Message-Id: <20130325185009.556418899@gulag1.americas.sgi.com>
References: <20130325185007.321022858@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 25 Mar 2013 13:50:22 -0500
From: Mike Travis <travis@sgi.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Steffen Persvold <sp@numascale.com>
Subject: [PATCH 15/15] x86/UV: Add call to KGDB/KDB from NMI handler
Content-Disposition: inline; filename=uv-add-nmi-call-kdb.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch restores the ability to enter KDB (and KGDB) from the UV
NMI handler.  It utilizes the newly added kgdb_nmicallin function
to gain entry to KGDB/KDB by the master.  The slaves still enter via
the standard kgdb_nmicallback function.

The handler also uses the new 'send_ready' pointer to tell KGDB/KDB
to signal the slaves when to proceed into the KGDB slave loop.

Cc: Alexander Gordeev <agordeev@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Steffen Persvold <sp@numascale.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/platform/uv/uv_nmi.c |   73 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 71 insertions(+), 2 deletions(-)

--- linux.orig/arch/x86/platform/uv/uv_nmi.c
+++ linux/arch/x86/platform/uv/uv_nmi.c
@@ -21,6 +21,8 @@
 
 #include <linux/cpu.h>
 #include <linux/delay.h>
+#include <linux/kgdb.h>
+#include <linux/kdb.h>
 #include <linux/module.h>
 #include <linux/nmi.h>
 #include <linux/sched.h>
@@ -34,6 +36,7 @@
 #include <asm/current.h>
 #include <asm/kdebug.h>
 #include <asm/local64.h>
+#include <asm/traps.h>
 #include <asm/uv/uv.h>
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_mmrs.h>
@@ -521,6 +524,68 @@ static void uv_nmi_touch_watchdogs(void)
 	touch_nmi_watchdog();
 }
 
+#ifdef CONFIG_KGDB_KDB
+
+/* Disable to force process dump instead of entering KDB or KGDB */
+static int uv_nmi_kdb_on = 1;
+module_param_named(kdb_on, uv_nmi_kdb_on, int, 0644);
+
+/* Call KDB from NMI handler */
+static void uv_call_kdb(int cpu, struct pt_regs *regs,
+			int master, unsigned long *flags)
+{
+	int ret;
+
+	if (master) {
+		/* call KGDB NMI handler as MASTER */
+		local_irq_restore(*flags);
+		ret = kgdb_nmicallin(cpu, X86_TRAP_NMI, regs,
+					&uv_nmi_slave_continue);
+		local_irq_save(*flags);
+
+		/*
+		 * if KGDB/KDB did not handle the NMI, then signal slaves
+		 *   to do process dump instead.
+		 */
+		if (ret) {
+			uv_nmi_dump_state(cpu, regs, 1);
+			return;
+		}
+	} else {
+		int sig;
+
+		/* wait for KGDB to say it's ready for slaves to enter */
+		do {
+			cpu_relax();
+			sig = atomic_read(&uv_nmi_slave_continue);
+		} while (!sig);
+
+		/*
+		 * if KGDB/KDB did not handle the NMI for the master, then
+		 *   the master signals the slaves to do process dump instead.
+		 */
+		if (sig == 2) {
+			uv_nmi_dump_state(cpu, regs, 0);
+			return;
+		}
+
+		/* call KGDB as slave */
+		local_irq_restore(*flags);
+		ret = kgdb_nmicallback(cpu, regs);
+		local_irq_save(*flags);
+	}
+	uv_nmi_sync_exit(master);
+}
+
+#else /* !CONFIG_KGDB_KDB */
+static inline void uv_call_kdb(int cpu, struct pt_regs *regs,
+				int master, unsigned long *flags)
+{
+	pr_err("UV: NMI error: KDB is not enabled in this kernel\n");
+	uv_nmi_dump_state(cpu, regs, master);
+}
+#endif /* !CONFIG_KGDB_KDB */
+
 /*
  * UV NMI handler
  */
@@ -547,8 +612,12 @@ int uv_handle_nmi(unsigned int reason, s
 	if (master && uv_nmi_kdump_requested)
 		uv_nmi_kdump(regs);
 
-	/* Dump state of each cpu */
-	uv_nmi_dump_state(cpu, regs, master);
+	/* Call KDB if enabled */
+	if (uv_nmi_kdb_on)
+		uv_call_kdb(cpu, regs, master, &flags);
+
+	else	/* Otherwise dump state of each cpu */
+		uv_nmi_dump_state(cpu, regs, master);
 
 	/* Clear per_cpu "in nmi" flag */
 	atomic_set(&uv_cpu_nmi.state, UV_NMI_STATE_OUT);

-- 
