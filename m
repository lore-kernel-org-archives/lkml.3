Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbaCEWcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 17:32:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37631 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaCEWcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 17:32:47 -0500
Date: Wed, 5 Mar 2014 14:32:26 -0800
From: "tip-bot for stefani@seibold.net" <tipbot@zytor.com>
Message-ID: <tip-8535b99d22f319672fa22da4df557ba32a58d04f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1393881143-3569-12-git-send-email-stefani@seibold.net>
References: <1393881143-3569-12-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso:
  Do conditional fixmap of VVAR and HPET page
Git-Commit-ID: 8535b99d22f319672fa22da4df557ba32a58d04f
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

Commit-ID:  8535b99d22f319672fa22da4df557ba32a58d04f
Gitweb:     http://git.kernel.org/tip/8535b99d22f319672fa22da4df557ba32a58d04f
Author:     stefani@seibold.net <stefani@seibold.net>
AuthorDate: Mon, 3 Mar 2014 22:12:22 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 5 Mar 2014 14:02:39 -0800

x86, vdso: Do conditional fixmap of VVAR and HPET page

This patch adds conditional fixmap of the VVAR and HPET pages for a 32
bit kernel

Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/1393881143-3569-12-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/vdso.h   | 6 ++++++
 arch/x86/kernel/hpet.c        | 5 +++++
 arch/x86/kernel/vsyscall_32.c | 4 ++++
 arch/x86/vdso/vdso32-setup.c  | 6 ------
 4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 0f363c1..a844f90 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -1,6 +1,12 @@
 #ifndef _ASM_X86_VDSO_H
 #define _ASM_X86_VDSO_H
 
+enum {
+	VDSO_DISABLED = 0,
+	VDSO_ENABLED = 1,
+	VDSO_COMPAT = 2,
+};
+
 #if defined CONFIG_X86_32 || defined CONFIG_COMPAT
 
 #include <asm/vdso32.h>
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 54263f0..b99544b 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -15,6 +15,7 @@
 #include <asm/fixmap.h>
 #include <asm/hpet.h>
 #include <asm/time.h>
+#include <asm/elf.h>
 
 #define HPET_MASK			CLOCKSOURCE_MASK(32)
 
@@ -74,6 +75,10 @@ static inline void hpet_writel(unsigned int d, unsigned int a)
 static inline void hpet_set_mapping(void)
 {
 	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
+#ifdef CONFIG_X86_32
+	if (vdso_enabled != VDSO_COMPAT)
+		return;
+#endif
 	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VVAR_NOCACHE);
 }
 
diff --git a/arch/x86/kernel/vsyscall_32.c b/arch/x86/kernel/vsyscall_32.c
index 4b94c47..0cbf94b 100644
--- a/arch/x86/kernel/vsyscall_32.c
+++ b/arch/x86/kernel/vsyscall_32.c
@@ -13,8 +13,12 @@
 #include <asm/vsyscall.h>
 #include <asm/pgtable.h>
 #include <asm/fixmap.h>
+#include <asm/elf.h>
 
 void __init map_vsyscall(void)
 {
+	if (vdso_enabled != VDSO_COMPAT)
+		return;
+
 	__set_fixmap(VVAR_PAGE, __pa_symbol(&__vvar_page), PAGE_KERNEL_VVAR);
 }
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 54db7e4..b37aa1d 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -29,12 +29,6 @@
 #include <asm/hpet.h>
 #include <asm/vvar.h>
 
-enum {
-	VDSO_DISABLED = 0,
-	VDSO_ENABLED = 1,
-	VDSO_COMPAT = 2,
-};
-
 #ifdef CONFIG_COMPAT_VDSO
 #define VDSO_DEFAULT	VDSO_COMPAT
 #else
