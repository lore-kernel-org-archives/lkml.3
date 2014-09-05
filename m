Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbaIEOKF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:10:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932655AbaIEOKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:10:02 -0400
From: Baoquan He <bhe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: ak@linux.intel.com, mingo@redhat.com, whissi@whissi.de, dyoung@redhat.com,
        tglx@linutronix.de, vgoyal@redhat.com, keescook@chromium.org,
        chaowang@redhat.com, Baoquan He <bhe@redhat.com>
Subject: [PATCH 1/4] kaslr: check user's config too when handle relocations
Date: Fri,  5 Sep 2014 22:08:14 +0800
Message-Id: <1409926097-2101-2-git-send-email-bhe@redhat.com>
In-Reply-To: <1409926097-2101-1-git-send-email-bhe@redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kaslr's action is splitted into 2 parts. The 1st is getting available memory
slots and randomly choose the kernel relocation address. After decompression
of kernel to the chosen place, the 2nd part begin to check if kaslr has got
a relocation address, and will do the relocations handling if yes.

However in current implementation, in the 2nd part, it doesn't check user's
config, just compare decompression output address and the LOAD_PHYSICAL_ADDR
where kernel was compiled to run. If they are equal, it means a kaslr is
taking action, and need do the relocation handling. This truly works when
bootloader always load kernel to LOAD_PHYSICAL_ADDR. But this doesn't always
happens. Kexec/kdump kernel loading is exceptional. Kdump/kexec can load
kernel anywhere, this is not fixed. So in this case, it will do the relocation
handling though user clearly set nokaslr in cmdline. This is not correct.

So in this patch, check user's config too in the 2nd part, namely in
handle_relocations().

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 arch/x86/boot/compressed/aslr.c |  2 ++
 arch/x86/boot/compressed/misc.c | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index fc6091a..975b07b 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -292,11 +292,13 @@ unsigned char *choose_kernel_location(unsigned char *input,
 #ifdef CONFIG_HIBERNATION
 	if (!cmdline_find_option_bool("kaslr")) {
 		debug_putstr("KASLR disabled by default...\n");
+		debug_putstr("No need to choose kernel relocation...\n");
 		goto out;
 	}
 #else
 	if (cmdline_find_option_bool("nokaslr")) {
 		debug_putstr("KASLR disabled by cmdline...\n");
+		debug_putstr("No need to choose kernel relocation...\n");
 		goto out;
 	}
 #endif
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 57ab74d..7780a5b 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -238,6 +238,18 @@ static void handle_relocations(void *output, unsigned long output_len)
 	unsigned long min_addr = (unsigned long)output;
 	unsigned long max_addr = min_addr + output_len;
 
+#ifdef CONFIG_HIBERNATION
+	if (!cmdline_find_option_bool("kaslr")) {
+		debug_putstr("No relocation needed... ");
+		return;
+	}
+#else
+	if (cmdline_find_option_bool("nokaslr")) {
+		debug_putstr("No relocation needed... ");
+		return;
+	}
+#endif
+
 	/*
 	 * Calculate the delta between where vmlinux was linked to load
 	 * and where it was actually loaded.
-- 
1.8.5.3

