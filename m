Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaKFXLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:11:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58738 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaKFWl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:27 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 038/162] sparc64: Fix FPU register corruption with AES crypto offload.
Date: Thu,  6 Nov 2014 14:35:02 -0800
Message-Id: <1415313426-9622-39-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit f4da3628dc7c32a59d1fb7116bb042e6f436d611 ]

The AES loops in arch/sparc/crypto/aes_glue.c use a scheme where the
key material is preloaded into the FPU registers, and then we loop
over and over doing the crypt operation, reusing those pre-cooked key
registers.

There are intervening blkcipher*() calls between the crypt operation
calls.  And those might perform memcpy() and thus also try to use the
FPU.

The sparc64 kernel FPU usage mechanism is designed to allow such
recursive uses, but with a catch.

There has to be a trap between the two FPU using threads of control.

The mechanism works by, when the FPU is already in use by the kernel,
allocating a slot for FPU saving at trap time.  Then if, within the
trap handler, we try to use the FPU registers, the pre-trap FPU
register state is saved into the slot.  Then at trap return time we
notice this and restore the pre-trap FPU state.

Over the long term there are various more involved ways we can make
this work, but for a quick fix let's take advantage of the fact that
the situation where this happens is very limited.

All sparc64 chips that support the crypto instructiosn also are using
the Niagara4 memcpy routine, and that routine only uses the FPU for
large copies where we can't get the source aligned properly to a
multiple of 8 bytes.

We look to see if the FPU is already in use in this context, and if so
we use the non-large copy path which only uses integer registers.

Furthermore, we also limit this special logic to when we are doing
kernel copy, rather than a user copy.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/include/asm/visasm.h |  8 ++++++++
 arch/sparc/lib/NG4memcpy.S      | 14 +++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/sparc/include/asm/visasm.h b/arch/sparc/include/asm/visasm.h
index 39ca301..11fdf0e 100644
--- a/arch/sparc/include/asm/visasm.h
+++ b/arch/sparc/include/asm/visasm.h
@@ -39,6 +39,14 @@
 297:	wr		%o5, FPRS_FEF, %fprs;		\
 298:
 
+#define VISEntryHalfFast(fail_label)			\
+	rd		%fprs, %o5;			\
+	andcc		%o5, FPRS_FEF, %g0;		\
+	be,pt		%icc, 297f;			\
+	 nop;						\
+	ba,a,pt		%xcc, fail_label;		\
+297:	wr		%o5, FPRS_FEF, %fprs;
+
 #define VISExitHalf					\
 	wr		%o5, 0, %fprs;
 
diff --git a/arch/sparc/lib/NG4memcpy.S b/arch/sparc/lib/NG4memcpy.S
index 9cf2ee0..140527a 100644
--- a/arch/sparc/lib/NG4memcpy.S
+++ b/arch/sparc/lib/NG4memcpy.S
@@ -41,6 +41,10 @@
 #endif
 #endif
 
+#if !defined(EX_LD) && !defined(EX_ST)
+#define NON_USER_COPY
+#endif
+
 #ifndef EX_LD
 #define EX_LD(x)	x
 #endif
@@ -197,9 +201,13 @@ FUNC_NAME:	/* %o0=dst, %o1=src, %o2=len */
 	 mov		EX_RETVAL(%o3), %o0
 
 .Llarge_src_unaligned:
+#ifdef NON_USER_COPY
+	VISEntryHalfFast(.Lmedium_vis_entry_fail)
+#else
+	VISEntryHalf
+#endif
 	andn		%o2, 0x3f, %o4
 	sub		%o2, %o4, %o2
-	VISEntryHalf
 	alignaddr	%o1, %g0, %g1
 	add		%o1, %o4, %o1
 	EX_LD(LOAD(ldd, %g1 + 0x00, %f0))
@@ -240,6 +248,10 @@ FUNC_NAME:	/* %o0=dst, %o1=src, %o2=len */
 	 nop
 	ba,a,pt		%icc, .Lmedium_unaligned
 
+#ifdef NON_USER_COPY
+.Lmedium_vis_entry_fail:
+	 or		%o0, %o1, %g2
+#endif
 .Lmedium:
 	LOAD(prefetch, %o1 + 0x40, #n_reads_strong)
 	andcc		%g2, 0x7, %g0
-- 
1.9.1

