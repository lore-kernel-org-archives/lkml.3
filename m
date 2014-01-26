Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaAZVZL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 16:25:11 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:49593 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbaAZVZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 16:25:09 -0500
From: Yann Droneaud <ydroneaud@opteya.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] random: remove unused len argument in randomize_range() function
Date: Sun, 26 Jan 2014 22:20:38 +0100
Message-Id: <e1fb4dde971f2c008411d872d096e04e14c5a466.1390770607.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <cover.1390770607.git.ydroneaud@opteya.com>
References: <cover.1390770607.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1390770607.git.ydroneaud@opteya.com>
References: <cover.1390770607.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

randomize_range() accepts a third parameter as the size of the object
to randomly fit in the range [PAGE_ALIGN(start), PAGE_ALIGN(end)].
The functions returns an address in the range [PAGE_ALIGN(start),
PAGE_ALIGN(end - len)].

But no kernel code is currently using the third parameter:
it's hardcoded to 0 in each functions calling randomize_range().

So len argument is useless in the current codebase and can be safely
removed: this patch removes the len argument from randomize_range()
and fixes code using randomize_range() with len set to 0.

Link: http://lkml.kernel.org/r/cover.1390770607.git.ydroneaud@opteya.com
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 arch/arm/kernel/process.c       |  2 +-
 arch/arm64/kernel/process.c     |  2 +-
 arch/tile/mm/mmap.c             |  2 +-
 arch/unicore32/kernel/process.c |  2 +-
 arch/x86/kernel/process.c       |  2 +-
 arch/x86/kernel/sys_x86_64.c    |  2 +-
 drivers/char/random.c           | 17 ++++++-----------
 include/linux/random.h          |  2 +-
 8 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 92f7b15dd221..a13d456cc8d1 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -428,7 +428,7 @@ unsigned long get_wchan(struct task_struct *p)
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
 	unsigned long range_end = mm->brk + 0x02000000;
-	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
+	return randomize_range(mm->brk, range_end) ? : mm->brk;
 }
 
 #ifdef CONFIG_MMU
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 1e5a17811648..855c49be0050 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -340,7 +340,7 @@ unsigned long arch_align_stack(unsigned long sp)
 static unsigned long randomize_base(unsigned long base)
 {
 	unsigned long range_end = base + (STACK_RND_MASK << PAGE_SHIFT) + 1;
-	return randomize_range(base, range_end, 0) ? : base;
+	return randomize_range(base, range_end) ? : base;
 }
 
 unsigned long arch_randomize_brk(struct mm_struct *mm)
diff --git a/arch/tile/mm/mmap.c b/arch/tile/mm/mmap.c
index 851a94e6ae58..bc29e8ce0d27 100644
--- a/arch/tile/mm/mmap.c
+++ b/arch/tile/mm/mmap.c
@@ -89,5 +89,5 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
 	unsigned long range_end = mm->brk + 0x02000000;
-	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
+	return randomize_range(mm->brk, range_end) ? : mm->brk;
 }
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index 778ebba80827..79a4423c48ba 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -302,7 +302,7 @@ unsigned long get_wchan(struct task_struct *p)
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
 	unsigned long range_end = mm->brk + 0x02000000;
-	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
+	return randomize_range(mm->brk, range_end) ? : mm->brk;
 }
 
 /*
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 3fb8d95ab8b5..2db44a7147d1 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -466,6 +466,6 @@ unsigned long arch_align_stack(unsigned long sp)
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
 	unsigned long range_end = mm->brk + 0x02000000;
-	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
+	return randomize_range(mm->brk, range_end) ? : mm->brk;
 }
 
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 30277e27431a..5cd395f21a25 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -96,7 +96,7 @@ static void find_start_end(unsigned long flags, unsigned long *begin,
 		*begin = 0x40000000;
 		*end = 0x80000000;
 		if (current->flags & PF_RANDOMIZE) {
-			new_begin = randomize_range(*begin, *begin + 0x02000000, 0);
+			new_begin = randomize_range(*begin, *begin + 0x02000000);
 			if (new_begin)
 				*begin = new_begin;
 		}
diff --git a/drivers/char/random.c b/drivers/char/random.c
index d07575c99a5f..115b5a5381fb 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1634,20 +1634,15 @@ unsigned int get_random_int(void)
 EXPORT_SYMBOL(get_random_int);
 
 /*
- * randomize_range() returns a start address such that
+ * randomize_range() returns a page aligned random address
+ * in range [PAGE_ALIGN(start), PAGE_ALIGN(end)].
  *
- *    [...... <range> .....]
- *  start                  end
- *
- * a <range> with size "len" starting at the return value is inside in the
- * area defined by [start, end], but is otherwise randomized.
  */
 unsigned long
-randomize_range(unsigned long start, unsigned long end, unsigned long len)
+randomize_range(unsigned long start, unsigned long end)
 {
-	unsigned long range = end - len - start;
-
-	if (end <= start + len)
+	if (end <= start)
 		return 0;
-	return PAGE_ALIGN(get_random_int() % range + start);
+
+	return PAGE_ALIGN(get_random_int() % (end - start) + start);
 }
diff --git a/include/linux/random.h b/include/linux/random.h
index 1cfce0e24dbd..9416a0ff129d 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -23,7 +23,7 @@ extern const struct file_operations random_fops, urandom_fops;
 #endif
 
 unsigned int get_random_int(void);
-unsigned long randomize_range(unsigned long start, unsigned long end, unsigned long len);
+unsigned long randomize_range(unsigned long start, unsigned long end);
 
 u32 prandom_u32(void);
 void prandom_bytes(void *buf, int nbytes);
-- 
1.8.5.3

