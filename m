Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229Ab3DKXBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 19:01:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48333 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765445Ab3DKXBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 19:01:48 -0400
Date: Thu, 11 Apr 2013 16:01:36 -0700
From: tip-bot for Konrad Rzeszutek Wilk <tipbot@zytor.com>
Message-ID: <tip-357d122670937c35b33d99c46356ef2b63182a1f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1365194544-14648-4-git-send-email-konrad.wilk@oracle.com>
References: <1365194544-14648-4-git-send-email-konrad.wilk@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/paravirt] x86, xen, gdt:
  Remove the pvops variant of store_gdt.
Git-Commit-ID: 357d122670937c35b33d99c46356ef2b63182a1f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 11 Apr 2013 16:01:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  357d122670937c35b33d99c46356ef2b63182a1f
Gitweb:     http://git.kernel.org/tip/357d122670937c35b33d99c46356ef2b63182a1f
Author:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
AuthorDate: Fri, 5 Apr 2013 16:42:23 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 11 Apr 2013 15:40:38 -0700

x86, xen, gdt: Remove the pvops variant of store_gdt.

The two use-cases where we needed to store the GDT were during ACPI S3 suspend
and resume. As the patches:
 x86/gdt/i386: store/load GDT for ACPI S3 or hibernation/resume path is not needed
 x86/gdt/64-bit: store/load GDT for ACPI S3 or hibernate/resume path is not needed.

have demonstrated - there are other mechanism by which the GDT is
saved and reloaded during early resume path.

Hence we do not need to worry about the pvops call-chain for saving the
GDT and can and can eliminate it. The other areas where the store_gdt is
used are never going to be hit when running under the pvops platforms.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/r/1365194544-14648-4-git-send-email-konrad.wilk@oracle.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/paravirt.h       | 4 ----
 arch/x86/include/asm/paravirt_types.h | 2 +-
 arch/x86/kernel/acpi/sleep.c          | 2 +-
 arch/x86/kernel/doublefault_32.c      | 2 +-
 arch/x86/kernel/paravirt.c            | 1 -
 arch/x86/kvm/vmx.c                    | 2 +-
 arch/x86/xen/enlighten.c              | 1 -
 7 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 5edd174..7365128 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -262,10 +262,6 @@ static inline void set_ldt(const void *addr, unsigned entries)
 {
 	PVOP_VCALL2(pv_cpu_ops.set_ldt, addr, entries);
 }
-static inline void store_gdt(struct desc_ptr *dtr)
-{
-	PVOP_VCALL1(pv_cpu_ops.store_gdt, dtr);
-}
 static inline void store_idt(struct desc_ptr *dtr)
 {
 	PVOP_VCALL1(pv_cpu_ops.store_idt, dtr);
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 142236e..b6c69a6 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -122,7 +122,7 @@ struct pv_cpu_ops {
 	void (*load_tr_desc)(void);
 	void (*load_gdt)(const struct desc_ptr *);
 	void (*load_idt)(const struct desc_ptr *);
-	void (*store_gdt)(struct desc_ptr *);
+	/* store_gdt has been removed. */
 	void (*store_idt)(struct desc_ptr *);
 	void (*set_ldt)(const void *desc, unsigned entries);
 	unsigned long (*store_tr)(void);
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 0532f5d..b44577b 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -46,7 +46,7 @@ int acpi_suspend_lowlevel(void)
 	header->pmode_behavior = 0;
 
 #ifndef CONFIG_64BIT
-	store_gdt((struct desc_ptr *)&header->pmode_gdt);
+	native_store_gdt((struct desc_ptr *)&header->pmode_gdt);
 
 	if (!rdmsr_safe(MSR_EFER,
 			&header->pmode_efer_low,
diff --git a/arch/x86/kernel/doublefault_32.c b/arch/x86/kernel/doublefault_32.c
index 37250fe..155a13f 100644
--- a/arch/x86/kernel/doublefault_32.c
+++ b/arch/x86/kernel/doublefault_32.c
@@ -20,7 +20,7 @@ static void doublefault_fn(void)
 	struct desc_ptr gdt_desc = {0, 0};
 	unsigned long gdt, tss;
 
-	store_gdt(&gdt_desc);
+	native_store_gdt(&gdt_desc);
 	gdt = gdt_desc.address;
 
 	printk(KERN_EMERG "PANIC: double fault, gdt at %08lx [%d bytes]\n", gdt, gdt_desc.size);
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 17fff18..4ae3d23 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -360,7 +360,6 @@ struct pv_cpu_ops pv_cpu_ops = {
 	.set_ldt = native_set_ldt,
 	.load_gdt = native_load_gdt,
 	.load_idt = native_load_idt,
-	.store_gdt = native_store_gdt,
 	.store_idt = native_store_idt,
 	.store_tr = native_store_tr,
 	.load_tls = native_load_tls,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6667042..867b810 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2459,7 +2459,7 @@ static int hardware_enable(void *garbage)
 		ept_sync_global();
 	}
 
-	store_gdt(&__get_cpu_var(host_gdt));
+	native_store_gdt(&__get_cpu_var(host_gdt));
 
 	return 0;
 }
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c8e1c7b..ddab539 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1220,7 +1220,6 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.alloc_ldt = xen_alloc_ldt,
 	.free_ldt = xen_free_ldt,
 
-	.store_gdt = native_store_gdt,
 	.store_idt = native_store_idt,
 	.store_tr = xen_store_tr,
 
