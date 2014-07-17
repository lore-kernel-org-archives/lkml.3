Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934234AbaGQPN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:13:58 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22643 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933147AbaGQPN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:13:57 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: hpa@zytor.com
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] x86-64, espfix: consider IRQs are off when initializing
Date: Thu, 17 Jul 2014 11:13:35 -0400
Message-Id: <1405610015-27464-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.9.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When going through our initialization code (init_espfix_ap() ) we need to
keep in mind IRQs are off, and we need to handle it appropriately:

 - Do not allocate with __GFP_FS.
 - No point in using a mutex.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/x86/kernel/espfix_64.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/espfix_64.c b/arch/x86/kernel/espfix_64.c
index 6afbb16..3ef78ce 100644
--- a/arch/x86/kernel/espfix_64.c
+++ b/arch/x86/kernel/espfix_64.c
@@ -64,7 +64,7 @@ DEFINE_PER_CPU_READ_MOSTLY(unsigned long, espfix_stack);
 DEFINE_PER_CPU_READ_MOSTLY(unsigned long, espfix_waddr);
 
 /* Initialization mutex - should this be a spinlock? */
-static DEFINE_MUTEX(espfix_init_mutex);
+static DEFINE_SPINLOCK(espfix_init_mutex);
 
 /* Page allocation bitmap - each page serves ESPFIX_STACKS_PER_PAGE CPUs */
 #define ESPFIX_MAX_PAGES  DIV_ROUND_UP(CONFIG_NR_CPUS, ESPFIX_STACKS_PER_PAGE)
@@ -161,7 +161,7 @@ void init_espfix_ap(void)
 	if (likely(stack_page))
 		goto done;
 
-	mutex_lock(&espfix_init_mutex);
+	spin_lock(&espfix_init_mutex);
 
 	/* Did we race on the lock? */
 	stack_page = ACCESS_ONCE(espfix_pages[page]);
@@ -191,7 +191,7 @@ void init_espfix_ap(void)
 	}
 
 	pte_p = pte_offset_kernel(&pmd, addr);
-	stack_page = (void *)__get_free_page(GFP_KERNEL);
+	stack_page = (void *)__get_free_page(GFP_ATOMIC);
 	pte = __pte(__pa(stack_page) | (__PAGE_KERNEL_RO & ptemask));
 	paravirt_alloc_pte(&init_mm, __pa(stack_page) >> PAGE_SHIFT);
 	for (n = 0; n < ESPFIX_PTE_CLONES; n++)
@@ -201,7 +201,7 @@ void init_espfix_ap(void)
 	ACCESS_ONCE(espfix_pages[page]) = stack_page;
 
 unlock_done:
-	mutex_unlock(&espfix_init_mutex);
+	spin_unlock(&espfix_init_mutex);
 done:
 	this_cpu_write(espfix_stack, addr);
 	this_cpu_write(espfix_waddr, (unsigned long)stack_page
-- 
1.7.10.4

