Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab3KQGTq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 01:19:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47376 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3KQGTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 01:19:21 -0500
Date: Sat, 16 Nov 2013 22:18:52 -0800
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-f4cb1cc18f364d761d5614eb6293cccc6647f259@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, fenghua.yu@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, fenghua.yu@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1384634221-6006-1-git-send-email-fenghua.yu@intel.com>
References: <1384634221-6006-1-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64, copy_user:
  Remove zero byte check before copy user buffer.
Git-Commit-ID: f4cb1cc18f364d761d5614eb6293cccc6647f259
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 16 Nov 2013 22:18:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f4cb1cc18f364d761d5614eb6293cccc6647f259
Gitweb:     http://git.kernel.org/tip/f4cb1cc18f364d761d5614eb6293cccc6647f259
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Sat, 16 Nov 2013 12:37:01 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sat, 16 Nov 2013 18:00:58 -0800

x86-64, copy_user: Remove zero byte check before copy user buffer.

Operation of rep movsb instruction handles zero byte copy. As pointed out by
Linus, there is no need to check zero size in kernel. Removing this redundant
check saves a few cycles in copy user functions.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1384634221-6006-1-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
 
