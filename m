Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbaJCVlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:41:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbaJCVfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:35:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 3.16 103/357] xtensa: fix access to THREAD_RA/THREAD_SP/THREAD_DS
Date: Fri,  3 Oct 2014 14:28:09 -0700
Message-Id: <20141003212936.569604387@linuxfoundation.org>
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

From: Max Filippov <jcmvbkbc@gmail.com>

commit 52247123749cc3cbc30168b33ad8c69515c96d23 upstream.

With SMP and a lot of debug options enabled task_struct::thread gets out
of reach of s32i/l32i instructions with base pointing at task_struct,
breaking build with the following messages:

  arch/xtensa/kernel/entry.S: Assembler messages:
  arch/xtensa/kernel/entry.S:1002: Error: operand 3 of 'l32i.n' has invalid value '1048'
  arch/xtensa/kernel/entry.S:1831: Error: operand 3 of 's32i.n' has invalid value '1040'
  arch/xtensa/kernel/entry.S:1832: Error: operand 3 of 's32i.n' has invalid value '1044'

Change base to point to task_struct::thread in such cases.
Don't use a10 in _switch_to to save/restore prev pointer as a2 is not
clobbered.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/include/asm/uaccess.h |    5 +++++
 arch/xtensa/kernel/entry.S        |   12 ++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/arch/xtensa/include/asm/uaccess.h
+++ b/arch/xtensa/include/asm/uaccess.h
@@ -52,7 +52,12 @@
  */
 	.macro	get_fs	ad, sp
 	GET_CURRENT(\ad,\sp)
+#if THREAD_CURRENT_DS > 1020
+	addi	\ad, \ad, TASK_THREAD
+	l32i	\ad, \ad, THREAD_CURRENT_DS - TASK_THREAD
+#else
 	l32i	\ad, \ad, THREAD_CURRENT_DS
+#endif
 	.endm
 
 /*
--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -1820,7 +1820,6 @@ ENTRY(_switch_to)
 
 	entry	a1, 16
 
-	mov	a10, a2			# preserve 'prev' (a2)
 	mov	a11, a3			# and 'next' (a3)
 
 	l32i	a4, a2, TASK_THREAD_INFO
@@ -1828,8 +1827,14 @@ ENTRY(_switch_to)
 
 	save_xtregs_user a4 a6 a8 a9 a12 a13 THREAD_XTREGS_USER
 
-	s32i	a0, a10, THREAD_RA	# save return address
-	s32i	a1, a10, THREAD_SP	# save stack pointer
+#if THREAD_RA > 1020 || THREAD_SP > 1020
+	addi	a10, a2, TASK_THREAD
+	s32i	a0, a10, THREAD_RA - TASK_THREAD	# save return address
+	s32i	a1, a10, THREAD_SP - TASK_THREAD	# save stack pointer
+#else
+	s32i	a0, a2, THREAD_RA	# save return address
+	s32i	a1, a2, THREAD_SP	# save stack pointer
+#endif
 
 	/* Disable ints while we manipulate the stack pointer. */
 
@@ -1870,7 +1875,6 @@ ENTRY(_switch_to)
 	load_xtregs_user a5 a6 a8 a9 a12 a13 THREAD_XTREGS_USER
 
 	wsr	a14, ps
-	mov	a2, a10			# return 'prev'
 	rsync
 
 	retw


