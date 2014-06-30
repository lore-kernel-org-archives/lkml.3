Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbaF3Vx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:53:58 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:38837 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbaF3Vxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:53:52 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, hpa@zytor.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 07/10] x86_64,vsyscall: Rewrite comment and clean up headers in vsyscall code
Date: Mon, 30 Jun 2014 14:53:18 -0700
Message-Id: <5848c7134cacc507bb84d6d222d0dbf45e91052f.1404164803.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1404164803.git.luto@amacapital.net>
References: <cover.1404164803.git.luto@amacapital.net>
In-Reply-To: <cover.1404164803.git.luto@amacapital.net>
References: <cover.1404164803.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vsyscall_64.c is just vsyscall emulation.  Tidy it up accordingly.

If my comment editing offends anyone, let me know and I can fix it.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/vsyscall_64.c | 51 +++++++++++++++----------------------------
 1 file changed, 18 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 5029be3..1ea34e7 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -1,52 +1,37 @@
 /*
- *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
- *  Copyright 2003 Andi Kleen, SuSE Labs.
+ * Mostly copyright (c) 2012-2014 Andy Lutomirski <luto@amacapital.net>
  *
- *  [ NOTE: this mechanism is now deprecated in favor of the vDSO. ]
+ * This file implements vsyscall emulation.  vsyscalls are a legacy ABI:
+ * userspace can request certain kernel services by calling fixed
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
+ *
+ * The original version of this code is:
+ * Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
+ * Copyright 2003 Andi Kleen, SuSE Labs.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
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
-- 
1.9.3

