Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab3KPUhw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 15:37:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:59713 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab3KPUhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 15:37:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="409932778"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH] x86/copy_user.S: Remove zero byte check before copy user buffer.
Date: Sat, 16 Nov 2013 12:37:01 -0800
Message-Id: <1384634221-6006-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Operation of rep movsb instruction handles zero byte copy. As pointed out by
Linus, there is no need to check zero size in kernel. Removing this redundant
check saves a few cycles in copy user functions.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/lib/copy_user_64.S | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index a30ca15..ffe4eb9 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -236,8 +236,6 @@ ENDPROC(copy_user_generic_unrolled)
 ENTRY(copy_user_generic_string)
 	CFI_STARTPROC
 	ASM_STAC
-	andl %edx,%edx
-	jz 4f
 	cmpl $8,%edx
 	jb 2f		/* less than 8 bytes, go to byte copy loop */
 	ALIGN_DESTINATION
@@ -249,7 +247,7 @@ ENTRY(copy_user_generic_string)
 2:	movl %edx,%ecx
 3:	rep
 	movsb
-4:	xorl %eax,%eax
+	xorl %eax,%eax
 	ASM_CLAC
 	ret
 
@@ -279,12 +277,10 @@ ENDPROC(copy_user_generic_string)
 ENTRY(copy_user_enhanced_fast_string)
 	CFI_STARTPROC
 	ASM_STAC
-	andl %edx,%edx
-	jz 2f
 	movl %edx,%ecx
 1:	rep
 	movsb
-2:	xorl %eax,%eax
+	xorl %eax,%eax
 	ASM_CLAC
 	ret
 
-- 
1.8.0.1

