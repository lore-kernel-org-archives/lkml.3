Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab3LPRYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:24:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48988 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab3LPRYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:24:48 -0500
Date: Mon, 16 Dec 2013 09:24:35 -0800
From: tip-bot for Qiaowei Ren <tipbot@zytor.com>
Message-ID: <tip-0ee3b6f87d4d748d5362cb47ff33fa1553805cb4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, qiaowei.ren@intel.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, qiaowei.ren@intel.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1387002303-6620-2-git-send-email-qiaowei.ren@intel.com>
References: <1387002303-6620-2-git-send-email-qiaowei.ren@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] x86: replace futex_atomic_cmpxchg_inatomic()
  with user_atomic_cmpxchg_inatomic
Git-Commit-ID: 0ee3b6f87d4d748d5362cb47ff33fa1553805cb4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 09:24:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ee3b6f87d4d748d5362cb47ff33fa1553805cb4
Gitweb:     http://git.kernel.org/tip/0ee3b6f87d4d748d5362cb47ff33fa1553805cb4
Author:     Qiaowei Ren <qiaowei.ren@intel.com>
AuthorDate: Sat, 14 Dec 2013 14:25:03 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 16 Dec 2013 09:08:13 -0800

x86: replace futex_atomic_cmpxchg_inatomic() with user_atomic_cmpxchg_inatomic

futex_atomic_cmpxchg_inatomic() is simply the 32-bit implementation of
user_atomic_cmpxchg_inatomic(), which in turn is simply a
generalization of the original code in
futex_atomic_cmpxchg_inatomic().

Use the newly generalized user_atomic_cmpxchg_inatomic() as the futex
implementation, too.

[ hpa: retain the inline in futex.h rather than changing it to a macro ]

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Link: http://lkml.kernel.org/r/1387002303-6620-2-git-send-email-qiaowei.ren@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/include/asm/futex.h | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/futex.h b/arch/x86/include/asm/futex.h
index be27ba1..b4c1f54 100644
--- a/arch/x86/include/asm/futex.h
+++ b/arch/x86/include/asm/futex.h
@@ -110,26 +110,7 @@ static inline int futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
 static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 						u32 oldval, u32 newval)
 {
-	int ret = 0;
-
-	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
-		return -EFAULT;
-
-	asm volatile("\t" ASM_STAC "\n"
-		     "1:\t" LOCK_PREFIX "cmpxchgl %4, %2\n"
-		     "2:\t" ASM_CLAC "\n"
-		     "\t.section .fixup, \"ax\"\n"
-		     "3:\tmov     %3, %0\n"
-		     "\tjmp     2b\n"
-		     "\t.previous\n"
-		     _ASM_EXTABLE(1b, 3b)
-		     : "+r" (ret), "=a" (oldval), "+m" (*uaddr)
-		     : "i" (-EFAULT), "r" (newval), "1" (oldval)
-		     : "memory"
-	);
-
-	*uval = oldval;
-	return ret;
+	return user_atomic_cmpxchg_inatomic(uval, uaddr, oldval, newval);
 }
 
 #endif
