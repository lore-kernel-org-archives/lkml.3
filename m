Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab3CCK30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 05:29:26 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:48529 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab3CCK3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 05:29:23 -0500
Date: Sun, 3 Mar 2013 11:29:14 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.9 merge window #2
Message-ID: <20130303112914.52bd66c2@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030310-2966-0000-0000-000006E12E15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
The main part of this merge are Heikos uaccess patches. Together with
commit 09884964335e85e8 "mm: do not grow the stack vma just because of
an overrun on preceding vma" the user string access is hopefully fixed
for good. In addition some bug fixes and two cleanup patches.


Heiko Carstens (9):
      s390/page table dumper: add support for change-recording override bit
      s390/mm: ignore change bit for vmemmap
      s390/uaccess: shorten strncpy_from_user/strnlen_user
      s390/uaccess: fix strncpy_from_user/strnlen_user zero maxlen case
      s390/uaccess: remove pointless access_ok() checks
      input: disable i8042 PC Keyboard controller for s390
      s390/uaccess: fix strncpy_from_user string length check
      s390/uaccess: fix kernel ds access for page table walk
      s390/module: fix compile warning

Stefan Haberland (1):
      s390/dasd: fix unresponsive device after all channel paths were lost

Stefan Raspl (1):
      qdio: remove unused parameters

Syam Sidhardhan (1):
      s390/dis: Fix invalid array size

 arch/s390/include/asm/futex.h    |    6 --
 arch/s390/include/asm/pgtable.h  |    2 +
 arch/s390/include/asm/uaccess.h  |   23 ++-----
 arch/s390/kernel/compat_signal.c |   14 -----
 arch/s390/kernel/dis.c           |    4 +-
 arch/s390/kernel/module.c        |    2 +-
 arch/s390/kernel/signal.c        |    8 ---
 arch/s390/lib/uaccess_mvcos.c    |   26 ++++----
 arch/s390/lib/uaccess_pt.c       |  129 +++++++++++++++++++++++++++-----------
 arch/s390/lib/uaccess_std.c      |   48 ++++++--------
 arch/s390/mm/dump_pagetables.c   |   25 ++++++--
 arch/s390/mm/vmem.c              |    3 +-
 drivers/input/serio/Kconfig      |    2 +-
 drivers/s390/block/dasd_eckd.c   |   10 ++-
 drivers/s390/cio/qdio_debug.c    |    9 +--
 drivers/s390/cio/qdio_debug.h    |    3 +-
 drivers/s390/cio/qdio_main.c     |    2 +-
 17 files changed, 172 insertions(+), 144 deletions(-)

diff --git a/arch/s390/include/asm/futex.h b/arch/s390/include/asm/futex.h
index 96bc83e..51bcaa0 100644
--- a/arch/s390/include/asm/futex.h
+++ b/arch/s390/include/asm/futex.h
@@ -16,9 +16,6 @@ static inline int futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
 		oparg = 1 << oparg;
 
-	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
-		return -EFAULT;
-
 	pagefault_disable();
 	ret = uaccess.futex_atomic_op(op, uaddr, oparg, &oldval);
 	pagefault_enable();
@@ -40,9 +37,6 @@ static inline int futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
 static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 						u32 oldval, u32 newval)
 {
-	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u32)))
-		return -EFAULT;
-
 	return uaccess.futex_atomic_cmpxchg(uval, uaddr, oldval, newval);
 }
 
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 97de120..4a29308 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -340,6 +340,8 @@ extern unsigned long MODULES_END;
 #define _REGION3_ENTRY_EMPTY	(_REGION_ENTRY_TYPE_R3 | _REGION_ENTRY_INV)
 
 #define _REGION3_ENTRY_LARGE	0x400	/* RTTE-format control, large page  */
+#define _REGION3_ENTRY_RO	0x200	/* page protection bit		    */
+#define _REGION3_ENTRY_CO	0x100	/* change-recording override	    */
 
 /* Bits in the segment table entry */
 #define _SEGMENT_ENTRY_ORIGIN	~0x7ffUL/* segment table origin		    */
diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
index 34268df..9c33ed4 100644
--- a/arch/s390/include/asm/uaccess.h
+++ b/arch/s390/include/asm/uaccess.h
@@ -252,9 +252,7 @@ static inline unsigned long __must_check
 copy_to_user(void __user *to, const void *from, unsigned long n)
 {
 	might_fault();
-	if (access_ok(VERIFY_WRITE, to, n))
-		n = __copy_to_user(to, from, n);
-	return n;
+	return __copy_to_user(to, from, n);
 }
 
 /**
@@ -315,11 +313,7 @@ copy_from_user(void *to, const void __user *from, unsigned long n)
 		copy_from_user_overflow();
 		return n;
 	}
-	if (access_ok(VERIFY_READ, from, n))
-		n = __copy_from_user(to, from, n);
-	else
-		memset(to, 0, n);
-	return n;
+	return __copy_from_user(to, from, n);
 }
 
 static inline unsigned long __must_check
@@ -332,9 +326,7 @@ static inline unsigned long __must_check
 copy_in_user(void __user *to, const void __user *from, unsigned long n)
 {
 	might_fault();
-	if (__access_ok(from,n) && __access_ok(to,n))
-		n = __copy_in_user(to, from, n);
-	return n;
+	return __copy_in_user(to, from, n);
 }
 
 /*
@@ -343,11 +335,8 @@ copy_in_user(void __user *to, const void __user *from, unsigned long n)
 static inline long __must_check
 strncpy_from_user(char *dst, const char __user *src, long count)
 {
-        long res = -EFAULT;
 	might_fault();
-        if (access_ok(VERIFY_READ, src, 1))
-		res = uaccess.strncpy_from_user(count, src, dst);
-        return res;
+	return uaccess.strncpy_from_user(count, src, dst);
 }
 
 static inline unsigned long
@@ -387,9 +376,7 @@ static inline unsigned long __must_check
 clear_user(void __user *to, unsigned long n)
 {
 	might_fault();
-	if (access_ok(VERIFY_WRITE, to, n))
-		n = uaccess.clear_user(n, to);
-	return n;
+	return uaccess.clear_user(n, to);
 }
 
 extern int copy_to_user_real(void __user *dest, void *src, size_t count);
diff --git a/arch/s390/kernel/compat_signal.c b/arch/s390/kernel/compat_signal.c
index 3e71194..6de049f 100644
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -53,9 +53,6 @@ int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 {
 	int err;
 
-	if (!access_ok (VERIFY_WRITE, to, sizeof(compat_siginfo_t)))
-		return -EFAULT;
-
 	/* If you change siginfo_t structure, please be sure
 	   this code is fixed accordingly.
 	   It should never copy any pad contained in the structure
@@ -110,9 +107,6 @@ int copy_siginfo_from_user32(siginfo_t *to, compat_siginfo_t __user *from)
 	int err;
 	u32 tmp;
 
-	if (!access_ok (VERIFY_READ, from, sizeof(compat_siginfo_t)))
-		return -EFAULT;
-
 	err = __get_user(to->si_signo, &from->si_signo);
 	err |= __get_user(to->si_errno, &from->si_errno);
 	err |= __get_user(to->si_code, &from->si_code);
@@ -244,8 +238,6 @@ asmlinkage long sys32_sigreturn(void)
 	sigframe32 __user *frame = (sigframe32 __user *)regs->gprs[15];
 	sigset_t set;
 
-	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
-		goto badframe;
 	if (__copy_from_user(&set.sig, &frame->sc.oldmask, _SIGMASK_COPY_SIZE32))
 		goto badframe;
 	set_current_blocked(&set);
@@ -265,8 +257,6 @@ asmlinkage long sys32_rt_sigreturn(void)
 	rt_sigframe32 __user *frame = (rt_sigframe32 __user *)regs->gprs[15];
 	sigset_t set;
 
-	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
-		goto badframe;
 	if (__copy_from_user(&set, &frame->uc.uc_sigmask, sizeof(set)))
 		goto badframe;
 	set_current_blocked(&set);
@@ -325,8 +315,6 @@ static int setup_frame32(int sig, struct k_sigaction *ka,
 			sigset_t *set, struct pt_regs * regs)
 {
 	sigframe32 __user *frame = get_sigframe(ka, regs, sizeof(sigframe32));
-	if (!access_ok(VERIFY_WRITE, frame, sizeof(sigframe32)))
-		goto give_sigsegv;
 
 	if (frame == (void __user *) -1UL)
 		goto give_sigsegv;
@@ -391,8 +379,6 @@ static int setup_rt_frame32(int sig, struct k_sigaction *ka, siginfo_t *info,
 {
 	int err = 0;
 	rt_sigframe32 __user *frame = get_sigframe(ka, regs, sizeof(rt_sigframe32));
-	if (!access_ok(VERIFY_WRITE, frame, sizeof(rt_sigframe32)))
-		goto give_sigsegv;
 
 	if (frame == (void __user *) -1UL)
 		goto give_sigsegv;
diff --git a/arch/s390/kernel/dis.c b/arch/s390/kernel/dis.c
index c50665f..3ad5e95 100644
--- a/arch/s390/kernel/dis.c
+++ b/arch/s390/kernel/dis.c
@@ -1711,10 +1711,10 @@ int insn_to_mnemonic(unsigned char *instruction, char buf[8])
 	if (!insn)
 		return -ENOENT;
 	if (insn->name[0] == '\0')
-		snprintf(buf, sizeof(buf), "%s",
+		snprintf(buf, 8, "%s",
 			 long_insn_name[(int) insn->name[1]]);
 	else
-		snprintf(buf, sizeof(buf), "%.5s", insn->name);
+		snprintf(buf, 8, "%.5s", insn->name);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(insn_to_mnemonic);
diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index f750bd7..7845e15 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -222,7 +222,7 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
 	struct mod_arch_syminfo *info;
 	Elf_Addr loc, val;
 	int r_type, r_sym;
-	int rc;
+	int rc = -ENOEXEC;
 
 	/* This is where to make the change */
 	loc = base + rela->r_offset;
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index 9c6e747..c45becf 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -116,8 +116,6 @@ SYSCALL_DEFINE0(sigreturn)
 	sigframe __user *frame = (sigframe __user *)regs->gprs[15];
 	sigset_t set;
 
-	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
-		goto badframe;
 	if (__copy_from_user(&set.sig, &frame->sc.oldmask, _SIGMASK_COPY_SIZE))
 		goto badframe;
 	set_current_blocked(&set);
@@ -135,8 +133,6 @@ SYSCALL_DEFINE0(rt_sigreturn)
 	rt_sigframe __user *frame = (rt_sigframe __user *)regs->gprs[15];
 	sigset_t set;
 
-	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
-		goto badframe;
 	if (__copy_from_user(&set.sig, &frame->uc.uc_sigmask, sizeof(set)))
 		goto badframe;
 	set_current_blocked(&set);
@@ -195,8 +191,6 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 	sigframe __user *frame;
 
 	frame = get_sigframe(ka, regs, sizeof(sigframe));
-	if (!access_ok(VERIFY_WRITE, frame, sizeof(sigframe)))
-		goto give_sigsegv;
 
 	if (frame == (void __user *) -1UL)
 		goto give_sigsegv;
@@ -264,8 +258,6 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	rt_sigframe __user *frame;
 
 	frame = get_sigframe(ka, regs, sizeof(rt_sigframe));
-	if (!access_ok(VERIFY_WRITE, frame, sizeof(rt_sigframe)))
-		goto give_sigsegv;
 
 	if (frame == (void __user *) -1UL)
 		goto give_sigsegv;
diff --git a/arch/s390/lib/uaccess_mvcos.c b/arch/s390/lib/uaccess_mvcos.c
index 2443ae4..1829742 100644
--- a/arch/s390/lib/uaccess_mvcos.c
+++ b/arch/s390/lib/uaccess_mvcos.c
@@ -162,19 +162,19 @@ static size_t clear_user_mvcos(size_t size, void __user *to)
 
 static size_t strnlen_user_mvcos(size_t count, const char __user *src)
 {
+	size_t done, len, offset, len_str;
 	char buf[256];
-	int rc;
-	size_t done, len, len_str;
 
 	done = 0;
 	do {
-		len = min(count - done, (size_t) 256);
-		rc = uaccess.copy_from_user(len, src + done, buf);
-		if (unlikely(rc == len))
+		offset = (size_t)src & ~PAGE_MASK;
+		len = min(256UL, PAGE_SIZE - offset);
+		len = min(count - done, len);
+		if (copy_from_user_mvcos(len, src, buf))
 			return 0;
-		len -= rc;
 		len_str = strnlen(buf, len);
 		done += len_str;
+		src += len_str;
 	} while ((len_str == len) && (done < count));
 	return done + 1;
 }
@@ -182,18 +182,20 @@ static size_t strnlen_user_mvcos(size_t count, const char __user *src)
 static size_t strncpy_from_user_mvcos(size_t count, const char __user *src,
 				      char *dst)
 {
-	int rc;
-	size_t done, len, len_str;
+	size_t done, len, offset, len_str;
 
+	if (unlikely(!count))
+		return 0;
 	done = 0;
 	do {
-		len = min(count - done, (size_t) 4096);
-		rc = uaccess.copy_from_user(len, src + done, dst);
-		if (unlikely(rc == len))
+		offset = (size_t)src & ~PAGE_MASK;
+		len = min(count - done, PAGE_SIZE - offset);
+		if (copy_from_user_mvcos(len, src, dst))
 			return -EFAULT;
-		len -= rc;
 		len_str = strnlen(dst, len);
 		done += len_str;
+		src += len_str;
+		dst += len_str;
 	} while ((len_str == len) && (done < count));
 	return done;
 }
diff --git a/arch/s390/lib/uaccess_pt.c b/arch/s390/lib/uaccess_pt.c
index a70ee84..dff631d 100644
--- a/arch/s390/lib/uaccess_pt.c
+++ b/arch/s390/lib/uaccess_pt.c
@@ -14,6 +14,63 @@
 #include <asm/futex.h>
 #include "uaccess.h"
 
+#ifndef CONFIG_64BIT
+#define AHI	"ahi"
+#define SLR	"slr"
+#else
+#define AHI	"aghi"
+#define SLR	"slgr"
+#endif
+
+static size_t strnlen_kernel(size_t count, const char __user *src)
+{
+	register unsigned long reg0 asm("0") = 0UL;
+	unsigned long tmp1, tmp2;
+
+	asm volatile(
+		"   la	  %2,0(%1)\n"
+		"   la	  %3,0(%0,%1)\n"
+		"  "SLR"  %0,%0\n"
+		"0: srst  %3,%2\n"
+		"   jo	  0b\n"
+		"   la	  %0,1(%3)\n"	/* strnlen_kernel results includes \0 */
+		"  "SLR"  %0,%1\n"
+		"1:\n"
+		EX_TABLE(0b,1b)
+		: "+a" (count), "+a" (src), "=a" (tmp1), "=a" (tmp2)
+		: "d" (reg0) : "cc", "memory");
+	return count;
+}
+
+static size_t copy_in_kernel(size_t count, void __user *to,
+			     const void __user *from)
+{
+	unsigned long tmp1;
+
+	asm volatile(
+		"  "AHI"  %0,-1\n"
+		"   jo	  5f\n"
+		"   bras  %3,3f\n"
+		"0:"AHI"  %0,257\n"
+		"1: mvc	  0(1,%1),0(%2)\n"
+		"   la	  %1,1(%1)\n"
+		"   la	  %2,1(%2)\n"
+		"  "AHI"  %0,-1\n"
+		"   jnz	  1b\n"
+		"   j	  5f\n"
+		"2: mvc	  0(256,%1),0(%2)\n"
+		"   la	  %1,256(%1)\n"
+		"   la	  %2,256(%2)\n"
+		"3:"AHI"  %0,-256\n"
+		"   jnm	  2b\n"
+		"4: ex	  %0,1b-0b(%3)\n"
+		"5:"SLR"  %0,%0\n"
+		"6:\n"
+		EX_TABLE(1b,6b) EX_TABLE(2b,0b) EX_TABLE(4b,0b)
+		: "+a" (count), "+a" (to), "+a" (from), "=a" (tmp1)
+		: : "cc", "memory");
+	return count;
+}
 
 /*
  * Returns kernel address for user virtual address. If the returned address is
@@ -123,10 +180,8 @@ size_t copy_from_user_pt(size_t n, const void __user *from, void *to)
 {
 	size_t rc;
 
-	if (segment_eq(get_fs(), KERNEL_DS)) {
-		memcpy(to, (void __kernel __force *) from, n);
-		return 0;
-	}
+	if (segment_eq(get_fs(), KERNEL_DS))
+		return copy_in_kernel(n, (void __user *) to, from);
 	rc = __user_copy_pt((unsigned long) from, to, n, 0);
 	if (unlikely(rc))
 		memset(to + n - rc, 0, rc);
@@ -135,30 +190,28 @@ size_t copy_from_user_pt(size_t n, const void __user *from, void *to)
 
 size_t copy_to_user_pt(size_t n, void __user *to, const void *from)
 {
-	if (segment_eq(get_fs(), KERNEL_DS)) {
-		memcpy((void __kernel __force *) to, from, n);
-		return 0;
-	}
+	if (segment_eq(get_fs(), KERNEL_DS))
+		return copy_in_kernel(n, to, (void __user *) from);
 	return __user_copy_pt((unsigned long) to, (void *) from, n, 1);
 }
 
 static size_t clear_user_pt(size_t n, void __user *to)
 {
+	void *zpage = &empty_zero_page;
 	long done, size, ret;
 
-	if (segment_eq(get_fs(), KERNEL_DS)) {
-		memset((void __kernel __force *) to, 0, n);
-		return 0;
-	}
 	done = 0;
 	do {
 		if (n - done > PAGE_SIZE)
 			size = PAGE_SIZE;
 		else
 			size = n - done;
-		ret = __user_copy_pt((unsigned long) to + done,
-				      &empty_zero_page, size, 1);
+		if (segment_eq(get_fs(), KERNEL_DS))
+			ret = copy_in_kernel(n, to, (void __user *) zpage);
+		else
+			ret = __user_copy_pt((unsigned long) to, zpage, size, 1);
 		done += size;
+		to += size;
 		if (ret)
 			return ret + n - done;
 	} while (done < n);
@@ -172,8 +225,10 @@ static size_t strnlen_user_pt(size_t count, const char __user *src)
 	unsigned long offset, done, len, kaddr;
 	size_t len_str;
 
+	if (unlikely(!count))
+		return 0;
 	if (segment_eq(get_fs(), KERNEL_DS))
-		return strnlen((const char __kernel __force *) src, count) + 1;
+		return strnlen_kernel(count, src);
 	done = 0;
 retry:
 	spin_lock(&mm->page_table_lock);
@@ -200,25 +255,27 @@ fault:
 static size_t strncpy_from_user_pt(size_t count, const char __user *src,
 				   char *dst)
 {
-	size_t n = strnlen_user_pt(count, src);
+	size_t done, len, offset, len_str;
 
-	if (!n)
-		return -EFAULT;
-	if (n > count)
-		n = count;
-	if (segment_eq(get_fs(), KERNEL_DS)) {
-		memcpy(dst, (const char __kernel __force *) src, n);
-		if (dst[n-1] == '\0')
-			return n-1;
-		else
-			return n;
-	}
-	if (__user_copy_pt((unsigned long) src, dst, n, 0))
-		return -EFAULT;
-	if (dst[n-1] == '\0')
-		return n-1;
-	else
-		return n;
+	if (unlikely(!count))
+		return 0;
+	done = 0;
+	do {
+		offset = (size_t)src & ~PAGE_MASK;
+		len = min(count - done, PAGE_SIZE - offset);
+		if (segment_eq(get_fs(), KERNEL_DS)) {
+			if (copy_in_kernel(len, (void __user *) dst, src))
+				return -EFAULT;
+		} else {
+			if (__user_copy_pt((unsigned long) src, dst, len, 0))
+				return -EFAULT;
+		}
+		len_str = strnlen(dst, len);
+		done += len_str;
+		src += len_str;
+		dst += len_str;
+	} while ((len_str == len) && (done < count));
+	return done;
 }
 
 static size_t copy_in_user_pt(size_t n, void __user *to,
@@ -231,10 +288,8 @@ static size_t copy_in_user_pt(size_t n, void __user *to,
 	unsigned long kaddr_to, kaddr_from;
 	int write_user;
 
-	if (segment_eq(get_fs(), KERNEL_DS)) {
-		memcpy((void __force *) to, (void __force *) from, n);
-		return 0;
-	}
+	if (segment_eq(get_fs(), KERNEL_DS))
+		return copy_in_kernel(n, to, from);
 	done = 0;
 retry:
 	spin_lock(&mm->page_table_lock);
diff --git a/arch/s390/lib/uaccess_std.c b/arch/s390/lib/uaccess_std.c
index 6fbd063..4a75d47 100644
--- a/arch/s390/lib/uaccess_std.c
+++ b/arch/s390/lib/uaccess_std.c
@@ -188,6 +188,8 @@ size_t strnlen_user_std(size_t size, const char __user *src)
 	register unsigned long reg0 asm("0") = 0UL;
 	unsigned long tmp1, tmp2;
 
+	if (unlikely(!size))
+		return 0;
 	asm volatile(
 		"   la    %2,0(%1)\n"
 		"   la    %3,0(%0,%1)\n"
@@ -204,38 +206,24 @@ size_t strnlen_user_std(size_t size, const char __user *src)
 	return size;
 }
 
-size_t strncpy_from_user_std(size_t size, const char __user *src, char *dst)
+size_t strncpy_from_user_std(size_t count, const char __user *src, char *dst)
 {
-	register unsigned long reg0 asm("0") = 0UL;
-	unsigned long tmp1, tmp2;
+	size_t done, len, offset, len_str;
 
-	asm volatile(
-		"   la    %3,0(%1)\n"
-		"   la    %4,0(%0,%1)\n"
-		"   sacf  256\n"
-		"0: srst  %4,%3\n"
-		"   jo    0b\n"
-		"   sacf  0\n"
-		"   la    %0,0(%4)\n"
-		"   jh    1f\n"		/* found \0 in string ? */
-		"  "AHI"  %4,1\n"	/* include \0 in copy */
-		"1:"SLR"  %0,%1\n"	/* %0 = return length (without \0) */
-		"  "SLR"  %4,%1\n"	/* %4 = copy length (including \0) */
-		"2: mvcp  0(%4,%2),0(%1),%5\n"
-		"   jz    9f\n"
-		"3:"AHI"  %4,-256\n"
-		"   la    %1,256(%1)\n"
-		"   la    %2,256(%2)\n"
-		"4: mvcp  0(%4,%2),0(%1),%5\n"
-		"   jnz   3b\n"
-		"   j     9f\n"
-		"7: sacf  0\n"
-		"8:"LHI"  %0,%6\n"
-		"9:\n"
-		EX_TABLE(0b,7b) EX_TABLE(2b,8b) EX_TABLE(4b,8b)
-		: "+a" (size), "+a" (src), "+d" (dst), "=a" (tmp1), "=a" (tmp2)
-		: "d" (reg0), "K" (-EFAULT) : "cc", "memory");
-	return size;
+	if (unlikely(!count))
+		return 0;
+	done = 0;
+	do {
+		offset = (size_t)src & ~PAGE_MASK;
+		len = min(count - done, PAGE_SIZE - offset);
+		if (copy_from_user_std(len, src, dst))
+			return -EFAULT;
+		len_str = strnlen(dst, len);
+		done += len_str;
+		src += len_str;
+		dst += len_str;
+	} while ((len_str == len) && (done < count));
+	return done;
 }
 
 #define __futex_atomic_op(insn, ret, oldval, newval, uaddr, oparg)	\
diff --git a/arch/s390/mm/dump_pagetables.c b/arch/s390/mm/dump_pagetables.c
index 04e4892..3ad65b0 100644
--- a/arch/s390/mm/dump_pagetables.c
+++ b/arch/s390/mm/dump_pagetables.c
@@ -49,10 +49,13 @@ static void print_prot(struct seq_file *m, unsigned int pr, int level)
 		{ "ASCE", "PGD", "PUD", "PMD", "PTE" };
 
 	seq_printf(m, "%s ", level_name[level]);
-	if (pr & _PAGE_INVALID)
+	if (pr & _PAGE_INVALID) {
 		seq_printf(m, "I\n");
-	else
-		seq_printf(m, "%s\n", pr & _PAGE_RO ? "RO" : "RW");
+		return;
+	}
+	seq_printf(m, "%s", pr & _PAGE_RO ? "RO " : "RW ");
+	seq_printf(m, "%s", pr & _PAGE_CO ? "CO " : "   ");
+	seq_putc(m, '\n');
 }
 
 static void note_page(struct seq_file *m, struct pg_state *st,
@@ -125,6 +128,12 @@ static void walk_pte_level(struct seq_file *m, struct pg_state *st,
 	}
 }
 
+#ifdef CONFIG_64BIT
+#define _PMD_PROT_MASK (_SEGMENT_ENTRY_RO | _SEGMENT_ENTRY_CO)
+#else
+#define _PMD_PROT_MASK 0
+#endif
+
 static void walk_pmd_level(struct seq_file *m, struct pg_state *st,
 			   pud_t *pud, unsigned long addr)
 {
@@ -137,7 +146,7 @@ static void walk_pmd_level(struct seq_file *m, struct pg_state *st,
 		pmd = pmd_offset(pud, addr);
 		if (!pmd_none(*pmd)) {
 			if (pmd_large(*pmd)) {
-				prot = pmd_val(*pmd) & _SEGMENT_ENTRY_RO;
+				prot = pmd_val(*pmd) & _PMD_PROT_MASK;
 				note_page(m, st, prot, 3);
 			} else
 				walk_pte_level(m, st, pmd, addr);
@@ -147,6 +156,12 @@ static void walk_pmd_level(struct seq_file *m, struct pg_state *st,
 	}
 }
 
+#ifdef CONFIG_64BIT
+#define _PUD_PROT_MASK (_REGION3_ENTRY_RO | _REGION3_ENTRY_CO)
+#else
+#define _PUD_PROT_MASK 0
+#endif
+
 static void walk_pud_level(struct seq_file *m, struct pg_state *st,
 			   pgd_t *pgd, unsigned long addr)
 {
@@ -159,7 +174,7 @@ static void walk_pud_level(struct seq_file *m, struct pg_state *st,
 		pud = pud_offset(pgd, addr);
 		if (!pud_none(*pud))
 			if (pud_large(*pud)) {
-				prot = pud_val(*pud) & _PAGE_RO;
+				prot = pud_val(*pud) & _PUD_PROT_MASK;
 				note_page(m, st, prot, 2);
 			} else
 				walk_pmd_level(m, st, pud, addr);
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index e21aaf4..ffab84d 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -236,7 +236,8 @@ int __meminit vmemmap_populate(struct page *start, unsigned long nr, int node)
 				if (!new_page)
 					goto out;
 				pmd_val(*pm_dir) = __pa(new_page) |
-					_SEGMENT_ENTRY | _SEGMENT_ENTRY_LARGE;
+					_SEGMENT_ENTRY | _SEGMENT_ENTRY_LARGE |
+					_SEGMENT_ENTRY_CO;
 				address = (address + PMD_SIZE) & PMD_MASK;
 				continue;
 			}
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 6e9cc76..3ec5ef2 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -22,7 +22,7 @@ config SERIO_I8042
 	tristate "i8042 PC Keyboard controller" if EXPERT || !X86
 	default y
 	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
-		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN
+		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN && !S390
 	help
 	  i8042 is the chip over which the standard AT keyboard and PS/2
 	  mouse are connected to the computer. If you use these devices,
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 33f26bf..6999fd9 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -1573,7 +1573,10 @@ static void dasd_eckd_do_validate_server(struct work_struct *work)
 {
 	struct dasd_device *device = container_of(work, struct dasd_device,
 						  kick_validate);
-	if (dasd_eckd_validate_server(device, DASD_CQR_FLAGS_FAILFAST)
+	unsigned long flags = 0;
+
+	set_bit(DASD_CQR_FLAGS_FAILFAST, &flags);
+	if (dasd_eckd_validate_server(device, flags)
 	    == -EAGAIN) {
 		/* schedule worker again if failed */
 		schedule_work(&device->kick_validate);
@@ -4157,6 +4160,7 @@ static int dasd_eckd_restore_device(struct dasd_device *device)
 	int rc;
 	struct dasd_uid temp_uid;
 	unsigned long flags;
+	unsigned long cqr_flags = 0;
 
 	private = (struct dasd_eckd_private *) device->private;
 
@@ -4178,7 +4182,9 @@ static int dasd_eckd_restore_device(struct dasd_device *device)
 	rc = dasd_alias_make_device_known_to_lcu(device);
 	if (rc)
 		return rc;
-	dasd_eckd_validate_server(device, DASD_CQR_FLAGS_FAILFAST);
+
+	set_bit(DASD_CQR_FLAGS_FAILFAST, &cqr_flags);
+	dasd_eckd_validate_server(device, cqr_flags);
 
 	/* RE-Read Configuration Data */
 	dasd_eckd_read_conf(device);
diff --git a/drivers/s390/cio/qdio_debug.c b/drivers/s390/cio/qdio_debug.c
index 749b727..ccaae9d 100644
--- a/drivers/s390/cio/qdio_debug.c
+++ b/drivers/s390/cio/qdio_debug.c
@@ -232,7 +232,8 @@ static struct file_operations debugfs_perf_fops = {
 	.llseek  = seq_lseek,
 	.release = single_release,
 };
-static void setup_debugfs_entry(struct qdio_q *q, struct ccw_device *cdev)
+
+static void setup_debugfs_entry(struct qdio_q *q)
 {
 	char name[QDIO_DEBUGFS_NAME_LEN];
 
@@ -263,12 +264,12 @@ void qdio_setup_debug_entries(struct qdio_irq *irq_ptr, struct ccw_device *cdev)
 		irq_ptr->debugfs_perf = NULL;
 
 	for_each_input_queue(irq_ptr, q, i)
-		setup_debugfs_entry(q, cdev);
+		setup_debugfs_entry(q);
 	for_each_output_queue(irq_ptr, q, i)
-		setup_debugfs_entry(q, cdev);
+		setup_debugfs_entry(q);
 }
 
-void qdio_shutdown_debug_entries(struct qdio_irq *irq_ptr, struct ccw_device *cdev)
+void qdio_shutdown_debug_entries(struct qdio_irq *irq_ptr)
 {
 	struct qdio_q *q;
 	int i;
diff --git a/drivers/s390/cio/qdio_debug.h b/drivers/s390/cio/qdio_debug.h
index 7f8b973..647b422 100644
--- a/drivers/s390/cio/qdio_debug.h
+++ b/drivers/s390/cio/qdio_debug.h
@@ -85,8 +85,7 @@ void qdio_allocate_dbf(struct qdio_initialize *init_data,
 		       struct qdio_irq *irq_ptr);
 void qdio_setup_debug_entries(struct qdio_irq *irq_ptr,
 			      struct ccw_device *cdev);
-void qdio_shutdown_debug_entries(struct qdio_irq *irq_ptr,
-				 struct ccw_device *cdev);
+void qdio_shutdown_debug_entries(struct qdio_irq *irq_ptr);
 int qdio_debug_init(void);
 void qdio_debug_exit(void);
 
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index abc550e..843051b 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -1226,7 +1226,7 @@ int qdio_shutdown(struct ccw_device *cdev, int how)
 
 	tiqdio_remove_input_queues(irq_ptr);
 	qdio_shutdown_queues(cdev);
-	qdio_shutdown_debug_entries(irq_ptr, cdev);
+	qdio_shutdown_debug_entries(irq_ptr);
 
 	/* cleanup subchannel */
 	spin_lock_irqsave(get_ccwdev_lock(cdev), flags);


-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.



-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

