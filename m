Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbaB1ASi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 19:18:38 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:64888 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaB1ASf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 19:18:35 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Stefani Seibold <stefani@seibold.net>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 3/4] x86: Patch alternatives in the 32-bit vDSO
Date: Thu, 27 Feb 2014 16:18:14 -0800
Message-Id: <09bf3b51cae30d91b5e8fb05453c1d8d886d3839.1393545985.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <cover.1393545985.git.luto@amacapital.net>
References: <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com>
 <cover.1393545985.git.luto@amacapital.net>
In-Reply-To: <cover.1393545985.git.luto@amacapital.net>
References: <cover.1393545985.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rdtsc_barrier() needs this.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/vdso.h  |  2 ++
 arch/x86/vdso/vdso32-setup.c | 25 +++++++++++++------------
 arch/x86/vdso/vma.c          |  9 ++++++---
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 6db8b23..a844f90 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -40,4 +40,6 @@ extern const char vdso32_int80_start, vdso32_int80_end;
 extern const char vdso32_syscall_start, vdso32_syscall_end;
 extern const char vdso32_sysenter_start, vdso32_sysenter_end;
 
+void __init patch_vdso32(void *vdso, size_t len);
+
 #endif /* _ASM_X86_VDSO_H */
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 6b74a46..b37aa1d 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -273,29 +273,30 @@ static void map_compat_vdso(int map)
 
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
index 431e875..149caa1 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -28,8 +28,11 @@ static unsigned vdso_size;
 extern char vdsox32_start[], vdsox32_end[];
 extern struct page *vdsox32_pages[];
 static unsigned vdsox32_size;
+#endif
 
-static void __init patch_vdsox32(void *vdso, size_t len)
+#if defined(CONFIG_X86_32) || defined(CONFIG_X86_X32_ABI) || \
+	defined(CONFIG_COMPAT)
+void __init patch_vdso32(void *vdso, size_t len)
 {
 	Elf32_Ehdr *hdr = vdso;
 	Elf32_Shdr *sechdrs, *alt_sec = 0;
@@ -52,7 +55,7 @@ static void __init patch_vdsox32(void *vdso, size_t len)
 	}
 
 	/* If we get here, it's probably a bug. */
-	pr_warning("patch_vdsox32: .altinstructions not found\n");
+	pr_warning("patch_vdso32: .altinstructions not found\n");
 	return;  /* nothing to patch */
 
 found:
@@ -104,7 +107,7 @@ static int __init init_vdso(void)
 		vdso_pages[i] = virt_to_page(vdso_start + i*PAGE_SIZE);
 
 #ifdef CONFIG_X86_X32_ABI
-	patch_vdsox32(vdsox32_start, vdsox32_end - vdsox32_start);
+	patch_vdso32(vdsox32_start, vdsox32_end - vdsox32_start);
 	npages = (vdsox32_end - vdsox32_start + PAGE_SIZE - 1) / PAGE_SIZE;
 	vdsox32_size = npages << PAGE_SHIFT;
 	for (i = 0; i < npages; i++)
-- 
1.8.5.3

