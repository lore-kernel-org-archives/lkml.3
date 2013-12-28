Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab3L1BA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 20:00:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57978 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab3L1BAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 20:00:54 -0500
Date: Fri, 27 Dec 2013 17:00:40 -0800
From: tip-bot for Linus Torvalds <tipbot@zytor.com>
Message-ID: <tip-c5fe5d80680e2949ffe102180f5fc6cefc0d145f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <CA+55aFzPBdbfKovMT8Edr4SmE2_=+OKJFac9XW2awegogTkVTA@mail.gmail.com>
References: <CA+55aFzPBdbfKovMT8Edr4SmE2_=+OKJFac9XW2awegogTkVTA@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Replace assembly access_ok() with a C variant
Git-Commit-ID: c5fe5d80680e2949ffe102180f5fc6cefc0d145f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 27 Dec 2013 17:00:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5fe5d80680e2949ffe102180f5fc6cefc0d145f
Gitweb:     http://git.kernel.org/tip/c5fe5d80680e2949ffe102180f5fc6cefc0d145f
Author:     Linus Torvalds <torvalds@linux-foundation.org>
AuthorDate: Fri, 27 Dec 2013 15:30:58 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 27 Dec 2013 16:58:17 -0800

x86: Replace assembly access_ok() with a C variant

It turns out that the assembly variant doesn't actually produce that
good code, presumably partly because it creates a long dependency
chain with no scheduling, and partly because we cannot get a flags
result out of gcc (which could be fixed with asm goto, but it turns
out not to be worth it.)

The C code allows gcc to schedule and generate multiple (easily
predictable) branches, and as a side benefit we can really optimize
the case where the size is constant.

Link: http://lkml.kernel.org/r/CA%2B55aFzPBdbfKovMT8Edr4SmE2_=%2BOKJFac9XW2awegogTkVTA@mail.gmail.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/uaccess.h | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 8ec57c0..84ecf1d 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -40,22 +40,28 @@
 /*
  * Test whether a block of memory is a valid user space address.
  * Returns 0 if the range is valid, nonzero otherwise.
- *
- * This is equivalent to the following test:
- * (u33)addr + (u33)size > (u33)current->addr_limit.seg (u65 for x86_64)
- *
- * This needs 33-bit (65-bit for x86_64) arithmetic. We have a carry...
  */
+static inline int __chk_range_not_ok(unsigned long addr, unsigned long size, unsigned long limit)
+{
+	/*
+	 * If we have used "sizeof()" for the size,
+	 * we know it won't overflow the limit (but
+	 * it might overflow the 'addr', so it's
+	 * important to subtract the size from the
+	 * limit, not add it to the address).
+	 */
+	if (__builtin_constant_p(size))
+		return addr > limit - size;
+
+	/* Arbitrary sizes? Be careful about overflow */
+	addr += size;
+	return (addr < size) || (addr > limit);
+}
 
 #define __range_not_ok(addr, size, limit)				\
 ({									\
-	unsigned long flag, roksum;					\
 	__chk_user_ptr(addr);						\
-	asm("add %3,%1 ; sbb %0,%0 ; cmp %1,%4 ; sbb $0,%0"		\
-	    : "=&r" (flag), "=r" (roksum)				\
-	    : "1" (addr), "g" ((long)(size)),				\
-	      "rm" (limit));						\
-	flag;								\
+	__chk_range_not_ok((unsigned long __force)(addr), size, limit); \
 })
 
 /**
