Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab3HFVnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:43:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43473 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab3HFVnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:43:04 -0400
Date: Tue, 6 Aug 2013 14:42:44 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-1599e8fc84dd9c2954df0d4b2db52f7f6719f339@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        richard@nod.at, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, richard@nod.at, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1375740170-7446-2-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-2-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86: Fix sys_call_table type in asm/
 syscall.h
Git-Commit-ID: 1599e8fc84dd9c2954df0d4b2db52f7f6719f339
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 06 Aug 2013 14:42:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1599e8fc84dd9c2954df0d4b2db52f7f6719f339
Gitweb:     http://git.kernel.org/tip/1599e8fc84dd9c2954df0d4b2db52f7f6719f339
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 5 Aug 2013 15:02:35 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 6 Aug 2013 14:18:08 -0700

x86: Fix sys_call_table type in asm/syscall.h

Make the sys_call_table type defined in asm/syscall.h match
the definition in syscall_64.c

v2: include asm/syscall.h in syscall_64.c too. I left uml alone
because it doesn't have an syscall.h on its own and including
the native one leads to other errors.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1375740170-7446-2-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Richard Weinberger <richard@nod.at>
---
 arch/x86/include/asm/syscall.h | 3 ++-
 arch/x86/kernel/syscall_64.c   | 3 +--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index 2e188d6..aea284b 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -20,7 +20,8 @@
 #include <asm/thread_info.h>	/* for TS_COMPAT */
 #include <asm/unistd.h>
 
-extern const unsigned long sys_call_table[];
+typedef void (*sys_call_ptr_t)(void);
+extern const sys_call_ptr_t sys_call_table[];
 
 /*
  * Only the low 32 bits of orig_ax are meaningful, so we return int.
diff --git a/arch/x86/kernel/syscall_64.c b/arch/x86/kernel/syscall_64.c
index 5c7f8c2..ec008f5 100644
--- a/arch/x86/kernel/syscall_64.c
+++ b/arch/x86/kernel/syscall_64.c
@@ -4,6 +4,7 @@
 #include <linux/sys.h>
 #include <linux/cache.h>
 #include <asm/asm-offsets.h>
+#include <asm/syscall.h>
 
 #define __SYSCALL_COMMON(nr, sym, compat) __SYSCALL_64(nr, sym, compat)
 
@@ -19,8 +20,6 @@
 
 #define __SYSCALL_64(nr, sym, compat) [nr] = sym,
 
-typedef void (*sys_call_ptr_t)(void);
-
 extern void sys_ni_syscall(void);
 
 const sys_call_ptr_t sys_call_table[__NR_syscall_max+1] = {
