Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbaJCV4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:56:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313AbaJCVzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:55:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>
Subject: [PATCH 3.16 284/357] powerpc/perf: Fix ABIv2 kernel backtraces
Date: Fri,  3 Oct 2014 14:31:10 -0700
Message-Id: <20141003212942.019502601@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 85101af13bb854a6572fa540df7c7201958624b9 upstream.

ABIv2 kernels are failing to backtrace through the kernel. An example:

39.30%  readseek2_proce  [kernel.kallsyms]    [k] find_get_entry
            |
            --- find_get_entry
               __GI___libc_read

The problem is in valid_next_sp() where we check that the new stack
pointer is at least STACK_FRAME_OVERHEAD below the previous one.

ABIv1 has a minimum stack frame size of 112 bytes consisting of 48 bytes
and 64 bytes of parameter save area. ABIv2 changes that to 32 bytes
with no paramter save area.

STACK_FRAME_OVERHEAD is in theory the minimum stack frame size,
but we over 240 uses of it, some of which assume that it includes
space for the parameter area.

We need to work through all our stack defines and rationalise them
but let's fix perf now by creating STACK_FRAME_MIN_SIZE and using
in valid_next_sp(). This fixes the issue:

30.64%  readseek2_proce  [kernel.kallsyms]    [k] find_get_entry
            |
            --- find_get_entry
               pagecache_get_page
               generic_file_read_iter
               new_sync_read
               vfs_read
               sys_read
               syscall_exit
               __GI___libc_read

Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/ptrace.h |    7 +++++++
 arch/powerpc/perf/callchain.c     |    2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/ptrace.h
+++ b/arch/powerpc/include/asm/ptrace.h
@@ -47,6 +47,12 @@
 				 STACK_FRAME_OVERHEAD + KERNEL_REDZONE_SIZE)
 #define STACK_FRAME_MARKER	12
 
+#if defined(_CALL_ELF) && _CALL_ELF == 2
+#define STACK_FRAME_MIN_SIZE	32
+#else
+#define STACK_FRAME_MIN_SIZE	STACK_FRAME_OVERHEAD
+#endif
+
 /* Size of dummy stack frame allocated when calling signal handler. */
 #define __SIGNAL_FRAMESIZE	128
 #define __SIGNAL_FRAMESIZE32	64
@@ -60,6 +66,7 @@
 #define STACK_FRAME_REGS_MARKER	ASM_CONST(0x72656773)
 #define STACK_INT_FRAME_SIZE	(sizeof(struct pt_regs) + STACK_FRAME_OVERHEAD)
 #define STACK_FRAME_MARKER	2
+#define STACK_FRAME_MIN_SIZE	STACK_FRAME_OVERHEAD
 
 /* Size of stack frame allocated when calling signal handler. */
 #define __SIGNAL_FRAMESIZE	64
--- a/arch/powerpc/perf/callchain.c
+++ b/arch/powerpc/perf/callchain.c
@@ -35,7 +35,7 @@ static int valid_next_sp(unsigned long s
 		return 0;		/* must be 16-byte aligned */
 	if (!validate_sp(sp, current, STACK_FRAME_OVERHEAD))
 		return 0;
-	if (sp >= prev_sp + STACK_FRAME_OVERHEAD)
+	if (sp >= prev_sp + STACK_FRAME_MIN_SIZE)
 		return 1;
 	/*
 	 * sp could decrease when we jump off an interrupt stack


