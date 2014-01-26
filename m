Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaAZVVK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 16:21:10 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:60162 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbaAZVVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 16:21:04 -0500
From: Yann Droneaud <ydroneaud@opteya.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Yann Droneaud <ydroneaud@opteya.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] random: don't return 0 in randomize_range()
Date: Sun, 26 Jan 2014 22:20:39 +0100
Message-Id: <a5cabde16c40fd3675efaeec37245ad4123beba1.1390770607.git.ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <cover.1390770607.git.ydroneaud@opteya.com>
References: <cover.1390770607.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1390770607.git.ydroneaud@opteya.com>
References: <cover.1390770607.git.ydroneaud@opteya.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

randomize_range() returns 0 when 'end' address is below 'start'
address: it's an error to pass an invalid range to the function.

Code using randomize_range() deals with such error silently and
use the start address instead.

This patch makes randomize_range() issue a warning with WARN_ON()
when its parameters are invalid and returns the start address, so
that code using the function doesn't have to handle an error which
is not supposed to happen. The patch also removes the code handling
the error in functions using randomize_range().

Link: http://lkml.kernel.org/r/cover.1390770607.git.ydroneaud@opteya.com
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 arch/arm/kernel/process.c    | 2 +-
 arch/tile/mm/mmap.c          | 2 +-
 arch/x86/kernel/process.c    | 2 +-
 arch/x86/kernel/sys_x86_64.c | 5 +----
 drivers/char/random.c        | 4 +++-
 5 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index a13d456cc8d1..005a8ba04739 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -428,7 +428,7 @@ unsigned long get_wchan(struct task_struct *p)
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
 	unsigned long range_end = mm->brk + 0x02000000;
-	return randomize_range(mm->brk, range_end) ? : mm->brk;
+	return randomize_range(mm->brk, range_end);
 }
 
 #ifdef CONFIG_MMU
diff --git a/arch/tile/mm/mmap.c b/arch/tile/mm/mmap.c
index bc29e8ce0d27..294292714f34 100644
--- a/arch/tile/mm/mmap.c
+++ b/arch/tile/mm/mmap.c
@@ -89,5 +89,5 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
 	unsigned long range_end = mm->brk + 0x02000000;
-	return randomize_range(mm->brk, range_end) ? : mm->brk;
+	return randomize_range(mm->brk, range_end);
 }
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 2db44a7147d1..076358128404 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -466,6 +466,6 @@ unsigned long arch_align_stack(unsigned long sp)
 unsigned long arch_randomize_brk(struct mm_struct *mm)
 {
 	unsigned long range_end = mm->brk + 0x02000000;
-	return randomize_range(mm->brk, range_end) ? : mm->brk;
+	return randomize_range(mm->brk, range_end);
 }
 
diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 5cd395f21a25..7b2a029e63fb 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -85,7 +85,6 @@ static void find_start_end(unsigned long flags, unsigned long *begin,
 			   unsigned long *end)
 {
 	if (!test_thread_flag(TIF_ADDR32) && (flags & MAP_32BIT)) {
-		unsigned long new_begin;
 		/* This is usually used needed to map code in small
 		   model, so it needs to be in the first 31bit. Limit
 		   it to that.  This means we need to move the
@@ -96,9 +95,7 @@ static void find_start_end(unsigned long flags, unsigned long *begin,
 		*begin = 0x40000000;
 		*end = 0x80000000;
 		if (current->flags & PF_RANDOMIZE) {
-			new_begin = randomize_range(*begin, *begin + 0x02000000);
-			if (new_begin)
-				*begin = new_begin;
+			*begin = randomize_range(*begin, *begin + 0x02000000);
 		}
 	} else {
 		*begin = current->mm->mmap_legacy_base;
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 115b5a5381fb..7c7c47e220ca 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1641,8 +1641,10 @@ EXPORT_SYMBOL(get_random_int);
 unsigned long
 randomize_range(unsigned long start, unsigned long end)
 {
+	WARN_ON(end <= start);
+
 	if (end <= start)
-		return 0;
+		return start;
 
 	return PAGE_ALIGN(get_random_int() % (end - start) + start);
 }
-- 
1.8.5.3

