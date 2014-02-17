Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbaBQP7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 10:59:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59097 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbaBQP7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 10:59:08 -0500
Date: Mon, 17 Feb 2014 07:58:45 -0800
From: "tip-bot for stefani@seibold.net" <tipbot@zytor.com>
Message-ID: <tip-f03c08a0c4ff1af34d7b4c5f714b32a23e36b2de@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stefani@seibold.net, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stefani@seibold.net, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1392631424-32205-11-git-send-email-stefani@seibold.net>
References: <1392631424-32205-11-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso:
  Do conditional fixmap of VVAR and HPET page
Git-Commit-ID: f03c08a0c4ff1af34d7b4c5f714b32a23e36b2de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 17 Feb 2014 07:58:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f03c08a0c4ff1af34d7b4c5f714b32a23e36b2de
Gitweb:     http://git.kernel.org/tip/f03c08a0c4ff1af34d7b4c5f714b32a23e36b2de
Author:     stefani@seibold.net <stefani@seibold.net>
AuthorDate: Mon, 17 Feb 2014 11:03:44 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 17 Feb 2014 07:54:59 -0800

x86, vdso: Do conditional fixmap of VVAR and HPET page

This patch adds conditional fixmap of the VVAR and HPET pages for the
32-bit kernel.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/1392631424-32205-11-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/vdso.h   | 6 ++++++
 arch/x86/kernel/hpet.c        | 5 +++++
 arch/x86/kernel/vsyscall_32.c | 5 +++++
 arch/x86/vdso/vdso32-setup.c  | 6 ------
 4 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index fe3cef9..6db8b23 100644
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
index 4b94c47..d4bf015 100644
--- a/arch/x86/kernel/vsyscall_32.c
+++ b/arch/x86/kernel/vsyscall_32.c
@@ -13,8 +13,13 @@
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
+
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 9b57770..6b74a46 100644
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
