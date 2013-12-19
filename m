Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab3LSLNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:13:50 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:45154 "EHLO
	smtp-relay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3LSLNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:13:48 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        Francois Bedard <Francois.Bedard@synopsys.com>,
        David Howells <dhowells@redhat.com>,
        "Chen Gang" <gang.chen.5i5j@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH] Revert "ARC: Add guard macro to uapi/asm/unistd.h"
Date: Thu, 19 Dec 2013 16:43:18 +0530
Message-ID: <1387451598-14490-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.95]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 97bc386fc12deeb41d5bff33548e3002b258d4e0.

Generic syscall table generator relies on ARCH unistd.h as follows:

	void *sys_call_table[NR_syscalls] = {
		[0 ... NR_syscalls-1] = sys_ni_syscall,
	#include <asm/unistd.h>
	};

And turns out that prior dependencies already include that header by
the time preprocessor hits the above. Meaning ARCH unistd.h needs to be
able to included twice.

This however means that perf cross comilation warning will re-appear
which needs to be discussed with perf folks (why they need to include
both libc variant as well as kernel internal header directly).

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/uapi/asm/unistd.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arc/include/uapi/asm/unistd.h b/arch/arc/include/uapi/asm/unistd.h
index 68125dd766c6..6f30484f34b7 100644
--- a/arch/arc/include/uapi/asm/unistd.h
+++ b/arch/arc/include/uapi/asm/unistd.h
@@ -8,9 +8,6 @@
 
 /******** no-legacy-syscalls-ABI *******/
 
-#ifndef _UAPI_ASM_ARC_UNISTD_H
-#define _UAPI_ASM_ARC_UNISTD_H
-
 #define __ARCH_WANT_SYS_EXECVE
 #define __ARCH_WANT_SYS_CLONE
 #define __ARCH_WANT_SYS_VFORK
@@ -35,5 +32,3 @@ __SYSCALL(__NR_arc_gettls, sys_arc_gettls)
 /* Generic syscall (fs/filesystems.c - lost in asm-generic/unistd.h */
 #define __NR_sysfs		(__NR_arch_specific_syscall + 3)
 __SYSCALL(__NR_sysfs, sys_sysfs)
-
-#endif
-- 
1.8.1.2

