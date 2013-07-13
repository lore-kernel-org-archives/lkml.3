Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab3GMDWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 23:22:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43953 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969Ab3GMDWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 23:22:01 -0400
Date: Fri, 12 Jul 2013 20:21:39 -0700
From: tip-bot for Kees Cook <tipbot@zytor.com>
Message-ID: <tip-c0b3450f101523a49823fa93d155f1d258e5ac6f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, pageexec@gmail.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, pageexec@gmail.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20130712225017.GA5366@www.outflux.net>
References: <20130712225017.GA5366@www.outflux.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Make sure IDT is page aligned
Git-Commit-ID: c0b3450f101523a49823fa93d155f1d258e5ac6f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 20:21:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0b3450f101523a49823fa93d155f1d258e5ac6f
Gitweb:     http://git.kernel.org/tip/c0b3450f101523a49823fa93d155f1d258e5ac6f
Author:     Kees Cook <keescook@chromium.org>
AuthorDate: Fri, 12 Jul 2013 15:50:17 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 12 Jul 2013 16:14:08 -0700

x86: Make sure IDT is page aligned

Since the IDT is referenced from a fixmap, make sure it is page aligned.
Merge with 32-bit one, since it was already aligned to deal with F00F bug.
This avoids the risk of it ever being moved in the bss and having the
mapping be offset, resulting in calling incorrect handlers.

[ hpa: It isn't clear that this is a manifest bug in any way, but
  tagging for -stable because it shouldn't hurt and might avoid some
  very hard-to-debug breakages due to unrelated changes. ]

Signed-off-by: Kees Cook <keescook@chromium.org>
Link: http://lkml.kernel.org/r/20130712225017.GA5366@www.outflux.net
Reported-by: PaX Team <pageexec@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head_64.S | 4 ----
 arch/x86/kernel/traps.c   | 7 ++-----
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 5e4d8a8..317b8cc 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -514,10 +514,6 @@ ENTRY(phys_base)
 	
 	.section .bss, "aw", @nobits
 	.align L1_CACHE_BYTES
-ENTRY(idt_table)
-	.skip IDT_ENTRIES * 16
-
-	.align L1_CACHE_BYTES
 ENTRY(debug_idt_table)
 	.skip IDT_ENTRIES * 16
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b0865e8..0952614 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -68,13 +68,10 @@
 #include <asm/setup.h>
 
 asmlinkage int system_call(void);
+#endif
 
-/*
- * The IDT has to be page-aligned to simplify the Pentium
- * F0 0F bug workaround.
- */
+/* The IDT has to be page-aligned to keep it aligned with its fixmap. */
 gate_desc idt_table[NR_VECTORS] __page_aligned_data = { { { { 0, 0 } } }, };
-#endif
 
 DECLARE_BITMAP(used_vectors, NR_VECTORS);
 EXPORT_SYMBOL_GPL(used_vectors);
