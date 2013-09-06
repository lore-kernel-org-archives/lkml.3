Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab3IFVsB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 17:48:01 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:40976 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab3IFVr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 17:47:59 -0400
From: behanw@converseincode.com
To: linux@arm.linux.org.uk
Cc: behanw@converseincode.com, Mark Charlebois <charlebm@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Wade Farnsworth <wade_farnsworth@mentor.com>,
        Will Drewry <wad@chromium.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] arm: LLVMLinux: Calculate current_thread_info from fp
Date: Fri,  6 Sep 2013 17:47:40 -0400
Message-Id: <1378504062-9117-2-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378504062-9117-1-git-send-email-behanw@converseincode.com>
References: <1378504062-9117-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Use the frame pointer to calculate the start of the stack for current_thread_info()
The existing code uses the stack pointer to do this calculation.
Using the frame pointer yeilds the same value in a portable way.
This change supports being able to compile the kernel with gcc and Clang.

Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Jan-Simon Möller <dl9pf@gmx.de>
---
 arch/arm/include/asm/thread_info.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index df5e13d..cb50933 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -106,8 +106,9 @@ static inline struct thread_info *current_thread_info(void) __attribute_const__;
 
 static inline struct thread_info *current_thread_info(void)
 {
-	register unsigned long sp asm ("sp");
-	return (struct thread_info *)(sp & ~(THREAD_SIZE - 1));
+	return (struct thread_info *)
+		((u32)(__builtin_frame_address(0))
+		& ~(THREAD_SIZE - 1));
 }
 
 #define thread_saved_pc(tsk)	\
-- 
1.8.1.2

