Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965230AbaGES1C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 14:27:02 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:38771 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965069AbaGES07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 14:26:59 -0400
From: Emil Goode <emilgoode@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        John Crispin <blogic@openwrt.org>, Jonas Gorski <jogo@openwrt.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH v2] MIPS: Fix incorrect NULL check in local_flush_tlb_page()
Date: Sat,  5 Jul 2014 20:26:52 +0200
Message-Id: <1404584812-12377-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We check that the struct vm_area_struct pointer vma is NULL and then
dereference it a few lines below. The intent must have been to make sure
that vma is not NULL and then to check the value from cpu_context() for
the condition to be true.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---

v2: Updated the commit message with a better explanation.

 arch/mips/mm/tlb-r3k.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/mm/tlb-r3k.c b/arch/mips/mm/tlb-r3k.c
index d657493..6546758 100644
--- a/arch/mips/mm/tlb-r3k.c
+++ b/arch/mips/mm/tlb-r3k.c
@@ -158,7 +158,7 @@ void local_flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
 {
 	int cpu = smp_processor_id();
 
-	if (!vma || cpu_context(cpu, vma->vm_mm) != 0) {
+	if (vma && cpu_context(cpu, vma->vm_mm) != 0) {
 		unsigned long flags;
 		int oldpid, newpid, idx;
 
-- 
1.7.10.4

