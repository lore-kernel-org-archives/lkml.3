Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030231Ab3BANIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:08:01 -0500
Received: from mail.kernel.org ([198.145.19.201]:44333 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030200Ab3BANHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:07:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Martin <dave.martin@linaro.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [ 13/89] ARM: virt: Avoid bx instruction for compatibility with <=ARMv4
Date: Fri,  1 Feb 2013 14:07:28 +0100
Message-Id: <20130201130208.410154578@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Martin <dave.martin@linaro.org>

commit a4a12e008e292a81d312659529b71be2026ab355 upstream.

Non-T variants of ARMv4 do not support the bx instruction.

However, __hyp_stub_install is always called from the same
instruction set used to build the bulk of the kernel, so bx should
not be necessary.

This patch uses the traditional "mov pc" instead of bx.

Signed-off-by: Dave Martin <dave.martin@linaro.org>
[will: fixed up remaining bx instruction]
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/hyp-stub.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -99,7 +99,7 @@ ENTRY(__hyp_stub_install_secondary)
 	 * immediately.
 	 */
 	compare_cpu_mode_with_primary	r4, r5, r6, r7
-	bxne	lr
+	movne	pc, lr
 
 	/*
 	 * Once we have given up on one CPU, we do not try to install the
@@ -111,7 +111,7 @@ ENTRY(__hyp_stub_install_secondary)
 	 */
 
 	cmp	r4, #HYP_MODE
-	bxne	lr			@ give up if the CPU is not in HYP mode
+	movne	pc, lr			@ give up if the CPU is not in HYP mode
 
 /*
  * Configure HSCTLR to set correct exception endianness/instruction set
@@ -200,7 +200,7 @@ ENDPROC(__hyp_get_vectors)
 	@ fall through
 ENTRY(__hyp_set_vectors)
 	__HVC(0)
-	bx	lr
+	mov	pc, lr
 ENDPROC(__hyp_set_vectors)
 
 #ifndef ZIMAGE


