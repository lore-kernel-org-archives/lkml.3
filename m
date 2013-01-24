Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab3AXUYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:24:32 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27236 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab3AXUWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:22:36 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 32/35] x86, 64bit, mm: Mark data/bss/brk to nx
Date: Thu, 24 Jan 2013 12:20:13 -0800
Message-Id: <1359058816-7615-33-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HPA said, we should not have RW and +x set at the time.

for kernel layout:
[    0.000000] Kernel Layout:
[    0.000000]   .text: [0x01000000-0x021434f8]
[    0.000000] .rodata: [0x02200000-0x02a13fff]
[    0.000000]   .data: [0x02c00000-0x02dc763f]
[    0.000000]   .init: [0x02dc9000-0x0312cfff]
[    0.000000]    .bss: [0x0313b000-0x03dd6fff]
[    0.000000]    .brk: [0x03dd7000-0x03dfffff]

before the patch, we have
---[ High Kernel Mapping ]---
0xffffffff80000000-0xffffffff81000000          16M                           pmd
0xffffffff81000000-0xffffffff82200000          18M     ro         PSE GLB x  pmd
0xffffffff82200000-0xffffffff82c00000          10M     ro         PSE GLB NX pmd
0xffffffff82c00000-0xffffffff82dc9000        1828K     RW             GLB x  pte
0xffffffff82dc9000-0xffffffff82e00000         220K     RW             GLB NX pte
0xffffffff82e00000-0xffffffff83000000           2M     RW         PSE GLB NX pmd
0xffffffff83000000-0xffffffff8313a000        1256K     RW             GLB NX pte
0xffffffff8313a000-0xffffffff83200000         792K     RW             GLB x  pte
0xffffffff83200000-0xffffffff83e00000          12M     RW         PSE GLB x  pmd
0xffffffff83e00000-0xffffffffa0000000         450M                           pmd

after patch,, we get
---[ High Kernel Mapping ]---
0xffffffff80000000-0xffffffff81000000          16M                           pmd
0xffffffff81000000-0xffffffff82200000          18M     ro         PSE GLB x  pmd
0xffffffff82200000-0xffffffff82c00000          10M     ro         PSE GLB NX pmd
0xffffffff82c00000-0xffffffff82e00000           2M     RW             GLB NX pte
0xffffffff82e00000-0xffffffff83000000           2M     RW         PSE GLB NX pmd
0xffffffff83000000-0xffffffff83200000           2M     RW             GLB NX pte
0xffffffff83200000-0xffffffff83e00000          12M     RW         PSE GLB NX pmd
0xffffffff83e00000-0xffffffffa0000000         450M                           pmd

so data, bss, brk get NX ...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init_64.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 64e6fe0..edaa2da 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -808,6 +808,7 @@ void mark_rodata_ro(void)
 	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
 	unsigned long text_end = PFN_ALIGN(&__stop___ex_table);
 	unsigned long rodata_end = PFN_ALIGN(&__end_rodata);
+	unsigned long all_end = PFN_ALIGN(&_end);
 
 	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
 	       (end - start) >> 10);
@@ -816,10 +817,10 @@ void mark_rodata_ro(void)
 	kernel_set_to_readonly = 1;
 
 	/*
-	 * The rodata section (but not the kernel text!) should also be
-	 * not-executable.
+	 * The rodata/data/bss/brk section (but not the kernel text!)
+	 * should also be not-executable.
 	 */
-	set_memory_nx(rodata_start, (end - rodata_start) >> PAGE_SHIFT);
+	set_memory_nx(rodata_start, (all_end - rodata_start) >> PAGE_SHIFT);
 
 	rodata_test();
 
-- 
1.7.10.4

