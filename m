Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab3H0BMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:12:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab3H0BHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Shorey <shoreyjeff@gmail.com>, Radu Caragea <sinaelgl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 67/74] Revert "x86 get_unmapped_area(): use proper mmap base for bottom-up direction"
Date: Mon, 26 Aug 2013 18:09:05 -0700
Message-Id: <20130827010438.367831189@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 5ea80f76a56605a190a7ea16846c82aa63dbd0aa upstream.

This reverts commit df54d6fa54275ce59660453e29d1228c2b45a826.

The commit isn't necessarily wrong, but because it recalculates the
random mmap_base every time, it seems to confuse user memory allocators
that expect contiguous mmap allocations even when the mmap address isn't
specified.

In particular, the MATLAB Java runtime seems to be unhappy. See

  https://bugzilla.kernel.org/show_bug.cgi?id=60774

So we'll want to apply the random offset only once, and Radu has a patch
for that.  Revert this older commit in order to apply the other one.

Reported-by: Jeff Shorey <shoreyjeff@gmail.com>
Cc: Radu Caragea <sinaelgl@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/sys_x86_64.c |    2 +-
 arch/x86/mm/mmap.c           |    2 +-
 include/linux/sched.h        |    1 -
 3 files changed, 2 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -101,7 +101,7 @@ static void find_start_end(unsigned long
 				*begin = new_begin;
 		}
 	} else {
-		*begin = mmap_legacy_base();
+		*begin = TASK_UNMAPPED_BASE;
 		*end = TASK_SIZE;
 	}
 }
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -98,7 +98,7 @@ static unsigned long mmap_base(void)
  * Bottom-up (legacy) layout on X86_32 did not support randomization, X86_64
  * does, but not when emulating X86_32
  */
-unsigned long mmap_legacy_base(void)
+static unsigned long mmap_legacy_base(void)
 {
 	if (mmap_is_ia32())
 		return TASK_UNMAPPED_BASE;
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -314,7 +314,6 @@ struct nsproxy;
 struct user_namespace;
 
 #ifdef CONFIG_MMU
-extern unsigned long mmap_legacy_base(void);
 extern void arch_pick_mmap_layout(struct mm_struct *mm);
 extern unsigned long
 arch_get_unmapped_area(struct file *, unsigned long, unsigned long,


