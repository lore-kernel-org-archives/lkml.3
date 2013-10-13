Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab3JMMCN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 08:02:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43724 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab3JMMCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 08:02:09 -0400
Date: Sun, 13 Oct 2013 05:01:57 -0700
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-f32360ef6608434a032dc7ad262d45e9693c27f3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1381450698-28710-6-git-send-email-keescook@chromium.org>
References: <1381450698-28710-6-git-send-email-keescook@chromium.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kaslr] x86, kaslr: Report kernel offset on panic
Git-Commit-ID: f32360ef6608434a032dc7ad262d45e9693c27f3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 13 Oct 2013 05:02:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f32360ef6608434a032dc7ad262d45e9693c27f3
Gitweb:     http://git.kernel.org/tip/f32360ef6608434a032dc7ad262d45e9693c27f3
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Thu, 10 Oct 2013 17:18:17 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 13 Oct 2013 03:12:24 -0700

x86, kaslr: Report kernel offset on panic

When the system panics, include the kernel offset in the report to assist
in debugging.

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/1381450698-28710-6-git-send-email-keescook@chromium.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/setup.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f0de629..1708862 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -824,6 +824,20 @@ static void __init trim_low_memory_range(void)
 }
 	
 /*
+ * Dump out kernel offset information on panic.
+ */
+static int
+dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
+{
+	pr_emerg("Kernel Offset: 0x%lx from 0x%lx "
+		 "(relocation range: 0x%lx-0x%lx)\n",
+		 (unsigned long)&_text - __START_KERNEL, __START_KERNEL,
+		 __START_KERNEL_map, MODULES_VADDR-1);
+
+	return 0;
+}
+
+/*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
  * for initialization.  Note, the efi init code path is determined by the
@@ -1242,3 +1256,15 @@ void __init i386_reserve_resources(void)
 }
 
 #endif /* CONFIG_X86_32 */
+
+static struct notifier_block kernel_offset_notifier = {
+	.notifier_call = dump_kernel_offset
+};
+
+static int __init register_kernel_offset_dumper(void)
+{
+	atomic_notifier_chain_register(&panic_notifier_list,
+					&kernel_offset_notifier);
+	return 0;
+}
+__initcall(register_kernel_offset_dumper);
