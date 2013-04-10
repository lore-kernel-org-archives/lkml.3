Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937086Ab3DJXNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:13:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937184Ab3DJWrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Daney <david.daney@cavium.com>, Al Cooper <alcooperx@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        viric@viric.name
Subject: [ 27/64] MIPS: Unbreak function tracer for 64-bit kernel.
Date: Wed, 10 Apr 2013 15:46:24 -0700
Message-Id: <20130410224339.394444541@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Daney <david.daney@cavium.com>

commit ad8c396936e328f5344e1881afde9e28d5f2045f upstream.

Commit 58b69401c797 [MIPS: Function tracer: Fix broken function tracing]
completely broke the function tracer for 64-bit kernels.  The symptom is
a system hang very early in the boot process.

The fix: Remove/fix $sp adjustments for 64-bit case.

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: linux-mips@linux-mips.org
Cc: Al Cooper <alcooperx@gmail.com>
Cc: viric@viric.name
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/mcount.S |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/mips/kernel/mcount.S
+++ b/arch/mips/kernel/mcount.S
@@ -46,10 +46,9 @@
 	PTR_L	a5, PT_R9(sp)
 	PTR_L	a6, PT_R10(sp)
 	PTR_L	a7, PT_R11(sp)
-#else
-	PTR_ADDIU	sp, PT_SIZE
 #endif
-.endm
+	PTR_ADDIU	sp, PT_SIZE
+	.endm
 
 	.macro RETURN_BACK
 	jr ra
@@ -68,7 +67,11 @@ NESTED(ftrace_caller, PT_SIZE, ra)
 	.globl _mcount
 _mcount:
 	b	ftrace_stub
-	addiu sp,sp,8
+#ifdef CONFIG_32BIT
+	 addiu sp,sp,8
+#else
+	 nop
+#endif
 
 	/* When tracing is activated, it calls ftrace_caller+8 (aka here) */
 	lw	t1, function_trace_stop


