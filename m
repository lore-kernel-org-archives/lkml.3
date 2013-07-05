Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab3GEOZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:25:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34608 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab3GEOZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:25:02 -0400
Date: Fri, 5 Jul 2013 07:24:42 -0700
From: tip-bot for Wedson Almeida Filho <tipbot@zytor.com>
Message-ID: <tip-00e55a790706223c903ce6a450c18596a7bc9be0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        wedsonaf@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        wedsonaf@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1372420245-60021-1-git-send-email-wedsonaf@gmail.com>
References: <1372420245-60021-1-git-send-email-wedsonaf@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86:
  Use asm-goto to implement mutex fast path on x86-64
Git-Commit-ID: 00e55a790706223c903ce6a450c18596a7bc9be0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 05 Jul 2013 07:24:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00e55a790706223c903ce6a450c18596a7bc9be0
Gitweb:     http://git.kernel.org/tip/00e55a790706223c903ce6a450c18596a7bc9be0
Author:     Wedson Almeida Filho <wedsonaf@gmail.com>
AuthorDate: Fri, 28 Jun 2013 04:50:45 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 28 Jun 2013 15:22:18 -0700

x86: Use asm-goto to implement mutex fast path on x86-64

The new implementation allows the compiler to better optimize the code; the
original implementation is still used when the kernel is compiled with older
versions of gcc that don't support asm-goto.

Compiling with gcc 4.7.3, the original mutex_lock() is 60 bytes with the fast
path taking 16 instructions; the new mutex_lock() is 42 bytes, with the fast
path taking 12 instructions.

The original mutex_unlock() is 24 bytes with the fast path taking 7
instructions; the new mutex_unlock() is 25 bytes (because the compiler used
a 2-byte ret) with the fast path taking 4 instructions.

The two versions of the functions are included below for reference.

Old:
ffffffff817742a0 <mutex_lock>:
ffffffff817742a0:       55                      push   %rbp
ffffffff817742a1:       48 89 e5                mov    %rsp,%rbp
ffffffff817742a4:       48 83 ec 10             sub    $0x10,%rsp
ffffffff817742a8:       48 89 5d f0             mov    %rbx,-0x10(%rbp)
ffffffff817742ac:       48 89 fb                mov    %rdi,%rbx
ffffffff817742af:       4c 89 65 f8             mov    %r12,-0x8(%rbp)
ffffffff817742b3:       e8 28 15 00 00          callq  ffffffff817757e0 <_cond_resched>
ffffffff817742b8:       48 89 df                mov    %rbx,%rdi
ffffffff817742bb:       f0 ff 0f                lock decl (%rdi)
ffffffff817742be:       79 05                   jns    ffffffff817742c5 <mutex_lock+0x25>
ffffffff817742c0:       e8 cb 04 00 00          callq  ffffffff81774790 <__mutex_lock_slowpath>
ffffffff817742c5:       65 48 8b 04 25 c0 b7    mov    %gs:0xb7c0,%rax
ffffffff817742cc:       00 00
ffffffff817742ce:       4c 8b 65 f8             mov    -0x8(%rbp),%r12
ffffffff817742d2:       48 89 43 18             mov    %rax,0x18(%rbx)
ffffffff817742d6:       48 8b 5d f0             mov    -0x10(%rbp),%rbx
ffffffff817742da:       c9                      leaveq
ffffffff817742db:       c3                      retq

ffffffff81774250 <mutex_unlock>:
ffffffff81774250:       55                      push   %rbp
ffffffff81774251:       48 c7 47 18 00 00 00    movq   $0x0,0x18(%rdi)
ffffffff81774258:       00
ffffffff81774259:       48 89 e5                mov    %rsp,%rbp
ffffffff8177425c:       f0 ff 07                lock incl (%rdi)
ffffffff8177425f:       7f 05                   jg     ffffffff81774266 <mutex_unlock+0x16>
ffffffff81774261:       e8 ea 04 00 00          callq  ffffffff81774750 <__mutex_unlock_slowpath>
ffffffff81774266:       5d                      pop    %rbp
ffffffff81774267:       c3                      retq

New:
ffffffff81774920 <mutex_lock>:
ffffffff81774920:       55                      push   %rbp
ffffffff81774921:       48 89 e5                mov    %rsp,%rbp
ffffffff81774924:       53                      push   %rbx
ffffffff81774925:       48 89 fb                mov    %rdi,%rbx
ffffffff81774928:       e8 a3 0e 00 00          callq  ffffffff817757d0 <_cond_resched>
ffffffff8177492d:       f0 ff 0b                lock decl (%rbx)
ffffffff81774930:       79 08                   jns    ffffffff8177493a <mutex_lock+0x1a>
ffffffff81774932:       48 89 df                mov    %rbx,%rdi
ffffffff81774935:       e8 16 fe ff ff          callq  ffffffff81774750 <__mutex_lock_slowpath>
ffffffff8177493a:       65 48 8b 04 25 c0 b7    mov    %gs:0xb7c0,%rax
ffffffff81774941:       00 00
ffffffff81774943:       48 89 43 18             mov    %rax,0x18(%rbx)
ffffffff81774947:       5b                      pop    %rbx
ffffffff81774948:       5d                      pop    %rbp
ffffffff81774949:       c3                      retq

ffffffff81774730 <mutex_unlock>:
ffffffff81774730:       48 c7 47 18 00 00 00    movq   $0x0,0x18(%rdi)
ffffffff81774737:       00
ffffffff81774738:       f0 ff 07                lock incl (%rdi)
ffffffff8177473b:       7f 0a                   jg     ffffffff81774747 <mutex_unlock+0x17>
ffffffff8177473d:       55                      push   %rbp
ffffffff8177473e:       48 89 e5                mov    %rsp,%rbp
ffffffff81774741:       e8 aa ff ff ff          callq  ffffffff817746f0 <__mutex_unlock_slowpath>
ffffffff81774746:       5d                      pop    %rbp
ffffffff81774747:       f3 c3                   repz retq

Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>
Link: http://lkml.kernel.org/r/1372420245-60021-1-git-send-email-wedsonaf@gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/mutex_64.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/include/asm/mutex_64.h b/arch/x86/include/asm/mutex_64.h
index 68a87b0..c030bee 100644
--- a/arch/x86/include/asm/mutex_64.h
+++ b/arch/x86/include/asm/mutex_64.h
@@ -16,6 +16,20 @@
  *
  * Atomically decrements @v and calls <fail_fn> if the result is negative.
  */
+#ifdef CC_HAVE_ASM_GOTO
+static inline void __mutex_fastpath_lock(atomic_t *v,
+					 void (*fail_fn)(atomic_t *))
+{
+	asm volatile goto(LOCK_PREFIX "   decl %0\n"
+			  "   jns %l[exit]\n"
+			  : : "m" (v->counter)
+			  : "memory", "cc"
+			  : exit);
+	fail_fn(v);
+exit:
+	return;
+}
+#else
 #define __mutex_fastpath_lock(v, fail_fn)			\
 do {								\
 	unsigned long dummy;					\
@@ -32,6 +46,7 @@ do {								\
 		     : "rax", "rsi", "rdx", "rcx",		\
 		       "r8", "r9", "r10", "r11", "memory");	\
 } while (0)
+#endif
 
 /**
  *  __mutex_fastpath_lock_retval - try to take the lock by moving the count
@@ -59,6 +74,20 @@ static inline int __mutex_fastpath_lock_retval(atomic_t *count,
  *
  * Atomically increments @v and calls <fail_fn> if the result is nonpositive.
  */
+#ifdef CC_HAVE_ASM_GOTO
+static inline void __mutex_fastpath_unlock(atomic_t *v,
+					   void (*fail_fn)(atomic_t *))
+{
+	asm volatile goto(LOCK_PREFIX "   incl %0\n"
+			  "   jg %l[exit]\n"
+			  : : "m" (v->counter)
+			  : "memory", "cc"
+			  : exit);
+	fail_fn(v);
+exit:
+	return;
+}
+#else
 #define __mutex_fastpath_unlock(v, fail_fn)			\
 do {								\
 	unsigned long dummy;					\
@@ -75,6 +104,7 @@ do {								\
 		     : "rax", "rsi", "rdx", "rcx",		\
 		       "r8", "r9", "r10", "r11", "memory");	\
 } while (0)
+#endif
 
 #define __mutex_slowpath_needs_to_unlock()	1
 
