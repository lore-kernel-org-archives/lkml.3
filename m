Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab3BEWKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:10:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48036 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707Ab3BEWK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:10:26 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Nathan Zimmer <nzimmer@sgi.com>,
        Robin Holt <holt@sgi.com>, Matt Fleming <matt.fleming@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 43/93] efi, x86: Pass a proper identity mapping in efi_call_phys_prelog
Date: Tue,  5 Feb 2013 20:06:32 -0200
Message-Id: <1360102042-10732-44-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Zimmer <nzimmer@sgi.com>

commit b8f2c21db390273c3eaf0e5308faeaeb1e233840 upstream.

Update efi_call_phys_prelog to install an identity mapping of all available
memory.  This corrects a bug on very large systems with more then 512 GB in
which bios would not be able to access addresses above not in the mapping.

The result is a crash that looks much like this.

BUG: unable to handle kernel paging request at 000000effd870020
IP: [<0000000078bce331>] 0x78bce330
PGD 0
Oops: 0000 [#1] SMP
Modules linked in:
CPU 0
Pid: 0, comm: swapper/0 Tainted: G        W    3.8.0-rc1-next-20121224-medusa_ntz+ #2 Intel Corp. Stoutland Platform
RIP: 0010:[<0000000078bce331>]  [<0000000078bce331>] 0x78bce330
RSP: 0000:ffffffff81601d28  EFLAGS: 00010006
RAX: 0000000078b80e18 RBX: 0000000000000004 RCX: 0000000000000004
RDX: 0000000078bcf958 RSI: 0000000000002400 RDI: 8000000000000000
RBP: 0000000078bcf760 R08: 000000effd870000 R09: 0000000000000000
R10: 0000000000000000 R11: 00000000000000c3 R12: 0000000000000030
R13: 000000effd870000 R14: 0000000000000000 R15: ffff88effd870000
FS:  0000000000000000(0000) GS:ffff88effe400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000effd870020 CR3: 000000000160c000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper/0 (pid: 0, threadinfo ffffffff81600000, task ffffffff81614400)
Stack:
 0000000078b80d18 0000000000000004 0000000078bced7b ffff880078b81fff
 0000000000000000 0000000000000082 0000000078bce3a8 0000000000002400
 0000000060000202 0000000078b80da0 0000000078bce45d ffffffff8107cb5a
Call Trace:
 [<ffffffff8107cb5a>] ? on_each_cpu+0x77/0x83
 [<ffffffff8102f4eb>] ? change_page_attr_set_clr+0x32f/0x3ed
 [<ffffffff81035946>] ? efi_call4+0x46/0x80
 [<ffffffff816c5abb>] ? efi_enter_virtual_mode+0x1f5/0x305
 [<ffffffff816aeb24>] ? start_kernel+0x34a/0x3d2
 [<ffffffff816ae5ed>] ? repair_env_string+0x60/0x60
 [<ffffffff816ae2be>] ? x86_64_start_reservations+0xba/0xc1
 [<ffffffff816ae120>] ? early_idt_handlers+0x120/0x120
 [<ffffffff816ae419>] ? x86_64_start_kernel+0x154/0x163
Code:  Bad RIP value.
RIP  [<0000000078bce331>] 0x78bce330
 RSP <ffffffff81601d28>
CR2: 000000effd870020
---[ end trace ead828934fef5eab ]---

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/platform/efi/efi_64.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index ac3aa54..0fba86d 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -38,7 +38,7 @@
 #include <asm/cacheflush.h>
 #include <asm/fixmap.h>
 
-static pgd_t save_pgd __initdata;
+static pgd_t *save_pgd __initdata;
 static unsigned long efi_flags __initdata;
 
 static void __init early_code_mapping_set_exec(int executable)
@@ -61,12 +61,20 @@ static void __init early_code_mapping_set_exec(int executable)
 void __init efi_call_phys_prelog(void)
 {
 	unsigned long vaddress;
+	int pgd;
+	int n_pgds;
 
 	early_code_mapping_set_exec(1);
 	local_irq_save(efi_flags);
-	vaddress = (unsigned long)__va(0x0UL);
-	save_pgd = *pgd_offset_k(0x0UL);
-	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
+
+	n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT), PGDIR_SIZE);
+	save_pgd = kmalloc(n_pgds * sizeof(pgd_t), GFP_KERNEL);
+
+	for (pgd = 0; pgd < n_pgds; pgd++) {
+		save_pgd[pgd] = *pgd_offset_k(pgd * PGDIR_SIZE);
+		vaddress = (unsigned long)__va(pgd * PGDIR_SIZE);
+		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), *pgd_offset_k(vaddress));
+	}
 	__flush_tlb_all();
 }
 
@@ -75,7 +83,11 @@ void __init efi_call_phys_epilog(void)
 	/*
 	 * After the lock is released, the original page table is restored.
 	 */
-	set_pgd(pgd_offset_k(0x0UL), save_pgd);
+	int pgd;
+	int n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT) , PGDIR_SIZE);
+	for (pgd = 0; pgd < n_pgds; pgd++)
+		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), save_pgd[pgd]);
+	kfree(save_pgd);
 	__flush_tlb_all();
 	local_irq_restore(efi_flags);
 	early_code_mapping_set_exec(0);
-- 
1.7.9.5

