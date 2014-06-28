Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbaF1SnX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:43:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360AbaF1RuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:50:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jianguo Wu <wujianguo@huawei.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.14 067/110] ARM: 8037/1: mm: support big-endian page tables
Date: Sat, 28 Jun 2014 10:47:04 -0700
Message-Id: <20140628174549.570630377@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianguo Wu <wujianguo@huawei.com>

commit 86f40622af7329375e38f282f6c0aab95f3e5f72 upstream.

When enable LPAE and big-endian in a hisilicon board, while specify
mem=384M mem=512M@7680M, will get bad page state:

Freeing unused kernel memory: 180K (c0466000 - c0493000)
BUG: Bad page state in process init  pfn:fa442
page:c7749840 count:0 mapcount:-1 mapping:  (null) index:0x0
page flags: 0x40000400(reserved)
Modules linked in:
CPU: 0 PID: 1 Comm: init Not tainted 3.10.27+ #66
[<c000f5f0>] (unwind_backtrace+0x0/0x11c) from [<c000cbc4>] (show_stack+0x10/0x14)
[<c000cbc4>] (show_stack+0x10/0x14) from [<c009e448>] (bad_page+0xd4/0x104)
[<c009e448>] (bad_page+0xd4/0x104) from [<c009e520>] (free_pages_prepare+0xa8/0x14c)
[<c009e520>] (free_pages_prepare+0xa8/0x14c) from [<c009f8ec>] (free_hot_cold_page+0x18/0xf0)
[<c009f8ec>] (free_hot_cold_page+0x18/0xf0) from [<c00b5444>] (handle_pte_fault+0xcf4/0xdc8)
[<c00b5444>] (handle_pte_fault+0xcf4/0xdc8) from [<c00b6458>] (handle_mm_fault+0xf4/0x120)
[<c00b6458>] (handle_mm_fault+0xf4/0x120) from [<c0013754>] (do_page_fault+0xfc/0x354)
[<c0013754>] (do_page_fault+0xfc/0x354) from [<c0008400>] (do_DataAbort+0x2c/0x90)
[<c0008400>] (do_DataAbort+0x2c/0x90) from [<c0008fb4>] (__dabt_usr+0x34/0x40)

The bad pfn:fa442 is not system memory(mem=384M mem=512M@7680M), after debugging,
I find in page fault handler, will get wrong pfn from pte just after set pte,
as follow:
do_anonymous_page()
{
	...
	set_pte_at(mm, address, page_table, entry);

	//debug code
	pfn = pte_pfn(entry);
	pr_info("pfn:0x%lx, pte:0x%llxn", pfn, pte_val(entry));

	//read out the pte just set
	new_pte = pte_offset_map(pmd, address);
	new_pfn = pte_pfn(*new_pte);
	pr_info("new pfn:0x%lx, new pte:0x%llxn", pfn, pte_val(entry));
	...
}

pfn:   0x1fa4f5,     pte:0xc00001fa4f575f
new_pfn:0xfa4f5, new_pte:0xc00000fa4f5f5f	//new pfn/pte is wrong.

The bug is happened in cpu_v7_set_pte_ext(ptep, pte):
An LPAE PTE is a 64bit quantity, passed to cpu_v7_set_pte_ext in the r2 and r3 registers.
On an LE kernel, r2 contains the LSB of the PTE, and r3 the MSB.
On a BE kernel, the assignment is reversed.

Unfortunately, the current code always assumes the LE case,
leading to corruption of the PTE when clearing/setting bits.

This patch fixes this issue much like it has been done already in the
cpu_v7_switch_mm case.

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/proc-v7-3level.S |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/arch/arm/mm/proc-v7-3level.S
+++ b/arch/arm/mm/proc-v7-3level.S
@@ -64,6 +64,14 @@ ENTRY(cpu_v7_switch_mm)
 	mov	pc, lr
 ENDPROC(cpu_v7_switch_mm)
 
+#ifdef __ARMEB__
+#define rl r3
+#define rh r2
+#else
+#define rl r2
+#define rh r3
+#endif
+
 /*
  * cpu_v7_set_pte_ext(ptep, pte)
  *
@@ -73,13 +81,13 @@ ENDPROC(cpu_v7_switch_mm)
  */
 ENTRY(cpu_v7_set_pte_ext)
 #ifdef CONFIG_MMU
-	tst	r2, #L_PTE_VALID
+	tst	rl, #L_PTE_VALID
 	beq	1f
-	tst	r3, #1 << (57 - 32)		@ L_PTE_NONE
-	bicne	r2, #L_PTE_VALID
+	tst	rh, #1 << (57 - 32)		@ L_PTE_NONE
+	bicne	rl, #L_PTE_VALID
 	bne	1f
-	tst	r3, #1 << (55 - 32)		@ L_PTE_DIRTY
-	orreq	r2, #L_PTE_RDONLY
+	tst	rh, #1 << (55 - 32)		@ L_PTE_DIRTY
+	orreq	rl, #L_PTE_RDONLY
 1:	strd	r2, r3, [r0]
 	ALT_SMP(W(nop))
 	ALT_UP (mcr	p15, 0, r0, c7, c10, 1)		@ flush_pte


