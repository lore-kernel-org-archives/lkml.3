Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbaJCW43 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:56:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594AbaJCWYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 3.10 038/143] xtensa: fix a6 and a7 handling in fast_syscall_xtensa
Date: Fri,  3 Oct 2014 14:33:53 -0700
Message-Id: <20141003213315.631003331@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit d1b6ba82a50cecf94be540a3a153aa89d97511a0 upstream.

Remove restoring a6 on some return paths and instead modify and restore
it in a single place, using symbolic name.
Correctly restore a7 from PT_AREG7 in case of illegal a6 value.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/kernel/entry.S |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -1121,9 +1121,8 @@ ENTRY(fast_syscall_xtensa)
 	movi	a7, 4			# sizeof(unsigned int)
 	access_ok a3, a7, a0, a2, .Leac	# a0: scratch reg, a2: sp
 
-	addi	a6, a6, -1		# assuming SYS_XTENSA_ATOMIC_SET = 1
-	_bgeui	a6, SYS_XTENSA_COUNT - 1, .Lill
-	_bnei	a6, SYS_XTENSA_ATOMIC_CMP_SWP - 1, .Lnswp
+	_bgeui	a6, SYS_XTENSA_COUNT, .Lill
+	_bnei	a6, SYS_XTENSA_ATOMIC_CMP_SWP, .Lnswp
 
 	/* Fall through for ATOMIC_CMP_SWP. */
 
@@ -1135,27 +1134,26 @@ TRY	s32i	a5, a3, 0		# different, modify
 	l32i	a7, a2, PT_AREG7	# restore a7
 	l32i	a0, a2, PT_AREG0	# restore a0
 	movi	a2, 1			# and return 1
-	addi	a6, a6, 1		# restore a6 (really necessary?)
 	rfe
 
 1:	l32i	a7, a2, PT_AREG7	# restore a7
 	l32i	a0, a2, PT_AREG0	# restore a0
 	movi	a2, 0			# return 0 (note that we cannot set
-	addi	a6, a6, 1		# restore a6 (really necessary?)
 	rfe
 
 .Lnswp:	/* Atomic set, add, and exg_add. */
 
 TRY	l32i	a7, a3, 0		# orig
+	addi	a6, a6, -SYS_XTENSA_ATOMIC_SET
 	add	a0, a4, a7		# + arg
 	moveqz	a0, a4, a6		# set
+	addi	a6, a6, SYS_XTENSA_ATOMIC_SET
 TRY	s32i	a0, a3, 0		# write new value
 
 	mov	a0, a2
 	mov	a2, a7
 	l32i	a7, a0, PT_AREG7	# restore a7
 	l32i	a0, a0, PT_AREG0	# restore a0
-	addi	a6, a6, 1		# restore a6 (really necessary?)
 	rfe
 
 CATCH
@@ -1164,7 +1162,7 @@ CATCH
 	movi	a2, -EFAULT
 	rfe
 
-.Lill:	l32i	a7, a2, PT_AREG0	# restore a7
+.Lill:	l32i	a7, a2, PT_AREG7	# restore a7
 	l32i	a0, a2, PT_AREG0	# restore a0
 	movi	a2, -EINVAL
 	rfe


