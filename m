Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3KUKc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 05:32:59 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:38456 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3KUKc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 05:32:58 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-kernel@vger.kernel.org>
CC: Francois Bedard <Francois.Bedard@synopsys.com>,
        Chen Gang <gang.chen.5i5j@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH] ARC: Add guard macro to uapi/asm/unistd.h
Date: Thu, 21 Nov 2013 15:59:38 +0530
Message-ID: <1385029778-26092-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen originally proposed this as "right thing to do" however I
actually ran into this when building perf tools. Some of the utils
include unistd.h as well as linux/unistd.h. Since -I includes kernel
headers too, we end up including the ARC unistd.h twice, leading to
redefinition nwarnings.

------------------>8-------------------
    CC bench/sched-pipe.o
In file included from ~/kernel/arch/arc/include/uapi/asm/unistd.h:21:0,
                 from ~/kernel/include/uapi/linux/unistd.h:7,
                 from bench/sched-pipe.c:24:
~/kernel/include/uapi/asm-generic/unistd.h:889:0: error: "__NR_fcntl64"
redefined [-Werror]
 #define __NR_fcntl64 __NR3264_fcntl
 ^
In file included from
~/gnu/arc-linux-uclibc/sys-include/sys/syscall.h:24:0,
                 from bench/../perf.h:112,
                 from bench/sched-pipe.c:13:
~/gnu/arc-linux-uclibc/include/bits/sysnum.h:761:0: note: this is the
location of the previous definition
------------------>8-------------------

Verified that make headers_install works fine with this.

Suggested-by: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: David Howells <dhowells@redhat.com>
---
I will be adding this to arc tree for 3.13
---
 arch/arc/include/uapi/asm/unistd.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arc/include/uapi/asm/unistd.h b/arch/arc/include/uapi/asm/unistd.h
index 6f30484f34b7..68125dd766c6 100644
--- a/arch/arc/include/uapi/asm/unistd.h
+++ b/arch/arc/include/uapi/asm/unistd.h
@@ -8,6 +8,9 @@
 
 /******** no-legacy-syscalls-ABI *******/
 
+#ifndef _UAPI_ASM_ARC_UNISTD_H
+#define _UAPI_ASM_ARC_UNISTD_H
+
 #define __ARCH_WANT_SYS_EXECVE
 #define __ARCH_WANT_SYS_CLONE
 #define __ARCH_WANT_SYS_VFORK
@@ -32,3 +35,5 @@ __SYSCALL(__NR_arc_gettls, sys_arc_gettls)
 /* Generic syscall (fs/filesystems.c - lost in asm-generic/unistd.h */
 #define __NR_sysfs		(__NR_arch_specific_syscall + 3)
 __SYSCALL(__NR_sysfs, sys_sysfs)
+
+#endif
-- 
1.8.1.2

