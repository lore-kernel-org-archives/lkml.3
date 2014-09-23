Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaIWChQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:37:16 -0400
Received: from mail.kernel.org ([198.145.19.201]:37899 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaIWChM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:37:12 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 17/45] xtensa: fix a6 and a7 handling in fast_syscall_xtensa
Date: Tue, 23 Sep 2014 10:31:19 +0800
Message-Id: <1411439507-30391-17-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit d1b6ba82a50cecf94be540a3a153aa89d97511a0 upstream.

Remove restoring a6 on some return paths and instead modify and restore
it in a single place, using symbolic name.
Correctly restore a7 from PT_AREG7 in case of illegal a6 value.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/xtensa/kernel/entry.S |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/xtensa/kernel/entry.S b/arch/xtensa/kernel/entry.S
index bc9f78e..e01cffc 100644
--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -1053,9 +1053,8 @@ ENTRY(fast_syscall_xtensa)
 	movi	a7, 4			# sizeof(unsigned int)
 	access_ok a3, a7, a0, a2, .Leac	# a0: scratch reg, a2: sp
 
-	addi	a6, a6, -1		# assuming SYS_XTENSA_ATOMIC_SET = 1
-	_bgeui	a6, SYS_XTENSA_COUNT - 1, .Lill
-	_bnei	a6, SYS_XTENSA_ATOMIC_CMP_SWP - 1, .Lnswp
+	_bgeui	a6, SYS_XTENSA_COUNT, .Lill
+	_bnei	a6, SYS_XTENSA_ATOMIC_CMP_SWP, .Lnswp
 
 	/* Fall through for ATOMIC_CMP_SWP. */
 
@@ -1067,27 +1066,26 @@ TRY	s32i	a5, a3, 0		# different, modify value
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
@@ -1096,7 +1094,7 @@ CATCH
 	movi	a2, -EFAULT
 	rfe
 
-.Lill:	l32i	a7, a2, PT_AREG0	# restore a7
+.Lill:	l32i	a7, a2, PT_AREG7	# restore a7
 	l32i	a0, a2, PT_AREG0	# restore a0
 	movi	a2, -EINVAL
 	rfe
-- 
1.7.9.5

