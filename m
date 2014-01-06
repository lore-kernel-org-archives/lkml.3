Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128AbaAFXYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:24:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882AbaAFWk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.10 058/129] powerpc: Fix bad stack check in exception entry
Date: Mon,  6 Jan 2014 14:38:07 -0800
Message-Id: <20140106223901.261137530@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/exception-64s.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -264,7 +264,7 @@ do_kvm_##n:								\
 	subi	r1,r1,INT_FRAME_SIZE;	/* alloc frame on kernel stack	*/ \
 	beq-	1f;							   \
 	ld	r1,PACAKSAVE(r13);	/* kernel stack to use		*/ \
-1:	cmpdi	cr1,r1,0;		/* check if r1 is in userspace	*/ \
+1:	cmpdi	cr1,r1,-INT_FRAME_SIZE;	/* check if r1 is in userspace	*/ \
 	blt+	cr1,3f;			/* abort if it is		*/ \
 	li	r1,(n);			/* will be reloaded later	*/ \
 	sth	r1,PACA_TRAP_SAVE(r13);					   \


