Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbaCCVNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 16:13:25 -0500
Received: from www84.your-server.de ([213.133.104.84]:42175 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092AbaCCVNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 16:13:22 -0500
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [Patch v22 08/12] x86: Patch alternatives in the 32-bit vDSO
Date: Mon,  3 Mar 2014 22:12:19 +0100
Message-Id: <1393881143-3569-9-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393881143-3569-1-git-send-email-stefani@seibold.net>
References: <1393881143-3569-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

rdtsc_barrier() needs this.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/include/asm/vdso.h  |  2 ++
 arch/x86/vdso/Makefile       |  3 ++-
 arch/x86/vdso/vdso32-setup.c | 25 +++++++++++++------------
 arch/x86/vdso/vma.c          | 13 ++++++++++---
 4 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index fddb53d..6e39eb8 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -31,4 +31,6 @@ extern const char vdso32_int80_start, vdso32_int80_end;
 extern const char vdso32_syscall_start, vdso32_syscall_end;
 extern const char vdso32_sysenter_start, vdso32_sysenter_end;
 
+void __init patch_vdso32(void *vdso, size_t len);
+
 #endif /* _ASM_X86_VDSO_H */
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index fd14be1..7a3d13e 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -21,7 +21,8 @@ vobjs-$(VDSOX32-y) += $(vobjx32s-compat)
 vobj64s := $(filter-out $(vobjx32s-compat),$(vobjs-y))
 
 # files to link into kernel
-obj-$(VDSO64-y)			+= vma.o vdso.o
+obj-y				+= vma.o
+obj-$(VDSO64-y)			+= vdso.o
 obj-$(VDSOX32-y)		+= vdsox32.o
 obj-$(VDSO32-y)			+= vdso32.o vdso32-setup.o
 
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index d6bfb87..bca2ffd 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -276,29 +276,30 @@ static void map_compat_vdso(int map)
 
 int __init sysenter_setup(void)
 {
-	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
-	const void *vsyscall;
-	size_t vsyscall_len;
+	void *vdso_page = (void *)get_zeroed_page(GFP_ATOMIC);
+	const void *vdso;
+	size_t vdso_len;
 
-	vdso32_pages[0] = virt_to_page(syscall_page);
+	vdso32_pages[0] = virt_to_page(vdso_page);
 
 #ifdef CONFIG_X86_32
 	gate_vma_init();
 #endif
 
 	if (vdso32_syscall()) {
-		vsyscall = &vdso32_syscall_start;
-		vsyscall_len = &vdso32_syscall_end - &vdso32_syscall_start;
+		vdso = &vdso32_syscall_start;
+		vdso_len = &vdso32_syscall_end - &vdso32_syscall_start;
 	} else if (vdso32_sysenter()){
-		vsyscall = &vdso32_sysenter_start;
-		vsyscall_len = &vdso32_sysenter_end - &vdso32_sysenter_start;
+		vdso = &vdso32_sysenter_start;
+		vdso_len = &vdso32_sysenter_end - &vdso32_sysenter_start;
 	} else {
-		vsyscall = &vdso32_int80_start;
-		vsyscall_len = &vdso32_int80_end - &vdso32_int80_start;
+		vdso = &vdso32_int80_start;
+		vdso_len = &vdso32_int80_end - &vdso32_int80_start;
 	}
 
-	memcpy(syscall_page, vsyscall, vsyscall_len);
-	relocate_vdso(syscall_page);
+	memcpy(vdso_page, vdso, vdso_len);
+	patch_vdso32(vdso_page, vdso_len);
+	relocate_vdso(vdso_page);
 
 	return 0;
 }
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 431e875..7345bc9 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -16,6 +16,7 @@
 #include <asm/vdso.h>
 #include <asm/page.h>
 
+#if defined(CONFIG_X86_64)
 unsigned int __read_mostly vdso_enabled = 1;
 
 extern char vdso_start[], vdso_end[];
@@ -28,8 +29,12 @@ static unsigned vdso_size;
 extern char vdsox32_start[], vdsox32_end[];
 extern struct page *vdsox32_pages[];
 static unsigned vdsox32_size;
+#endif
+#endif
 
-static void __init patch_vdsox32(void *vdso, size_t len)
+#if defined(CONFIG_X86_32) || defined(CONFIG_X86_X32_ABI) || \
+	defined(CONFIG_COMPAT)
+void __init patch_vdso32(void *vdso, size_t len)
 {
 	Elf32_Ehdr *hdr = vdso;
 	Elf32_Shdr *sechdrs, *alt_sec = 0;
@@ -52,7 +57,7 @@ static void __init patch_vdsox32(void *vdso, size_t len)
 	}
 
 	/* If we get here, it's probably a bug. */
-	pr_warning("patch_vdsox32: .altinstructions not found\n");
+	pr_warning("patch_vdso32: .altinstructions not found\n");
 	return;  /* nothing to patch */
 
 found:
@@ -61,6 +66,7 @@ found:
 }
 #endif
 
+#if defined(CONFIG_X86_64)
 static void __init patch_vdso64(void *vdso, size_t len)
 {
 	Elf64_Ehdr *hdr = vdso;
@@ -104,7 +110,7 @@ static int __init init_vdso(void)
 		vdso_pages[i] = virt_to_page(vdso_start + i*PAGE_SIZE);
 
 #ifdef CONFIG_X86_X32_ABI
-	patch_vdsox32(vdsox32_start, vdsox32_end - vdsox32_start);
+	patch_vdso32(vdsox32_start, vdsox32_end - vdsox32_start);
 	npages = (vdsox32_end - vdsox32_start + PAGE_SIZE - 1) / PAGE_SIZE;
 	vdsox32_size = npages << PAGE_SHIFT;
 	for (i = 0; i < npages; i++)
@@ -204,3 +210,4 @@ static __init int vdso_setup(char *s)
 	return 0;
 }
 __setup("vdso=", vdso_setup);
+#endif
-- 
1.9.0

