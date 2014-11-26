Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaKZTUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 14:20:34 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:54144 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaKZTUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 14:20:32 -0500
Message-ID: <547627F7.2070901@de.ibm.com>
Date: Wed, 26 Nov 2014 20:20:23 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mips@linux-mips.org, linux-x86_64@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCHv3 00/10] ACCESS_ONCE and non-scalar accesses
References: <1416919117-50652-1-git-send-email-borntraeger@de.ibm.com>
In-Reply-To: <1416919117-50652-1-git-send-email-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112619-0017-0000-0000-000001FDF934
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, 

I have changed the code as below (diff to v2). m68k and sparc do compile now. I changed the rmap.c code to use a barrier as the requirement of the code should be trivial. I also use a linker error for the default case. (rmap.c was the only case, so it might be easier to just fix the callers. Furthermore, memcpy did not work that well in compiler.h....) Below is git request pull output if somebody wants to look at the tree. How to proceed? Shall we add this to linux-next and merge in the next cycle if there are no issues? Send around another bunch of patches?

Christian

--------------------------------- snip----------------------
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index af6e673..12a69b4 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -92,7 +92,7 @@ static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
 		unsigned count = SPIN_THRESHOLD;
 
 		do {
-			if (ASSIGN_ONCE(inc.tail, lock->tickets.head))
+			if (READ_ONCE(lock->tickets.head) == inc.tail)
 				goto out;
 			cpu_relax();
 		} while (--count);
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 7265a6c..4434255 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -188,6 +188,7 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 
 #include <linux/types.h>
 
+extern void invalid_size_for_ASSIGN_ONCE(void);
 static __always_inline void __assign_once_size(volatile void *p, void *res, int size)
 {
 	switch (size) {
@@ -197,13 +198,14 @@ static __always_inline void __assign_once_size(volatile void *p, void *res, int
 #ifdef CONFIG_64BIT
 	case 8: *(volatile u64 *)p = *(u64 *)res; break;
 #endif
+	default: invalid_size_for_ASSIGN_ONCE();
 	}
 }
 
 #define ASSIGN_ONCE(val, p) \
       ({ typeof(p) __val; __val = val; __assign_once_size(&p, &__val, sizeof(__val)); __val; })
 
-
+extern void invalid_size_for_READ_ONCE(void);
 static __always_inline void __read_once_size(volatile void *p, void *res, int size)
 {
 	switch (size) {
@@ -213,6 +215,7 @@ static __always_inline void __read_once_size(volatile void *p, void *res, int si
 #ifdef CONFIG_64BIT
 	case 8: *(u64 *)res = *(volatile u64 *)p; break;
 #endif
+	default: invalid_size_for_READ_ONCE();
 	}
 }
 
diff --git a/mm/rmap.c b/mm/rmap.c
index 3152a9c..1e54274 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -581,7 +581,8 @@ pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address)
 	 * without holding anon_vma lock for write.  So when looking for a
 	 * genuine pmde (in which to find pte), test present and !THP together.
 	 */
-	pmde = READ_ONCE(*pmd);
+	pmde = *pmd;
+	barrier();
 	if (!pmd_present(pmde) || pmd_trans_huge(pmde))
 		pmd = NULL;
 out:

--------------------------------- snip----------------------



The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a1da4:

  Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/borntraeger/linux.git tags/access_once

for you to fetch changes up to fbb7eba5b777691dd1f0e106433b78de588ed16e:

  KVM: s390: change ipte lock from barrier to READ_ONCE (2014-11-26 12:30:10 +0100)

----------------------------------------------------------------
As discussed on LKML http://marc.info/?i=54611D86.4040306%40de.ibm.com
ACCESS_ONCE might fail with specific compiler for non-scalar accesses.

Here is a set of patches to tackle that problem.

We first introduce READ_ONCE/ASSIGN_ONCE as suggested by Linus. These
wrappers will make all accesses via scalar wrappers and will also check
that accesses are <= the word size of the system.
The next changes will modify current users of ACCESS_ONCE on non-scalar
types to use READ_ONCE/ASSIGN_ONCE or barrier where necessary.
The 2nd to last patch will force ACCESS_ONCE to error-out if it is used
on non-scalar accesses.

The series is cross-compiled the resulting kernel with defconfig for
microblaze, m68k, alpha, s390,x86_64, i686, sparc, sparc64, mips,
ia64, arm and arm64.

----------------------------------------------------------------
Christian Borntraeger (10):
      KVM: s390: Fix ipte locking
      kernel: Provide READ_ONCE and ASSIGN_ONCE
      mm: replace ACCESS_ONCE with READ_ONCE or barriers
      x86/spinlock: Replace ACCESS_ONCE with READ_ONCE
      x86: Replace ACCESS_ONCE in gup with READ_ONCE
      mips: Replace ACCESS_ONCE in gup with READ_ONCE
      arm64: Replace ACCESS_ONCE for spinlock code with READ_ONCE
      arm: Replace ACCESS_ONCE for spinlock code with READ_ONCE
      tighten rules for ACCESS ONCE
      KVM: s390: change ipte lock from barrier to READ_ONCE

 arch/arm/include/asm/spinlock.h   |  4 ++--
 arch/arm64/include/asm/spinlock.h |  4 ++--
 arch/mips/mm/gup.c                |  2 +-
 arch/s390/kvm/gaccess.c           | 14 ++++++++------
 arch/x86/include/asm/spinlock.h   |  8 ++++----
 arch/x86/mm/gup.c                 |  2 +-
 include/linux/compiler.h          | 46 +++++++++++++++++++++++++++++++++++++++++++++-
 mm/gup.c                          |  2 +-
 mm/memory.c                       |  2 +-
 mm/rmap.c                         |  3 ++-
 10 files changed, 67 insertions(+), 20 deletions(-)




