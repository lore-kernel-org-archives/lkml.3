Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbaGEXYJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 19:24:09 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:59029 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbaGEXYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 19:24:07 -0400
From: Emil Goode <emilgoode@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        John Crispin <blogic@openwrt.org>, Jonas Gorski <jogo@openwrt.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] MIPS: Remove incorrect NULL check in local_flush_tlb_page()
Date: Sun,  6 Jul 2014 01:23:58 +0200
Message-Id: <1404602638-16447-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We check that the struct vm_area_struct pointer vma is NULL and then
dereference it a few lines below. The intent was to make sure vma is
not NULL but this is not necessary since the bug pre-dates GIT history
and seem to never have caused a problem. The tlb-4k and tlb-8k versions
of local_flush_tlb_page() don't bother checking if vma is NULL, also
vma is dereferenced before being passed to local_flush_tlb_page(),
thus it is safe to remove this NULL check.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 arch/mips/mm/tlb-r3k.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/mm/tlb-r3k.c b/arch/mips/mm/tlb-r3k.c
index d657493..4094bbd 100644
--- a/arch/mips/mm/tlb-r3k.c
+++ b/arch/mips/mm/tlb-r3k.c
@@ -158,7 +158,7 @@ void local_flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
 {
 	int cpu = smp_processor_id();
 
-	if (!vma || cpu_context(cpu, vma->vm_mm) != 0) {
+	if (cpu_context(cpu, vma->vm_mm) != 0) {
 		unsigned long flags;
 		int oldpid, newpid, idx;
 
-- 
1.7.10.4

