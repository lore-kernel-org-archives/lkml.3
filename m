Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaLELSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:18:31 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:37153 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaLELS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:18:27 -0500
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        heiko.carstens@de.ibm.com, dahi@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com, mst@redhat.com,
        tglx@linutronix.de, David.Laight@ACULAB.COM, peterz@infradead.org,
        hughd@google.com, hocko@suse.cz
Subject: [PATCH v1 4/5] uaccess: clearify that uaccess may only sleep if pagefaults are not disabled
Date: Fri,  5 Dec 2014 12:18:08 +0100
Message-Id: <1417778289-51567-5-git-send-email-dahi@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1417778289-51567-1-git-send-email-dahi@linux.vnet.ibm.com>
References: <1417778289-51567-1-git-send-email-dahi@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120511-0029-0000-0000-0000020973A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In general, non-atomic variants of user access functions may not sleep if
pagefaults are disabled.

Let's update all relevant comments in uaccess code. This also refelects the
might_sleep() checks in might_fault().

Signed-off-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
---
 arch/avr32/include/asm/uaccess.h      | 12 ++++++----
 arch/hexagon/include/asm/uaccess.h    |  3 ++-
 arch/m32r/include/asm/uaccess.h       | 30 +++++++++++++++--------
 arch/microblaze/include/asm/uaccess.h |  6 +++--
 arch/mips/include/asm/uaccess.h       | 45 +++++++++++++++++++++++------------
 arch/s390/include/asm/uaccess.h       | 15 ++++++++----
 arch/score/include/asm/uaccess.h      | 15 ++++++++----
 arch/tile/include/asm/uaccess.h       | 21 ++++++++++------
 arch/x86/include/asm/uaccess.h        | 15 ++++++++----
 arch/x86/include/asm/uaccess_32.h     |  6 +++--
 arch/x86/lib/usercopy_32.c            |  6 +++--
 lib/strnlen_user.c                    |  6 +++--
 12 files changed, 120 insertions(+), 60 deletions(-)

diff --git a/arch/avr32/include/asm/uaccess.h b/arch/avr32/include/asm/uaccess.h
index 245b2ee..6b6dd58 100644
--- a/arch/avr32/include/asm/uaccess.h
+++ b/arch/avr32/include/asm/uaccess.h
@@ -97,7 +97,8 @@ static inline __kernel_size_t __copy_from_user(void *to,
  * @x:   Value to copy to user space.
  * @ptr: Destination address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple value from kernel space to user
  * space.  It supports simple types like char and int, but not larger
@@ -116,7 +117,8 @@ static inline __kernel_size_t __copy_from_user(void *to,
  * @x:   Variable to store result.
  * @ptr: Source address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple variable from user space to kernel
  * space.  It supports simple types like char and int, but not larger
@@ -136,7 +138,8 @@ static inline __kernel_size_t __copy_from_user(void *to,
  * @x:   Value to copy to user space.
  * @ptr: Destination address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple value from kernel space to user
  * space.  It supports simple types like char and int, but not larger
@@ -158,7 +161,8 @@ static inline __kernel_size_t __copy_from_user(void *to,
  * @x:   Variable to store result.
  * @ptr: Source address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple variable from user space to kernel
  * space.  It supports simple types like char and int, but not larger
diff --git a/arch/hexagon/include/asm/uaccess.h b/arch/hexagon/include/asm/uaccess.h
index e4127e4..af98618 100644
--- a/arch/hexagon/include/asm/uaccess.h
+++ b/arch/hexagon/include/asm/uaccess.h
@@ -36,7 +36,8 @@
  * @addr: User space pointer to start of block to check
  * @size: Size of block to check
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ * disabled.
  *
  * Checks if a pointer to a block of memory in user space is valid.
  *
diff --git a/arch/m32r/include/asm/uaccess.h b/arch/m32r/include/asm/uaccess.h
index 84fe7ba..83bfa33 100644
--- a/arch/m32r/include/asm/uaccess.h
+++ b/arch/m32r/include/asm/uaccess.h
@@ -91,7 +91,8 @@ static inline void set_fs(mm_segment_t s)
  * @addr: User space pointer to start of block to check
  * @size: Size of block to check
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Checks if a pointer to a block of memory in user space is valid.
  *
@@ -155,7 +156,8 @@ extern int fixup_exception(struct pt_regs *regs);
  * @x:   Variable to store result.
  * @ptr: Source address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple variable from user space to kernel
  * space.  It supports simple types like char and int, but not larger
@@ -175,7 +177,8 @@ extern int fixup_exception(struct pt_regs *regs);
  * @x:   Value to copy to user space.
  * @ptr: Destination address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple value from kernel space to user
  * space.  It supports simple types like char and int, but not larger
@@ -194,7 +197,8 @@ extern int fixup_exception(struct pt_regs *regs);
  * @x:   Variable to store result.
  * @ptr: Source address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple variable from user space to kernel
  * space.  It supports simple types like char and int, but not larger
@@ -274,7 +278,8 @@ do {									\
  * @x:   Value to copy to user space.
  * @ptr: Destination address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple value from kernel space to user
  * space.  It supports simple types like char and int, but not larger
@@ -568,7 +573,8 @@ unsigned long __generic_copy_from_user(void *, const void __user *, unsigned lon
  * @from: Source address, in kernel space.
  * @n:    Number of bytes to copy.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from kernel space to user space.  Caller must check
  * the specified block with access_ok() before calling this function.
@@ -588,7 +594,8 @@ unsigned long __generic_copy_from_user(void *, const void __user *, unsigned lon
  * @from: Source address, in kernel space.
  * @n:    Number of bytes to copy.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from kernel space to user space.
  *
@@ -606,7 +613,8 @@ unsigned long __generic_copy_from_user(void *, const void __user *, unsigned lon
  * @from: Source address, in user space.
  * @n:    Number of bytes to copy.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from user space to kernel space.  Caller must check
  * the specified block with access_ok() before calling this function.
@@ -626,7 +634,8 @@ unsigned long __generic_copy_from_user(void *, const void __user *, unsigned lon
  * @from: Source address, in user space.
  * @n:    Number of bytes to copy.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from user space to kernel space.
  *
@@ -677,7 +686,8 @@ unsigned long clear_user(void __user *mem, unsigned long len);
  * strlen_user: - Get the size of a string in user space.
  * @str: The string to measure.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Get the size of a NUL-terminated string in user space.
  *
diff --git a/arch/microblaze/include/asm/uaccess.h b/arch/microblaze/include/asm/uaccess.h
index 59a89a6..53bfbb8 100644
--- a/arch/microblaze/include/asm/uaccess.h
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -178,7 +178,8 @@ extern long __user_bad(void);
  * @x:   Variable to store result.
  * @ptr: Source address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple variable from user space to kernel
  * space.  It supports simple types like char and int, but not larger
@@ -290,7 +291,8 @@ extern long __user_bad(void);
  * @x:   Value to copy to user space.
  * @ptr: Destination address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple value from kernel space to user
  * space.  It supports simple types like char and int, but not larger
diff --git a/arch/mips/include/asm/uaccess.h b/arch/mips/include/asm/uaccess.h
index 22a5624..eded117 100644
--- a/arch/mips/include/asm/uaccess.h
+++ b/arch/mips/include/asm/uaccess.h
@@ -103,7 +103,8 @@ extern u64 __ua_limit;
  * @addr: User space pointer to start of block to check
  * @size: Size of block to check
  *
- * Context: User context only.	This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Checks if a pointer to a block of memory in user space is valid.
  *
@@ -138,7 +139,8 @@ extern u64 __ua_limit;
  * @x:	 Value to copy to user space.
  * @ptr: Destination address, in user space.
  *
- * Context: User context only.	This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple value from kernel space to user
  * space.  It supports simple types like char and int, but not larger
@@ -157,7 +159,8 @@ extern u64 __ua_limit;
  * @x:	 Variable to store result.
  * @ptr: Source address, in user space.
  *
- * Context: User context only.	This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple variable from user space to kernel
  * space.  It supports simple types like char and int, but not larger
@@ -177,7 +180,8 @@ extern u64 __ua_limit;
  * @x:	 Value to copy to user space.
  * @ptr: Destination address, in user space.
  *
- * Context: User context only.	This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple value from kernel space to user
  * space.  It supports simple types like char and int, but not larger
@@ -199,7 +203,8 @@ extern u64 __ua_limit;
  * @x:	 Variable to store result.
  * @ptr: Source address, in user space.
  *
- * Context: User context only.	This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple variable from user space to kernel
  * space.  It supports simple types like char and int, but not larger
@@ -498,7 +503,8 @@ extern void __put_user_unknown(void);
  * @x:	 Value to copy to user space.
  * @ptr: Destination address, in user space.
  *
- * Context: User context only.	This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple value from kernel space to user
  * space.  It supports simple types like char and int, but not larger
@@ -517,7 +523,8 @@ extern void __put_user_unknown(void);
  * @x:	 Variable to store result.
  * @ptr: Source address, in user space.
  *
- * Context: User context only.	This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple variable from user space to kernel
  * space.  It supports simple types like char and int, but not larger
@@ -537,7 +544,8 @@ extern void __put_user_unknown(void);
  * @x:	 Value to copy to user space.
  * @ptr: Destination address, in user space.
  *
- * Context: User context only.	This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple value from kernel space to user
  * space.  It supports simple types like char and int, but not larger
@@ -559,7 +567,8 @@ extern void __put_user_unknown(void);
  * @x:	 Variable to store result.
  * @ptr: Source address, in user space.
  *
- * Context: User context only.	This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple variable from user space to kernel
  * space.  It supports simple types like char and int, but not larger
@@ -815,7 +824,8 @@ extern size_t __copy_user(void *__to, const void *__from, size_t __n);
  * @from: Source address, in kernel space.
  * @n:	  Number of bytes to copy.
  *
- * Context: User context only.	This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from kernel space to user space.  Caller must check
  * the specified block with access_ok() before calling this function.
@@ -888,7 +898,8 @@ extern size_t __copy_user_inatomic(void *__to, const void *__from, size_t __n);
  * @from: Source address, in kernel space.
  * @n:	  Number of bytes to copy.
  *
- * Context: User context only.	This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from kernel space to user space.
  *
@@ -1075,7 +1086,8 @@ extern size_t __copy_in_user_eva(void *__to, const void *__from, size_t __n);
  * @from: Source address, in user space.
  * @n:	  Number of bytes to copy.
  *
- * Context: User context only.	This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from user space to kernel space.  Caller must check
  * the specified block with access_ok() before calling this function.
@@ -1107,7 +1119,8 @@ extern size_t __copy_in_user_eva(void *__to, const void *__from, size_t __n);
  * @from: Source address, in user space.
  * @n:	  Number of bytes to copy.
  *
- * Context: User context only.	This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from user space to kernel space.
  *
@@ -1356,7 +1369,8 @@ static inline long __strlen_user(const char __user *s)
  * strlen_user: - Get the size of a string in user space.
  * @str: The string to measure.
  *
- * Context: User context only.	This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Get the size of a NUL-terminated string in user space.
  *
@@ -1425,7 +1439,8 @@ static inline long __strnlen_user(const char __user *s, long n)
  * strnlen_user: - Get the size of a string in user space.
  * @str: The string to measure.
  *
- * Context: User context only.	This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Get the size of a NUL-terminated string in user space.
  *
diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
index cd4c68e..1291da5 100644
--- a/arch/s390/include/asm/uaccess.h
+++ b/arch/s390/include/asm/uaccess.h
@@ -98,7 +98,8 @@ static inline unsigned long extable_fixup(const struct exception_table_entry *x)
  * @from: Source address, in user space.
  * @n:	  Number of bytes to copy.
  *
- * Context: User context only.	This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from user space to kernel space.  Caller must check
  * the specified block with access_ok() before calling this function.
@@ -118,7 +119,8 @@ unsigned long __must_check __copy_from_user(void *to, const void __user *from,
  * @from: Source address, in kernel space.
  * @n:	  Number of bytes to copy.
  *
- * Context: User context only.	This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from kernel space to user space.  Caller must check
  * the specified block with access_ok() before calling this function.
@@ -264,7 +266,8 @@ int __get_user_bad(void) __attribute__((noreturn));
  * @from: Source address, in kernel space.
  * @n:    Number of bytes to copy.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from kernel space to user space.
  *
@@ -290,7 +293,8 @@ __compiletime_warning("copy_from_user() buffer size is not provably correct")
  * @from: Source address, in user space.
  * @n:    Number of bytes to copy.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from user space to kernel space.
  *
@@ -348,7 +352,8 @@ static inline unsigned long strnlen_user(const char __user *src, unsigned long n
  * strlen_user: - Get the size of a string in user space.
  * @str: The string to measure.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Get the size of a NUL-terminated string in user space.
  *
diff --git a/arch/score/include/asm/uaccess.h b/arch/score/include/asm/uaccess.h
index ab66ddd..010a800 100644
--- a/arch/score/include/asm/uaccess.h
+++ b/arch/score/include/asm/uaccess.h
@@ -36,7 +36,8 @@
  * @addr: User space pointer to start of block to check
  * @size: Size of block to check
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Checks if a pointer to a block of memory in user space is valid.
  *
@@ -61,7 +62,8 @@
  * @x:   Value to copy to user space.
  * @ptr: Destination address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple value from kernel space to user
  * space.  It supports simple types like char and int, but not larger
@@ -79,7 +81,8 @@
  * @x:   Variable to store result.
  * @ptr: Source address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple variable from user space to kernel
  * space.  It supports simple types like char and int, but not larger
@@ -98,7 +101,8 @@
  * @x:   Value to copy to user space.
  * @ptr: Destination address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple value from kernel space to user
  * space.  It supports simple types like char and int, but not larger
@@ -119,7 +123,8 @@
  * @x:   Variable to store result.
  * @ptr: Source address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple variable from user space to kernel
  * space.  It supports simple types like char and int, but not larger
diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
index b6cde32..9efe668 100644
--- a/arch/tile/include/asm/uaccess.h
+++ b/arch/tile/include/asm/uaccess.h
@@ -78,7 +78,8 @@ int __range_ok(unsigned long addr, unsigned long size);
  * @addr: User space pointer to start of block to check
  * @size: Size of block to check
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Checks if a pointer to a block of memory in user space is valid.
  *
@@ -192,7 +193,8 @@ extern int __get_user_bad(void)
  * @x:   Variable to store result.
  * @ptr: Source address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple variable from user space to kernel
  * space.  It supports simple types like char and int, but not larger
@@ -272,7 +274,8 @@ extern int __put_user_bad(void)
  * @x:   Value to copy to user space.
  * @ptr: Destination address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple value from kernel space to user
  * space.  It supports simple types like char and int, but not larger
@@ -327,7 +330,8 @@ extern int __put_user_bad(void)
  * @from: Source address, in kernel space.
  * @n:    Number of bytes to copy.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from kernel space to user space.  Caller must check
  * the specified block with access_ok() before calling this function.
@@ -363,7 +367,8 @@ copy_to_user(void __user *to, const void *from, unsigned long n)
  * @from: Source address, in user space.
  * @n:    Number of bytes to copy.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from user space to kernel space.  Caller must check
  * the specified block with access_ok() before calling this function.
@@ -434,7 +439,8 @@ static inline unsigned long __must_check copy_from_user(void *to,
  * @from: Source address, in user space.
  * @n:    Number of bytes to copy.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from user space to user space.  Caller must check
  * the specified blocks with access_ok() before calling this function.
@@ -466,7 +472,8 @@ copy_in_user(void __user *to, const void __user *from, unsigned long n)
  * strlen_user: - Get the size of a string in user space.
  * @str: The string to measure.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Get the size of a NUL-terminated string in user space.
  *
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 0d592e0..014d8cb 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -74,7 +74,8 @@ static inline bool __chk_range_not_ok(unsigned long addr, unsigned long size, un
  * @addr: User space pointer to start of block to check
  * @size: Size of block to check
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Checks if a pointer to a block of memory in user space is valid.
  *
@@ -145,7 +146,8 @@ __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
  * @x:   Variable to store result.
  * @ptr: Source address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple variable from user space to kernel
  * space.  It supports simple types like char and int, but not larger
@@ -240,7 +242,8 @@ extern void __put_user_8(void);
  * @x:   Value to copy to user space.
  * @ptr: Destination address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple value from kernel space to user
  * space.  It supports simple types like char and int, but not larger
@@ -455,7 +458,8 @@ struct __large_struct { unsigned long buf[100]; };
  * @x:   Variable to store result.
  * @ptr: Source address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple variable from user space to kernel
  * space.  It supports simple types like char and int, but not larger
@@ -479,7 +483,8 @@ struct __large_struct { unsigned long buf[100]; };
  * @x:   Value to copy to user space.
  * @ptr: Destination address, in user space.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * This macro copies a single simple value from kernel space to user
  * space.  It supports simple types like char and int, but not larger
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index 3c03a5d..ae5b37f 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -70,7 +70,8 @@ __copy_to_user_inatomic(void __user *to, const void *from, unsigned long n)
  * @from: Source address, in kernel space.
  * @n:    Number of bytes to copy.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from kernel space to user space.  Caller must check
  * the specified block with access_ok() before calling this function.
@@ -117,7 +118,8 @@ __copy_from_user_inatomic(void *to, const void __user *from, unsigned long n)
  * @from: Source address, in user space.
  * @n:    Number of bytes to copy.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from user space to kernel space.  Caller must check
  * the specified block with access_ok() before calling this function.
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index e2f5e21..64ba86e 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -647,7 +647,8 @@ EXPORT_SYMBOL(__copy_from_user_ll_nocache_nozero);
  * @from: Source address, in kernel space.
  * @n:    Number of bytes to copy.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from kernel space to user space.
  *
@@ -668,7 +669,8 @@ EXPORT_SYMBOL(_copy_to_user);
  * @from: Source address, in user space.
  * @n:    Number of bytes to copy.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Copy data from user space to kernel space.
  *
diff --git a/lib/strnlen_user.c b/lib/strnlen_user.c
index a28df52..0013abd 100644
--- a/lib/strnlen_user.c
+++ b/lib/strnlen_user.c
@@ -84,7 +84,8 @@ static inline long do_strnlen_user(const char __user *src, unsigned long count,
  * @str: The string to measure.
  * @count: Maximum count (including NUL character)
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Get the size of a NUL-terminated string in user space.
  *
@@ -113,7 +114,8 @@ EXPORT_SYMBOL(strnlen_user);
  * strlen_user: - Get the size of a user string INCLUDING final NUL.
  * @str: The string to measure.
  *
- * Context: User context only.  This function may sleep.
+ * Context: User context only. This function may sleep if pagefaults are not
+ *          disabled.
  *
  * Get the size of a NUL-terminated string in user space.
  *
-- 
1.8.5.5

