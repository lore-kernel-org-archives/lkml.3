Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654AbaJDAYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:24:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbaJCVnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:43:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Burton <paul.burton@imgtec.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.16 193/357] MIPS: Fix MFC1 & MFHC1 emulation for 64-bit MIPS systems
Date: Fri,  3 Oct 2014 14:29:39 -0700
Message-Id: <20141003212939.272207482@linuxfoundation.org>
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

From: Paul Burton <paul.burton@imgtec.com>

commit c8c0da6bdf0f0d6f59fc23aab6ee373a131df82d upstream.

Commit bbd426f542cb "MIPS: Simplify FP context access" modified the
SIFROMREG & SIFROMHREG macros such that they return unsigned rather
than signed 32b integers. I had believed that to be fine, but
inadvertently missed the MFC1 & MFHC1 cases which write to a struct
pt_regs regs element. On MIPS32 this is fine, but on 64 bit those
saved regs' fields are 64 bit wide. Using unsigned values caused the
32 bit value from the FP register to be zero rather than sign extended
as the architecture specifies, causing incorrect emulation of the
MFC1 & MFHc1 instructions. Fix by reintroducing the casts to signed
integers, and therefore the sign extension.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/7848/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/math-emu/cp1emu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/mips/math-emu/cp1emu.c
+++ b/arch/mips/math-emu/cp1emu.c
@@ -650,9 +650,9 @@ static inline int cop1_64bit(struct pt_r
 #define SIFROMREG(si, x)						\
 do {									\
 	if (cop1_64bit(xcp))						\
-		(si) = get_fpr32(&ctx->fpr[x], 0);			\
+		(si) = (int)get_fpr32(&ctx->fpr[x], 0);			\
 	else								\
-		(si) = get_fpr32(&ctx->fpr[(x) & ~1], (x) & 1);		\
+		(si) = (int)get_fpr32(&ctx->fpr[(x) & ~1], (x) & 1);	\
 } while (0)
 
 #define SITOREG(si, x)							\
@@ -667,7 +667,7 @@ do {									\
 	}								\
 } while (0)
 
-#define SIFROMHREG(si, x)	((si) = get_fpr32(&ctx->fpr[x], 1))
+#define SIFROMHREG(si, x)	((si) = (int)get_fpr32(&ctx->fpr[x], 1))
 
 #define SITOHREG(si, x)							\
 do {									\


