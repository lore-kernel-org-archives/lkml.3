Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbaL2BR7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:17:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33143 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751579AbaL2BMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:13 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Chris Webb" <chris@arachsys.com>,
        "Borislav Petkov" <bp@suse.de>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.36960447@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 27/27] x86: kvm: use alternatives for VMCALL vs.
 VMMCALL if kernel text is read-only
In-Reply-To: <lsq.1419815490.288081487@decadent.org.uk>
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.66-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit c1118b3602c2329671ad5ec8bdf8e374323d6343 upstream.

On x86_64, kernel text mappings are mapped read-only with CONFIG_DEBUG_RODATA.
In that case, KVM will fail to patch VMCALL instructions to VMMCALL
as required on AMD processors.

The failure mode is currently a divide-by-zero exception, which obviously
is a KVM bug that has to be fixed.  However, picking the right instruction
between VMCALL and VMMCALL will be faster and will help if you cannot upgrade
the hypervisor.

Reported-by: Chris Webb <chris@arachsys.com>
Tested-by: Chris Webb <chris@arachsys.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/cpufeature.h |  1 +
 arch/x86/include/asm/kvm_para.h   | 10 ++++++++--
 arch/x86/kernel/cpu/amd.c         |  7 +++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -193,6 +193,7 @@
 #define X86_FEATURE_DECODEASSISTS (8*32+12) /* AMD Decode Assists support */
 #define X86_FEATURE_PAUSEFILTER (8*32+13) /* AMD filtered pause intercept */
 #define X86_FEATURE_PFTHRESHOLD (8*32+14) /* AMD pause filter threshold */
+#define X86_FEATURE_VMMCALL     ( 8*32+15) /* Prefer vmmcall to vmcall */
 
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ebx), word 9 */
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -91,15 +91,21 @@ struct kvm_vcpu_pv_apf_data {
 
 #ifdef __KERNEL__
 #include <asm/processor.h>
+#include <asm/alternative.h>
 
 extern void kvmclock_init(void);
 extern int kvm_register_clock(char *txt);
 
 
-/* This instruction is vmcall.  On non-VT architectures, it will generate a
- * trap that we will then rewrite to the appropriate instruction.
+#ifdef CONFIG_DEBUG_RODATA
+#define KVM_HYPERCALL \
+        ALTERNATIVE(".byte 0x0f,0x01,0xc1", ".byte 0x0f,0x01,0xd9", X86_FEATURE_VMMCALL)
+#else
+/* On AMD processors, vmcall will generate a trap that we will
+ * then rewrite to the appropriate instruction.
  */
 #define KVM_HYPERCALL ".byte 0x0f,0x01,0xc1"
+#endif
 
 /* For KVM hypercalls, a three-byte sequence of either the vmrun or the vmmrun
  * instruction.  The hypervisor may replace it with something else but only the
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -469,6 +469,13 @@ static void __cpuinit early_init_amd(str
 			set_cpu_cap(c, X86_FEATURE_EXTD_APICID);
 	}
 #endif
+
+	/*
+	 * This is only needed to tell the kernel whether to use VMCALL
+	 * and VMMCALL.  VMMCALL is never executed except under virt, so
+	 * we can set it unconditionally.
+	 */
+	set_cpu_cap(c, X86_FEATURE_VMMCALL);
 }
 
 static void __cpuinit init_amd(struct cpuinfo_x86 *c)

