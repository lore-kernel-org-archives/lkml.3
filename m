Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806AbaFIJRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:17:48 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58401 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754824AbaFIIvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mark Salter <msalter@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 031/146] arm64: fix pud_huge() for 2-level pagetables
Date: Mon,  9 Jun 2014 10:49:26 +0200
Message-Id: <eb6fd856a4908a9205612c92acd8259540a3995a.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4797ec2dc83a43be35bad56037d1b53db9e2b5d5 upstream.

The following happens when trying to run a kvm guest on a kernel
configured for 64k pages. This doesn't happen with 4k pages:

  BUG: failure at include/linux/mm.h:297/put_page_testzero()!
  Kernel panic - not syncing: BUG!
  CPU: 2 PID: 4228 Comm: qemu-system-aar Tainted: GF            3.13.0-0.rc7.31.sa2.k32v1.aarch64.debug #1
  Call trace:
  [<fffffe0000096034>] dump_backtrace+0x0/0x16c
  [<fffffe00000961b4>] show_stack+0x14/0x1c
  [<fffffe000066e648>] dump_stack+0x84/0xb0
  [<fffffe0000668678>] panic+0xf4/0x220
  [<fffffe000018ec78>] free_reserved_area+0x0/0x110
  [<fffffe000018edd8>] free_pages+0x50/0x88
  [<fffffe00000a759c>] kvm_free_stage2_pgd+0x30/0x40
  [<fffffe00000a5354>] kvm_arch_destroy_vm+0x18/0x44
  [<fffffe00000a1854>] kvm_put_kvm+0xf0/0x184
  [<fffffe00000a1938>] kvm_vm_release+0x10/0x1c
  [<fffffe00001edc1c>] __fput+0xb0/0x288
  [<fffffe00001ede4c>] ____fput+0xc/0x14
  [<fffffe00000d5a2c>] task_work_run+0xa8/0x11c
  [<fffffe0000095c14>] do_notify_resume+0x54/0x58

In arch/arm/kvm/mmu.c:unmap_range(), we end up doing an extra put_page()
on the stage2 pgd which leads to the BUG in put_page_testzero(). This
happens because a pud_huge() test in unmap_range() returns true when it
should always be false with 2-level pages tables used by 64k pages.
This patch removes support for huge puds if 2-level pagetables are
being used.

Signed-off-by: Mark Salter <msalter@redhat.com>
[catalin.marinas@arm.com: removed #ifndef around PUD_SIZE check]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm64/mm/hugetlbpage.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 5e9aec358306..31eb959e9aa8 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -51,7 +51,11 @@ int pmd_huge(pmd_t pmd)
 
 int pud_huge(pud_t pud)
 {
+#ifndef __PAGETABLE_PMD_FOLDED
 	return !(pud_val(pud) & PUD_TABLE_BIT);
+#else
+	return 0;
+#endif
 }
 
 int pmd_huge_support(void)
-- 
1.9.3

