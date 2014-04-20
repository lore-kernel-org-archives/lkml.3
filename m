Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbaDTC2I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 22:28:08 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:57912 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbaDTC0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 22:26:48 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org
Cc: zeus@gnu.org, aswin@hp.com, davidlohr@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: [PATCH 3/6] mips: call find_vma with the mmap_sem held
Date: Sat, 19 Apr 2014 19:26:28 -0700
Message-Id: <1397960791-16320-4-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1397960791-16320-1-git-send-email-davidlohr@hp.com>
References: <1397960791-16320-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Performing vma lookups without taking the mm->mmap_sem is asking
for trouble. While doing the search, the vma in question can be
modified or even removed before returning to the caller. Take the
lock (exclusively) in order to avoid races while iterating through
the vmacache and/or rbtree.

Updates two functions:
  - process_fpemu_return()
  - cteon_flush_cache_sigtramp()

This patch is completely *untested*.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/kernel/traps.c | 2 ++
 arch/mips/mm/c-octeon.c  | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 074e857..c51bd20 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -712,10 +712,12 @@ int process_fpemu_return(int sig, void __user *fault_addr)
 		si.si_addr = fault_addr;
 		si.si_signo = sig;
 		if (sig == SIGSEGV) {
+			down_read(&current->mm->mmap_sem);
 			if (find_vma(current->mm, (unsigned long)fault_addr))
 				si.si_code = SEGV_ACCERR;
 			else
 				si.si_code = SEGV_MAPERR;
+			up_read(&current->mm->mmap_sem);
 		} else {
 			si.si_code = BUS_ADRERR;
 		}
diff --git a/arch/mips/mm/c-octeon.c b/arch/mips/mm/c-octeon.c
index f41a5c5..05b1d7c 100644
--- a/arch/mips/mm/c-octeon.c
+++ b/arch/mips/mm/c-octeon.c
@@ -137,8 +137,10 @@ static void octeon_flush_cache_sigtramp(unsigned long addr)
 {
 	struct vm_area_struct *vma;
 
+	down_read(&current->mm->mmap_sem);
 	vma = find_vma(current->mm, addr);
 	octeon_flush_icache_all_cores(vma);
+	up_read(&current->mm->mmap_sem);
 }
 
 
-- 
1.8.1.4

