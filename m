Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaAMOqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:46:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51442 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaAMO0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 57/96] powerpc: Fix bad stack check in exception entry
Date: Mon, 13 Jan 2014 14:24:20 +0000
Message-Id: <1389623099-18783-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit 90ff5d688e61f49f23545ffab6228bd7e87e6dc7 upstream.

In EXCEPTION_PROLOG_COMMON() we check to see if the stack pointer (r1)
is valid when coming from the kernel.  If it's not valid, we die but
with a nice oops message.

Currently we allocate a stack frame (subtract INT_FRAME_SIZE) before we
check to see if the stack pointer is negative.  Unfortunately, this
won't detect a bad stack where r1 is less than INT_FRAME_SIZE.

This patch fixes the check to compare the modified r1 with
-INT_FRAME_SIZE.  With this, bad kernel stack pointers (including NULL
pointers) are correctly detected again.

Kudos to Paulus for finding this.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/include/asm/exception-64s.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/exception-64s.h b/arch/powerpc/include/asm/exception-64s.h
index 6afb13a..241d2f3 100644
--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -163,7 +163,7 @@ do_kvm_##n:								\
 	subi	r1,r1,INT_FRAME_SIZE;	/* alloc frame on kernel stack	*/ \
 	beq-	1f;							   \
 	ld	r1,PACAKSAVE(r13);	/* kernel stack to use		*/ \
-1:	cmpdi	cr1,r1,0;		/* check if r1 is in userspace	*/ \
+1:	cmpdi	cr1,r1,-INT_FRAME_SIZE;	/* check if r1 is in userspace	*/ \
 	blt+	cr1,3f;			/* abort if it is		*/ \
 	li	r1,(n);			/* will be reloaded later	*/ \
 	sth	r1,PACA_TRAP_SAVE(r13);					   \
-- 
1.8.3.2

