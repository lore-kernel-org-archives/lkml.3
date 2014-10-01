Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaJAF0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 01:26:14 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37970 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaJAF0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 01:26:11 -0400
Message-ID: <1412141164.21488.39.camel@debian>
Subject: Re: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
From: Chen Yucong <slaoub@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: tony.luck@intel.com, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 01 Oct 2014 13:26:04 +0800
In-Reply-To: <20140930100940.GD4639@pd.tnic>
References: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
	 <1411460354.25617.3.camel@debian> <20140929120546.GB6495@pd.tnic>
	 <1412037578.21488.11.camel@debian> <20140930072553.GA4639@pd.tnic>
	 <1412070991.16556.12.camel@cyc> <20140930100940.GD4639@pd.tnic>
Content-Type: multipart/mixed; boundary="=-oGvFWTIAem2ZtD4XXf54"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oGvFWTIAem2ZtD4XXf54
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Tue, 2014-09-30 at 12:09 +0200, Borislav Petkov wrote:
> 
> Now let me repeat my question: how are you testing your patches?
> 
There are no any hardware facilities that can help me to inject some
MCE errors. So I have to modify the kernel source code for testing my
patches.

My method is based on the `mce-injection' that is better suited to 
Intel processors. So I have replaced rdmsrl/wrmsrl/rdmsr_safe with
mce_rdmsrl/mce_wrmsrl/mce_rdmsr_safe in mce_amd.c. But I use a new
kernel module for error injection instead of writing /dev/mcelog.

For more detailed information about testing, you can refer the 
attachments.

thx!
cyc 
  

--=-oGvFWTIAem2ZtD4XXf54
Content-Disposition: attachment; filename="amd-mce-injection.patch"
Content-Type: text/x-patch; name="amd-mce-injection.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff -uNr amd_inject/linux-3.16.3/arch/x86/include/asm/mce.h linux-3.16.3/arch/x86/include/asm/mce.h
--- amd_inject/linux-3.16.3/arch/x86/include/asm/mce.h	2014-09-18 01:22:16.000000000 +0800
+++ linux-3.16.3/arch/x86/include/asm/mce.h	2014-10-01 09:36:06.302670241 +0800
@@ -166,6 +166,7 @@
 #endif
 
 #ifdef CONFIG_X86_MCE_AMD
+void raise_amd_threshold_event(void);
 void mce_amd_feature_init(struct cpuinfo_x86 *c);
 #else
 static inline void mce_amd_feature_init(struct cpuinfo_x86 *c) { }
@@ -185,10 +186,14 @@
 	MCP_DONTLOG = (1 << 2),		/* only clear, don't log */
 };
 void machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
+u64 mce_rdmsrl(u32 msr);
+void mce_wrmsrl(u32 msr, u64 v);
+int mce_rdmsr_safe(u32 msr, u32 *low, u32 *high);
 
 int mce_notify_irq(void);
 void mce_notify_process(void);
 
+extern int amd_inject;
 DECLARE_PER_CPU(struct mce, injectm);
 
 extern void register_mce_write_callback(ssize_t (*)(struct file *filp,
diff -uNr amd_inject/linux-3.16.3/arch/x86/kernel/cpu/mcheck/mce_amd.c linux-3.16.3/arch/x86/kernel/cpu/mcheck/mce_amd.c
--- amd_inject/linux-3.16.3/arch/x86/kernel/cpu/mcheck/mce_amd.c	2014-09-18 01:22:16.000000000 +0800
+++ linux-3.16.3/arch/x86/kernel/cpu/mcheck/mce_amd.c	2014-10-01 11:09:07.817585622 +0800
@@ -274,6 +274,7 @@
 	struct mce m;
 
 	mce_setup(&m);
+	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
 
 	/* assume first bank caused it */
 	for (bank = 0; bank < mca_cfg.banks; ++bank) {
@@ -291,7 +292,7 @@
 				++address;
 			}
 
-			if (rdmsr_safe(address, &low, &high))
+			if (mce_rdmsr_safe(address, &low, &high))
 				break;
 
 			if (!(high & MASK_VALID_HI)) {
@@ -305,26 +306,35 @@
 			     (high & MASK_LOCKED_HI))
 				continue;
 
-			/*
-			 * Log the machine check that caused the threshold
-			 * event.
-			 */
-			machine_check_poll(MCP_TIMESTAMP,
-					&__get_cpu_var(mce_poll_banks));
-
 			if (high & MASK_OVERFLOW_HI) {
-				rdmsrl(address, m.misc);
-				rdmsrl(MSR_IA32_MC0_STATUS + bank * 4,
-				       m.status);
+				m.misc = mce_rdmsrl(address);
+				m.status = mce_rdmsrl(MSR_IA32_MC0_STATUS + bank * 4);
+				if (m.status & MCI_STATUS_ADDRV)
+					m.addr = mce_rdmsrl(MSR_IA32_MC0_ADDR + bank * 4);
 				m.bank = K8_MCE_THRESHOLD_BASE
 				       + bank * NR_BLOCKS
 				       + block;
 				mce_log(&m);
+				mce_wrmsrl(MSR_IA32_MC0_STATUS + bank * 4, 0);
 				return;
 			}
 		}
 	}
+
+	/*
+	 * Log the machine check that caused the threshold
+	 * event.
+	 */
+	machine_check_poll(MCP_TIMESTAMP,
+				&__get_cpu_var(mce_poll_banks));
+
+}
+
+void raise_amd_threshold_event(void)
+{
+	amd_threshold_interrupt();
 }
+EXPORT_SYMBOL_GPL(raise_amd_threshold_event);
 
 /*
  * Sysfs Interface
diff -uNr amd_inject/linux-3.16.3/arch/x86/kernel/cpu/mcheck/mce.c linux-3.16.3/arch/x86/kernel/cpu/mcheck/mce.c
--- amd_inject/linux-3.16.3/arch/x86/kernel/cpu/mcheck/mce.c	2014-09-18 01:22:16.000000000 +0800
+++ linux-3.16.3/arch/x86/kernel/cpu/mcheck/mce.c	2014-10-01 09:40:13.269228358 +0800
@@ -48,6 +48,9 @@
 
 #include "mce-internal.h"
 
+int amd_inject = 0;
+EXPORT_PER_CPU_SYMBOL_GPL(amd_inject);
+
 static DEFINE_MUTEX(mce_chrdev_read_mutex);
 
 #define rcu_dereference_check_mce(p) \
@@ -131,6 +134,7 @@
 	m->apicid = cpu_data(m->extcpu).initial_apicid;
 	rdmsrl(MSR_IA32_MCG_CAP, m->mcgcap);
 }
+EXPORT_SYMBOL_GPL(mce_setup);
 
 DEFINE_PER_CPU(struct mce, injectm);
 EXPORT_PER_CPU_SYMBOL_GPL(injectm);
@@ -391,7 +395,7 @@
 }
 
 /* MSR access wrappers used for error injection */
-static u64 mce_rdmsrl(u32 msr)
+u64 mce_rdmsrl(u32 msr)
 {
 	u64 v;
 
@@ -415,8 +419,9 @@
 
 	return v;
 }
 
-static void mce_wrmsrl(u32 msr, u64 v)
+void mce_wrmsrl(u32 msr, u64 v)
 {
 	if (__this_cpu_read(injectm.finished)) {
 		int offset = msr_to_offset(msr);
@@ -427,6 +432,18 @@
 	}
 	wrmsrl(msr, v);
 }
+
+int mce_rdmsr_safe(u32 msr, u32 *low, u32 *high) 
+{
+        u64 __val = mce_rdmsrl(msr);
+
+        (*low) = (u32)__val;
+        (*high) = (u32)(__val >> 32);
+
+	return 0;
+}
 
 /*
  * Collect all global (w.r.t. this processor) status about this machine
@@ -1637,6 +1654,7 @@
 		mce_adjust_timer = mce_intel_adjust_timer;
 		break;
 	case X86_VENDOR_AMD:
+		amd_inject = 1;
 		mce_amd_feature_init(c);
 		break;
 	default:
diff -uNr amd_inject/linux-3.16.3/arch/x86/kernel/cpu/mcheck/mce-inject.c linux-3.16.3/arch/x86/kernel/cpu/mcheck/mce-inject.c
--- amd_inject/linux-3.16.3/arch/x86/kernel/cpu/mcheck/mce-inject.c	2014-09-18 01:22:16.000000000 +0800
+++ linux-3.16.3/arch/x86/kernel/cpu/mcheck/mce-inject.c	2014-09-30 22:38:30.138557839 +0800
@@ -54,7 +54,10 @@
 
 	memset(&b, 0xff, sizeof(mce_banks_t));
 	local_irq_save(flags);
-	machine_check_poll(0, &b);
+	if (!amd_inject)
+		machine_check_poll(0, &b);
+	else 
+		mce_threshold_vector();
 	local_irq_restore(flags);
 	m->finished = 0;
 }
diff -uNr amd_inject/linux-3.16.3/arch/x86/kernel/cpu/mcheck/threshold.c linux-3.16.3/arch/x86/kernel/cpu/mcheck/threshold.c
--- amd_inject/linux-3.16.3/arch/x86/kernel/cpu/mcheck/threshold.c	2014-09-18 01:22:16.000000000 +0800
+++ linux-3.16.3/arch/x86/kernel/cpu/mcheck/threshold.c	2014-10-01 08:49:06.140738192 +0800
@@ -17,6 +17,7 @@
 }
 
 void (*mce_threshold_vector)(void) = default_threshold_interrupt;
+EXPORT_SYMBOL_GPL(mce_threshold_vector);
 
 static inline void __smp_threshold_interrupt(void)
 {

--=-oGvFWTIAem2ZtD4XXf54
Content-Disposition: attachment; filename="amd_inject.c"
Content-Type: text/x-csrc; name="amd_inject.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

/*
 * Copyright Chen Yucong<slaoub@gmail.com> 2014 
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; version 2
 * of the License.
 */
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/smp.h>
#include <linux/cpu.h>
#include <asm/mce.h>
#include <asm/msr.h>
#include <asm/amd_nb.h>

#define MASK_OVERFLOW  0x0001000000000000

/* Update fake mce registers on current CPU. */
static void inject_mce(struct mce *m)
{
	struct mce *i = &per_cpu(injectm, m->extcpu);

	/* Make sure no one reads partially written injectm */
	i->finished = 0;
	mb();
	m->finished = 0;
	/* First set the fields after finished */
	i->extcpu = m->extcpu;
	mb();
	/* Now write record in order, finished last (except above) */
	memcpy(i, m, sizeof(struct mce));
	/* Finally activate it */
	mb();
	i->finished = 1;
}

static void raise_mce(void)
{
	struct mce m;

	mce_setup(&m);
	m.status = 0X8C00000000000000;
	m.misc = 0XC008000000000000 | MASK_OVERFLOW;
	//m.misc = 0XC008000000000000;
	m.bank = 4;
	m.addr = 0xabcdef;
	inject_mce(&m);

	raise_amd_threshold_event();
}

static int __init amd_inject_init(void)
{
	raise_mce();
	pr_info("amd_inject module loaded ...\n");

	return 0;
}

static void __exit amd_inject_exit(void)
{
	pr_info("amd_inject module unloaded ...\n");
}

module_init(amd_inject_init);
module_exit(amd_inject_exit);

/*
 * Cannot tolerate unloading currently because we cannot
 * guarantee all openers of mce_chrdev will get a reference to us.
 */
MODULE_LICENSE("GPL");

--=-oGvFWTIAem2ZtD4XXf54--

