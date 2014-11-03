Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaKCUtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:49:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51887 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaKCUtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:49:06 -0500
Date: Mon, 3 Nov 2014 12:48:50 -0800
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-95c46b56922409ed8838b3b420b11cfebb8c6c88@git.kernel.org>
Cc: luto@amacapital.net, josh@joshtriplett.org, mingo@kernel.org,
        tglx@linutronix.de, hpa@zytor.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org
Reply-To: mingo@kernel.org, josh@joshtriplett.org, luto@amacapital.net,
        linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
        konrad.wilk@oracle.com
In-Reply-To: <9c448d5643d0fdb618f8cde9a54c21d2bcd486ce.1414618407.git.luto@amacapital.net>
References: <9c448d5643d0fdb618f8cde9a54c21d2bcd486ce.1414618407.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86_64, vsyscall:
  Rewrite comment and clean up headers in vsyscall code
Git-Commit-ID: 95c46b56922409ed8838b3b420b11cfebb8c6c88
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

Commit-ID:  95c46b56922409ed8838b3b420b11cfebb8c6c88
Gitweb:     http://git.kernel.org/tip/95c46b56922409ed8838b3b420b11cfebb8c6c88
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Wed, 29 Oct 2014 14:33:46 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 3 Nov 2014 21:44:57 +0100

x86_64, vsyscall: Rewrite comment and clean up headers in vsyscall code

vsyscall_64.c is just vsyscall emulation. Tidy it up accordingly.

[ tglx: Preserved the original copyright notices ]

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/r/9c448d5643d0fdb618f8cde9a54c21d2bcd486ce.1414618407.git.luto@amacapital.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/vsyscall_64.c | 50 ++++++++++++++++---------------------------
 1 file changed, 18 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 2d91262..7d9eb4b 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -1,52 +1,38 @@
 /*
+ * Copyright (c) 2012-2014 Andy Lutomirski <luto@amacapital.net>
+ *
+ * Based on the original implementation which is:
  *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
  *  Copyright 2003 Andi Kleen, SuSE Labs.
  *
- *  [ NOTE: this mechanism is now deprecated in favor of the vDSO. ]
+ *  Parts of the original code have been moved to arch/x86/vdso/vma.c
+ *
+ * This file implements vsyscall emulation.  vsyscalls are a legacy ABI:
+ * Userspace can request certain kernel services by calling fixed
+ * addresses.  This concept is problematic:
  *
- *  Thanks to hpa@transmeta.com for some useful hint.
- *  Special thanks to Ingo Molnar for his early experience with
- *  a different vsyscall implementation for Linux/IA32 and for the name.
+ * - It interferes with ASLR.
+ * - It's awkward to write code that lives in kernel addresses but is
+ *   callable by userspace at fixed addresses.
+ * - The whole concept is impossible for 32-bit compat userspace.
+ * - UML cannot easily virtualize a vsyscall.
  *
- *  vsyscall 1 is located at -10Mbyte, vsyscall 2 is located
- *  at virtual address -10Mbyte+1024bytes etc... There are at max 4
- *  vsyscalls. One vsyscall can reserve more than 1 slot to avoid
- *  jumping out of line if necessary. We cannot add more with this
- *  mechanism because older kernels won't return -ENOSYS.
+ * As of mid-2014, I believe that there is no new userspace code that
+ * will use a vsyscall if the vDSO is present.  I hope that there will
+ * soon be no new userspace code that will ever use a vsyscall.
  *
- *  Note: the concept clashes with user mode linux.  UML users should
- *  use the vDSO.
+ * The code in this file emulates vsyscalls when notified of a page
+ * fault to a vsyscall address.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/time.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/timer.h>
-#include <linux/seqlock.h>
-#include <linux/jiffies.h>
-#include <linux/sysctl.h>
-#include <linux/topology.h>
-#include <linux/timekeeper_internal.h>
-#include <linux/getcpu.h>
-#include <linux/cpu.h>
-#include <linux/smp.h>
-#include <linux/notifier.h>
 #include <linux/syscalls.h>
 #include <linux/ratelimit.h>
 
 #include <asm/vsyscall.h>
-#include <asm/pgtable.h>
-#include <asm/compat.h>
-#include <asm/page.h>
 #include <asm/unistd.h>
 #include <asm/fixmap.h>
-#include <asm/errno.h>
-#include <asm/io.h>
-#include <asm/segment.h>
-#include <asm/desc.h>
-#include <asm/topology.h>
 #include <asm/traps.h>
 
 #define CREATE_TRACE_POINTS
